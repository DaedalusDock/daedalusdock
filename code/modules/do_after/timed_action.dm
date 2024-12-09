#define WORKING 0
#define CANCELLED 1
#define SUCCEEDED 2

/datum/timed_action
	var/atom/movable/user
	var/list/targets

	var/atom/user_loc
	var/user_dir
	var/obj/item/user_held_item

	var/datum/progressbar/progbar

	var/datum/callback/extra_checks

	var/start_time
	var/end_time

	var/timed_action_flags = NONE

	var/drifting = FALSE

	var/status = WORKING

/datum/timed_action/New(_user, _targets, _time, _progress, _timed_action_flags, _extra_checks, image/_display)
	user = _user
	user_dir = user.dir

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
		if(!(timed_action_flags & DO_IGNORE_SLOWDOWNS))
			_time *= mobuser.cached_multiplicative_actions_slowdown
	else
		timed_action_flags |= DO_IGNORE_HELD_ITEM|DO_IGNORE_INCAPACITATED|DO_IGNORE_SLOWDOWNS|DO_PUBLIC

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
	STOP_PROCESSING(SStimed_action, src)
	return ..()

/datum/timed_action/proc/register_signals()
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(user_gone))

	if(!(timed_action_flags & DO_IGNORE_USER_LOC_CHANGE))
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(user_moved))

	if(!(timed_action_flags & DO_IGNORE_INCAPACITATED))
		RegisterSignal(user, SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED), PROC_REF(user_incap))

	if(!(timed_action_flags & DO_RESTRICT_CLICKING))
		RegisterSignal(user, COMSIG_LIVING_CHANGENEXT_MOVE, PROC_REF(on_changenext_move))

	if(timed_action_flags & DO_RESTRICT_USER_DIR_CHANGE)
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(user_dir_change))

	for(var/atom/target as anything in targets)
		if(target == user)
			continue

		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(target_gone))

		if(!(timed_action_flags & DO_IGNORE_TARGET_LOC_CHANGE))
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(target_moved))

/datum/timed_action/proc/cancel()
	status = CANCELLED
	STOP_PROCESSING(SStimed_action, src)

/datum/timed_action/proc/wait()
	START_PROCESSING(SStimed_action, src)

	while(status == WORKING)
		sleep(world.tick_lag)

	. = (status == CANCELLED) ? FALSE : TRUE

	if(!QDELETED(progbar))
		progbar.end_progress()

	qdel(src)

/datum/timed_action/process(delta_time)
	if(world.time >= end_time)
		status = SUCCEEDED
		return PROCESS_KILL

	// Anything requiring a mob cannot happen if it isn't a mob in New() so this is safe.
	var/mob/mob_user = user

	if(!(timed_action_flags & DO_IGNORE_HELD_ITEM) && mob_user.get_active_held_item() != user_held_item)
		cancel()
		return

	if((extra_checks && !extra_checks.InvokeAsync()))
		cancel()
		return

	if(!QDELETED(progbar))
		progbar.update(world.time - start_time)

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

/datum/timed_action/proc/user_dir_change(datum/source)
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

#undef WORKING
#undef CANCELLED
#undef SUCCEEDED
