/obj/effect/aether_rune/revival
	rune_type = "revival"

	var/required_woundseal_amt = 30
	var/required_woundseal_potency = 80

/obj/effect/aether_rune/revival/find_target_mob()
	for(var/mob/living/carbon/human/H in loc)
		if(H.stat != DEAD)
			continue

		var/obj/item/organ/brain/B = H.getorganslot(ORGAN_SLOT_BRAIN)
		if(!B)
			continue

		return H

/obj/effect/aether_rune/revival/wipe_state()
	var/obj/item/reagent_containers/woundseal_bottle = blackboard[RUNE_BB_REVIVAL_WOUNDSEAL_CONTAINER]
	if(woundseal_bottle)
		unregister_item(woundseal_bottle)

	var/obj/item/reagent_containers/blood_bottle = blackboard[RUNE_BB_REVIVAL_WOUNDSEAL_CONTAINER]
	if(blood_bottle)
		unregister_item(blood_bottle)

	var/obj/item/organ/heart/heart = blackboard[RUNE_BB_REVIVAL_HEART]
	if(heart)
		unregister_item(heart)
	return ..()

/obj/effect/aether_rune/revival/pre_invoke()
	. = ..()

	for(var/obj/item/reagent_containers/reagent_container in orange(1, src))
		if(!reagent_container.is_open_container())
			continue

		if(isnull(blackboard[RUNE_BB_REVIVAL_WOUNDSEAL_CONTAINER]))
			var/datum/reagent/tincture/woundseal/woundseal = reagent_container.reagents.has_reagent(/datum/reagent/tincture/woundseal, required_woundseal_amt)
			if(woundseal && woundseal.data?["potency"] >= required_woundseal_potency)
				register_item(reagent_container)
				blackboard[RUNE_BB_REVIVAL_WOUNDSEAL_CONTAINER] = reagent_container
				continue

	for(var/obj/item/organ/heart/heart in orange(1, src))
		if(heart.organ_flags & (ORGAN_DEAD | ORGAN_SYNTHETIC))
			continue

		register_item(heart)
		blackboard[RUNE_BB_REVIVAL_HEART] = heart
		break

/obj/effect/aether_rune/revival/can_invoke()
	. = ..()
	if(!.)
		return

	var/obj/item/organ/heart/heart = blackboard[RUNE_BB_REVIVAL_HEART]
	if(!heart)
		return FALSE

	if(heart.organ_flags & ORGAN_DEAD)
		return FALSE

	if(!blackboard[RUNE_BB_REVIVAL_WOUNDSEAL_CONTAINER])
		return FALSE

/obj/effect/aether_rune/revival/succeed_invoke(mob/living/carbon/human/target_mob)
	var/obj/item/organ/brain/B = target_mob.getorganslot(ORGAN_SLOT_BRAIN)
	B.applyOrganDamage(-INFINITY)
	B.set_organ_dead(FALSE)

	for(var/obj/item/organ/O in target_mob.processing_organs)
		if(O.organ_flags & ORGAN_SYNTHETIC)
			continue

		B.applyOrganDamage(-INFINITY)
		B.set_organ_dead(FALSE)
		B.germ_level = 0

	target_mob.set_heartattack(FALSE)
	target_mob.revive()

	target_mob.visible_message(
		span_statsgood("Lifeforce floods into [target_mob]'s flesh, briefly turning [target_mob.p_their()] veins a vile green.")
	)

	target_mob.Knockdown(10 SECONDS)
	target_mob.Paralyze(4 SECONDS)

	if(target_mob.stat == CONSCIOUS)
		spawn(-1)
			target_mob.emote("gasp")
			target_mob.manual_emote("coughs up blood onto [loc].")
			target_mob.add_splatter_floor(loc)

	var/obj/item/reagent_containers/woundseal_bottle = blackboard[RUNE_BB_REVIVAL_WOUNDSEAL_CONTAINER]
	woundseal_bottle.reagents.remove_reagent(/datum/reagent/tincture/woundseal, required_woundseal_amt)

	var/obj/item/heart = blackboard[RUNE_BB_REVIVAL_HEART]
	qdel(heart)
	return ..()

/obj/effect/aether_rune/revival/register_target_mob(target)
	RegisterSignal(target, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(clear_revival_target))
	RegisterSignal(target, COMSIG_MOB_STATCHANGE, PROC_REF(target_stat_change))

/obj/effect/aether_rune/revival/unregister_target_mob(target)
	UnregisterSignal(target, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_MOB_STATCHANGE))

/obj/effect/aether_rune/revival/proc/clear_revival_target(datum/source)
	SIGNAL_HANDLER

	var/mob/M = source
	if(QDELETED(source))
		try_cancel_invoke(RUNE_FAIL_GRACEFUL)
		return

	if(M.loc != loc)
		try_cancel_invoke(RUNE_FAIL_TARGET_MOB_MOVED, source)

/obj/effect/aether_rune/revival/proc/target_stat_change(datum/source)
	SIGNAL_HANDLER

	var/mob/living/L = source
	if(L.stat != DEAD)
		try_cancel_invoke(RUNE_FAIL_REVIVAL_TARGET_ALIVE, L)
