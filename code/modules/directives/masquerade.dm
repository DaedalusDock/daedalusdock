/datum/directive/masquerade
	name = "The Masquerade"
	desc = "All colonists are required to wear identity-concealing masks, unless their physiology prohibits such."

	severity = DIRECTIVE_SEVERITY_MED
	enact_delay = 5 MINUTES

	reward = 3000

/datum/directive/masquerade/get_announce_start_text()
	return "All colonists are required to wear identity-concealing masks in public, unless their physiology prohibits such."

/datum/directive/masquerade/get_announce_end_text(successful)
	return "Usage of identity-concealing masks is no longer enforced."
