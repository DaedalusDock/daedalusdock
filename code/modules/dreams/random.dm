/// The classic random dream of various words that might form a cohesive narrative, but usually wont
/datum/dream/random
	weight = 1000

/datum/dream/random/GenerateDream(mob/living/carbon/dreamer)
	var/list/custom_dream_nouns = list()
	var/fragment = ""

	for(var/obj/item/bedsheet/sheet in dreamer.loc)
		custom_dream_nouns += sheet.dream_messages

	. = list()
	. += "you see"

	//Subject
	if(custom_dream_nouns.len && prob(90))
		fragment += pick(custom_dream_nouns)
	else
		fragment += pick(GLOB.dream_strings)

	if(prob(50)) //Replace the adjective space with an adjective, or just get rid of it
		fragment = replacetext(fragment, "%ADJECTIVE%", pick(GLOB.adjectives))
	else
		fragment = replacetext(fragment, "%ADJECTIVE% ", "")
	if(findtext(fragment, "%A% "))
		fragment = "\a [replacetext(fragment, "%A% ", "")]"
	. += fragment

	//Verb
	fragment = ""
	if(prob(50))
		if(prob(35))
			fragment += "[pick(GLOB.adverbs)] "
		fragment += pick(GLOB.ing_verbs)
	else
		fragment += "will "
		fragment += pick(GLOB.verbs)
	. += fragment

	if(prob(25))
		for(var/dream_fragment in .)
			.[dream_fragment] = rand(1 SECOND, 3 SECONDS)
		return

	//Object
	fragment = ""
	fragment += pick(GLOB.dream_strings)
	if(prob(50))
		fragment = replacetext(fragment, "%ADJECTIVE%", pick(GLOB.adjectives))
	else
		fragment = replacetext(fragment, "%ADJECTIVE% ", "")
	if(findtext(fragment, "%A% "))
		fragment = "\a [replacetext(fragment, "%A% ", "")]"
	. += fragment

	for(var/dream_fragment in .)
		.[dream_fragment] = rand(1 SECOND, 3 SECONDS)
