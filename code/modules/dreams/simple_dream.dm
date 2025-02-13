/// Just pick a string from a list of options.
/datum/dream/simple
	abstract_type = /datum/dream/simple

	var/list/options

/datum/dream/simple/GenerateDream(mob/living/carbon/dreamer)
	var/string = pick(options)
	string = replacetext(string, "%NAME%", dreamer.name)
	return list(string)
