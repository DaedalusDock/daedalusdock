/obj/effect/aether_rune/revival

/obj/effect/aether_rune/revival/pre_invoke(mob/living/user, obj/item/book/tome)
	. = ..()
	for(var/mob/living/L in get_turf(src))
		if(L.stat == DEAD)
			set_revival_target(L)
			break

/obj/effect/aether_rune/revival/can_invoke()
	. = ..()
	if(!.)
		return

	var/mob/living/L = blackboard[RUNE_BB_REVIVAL_TARGET]
	if(QDELETED(L))
		return FALSE

/obj/effect/aether_rune/revival/proc/set_revival_target(mob/living/L)
	blackboard[RUNE_BB_REVIVAL_TARGET] = L
	RegisterSignal(L, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_MOB_STATCHANGE), PROC_REF(clear_revival_target))

/obj/effect/aether_rune/revival/proc/clear_revival_target(datum/source)
	SIGNAL_HANDLER

	if(QDELETED(source))
		try_cancel_invoke(RUNE_FAIL_GRACEFUL)
	UnregisterSignal(source, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_MOB_STATCHANGE))
