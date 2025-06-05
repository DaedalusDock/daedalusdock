/datum/directive/bar_closure
	name = "Bar Closure"
	desc = "The Bar is closed down to the public indefinitely."

	severity = DIRECTIVE_SEVERITY_HIGH
	enact_delay = 5 MINUTES

	reward = 5000

/datum/directive/bar_closure/get_announce_start_text()
	return "The Bar is now closed to the public indefinitely."

/datum/directive/bar_closure/get_announce_end_text(successful)
	return "Access to the bar is no longer restricted."
