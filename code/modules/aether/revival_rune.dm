/obj/effect/aether_rune/revival

/obj/effect/aether_rune/revival/find_target_mob()
	for(var/mob/living/carbon/human/H in loc)
		if(H.stat != DEAD)
			continue

		var/obj/item/organ/brain/B = H.getorganslot(ORGAN_SLOT_BRAIN)
		if(!B)
			continue

		return H

/obj/effect/aether_rune/revival/succeed_invoke()
	var/mob/living/carbon/human/H = blackboard[RUNE_BB_TARGET_MOB]
	var/obj/item/organ/brain/B = H.getorganslot(ORGAN_SLOT_BRAIN)
	B.applyOrganDamage(-INFINITY)
	B.set_organ_dead(FALSE)
	H.set_heartattack(FALSE)
	H.revive()

	H.visible_message(
		span_statsgood("Lifeforce floods into [H]'s flesh, briefly turning [H.p_their()] veins a vile green as it crawls through [H.p_them()].")
	)

	H.Knockdown(10 SECONDS)
	H.Paralyze(4 SECONDS)

	if(H.stat == CONSCIOUS)
		spawn(-1)
			H.emote("gasp")
			H.manual_emote("coughs up blood onto [loc].")
			H.add_splatter_floor(loc)

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
