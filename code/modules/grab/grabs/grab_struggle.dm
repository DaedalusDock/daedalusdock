/datum/grab/normal/struggle
	upgrab = /datum/grab/normal/aggressive
	downgrab = /datum/grab/normal/passive
	shift = 8
	stop_move = TRUE
	reverse_facing = FALSE
	same_tile = FALSE
	breakability = 3
	grab_slowdown = 0.7
	upgrade_cooldown = 2 SECONDS
	can_downgrade_on_resist = 0
	icon_state = "reinforce"
	break_chance_table = list(5, 20, 30, 80, 100)

/datum/grab/normal/struggle/enter_as_up(obj/item/hand_item/grab/G, silent)
	var/mob/living/affecting = G.get_affecting_mob()
	var/mob/living/assailant = G.assailant
	if(!affecting)
		return TRUE

	if(affecting == assailant)
		G.done_struggle = TRUE
		G.upgrade(TRUE)
		return FALSE

	if(!affecting.can_resist() || !affecting.combat_mode)
		affecting.visible_message(
			span_danger("\The <b>[affecting]</b> isn't prepared to fight back as <b>[assailant]</b> tightens [assailant.p_their()] grip!"),
			vision_distance = COMBAT_MESSAGE_RANGE,
		)
		G.done_struggle = TRUE
		G.upgrade(TRUE, FALSE)
		return FALSE

	affecting.visible_message("<span class='warning'>[affecting] struggles against [assailant]!</span>", vision_distance = COMBAT_MESSAGE_RANGE)
	G.done_struggle = FALSE
	addtimer(CALLBACK(G, TYPE_PROC_REF(/obj/item/hand_item/grab, handle_resist)), 1 SECOND)
	resolve_struggle(G)
	return ..()

/datum/grab/normal/struggle/proc/resolve_struggle(obj/item/hand_item/grab/G)
	set waitfor = FALSE

	#ifdef UNIT_TESTS
	var/upgrade_cooldown = 0
	sleep(world.tick_lag)
	#endif

	var/datum/callback/user_incapacitated_callback = CALLBACK(src, PROC_REF(resolve_struggle_check), G)
	if(do_after(G.assailant, G.affecting, upgrade_cooldown, DO_PUBLIC|DO_IGNORE_USER_LOC_CHANGE|DO_IGNORE_TARGET_LOC_CHANGE, extra_checks = user_incapacitated_callback))
		G.done_struggle = TRUE
		G.upgrade(TRUE)
	else
		if(!QDELETED(G))
			G.downgrade()

/// Callback for the above proc
/datum/grab/normal/struggle/proc/resolve_struggle_check(obj/item/hand_item/grab/G)
	if(QDELETED(G))
		return FALSE
	return TRUE

/datum/grab/normal/struggle/can_upgrade(obj/item/hand_item/grab/G)
	. = ..() && G.done_struggle

/datum/grab/normal/struggle/on_hit_disarm(obj/item/hand_item/grab/G, atom/A)
	to_chat(G.assailant, span_warning("Your grip isn't strong enough to pin."))
	return FALSE

/datum/grab/normal/struggle/on_hit_grab(obj/item/hand_item/grab/G, atom/A)
	to_chat(G.assailant, span_warning("Your grip isn't strong enough to jointlock."))
	return FALSE

/datum/grab/normal/struggle/on_hit_harm(obj/item/hand_item/grab/G, atom/A)
	to_chat(G.assailant, span_warning("Your grip isn't strong enough to dislocate."))
	return FALSE

/datum/grab/normal/struggle/resolve_openhand_attack(obj/item/hand_item/grab/G)
	return FALSE
