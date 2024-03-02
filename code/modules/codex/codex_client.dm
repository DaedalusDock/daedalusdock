/client
	var/codex_cooldown = FALSE

/client/verb/search_codex(searching as text)

	set name = "Search Codex"
	set category = "IC"
	set src = usr

	if(!SScodex.initialized)
		return

	if(codex_cooldown >= world.time)
		to_chat(src, span_warning("You cannot perform codex actions currently."))
		return

	if(!searching)
		searching = input("Enter a search string.", "Codex Search") as text|null
		if(!searching)
			return

	codex_cooldown = world.time + 1 SECONDS

	var/list/found_entries = SScodex.retrieve_entries_for_string(searching)
	if(mob && mob.mind && !length(mob.mind.antag_datums))
		found_entries = found_entries.Copy() // So we aren't messing with the codex search cache.
		for(var/datum/codex_entry/entry in found_entries)
			if(entry.antag_text && !entry.mechanics_text && !entry.lore_text)
				found_entries -= entry

	switch(LAZYLEN(found_entries))
		if(null)
			to_chat(src, span_alert("The codex reports <b>no matches</b> for '[searching]'."))
		if(1)
			SScodex.present_codex_entry(mob, found_entries[1])
		else
			SScodex.present_codex_search(mob, found_entries, searching)

/client/verb/list_codex_entries()

	set name = "List Codex Entries"
	set category = "IC"
	set src = usr

	if(!mob || !SScodex.initialized)
		return

	if(codex_cooldown >= world.time)
		to_chat(src, span_warning("You cannot perform codex actions currently."))
		return

	codex_cooldown = world.time + 1 SECONDS

	var/datum/browser/popup = new(mob, "codex", "Codex Index") //"codex-index"
	var/datum/codex_entry/nexus = SScodex.get_codex_entry(/datum/codex_entry/nexus)
	var/list/codex_data = list(nexus.get_codex_header(mob).Join(), "<h2>Codex Entries</h2>")
	codex_data += "<table width = 100%>"

	var/antag_check = mob && mob.mind && length(mob.mind.antag_datums)
	var/last_first_letter
	for(var/thing in SScodex.index_file)

		var/datum/codex_entry/entry = SScodex.index_file[thing]
		if(!antag_check && entry.antag_text && !entry.mechanics_text && !entry.lore_text && !entry.controls_text)
			continue

		var/first_letter = uppertext(copytext(thing, 1, 2))
		if(first_letter != last_first_letter)
			last_first_letter = first_letter
			codex_data += "<tr><td colspan = 2><hr></td></tr>"
			codex_data += "<tr><td colspan = 2>[last_first_letter]</td></tr>"
			codex_data += "<tr><td colspan = 2><hr></td></tr>"
		codex_data += "<tr><td>[thing]</td><td><a href='?src=\ref[SScodex];show_examined_info=\ref[SScodex.index_file[thing]];show_to=\ref[mob]'>View</a></td></tr>"
	codex_data += "</table>"
	popup.set_content(codex_data.Join())
	popup.open()


/client/verb/codex()
	set name = "Codex"
	set category = "IC"
	set src = usr

	if(!SScodex.initialized)
		return

	if(codex_cooldown >= world.time)
		to_chat(src, span_warning("You cannot perform codex actions currently."))
		return

	codex_cooldown = world.time + 1 SECONDS

	var/datum/codex_entry/entry = SScodex.get_codex_entry("nexus")
	SScodex.present_codex_entry(mob, entry)
