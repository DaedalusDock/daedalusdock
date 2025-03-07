/// Apply an item as a splint.
/obj/item/bodypart/proc/apply_splint(obj/item/stack/new_splint)
	if(splint)
		return FALSE

	if(new_splint.splint_slowdown == null)
		return

	splint = new_splint.split_stack(null, 1, src)

	update_interaction_speed()
	set_splint_timer()

	RegisterSignal(splint, COMSIG_PARENT_QDELETING, PROC_REF(splint_gone))
	SEND_SIGNAL(src, COMSIG_LIMB_SPLINTED, splint)

	return TRUE

/// Remove the existing splint.
/obj/item/bodypart/proc/remove_splint()
	if(!splint)
		return FALSE

	. = splint

	UnregisterSignal(splint, COMSIG_PARENT_QDELETING)
	if(splint.loc == src)
		splint.forceMove(drop_location())

	splint = null

	clear_splint_timer()
	update_interaction_speed()

	SEND_SIGNAL(src, COMSIG_LIMB_UNSPLINTED, splint)

/obj/item/bodypart/proc/splint_gone(obj/item/source)
	SIGNAL_HANDLER
	remove_splint()

/// Set the splint heal timer.
/obj/item/bodypart/proc/set_splint_timer()
	splint_heal_timer = addtimer(CALLBACK(src, PROC_REF(splint_heal_effect)), 5 MINUTES, TIMER_DELETE_ME | TIMER_STOPPABLE)

/// Called when a splint heals this limb.
/obj/item/bodypart/proc/splint_heal_effect()
	heal_bones()
	clear_splint_timer()

/// Delete the splint timer
/obj/item/bodypart/proc/clear_splint_timer()
	deltimer(splint_heal_timer)
	splint_heal_timer = null

/obj/item/bodypart/leg/apply_splint(obj/item/splint)
	. = ..()
	if(!.)
		return
	owner.apply_status_effect(/datum/status_effect/limp)
