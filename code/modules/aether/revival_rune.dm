/obj/effect/aether_rune/revival

/obj/effect/aether_rune/revival/pre_invoke(mob/living/user, obj/item/book/tome)
	. = ..()
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(H.stat != DEAD)
			continue

		var/obj/item/organ/brain/B = H.getorganslot(ORGAN_SLOT_BRAIN)
		if(!B)
			continue

		set_revival_target(H)
		break

/obj/effect/aether_rune/revival/can_invoke()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = blackboard[RUNE_BB_REVIVAL_TARGET]
	if(QDELETED(H))
		return FALSE

/obj/effect/aether_rune/revival/succeed_invoke()
	var/mob/living/carbon/human/H = blackboard[RUNE_BB_REVIVAL_TARGET]
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

/obj/effect/aether_rune/revival/proc/set_revival_target(mob/living/L)
	blackboard[RUNE_BB_REVIVAL_TARGET] = L
	RegisterSignal(L, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_MOB_STATCHANGE), PROC_REF(clear_revival_target))

/obj/effect/aether_rune/revival/proc/clear_revival_target(datum/source)
	SIGNAL_HANDLER

	if(QDELETED(source))
		try_cancel_invoke(RUNE_FAIL_GRACEFUL)
	UnregisterSignal(source, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_MOB_STATCHANGE))
