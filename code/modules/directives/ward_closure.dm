/datum/directive/ward_closure
	name = "Ward Closure"
	desc = "The Ward is closed pending an investigation. Staff members are to leave the area immediately."

	severity = DIRECTIVE_SEVERITY_HIGH
	enact_delay = 5 MINUTES

	reward = 5000

/datum/directive/ward_closure/get_announce_start_text()
	return "The Ward is closed pending an investigation. Staff members are to leave the area immediately."

/datum/directive/ward_closure/get_announce_end_text(successful)
	return "The investigation into the Ward has concluded."
