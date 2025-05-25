/datum/directive/parental_guidance
	name = "Orderly Conduct"
	desc = "Usage of disruptive language such as swearing or slurs is prohibited."

	reward = 1000

/datum/directive/parental_guidance/get_announce_start_text()
	return "Usage of disruptive language such as swearing or slurs is now prohibited."

/datum/directive/parental_guidance/get_announce_end_text(successful)
	return "Usage of disruptive language is now permitted."
