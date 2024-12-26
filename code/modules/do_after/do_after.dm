/**
 * Timed action involving one mob user. Target is optional, defaulting to user.
 * Returns TRUE if the action succeeded and was not interrupted.
 *
 * Args:
 * * user: The one performing the action.
 * * target: An atom or list of atoms to perform the action on. If null, defaults to user.
 * * timed_action_flags: A bitfield defining the behavior of the action.
 * * progress: Boolean value, if TRUE, show a progress bar over the target's head.
 * * extra_checks: An optional callback to check in addition to the default checks.
 * * interaction_key: An optional non-numeric value to disamibiguate the action, to be used with DOING_INTERACTION() macros. Defaults to target.
 * * max_interact_count: The action will automatically fail if they are already performing this many or more actions with the given interaction_key.
 * * display: An atom or image to display over the user's head. Only works with DO_PUBLIC flag.
 */
/proc/do_after(atom/movable/user, atom/target, time = 0, timed_action_flags = NONE, progress = TRUE, datum/callback/extra_checks, interaction_key, max_interact_count = 1, image/display)
	if(!user)
		return FALSE

	if(time == 0)
		return TRUE

	if(!target)
		target = user

	if(isnum(target))
		CRASH("a do_after created by [user] had a target set as [target]- probably intended to be the time instead.")
	if(isatom(time))
		CRASH("a do_after created by [user] had a timer of [time]- probably intended to be the target instead.")

	if(!interaction_key)
		if(!islist(target))
			interaction_key = target
		else
			var/list/temp = list()
			for(var/atom/atom as anything in target)
				temp += ref(atom)

			sortTim(temp, GLOBAL_PROC_REF(cmp_text_asc))
			interaction_key = jointext(temp, "-")

	if(interaction_key) //Do we have a interaction_key now?
		var/current_interaction_count = LAZYACCESS(user.do_afters, interaction_key) || 0
		if(current_interaction_count >= max_interact_count) //We are at our peak
			return
		LAZYSET(user.do_afters, interaction_key, current_interaction_count + 1)

	var/datum/timed_action/action = new(user, target, time, progress, timed_action_flags, extra_checks, display)

	. = action.wait()

	if(interaction_key)
		var/reduced_interaction_count = (LAZYACCESS(user.do_afters, interaction_key)) - 1
		if(reduced_interaction_count > 0) // Not done yet!
			LAZYSET(user.do_afters, interaction_key, reduced_interaction_count)
			return
		LAZYREMOVE(user.do_afters, interaction_key)


/// Returns the total amount of do_afters this mob is taking part in
/mob/proc/do_after_count()
	var/count = 0
	for(var/key in do_afters)
		count += do_afters[key]
	return count
