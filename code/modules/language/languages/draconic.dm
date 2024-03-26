/datum/language/draconic
	name = "Jinanuar"
	desc = "The common language of the Jinans, composed of sibilant hisses, grumbles, and clicks."
	key = "o"
	space_chance = 40
	flags = parent_type::flags | (LANGUAGE_SELECTABLE_SPEAK | LANGUAGE_SELECTABLE_UNDERSTAND)

	syllables = list(
		"ji", "na", "an", "ua", "au", "ou", "uo", "uh", "hu", "ar", "ra",
		"in", "ni", "ka", "ak", "ke", "ek", "ki", "ik", "uk", "ks", "sk",
		"sa", "as", "se", "es", "si", "is", "su", "us", "ss", "ss", "rs",
		"sr", "ur", "ru", "ra", "nu", "un", "il", "li", "sl", "ls", "ri",
		"ir", "ij", "ai", "ia", "hi", "ih",
		"j", "j", "a", "a", "i", "i", "u", "u", "r", "r", "s", "s", "s"
	)
	icon_state = "lizard"
	default_priority = 90
