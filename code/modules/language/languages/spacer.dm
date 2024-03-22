/datum/language/spacer
	name = "Spacer"
	desc = "A rough, informal language with syllables and words borrowed from countless languages and dialects."
	key = "l"
	syllables = list(
		"ada", "zir", "bian", "ach", "usk", "ado", "ich", "cuan", "iga", "qing", "le", "que", "ki", "qaf", "dei", "eta"
	)
	icon_state = "spacer"
	flags = parent_type::flags | (LANGUAGE_SELECTABLE_SPEAK | LANGUAGE_SELECTABLE_UNDERSTAND)
