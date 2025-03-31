/atom/proc/get_codex_value()
	return src

/atom/proc/get_specific_codex_entry()
	if(SScodex.entries_by_path[type])
		return SScodex.entries_by_path[type]

	var/lore = jointext(get_lore_info(), "<br>")
	var/mechanics = jointext(get_mechanics_info(), "<br>")
	var/antag = jointext(get_antag_info(), "<br>")
	var/controls = jointext(get_controls_info(), "<br>")
	if(!lore && !mechanics && !antag && !controls)
		return FALSE

	var/datum/codex_entry/entry = new(name, list(type), _lore_text = lore, _mechanics_text = mechanics, _antag_text = antag, _controls_text = controls, _dynamic = TRUE)
	return entry


/// Returns a list of mechanics information for this object.
/atom/proc/get_mechanics_info()
	. = list()

/// Returns a list of antagonist-related information about this object.
/atom/proc/get_antag_info()
	. = list()

/// Returns a list of lore information about this object.
/atom/proc/get_lore_info()
	. = list()

/// Returns a list of controls information about this object.
/atom/proc/get_controls_info()
	. = list()
