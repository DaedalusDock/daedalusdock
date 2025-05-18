/datum/game_mode/one_antag
	abstract_type = /datum/game_mode/one_antag

	/// How many players to assign antagonist by default. Overridable by get_antag_amount()
	var/antagonist_pop_ratio = 0.1

	/// The type of antag selector to use, and then the instance of it.
	var/datum/antagonist_selector/antag_selector

/datum/game_mode/one_antag/New()
	. = ..()
	antag_selector = new antag_selector

/datum/game_mode/one_antag/Destroy(force, ...)
	QDEL_NULL(antag_selector)
	return ..()

/datum/game_mode/one_antag/check_for_errors()
	. = ..()
	if(.)
		return

	var/list/antag_candidates = antag_selector.trim_candidates(SSticker.ready_players.Copy())
	if(length(antag_candidates) < required_enemies) //Not enough antags
		return "Not enough eligible players, [required_enemies] antagonists needed."

	return null

/datum/game_mode/one_antag/pre_setup()
	. = ..()
	if(!antag_selector.setup(get_antag_count(), SSticker.ready_players.Copy()))
		setup_error += "No possible antagonists found"
		return FALSE

	antagonists = antag_selector.selected_antagonists
	return TRUE

/datum/game_mode/one_antag/post_setup(report)
	. = ..()
	antag_selector.post_setup()

/datum/game_mode/one_antag/setup_antags()
	antag_selector.give_antag_datums()
	return ..()

/datum/game_mode/one_antag/get_required_jobs()
	return antag_selector.required_jobs

/// Returns the amount of antagonists to select at roundstart.
/datum/game_mode/one_antag/proc/get_antag_count()
	return max(1, ceil(length(SSticker.ready_players) * antagonist_pop_ratio))
