/datum/status_effect/grouped/king_in_yellow
	id = "kinginyellowstalk"

	tick_interval = 3 SECONDS

	alert_type = null

	/// 1 or 2
	var/curse_severity = 1

	/// A mob that exists purely so the hallucinator can touch it.
	var/obj/effect/abstract/kinginyellow_mob/my_liege
	/// The actual visual of the King
	var/image/liege_image

	var/expiration_timer_id

	COOLDOWN_DECLARE(grace_period)

/datum/status_effect/grouped/king_in_yellow/New(list/arguments)
	liege_image = image('goon/icons/obj/kinginyellow.dmi', "kingyellow")
	liege_image.plane = GAME_PLANE
	liege_image.layer = MOB_LAYER
	liege_image.override = TRUE

	create_my_king()
	addtimer(CALLBACK(src, PROC_REF(check_expire)), 5 SECONDS, TIMER_DELETE_ME | TIMER_LOOP)
	return ..()

/datum/status_effect/grouped/king_in_yellow/Destroy()
	QDEL_NULL(my_liege)
	return ..()

/datum/status_effect/grouped/king_in_yellow/on_apply()
	. = ..()

	apply_image()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(parent_moved))
	RegisterSignal(owner, COMSIG_MOB_LOGIN, PROC_REF(parent_login))
	RegisterSignal(owner, COMSIG_MOB_LOGOUT, PROC_REF(parent_logout))

/datum/status_effect/grouped/king_in_yellow/on_remove()
	. = ..()
	remove_image()

/datum/status_effect/grouped/king_in_yellow/tick(delta_time, times_fired)
	if(!isnull(my_liege.loc))
		return

	var/turf/possible_loc = get_oov_turf(owner)
	if(possible_loc)
		move_king(possible_loc)

/// Adds the image of the King to the owner mob's images.
/datum/status_effect/grouped/king_in_yellow/proc/apply_image()
	owner.client?.images += liege_image

/datum/status_effect/grouped/king_in_yellow/proc/remove_image()
	owner.client?.images -= liege_image

/// Moves the king to a given turf, and starts the expiration timer.
/datum/status_effect/grouped/king_in_yellow/proc/move_king(turf/position)
	COOLDOWN_START(src, grace_period, 5 SECONDS)
	my_liege.abstract_move(position)
	my_liege.setDir(get_dir(my_liege, owner))
	expiration_timer_id = addtimer(CALLBACK(src, PROC_REF(check_expire)), 5 SECONDS, TIMER_OVERRIDE | TIMER_STOPPABLE)

/datum/status_effect/grouped/king_in_yellow/proc/parent_moved(datum/source)
	SIGNAL_HANDLER

	if(!owner.client)
		vanish()

	if(COOLDOWN_FINISHED(src, grace_period) && !(owner in viewers(my_liege)))
		vanish()

	if(get_dist(my_liege, owner) <= 2)
		vanish()

	my_liege.setDir(get_dir(my_liege, owner))

/// Does a fancy effect and removes the king from the map.
/datum/status_effect/grouped/king_in_yellow/proc/vanish()
	new /obj/effect/abstract/kinginyellow_vanish(get_turf(my_liege), owner)
	addtimer(CALLBACK(src, PROC_REF(nullspace_king)), 0.3 SECONDS)

/// Moves the king to nullspace.
/datum/status_effect/grouped/king_in_yellow/proc/nullspace_king()
	my_liege.moveToNullspace()
	deltimer(expiration_timer_id)

/// Checks if the owner mob can still see the King. Vanishes the king if they cannot.
/datum/status_effect/grouped/king_in_yellow/proc/check_expire()
	if(isnull(my_liege.loc))
		return

	if(!(owner in viewers(my_liege)))
		vanish()

/datum/status_effect/grouped/king_in_yellow/proc/create_my_king(atom/newloc)
	my_liege = new(null, src)
	RegisterSignal(my_liege, COMSIG_PARENT_QDELETING, PROC_REF(king_gone))

	liege_image.loc = my_liege

/datum/status_effect/grouped/king_in_yellow/proc/king_gone(datum/source)
	SIGNAL_HANDLER

	vanish()
	create_my_king()

/datum/status_effect/grouped/king_in_yellow/proc/parent_login()
	SIGNAL_HANDLER
	apply_image()

/datum/status_effect/grouped/king_in_yellow/proc/parent_logout()
	SIGNAL_HANDLER
	remove_image()

/obj/effect/abstract/kinginyellow_mob
	name = "strange person"
	desc = "A tall figure wearing a grand yellow cape and gilded crown."
	icon = null
	icon_state = null
	density = FALSE
	anchored = TRUE
	layer = MOB_LAYER

/obj/effect/abstract/kinginyellow_vanish
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = EFFECTS_LAYER

	var/image/me
	var/mob/living/target

/obj/effect/abstract/kinginyellow_vanish/Initialize(mapload, _target)
	. = ..()
	if(!_target)
		return INITIALIZE_HINT_QDEL

	target = _target
	me = image('goon/icons/obj/kinginyellow.dmi', src, "kingyellowvanish")
	target.client?.images += me
	QDEL_IN(src, 0.3 SECONDS)

/obj/effect/abstract/kinginyellow_vanish/Destroy(force)
	target?.client?.images -= me
	target = null
	return ..()

///Returns a turf that is barely out of view of the target.
/proc/get_oov_turf(atom/target)
	var/list/turfs_in_range = RANGE_TURFS(10, target)
	var/list/turfs_in_view = list()

	for(var/turf/T as turf in oview(target))
		turfs_in_view += T

	var/list/unseen_turfs = turfs_in_view ^ turfs_in_range
	var/list/turfs_to_consider = list()

	for(var/turf/T as anything in unseen_turfs)
		if(isspaceturf(T) || IS_OPAQUE_TURF(T) || T.contains_dense_objects())
			continue
		if(can_see(T, target, 10))
			turfs_to_consider += T

	if(!length(turfs_to_consider))
		return

	return pick(turfs_to_consider)
