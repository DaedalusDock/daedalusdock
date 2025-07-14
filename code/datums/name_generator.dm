/datum/name_generator
	var/ensure_unique = FALSE

	var/given_forename = ""
	var/given_surname = ""

/// User-called proc to run the generator.
/datum/name_generator/proc/Generate()
	SHOULD_NOT_OVERRIDE(TRUE)

	var/attempts = 10
	while(attempts)
		. = build_name()

		if(!ensure_unique || !findname(.))
			return .

		attempts--

// Override for implementations. Do not call.
/datum/name_generator/proc/build_name()
	PROTECTED_PROC(TRUE)

/// Hoomans
/datum/name_generator/human
	var/given_country = ""

/datum/name_generator/human/build_name()
	var/static/list/country_map
	if(!country_map)
		country_map = list(
			"austria" = list(GLOB.austria_forenames, GLOB.austria_surnames),
			"chile" = list(GLOB.chile_forenames, GLOB.chile_surnames),
			"greece" = list(GLOB.greece_forenames, GLOB.greece_surnames),
			"netherlands" = list(GLOB.netherlands_forenames, GLOB.netherlands_surnames),
			"ukraine" = list(GLOB.ukraine_forenames, GLOB.ukraine_surnames),
			"wales" = list(GLOB.wales_forenames, GLOB.wales_surnames),
		)

	if(!given_country)
		given_country = pick(country_map)

	var/list/forename_pool = country_map[given_country][1]
	var/list/surname_pool = country_map[given_country][2]

	given_forename ||= pick(forename_pool)
	given_surname ||= pick(surname_pool)

	return "[given_forename] [given_surname]"

/// Jinans
/datum/name_generator/lizard

/datum/name_generator/lizard/build_name()
	var/fore = prob(50) ? pick(GLOB.lizard_names_male) : pick(GLOB.lizard_names_female)
	var/aft = prob(50) ? pick(GLOB.lizard_names_male) : pick(GLOB.lizard_names_female)
	return "[fore]-[aft]"

// Lightbulbs (to be moth-crystal things)
/datum/name_generator/ethereal

/datum/name_generator/ethereal/build_name()
	var/tempname = "[pick(GLOB.ethereal_names)] [random_capital_letter()]"
	if(prob(65))
		tempname += random_capital_letter()
	return tempname

// Moths (to be moth-crystal things)
/datum/name_generator/moth

/datum/name_generator/moth/build_name()
	return "[given_forename || pick(GLOB.moth_first)] [given_surname || pick(GLOB.moth_last)]"

// Horrible avali things, TODO: remove
/datum/name_generator/teshari
	var/static/list/first_syllable = list(
		"Fa", "Fe", "Fi", "Ma", "Me", "Mi", "Na", "Ne", "Ni", "Sa", "Se", "Si", "Ta", "Te", "Ti"
	)
	var/static/list/second_syllable = list(
		"fa", "fe", "fi", "la", "le", "li", "ma", "me", "mi", "na",
		"ne", "ni", "ra", "re", "ri", "sa", "se", "si", "sha", "she",
		"shi", "ta", "te", "ti"
	)
	var/static/list/third_syllable = list(
		"ca", "ce", "ci", "fa", "fe", "fi", "la", "le", "li", "ma",
		"me", "mi", "na", "ne", "ni", "ra", "re", "ri", "sa", "se",
		"si", "sha", "she", "shi", "ta", "te", "ti"
	)

/datum/name_generator/teshari/build_name()
	return "[pick(first_syllable)][pick(second_syllable)][pick(third_syllable)]"

/datum/name_generator/vox

/datum/name_generator/vox/build_name()
	var/static/list/sounds = list("ti","hi","ki","ya","ta","ha","ka","ya","chi","cha","kah","ri","ra")
	for(var/i in 1 to rand(3, 9))
		. += pick(sounds)

	. = capitalize(.)
