/proc/codex_sanitize(input)
	return lowertext(trim(strip_improper(input)))

/datum/codex_entry
	var/name
	var/list/associated_strings
	var/list/associated_paths
	//If TRUE, associated_paths will be passed into typesof first.
	var/use_typesof = FALSE
	//If TRUE, this is a dynamically created codex record, and will be stored in a different table.
	var/dynamic
	///IC information about the entry
	var/lore_text
	///OOC information about the entry.
	var/mechanics_text
	///Text for antagonists to utilize.
	var/antag_text
	///Text representing in-game controls.
	var/controls_text
	///A string appended to the name to disambiguate it's search.
	var/disambiguator
	var/list/categories

	//Codex entries support abstract_type.
	//Since the basetype is used for dynamically generated entries, it is not abstract.

/datum/codex_entry/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text, _controls_text, _disambiguator, _dynamic = FALSE)

	SScodex.all_entries += src

	if(SScodex.initialized && !_dynamic)
		_dynamic = TRUE //Override post-init codex entries to be dynamic
		stack_trace("Forced post-SSCodex init codex-entry record to be dynamic. This shouldn't need to happen. Check this call stack!")

	if(!SScodex.initialized && _dynamic) //If we haven't initialized, but we're creating a dynamic record, something has gone wrong.
		to_chat(world, span_warning("\tCodex: Attempted to create dynamic record before SSCodex init!"))
		CRASH("Attempted to create dynamic record before SSCodex init | Entry Name: [_display_name]")

	if(_display_name)
		name = _display_name
	if(_associated_paths)
		associated_paths = _associated_paths
	if(_associated_strings)
		associated_strings = _associated_strings
	if(_lore_text)
		lore_text = _lore_text
	if(_mechanics_text)
		mechanics_text = _mechanics_text
	if(_antag_text)
		antag_text = _antag_text
	if(_controls_text)
		controls_text = _controls_text
	if(_disambiguator)
		disambiguator = _disambiguator
	if(_dynamic)
		dynamic = _dynamic


	if(use_typesof && length(associated_paths))
		var/new_assoc_paths = list()
		for(var/path in associated_paths)
			new_assoc_paths |= typesof(path)
		associated_paths = new_assoc_paths

	if(length(associated_paths))
		for(var/tpath in associated_paths)
			var/atom/thing = tpath
			var/thing_name = codex_sanitize(initial(thing.name))
			if(disambiguator)
				thing_name = "[thing_name] ([disambiguator])"
			LAZYDISTINCTADD(associated_strings, thing_name)
		for(var/associated_path in associated_paths)
			if(SScodex.entries_by_path[associated_path])
				stack_trace("Trying to save codex entry for [name] by path [associated_path] but one already exists!")
			SScodex.entries_by_path[associated_path] = src

	/// We always point to our own entry. Duh.
	SScodex.entries_by_path[type] = src

	if(!name)
		if(length(associated_strings))
			name = associated_strings[1]
		else
			CRASH("Attempted to instantiate unnamed codex entry with no associated strings!")

	LAZYDISTINCTADD(associated_strings, "[codex_sanitize(name)]" )
	for(var/associated_string in associated_strings)
		var/clean_string = codex_sanitize(associated_string)
		if(!clean_string)
			associated_strings -= associated_string
			continue

		if(clean_string != associated_string)
			associated_strings -= associated_string
			associated_strings |= clean_string

		var/existing_entry = SScodex.entries_by_string[clean_string]
		if(islist(existing_entry))
			existing_entry += src
		else if(existing_entry)
			SScodex.entries_by_string[clean_string] = list(existing_entry, src)
		else
			SScodex.entries_by_string[clean_string] = src

	if(_dynamic)
		dynamic = TRUE
		SScodex.cache_dynamic_record(src)

	..()

/datum/codex_entry/Destroy(force)
	SScodex.all_entries -= src
	return ..()

/datum/codex_entry/proc/get_codex_header(mob/presenting_to)
	RETURN_TYPE(/list)

	. = list()
	if(presenting_to)
		var/datum/codex_entry/linked_entry = SScodex.get_codex_entry(/datum/codex_entry/nexus)
		. += "<a href='?src=\ref[SScodex];show_examined_info=\ref[linked_entry];show_to=\ref[presenting_to]'>Home</a>"
		if(presenting_to.client)
			. += "<a href='?src=\ref[presenting_to.client];codex_search=1'>Search Codex</a>"
			. += "<a href='?src=\ref[presenting_to.client];codex_index=1'>List All Entries</a>"
	. += "<hr><h2>[name]</h2>"

/datum/codex_entry/proc/get_codex_footer(mob/presenting_to)
	. = list()
	if(length(categories))
		for(var/datum/codex_category/category in categories)
			. += category.get_category_link(src)

/datum/codex_entry/proc/get_codex_body(mob/presenting_to, include_header = TRUE, include_footer = TRUE)
	RETURN_TYPE(/list)

	. = list()
	if(include_header && presenting_to)
		var/header = get_codex_header(presenting_to)
		if(length(header))
			. += "<div class='dmCodexHeader'>"
			. += jointext(header, null)
			. += "</div>"

	. += "<div class='dmCodexBody'>"
	if(lore_text)
		. += "<div class='codexLore'>[lore_text]</div>"
	if(mechanics_text)
		. += "<h3>OOC Information</h3><div class='codexMechanics'>[mechanics_text]</div>"
	if(antag_text && (!presenting_to || (presenting_to.mind && !length(presenting_to.mind.antag_datums))))
		. += "<h3>Antagonist Information</h3><div class='codexAntag'>[antag_text]</div>"
	if(controls_text)
		. += "<h3>Controls</h3><div class='codexControls'>[controls_text]</div>"
	. += "</div>"

	if(include_footer)
		var/footer = get_codex_footer(presenting_to)
		if(length(footer))
			. += "<div class='dmCodexFooter'>"
			. += footer
			. += "</div>"
