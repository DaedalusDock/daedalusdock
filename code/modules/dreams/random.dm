/// The classic random dream of various words that might form a cohesive narrative, but usually wont
/datum/dream/random
	weight = 100

	var/list/adjectives_list
	var/list/adverbs_list
	var/list/ing_verbs_list
	var/list/verbs_list
	var/list/subject_list
	var/list/object_list

	/// The first part of the dream.
	var/opener_string = "you see"

	/// If TRUE, the subject of the sentence can come from bedsheets on the dreamer's tile.
	var/sheets_okay = TRUE

	/// If able to use bedsheet nouns, the probability of doing so.
	var/bedsheet_subject_prob = 90
	/// Chance to replace an %ADJECTIVE% with an adjective, versus just skipping it.
	var/adjective_insert_subject_prob = 50
	/// The above, but for the Object of the sentence.
	var/adjective_insert_object_prob = 50
	/// Probability of using an adverb before the verb.
	var/adverb_prob = 35
	/// Probability of using a verb ending in "ing" instead of using "will [verb]"
	var/ing_verb_prob = 50
	/// Chance to stop at a verb and not proceed to the Object of the sentence.
	var/skip_object_prob = 25

/datum/dream/random/New()
	adjectives_list ||= GLOB.adjectives
	adverbs_list ||= GLOB.adverbs
	ing_verbs_list ||= GLOB.ing_verbs
	verbs_list ||= GLOB.verbs
	subject_list ||= GLOB.dream_strings
	object_list ||= GLOB.dream_strings

/datum/dream/random/GenerateDream(mob/living/carbon/dreamer)
	var/list/custom_dream_nouns = list()
	var/fragment = ""

	if(sheets_okay)
		for(var/obj/item/bedsheet/sheet in dreamer.loc)
			custom_dream_nouns += sheet.dream_messages

	. = list()
	. += opener_string

	//Subject
	if(custom_dream_nouns.len && prob(90))
		fragment += pick(custom_dream_nouns)
	else
		fragment += pick(subject_list)

	if(prob(adjective_insert_subject_prob)) //Replace the adjective space with an adjective, or just get rid of it
		fragment = replacetext(fragment, "%ADJECTIVE%", pick(adjectives_list))
	else
		fragment = replacetext(fragment, "%ADJECTIVE% ", "")

	if(findtext(fragment, "%A% "))
		fragment = "\a [replacetext(fragment, "%A% ", "")]"

	. += fragment

	//Verb
	fragment = ""
	if(prob(ing_verb_prob))
		if(prob(adverb_prob))
			fragment += "[pick(adverbs_list)] "
		fragment += pick(ing_verbs_list)
	else
		fragment += "will "
		fragment += pick(verbs_list)
	. += fragment

	if(prob(skip_object_prob))
		for(var/dream_fragment in .)
			.[dream_fragment] = rand(1 SECOND, 3 SECONDS)
		return

	//Object
	fragment = ""
	fragment += pick(subject_list)
	if(prob(adjective_insert_object_prob))
		fragment = replacetext(fragment, "%ADJECTIVE%", pick(adjectives_list))
	else
		fragment = replacetext(fragment, "%ADJECTIVE% ", "")
	if(findtext(fragment, "%A% "))
		fragment = "\a [replacetext(fragment, "%A% ", "")]"
	. += fragment

	for(var/dream_fragment in .)
		.[dream_fragment] = rand(1 SECOND, 3 SECONDS)
