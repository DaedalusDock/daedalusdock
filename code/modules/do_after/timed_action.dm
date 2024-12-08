/datum/timed_action
	var/atom/movable/user
	var/list/targets

	var/atom/user_loc
	var/obj/item/user_held_item

	var/datum/progressbar/progbar

	var/datum/callback/extra_checks

	var/start_time
	var/end_time

	var/timed_action_flags = NONE

	var/drifting = FALSE

	var/cancelled = FALSE

/datum/timed_action/New(_user, _targets, _time, _progress, _timed_action_flags, _extra_checks, image/_display)
	user = _user
	timed_action_flags = _timed_action_flags
	extra_checks = _extra_checks

	if(isnull(_targets))
		_targets = list(user)

	else if(!islist(_targets))
		_targets = list(_targets)

	for(var/atom/target as anything in _targets)
		_targets[target] = target.loc

	targets = _targets

	if(_progress)
		if(timed_action_flags & DO_PUBLIC)
			progbar = new /datum/world_progressbar(user, _time, _display)
		else
			progbar = new /datum/progressbar(user, _time, targets[1] || user)

	if(ismob(user))
		var/mob/mobuser = user
		user_held_item = mobuser.get_active_held_item()
		if(!(timed_action_flags & IGNORE_SLOWDOWNS))
			_time *= mobuser.cached_multiplicative_actions_slowdown
	else
		timed_action_flags |= IGNORE_HELD_ITEM|IGNORE_INCAPACITATED|IGNORE_SLOWDOWNS|DO_PUBLIC

	start_time = world.time
	end_time = world.time + _time

	if(SSmove_manager.processing_on(user, SSspacedrift))
		drifting = TRUE

	register_signals()

/datum/timed_action/Destroy(force, ...)
	user = null
	targets = null
	user_loc = null
	user_held_item = null
	extra_checks = null
	progbar = null
	return ..()

/datum/timed_action/proc/register_signals()
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(user_gone))

	if(!(timed_action_flags & IGNORE_USER_LOC_CHANGE))
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(user_moved))

	if(!(timed_action_flags & IGNORE_INCAPACITATED))
		RegisterSignal(user, SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED), PROC_REF(user_incap))

	if(!(timed_action_flags & DO_RESTRICT_CLICKING))
		RegisterSignal(user, COMSIG_LIVING_CHANGENEXT_MOVE, PROC_REF(on_changenext_move))

	for(var/atom/target as anything in targets)
		if(target == user)
			continue

		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(target_gone))

		if(!(timed_action_flags & IGNORE_TARGET_LOC_CHANGE))
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(target_moved))

/datum/timed_action/proc/cancel()
	cancelled = TRUE

/datum/timed_action/proc/wait()
	. = TRUE
	// Anything requiring a mob cannot happen if it isn't a mob in New() so this is safe.
	var/mob/mob_user = user

	while(world.time < end_time)
		if(cancelled)
			. = FALSE
			break

		stoplag(1)

		// Yes, we check twice for responsiveness.
		if(cancelled)
			. = FALSE
			break

		if(!(timed_action_flags & IGNORE_HELD_ITEM) && mob_user.get_active_held_item() != user_held_item)
			. = FALSE
			break

		if((extra_checks && !extra_checks.Invoke()))
			. = FALSE
			break

		if(!QDELETED(progbar))
			progbar.update(world.time - start_time)

	if(!QDELETED(progbar))
		progbar.end_progress()

	qdel(src)

/datum/timed_action/proc/user_gone(datum/source)
	SIGNAL_HANDLER

	cancel()

/datum/timed_action/proc/user_moved(datum/source)
	SIGNAL_HANDLER

	if(drifting && !SSmove_manager.processing_on(user, SSspacedrift))
		drifting = FALSE
		user_loc = user.loc

	if(!drifting && user.loc != user_loc)
		cancel()

/datum/timed_action/proc/user_incap(datum/source)
	SIGNAL_HANDLER
	cancel()

/datum/timed_action/proc/on_changenext_move(datum/source, next_move)
	SIGNAL_HANDLER

	if(next_move > world.time)
		cancel()

/datum/timed_action/proc/target_gone(datum/source)
	SIGNAL_HANDLER

	cancel()

/datum/timed_action/proc/target_moved(atom/movable/source)
	SIGNAL_HANDLER

	if(source.loc != targets[source])
		cancel()
