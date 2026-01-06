/datum/directive/prohibition
	abstract_type = /datum/directive/prohibition

	enact_delay = 1 MINUTE
	/// The name of the reagent to be banned.
	var/prohibited_thing

/datum/directive/prohibition/New()
	prohibited_thing = lowertext(prohibited_thing)

	name = "Reagent Prohibition ([capitalize(prohibited_thing)])"
	desc = "The production, distribution, and usage of [prohibited_thing] is now prohibited."

/datum/directive/prohibition/get_announce_start_text()
	return "The production, distribution, and usage of [prohibited_thing] is now prohibited. Any existing material should be disposed of immediately."

/datum/directive/prohibition/get_announce_end_text(successful)
	return "The production, distribution, and usage of [prohibited_thing] is no longer prohibited."

/datum/directive/prohibition/alcohol
	prohibited_thing = "alcohol"
	reward = 1000

/datum/directive/prohibition/cigarettes
	prohibited_thing = "tobacco"
	reward = 1000

/datum/directive/prohibition/weed
	prohibited_thing = "marijuana"
	reward = 1000

/datum/directive/prohibition/painkillers
	prohibited_thing = "painkillers"

	severity = DIRECTIVE_SEVERITY_MED
	reward = 3000
