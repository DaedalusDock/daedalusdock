SUBSYSTEM_DEF(codex)
	name = "Codex"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_CODEX

	var/regex/linkRegex
	var/regex/trailingLinebreakRegexStart
	var/regex/trailingLinebreakRegexEnd

	/// All entries. Unkeyed.
	var/list/all_entries = list()
	/// All STATIC entries, By path. Does not include dynamic entries.
	var/list/entries_by_path = list()
	/// All entries, by name.
	var/list/entries_by_string = list()
	/// The same as above, but sorted (?)
	var/list/index_file = list()
	/// Search result cache, so we don't need to hit the DB every time.
	var/list/search_cache = list()
	/// All categories.
	var/list/codex_categories = list()

	/// Codex Database Connection
	var/database/codex_index

/datum/controller/subsystem/codex/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_REGENERATE_CODEX, "Regenerate Search Database")

/datum/controller/subsystem/codex/vv_do_topic(href_list)
	. = ..()
	if(href_list[VV_HK_REGENERATE_CODEX])
		if(tgui_alert(usr, "Are you sure you want to regenerate the search index? This will almost certainly cause lag.", "Regenerate Index", list("Yes", "No")) == "Yes")
			prepare_search_database(TRUE)


/datum/controller/subsystem/codex/Initialize()
	// Codex link syntax is such:
	// <l>keyword</l> when keyword is mentioned verbatim,
	// <span codexlink='keyword'>whatever</span> when shit gets tricky
	linkRegex = regex(@"<(span|l)(\s+codexlink='([^>]*)'|)>([^<]+)</(span|l)>","g")

	// Create general hardcoded entries.
	for(var/datum/codex_entry/entry as anything in subtypesof(/datum/codex_entry))
		if(initial(entry.name) && !(isabstract(entry)))
			entry = new entry()

	// Create categorized entries.
	var/list/deferred_population = list()
	for(var/path in subtypesof(/datum/codex_category))
		codex_categories[path] = new path

	for(var/ctype in codex_categories)
		var/datum/codex_category/cat = codex_categories[ctype]
		if(cat.defer_population)
			deferred_population += cat
			continue
		cat.Populate()

	for(var/datum/codex_category/cat as anything in deferred_population)
		cat.Populate()

	// Create the index file for later use.
	for(var/datum/codex_entry/entry as anything in all_entries)
		index_file[entry.name] = entry
	index_file = sortTim(index_file, GLOBAL_PROC_REF(cmp_text_asc))

	// Prepare the search database.
	prepare_search_database()
	. = ..()

/datum/controller/subsystem/codex/proc/parse_links(string, viewer)
	while(linkRegex.Find(string))
		var/key = linkRegex.group[4]
		if(linkRegex.group[2])
			key = linkRegex.group[3]
		key = codex_sanitize(key)
		var/datum/codex_entry/linked_entry = get_entry_by_string(key)
		var/replacement = linkRegex.group[4]
		if(linked_entry)
			replacement = "<a href='?src=\ref[SScodex];show_examined_info=\ref[linked_entry];show_to=\ref[viewer]'>[replacement]</a>"
		string = replacetextEx(string, linkRegex.match, replacement)
	return string

/// Returns a codex entry for the given query. May return a list if multiple are found, or null if none.
/datum/controller/subsystem/codex/proc/get_codex_entry(entry)
	if(isatom(entry))
		var/atom/entity = entry
		. = entity.get_specific_codex_entry()
		if(.)
			return
		return entries_by_path[entity.type] || get_entry_by_string(entity.name)

	if(isdatum(entry))
		entry = entry:type
	if(ispath(entry))
		return entries_by_path[entry]
	if(istext(entry))
		return entries_by_string[codex_sanitize(entry)]

/datum/controller/subsystem/codex/proc/get_entry_by_string(string)
	return entries_by_string[codex_sanitize(string)]

/// Presents a codex entry to a mob. If it receives a list of entries, it will prompt them to choose one.
/datum/controller/subsystem/codex/proc/present_codex_entry(mob/presenting_to, datum/codex_entry/entry)
	if(!entry || !istype(presenting_to) || !presenting_to.client)
		return

	if(islist(entry))
		present_codex_search(presenting_to, entry)
		return

	var/datum/browser/popup = new(presenting_to, "codex", "Codex", nheight=425) //"codex\ref[entry]"
	var/entry_data = entry.get_codex_body(presenting_to)
	popup.set_content(parse_links(jointext(entry_data, null), presenting_to))
	popup.open()

#define CODEX_ENTRY_LIMIT 10
/// Presents a list of codex entries to a mob.
/datum/controller/subsystem/codex/proc/present_codex_search(mob/presenting_to, list/entries, search_query)
	var/list/codex_data = list()
	codex_data += "<h3><b>[entries.len] matches</b>[search_query ? " for '[search_query]'" : ""]:</h3>"

	if(LAZYLEN(entries) > CODEX_ENTRY_LIMIT)
		codex_data += "Showing first <b>[CODEX_ENTRY_LIMIT]</b> entries. <b>[entries.len - CODEX_ENTRY_LIMIT] result\s</b> omitted.</br>"
	codex_data += "<table width = 100%>"

	for(var/i = 1 to min(entries.len, CODEX_ENTRY_LIMIT))
		var/datum/codex_entry/entry = entries[i]
		codex_data += "<tr><td>[entry.name]</td><td><a href='?src=\ref[SScodex];show_examined_info=\ref[entry];show_to=\ref[presenting_to]'>View</a></td></tr>"
	codex_data += "</table>"

	var/datum/browser/popup = new(presenting_to, "codex-search", "Codex Search") //"codex-search"
	popup.set_content(codex_data.Join())
	popup.open()


/datum/controller/subsystem/codex/proc/get_guide(category)
	var/datum/codex_category/cat = codex_categories[category]
	. = cat?.guide_html

/// Perform a full-text search through all codex entries. Entries matching the query by name will be shown first.
/// Results are cached. Relies on the index database.
/datum/controller/subsystem/codex/proc/retrieve_entries_for_string(searching)

	searching = codex_sanitize(searching)
	. = search_cache[searching]
	if(.)
		return .
	if(!searching || !initialized)
		return list()
	if(!codex_index) //No codex DB loaded. Use the fallback search.
		return text_search_no_db(searching)


	var/search_string = "%[searching]%"
	// Search by name to build the priority entries first
	var/database/query/cursor = new(
		{"SELECT name FROM codex_entries
		WHERE name LIKE ?
		ORDER BY name asc
		LIMIT [CODEX_ENTRY_LIMIT]"},
		search_string
		)
	// Execute the query, returning us a list of types we can retrieve from the list indexes.
	cursor.Execute(codex_index)

	// God this sucks.
	var/list/datum/codex_entry/priority_results = list()
	while(cursor.NextRow())
		var/row = cursor.GetRowData()
		priority_results += index_file[row["name"]]
		CHECK_TICK

	// Now the awful slow ones.
	cursor.Add(
		{"SELECT name FROM codex_entries
		WHERE lore_text LIKE ?
		AND mechanics_text LIKE ?
		AND antag_text LIKE ?
		ORDER BY name asc
		LIMIT [CODEX_ENTRY_LIMIT]"},
		search_string,
		search_string,
		search_string
		)
	// Execute the query, returning us a list of types we can retrieve from the list indexes.
	cursor.Execute(codex_index)
	var/list/datum/codex_entry/fulltext_results = list()
	while(cursor.NextRow())
		var/row = cursor.GetRowData()
		fulltext_results += index_file[row["name"]]
		CHECK_TICK

	priority_results += fulltext_results
	. = search_cache[searching] = priority_results

/// Straight-DM implimentation of full text search. Objectively garbage.
/// Does not use the DB. Used when database loading is skipped.
/// Argument has already been sanitized.
/// Safety checks have already been done. Cache has already been checked.
/datum/controller/subsystem/codex/proc/text_search_no_db(searching)
	PRIVATE_PROC(TRUE)

	var/list/results = list()
	var/list/priority_results = list()

	if(entries_by_string[searching])
		results += entries_by_string[searching]
	else
		for(var/datum/codex_entry/entry as anything in all_entries)
			if(findtext(entry.name, searching))
				priority_results += entry

			else if(findtext(entry.lore_text, searching) || findtext(entry.mechanics_text, searching) || findtext(entry.antag_text, searching))
				results += entry

	sortTim(priority_results, GLOBAL_PROC_REF(cmp_name_asc))
	sortTim(results, GLOBAL_PROC_REF(cmp_name_asc))

	priority_results += results
	search_cache[searching] = priority_results
	. = search_cache[searching]

/datum/controller/subsystem/codex/Topic(href, href_list)
	. = ..()
	if(!. && href_list["show_examined_info"] && href_list["show_to"])
		var/mob/showing_mob = locate(href_list["show_to"])
		if(!istype(showing_mob))
			return
		var/atom/showing_atom = locate(href_list["show_examined_info"])
		var/entry
		if(istype(showing_atom, /datum/codex_entry))
			entry = showing_atom
		else if(istype(showing_atom))
			entry = get_codex_entry(showing_atom.get_codex_value())
		else
			entry = get_codex_entry(href_list["show_examined_info"])

		if(entry)
			present_codex_entry(showing_mob, entry)
			return TRUE

#define CODEX_SEARCH_INDEX_FILE "codex.db"
#define CODEX_SERIAL_ALWAYS_VALID "I_DOWNLOADED_A_ZIP_INSTEAD_OF_USING_GIT"
/// Prepare the search database.
/datum/controller/subsystem/codex/proc/prepare_search_database(drop_existing = FALSE)
	if(GLOB.is_debug_server && !FORCE_CODEX_DATABASE)
		to_chat(world, span_debug("Codex: Debug server detected. DB operation disabled."))
		log_world("Codex: Codex DB generation Skipped")
		return
	if(drop_existing)
		to_chat(world, span_debug("Codex: Deleting old index..."))
		//Check if we've already opened one this round, if so, get rid of it.
		if(codex_index)
			del(codex_index)
		fdel(CODEX_SEARCH_INDEX_FILE)
	else
		to_chat(world, span_debug("Codex: Preparing Search Database"))


	if(!rustg_file_exists(CODEX_SEARCH_INDEX_FILE))
		if(!drop_existing)
			to_chat(world, span_debug("Codex: Database missing, building..."))
		create_db()
		build_db_index()

	if(!codex_index) //If we didn't just create it, we need to load it.
		codex_index = new(CODEX_SEARCH_INDEX_FILE)

	var/database/query/cursor = new("SELECT * FROM _info")
	if(!cursor.Execute(codex_index))
		to_chat(world, span_debug("Codex: ABORTING! Database error: [cursor.Error()] | [cursor.ErrorMsg()]"))
		return

	cursor.NextRow()
	var/list/revline = cursor.GetRowData()
	var/db_serial = revline["revision"]
	if(db_serial != GLOB.revdata.commit)
		if(db_serial == CODEX_SERIAL_ALWAYS_VALID)
			to_chat(world, span_debug("Codex: Special Database Serial detected. Data may be inaccurate or out of date."))
		else
			to_chat(world, span_debug("Codex: Database out of date, Rebuilding..."))
			prepare_search_database(TRUE) //recursiveness funny,,
			return

	if(drop_existing)
		to_chat(world, span_debug("Codex: Collation complete.\nCodex: Index ready."))
		return
	to_chat(world, span_debug("Codex: Database Serial validated.\nCodex: Loading complete."))

/datum/controller/subsystem/codex/proc/create_db()
	// No index? Make one.

	to_chat(world, span_debug("Codex: Writing new database file..."))
	//We explicitly store the DB in the root directory, so that TGS builds wipe it.
	codex_index = new(CODEX_SEARCH_INDEX_FILE)

	/// Holds the revision the index was compiled for. If it's different then live, we need to regenerate the index.
	var/static/create_info_schema = {"
	CREATE TABLE "_info" (
		"revision"	TEXT
	);"}

	//Create the initial schema
	var/database/query/init_cursor = new(create_info_schema)

	if(!init_cursor.Execute(codex_index))
		to_chat(world, span_debug("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]"))
		return

	// Holds all codex entries to enable accelerated text search.
	var/static/create_codex_schema = {"
	CREATE TABLE "codex_entries" (
		"name"	TEXT NOT NULL,
		"lore_text"	TEXT,
		"mechanics_text"	TEXT,
		"antag_text"	TEXT,
		PRIMARY KEY("name")
	);"}

	init_cursor.Add(create_codex_schema)
	if(!init_cursor.Execute(codex_index))
		to_chat(world, span_debug("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]"))
		return

	var/revid = GLOB.revdata.commit
	if(!revid) //zip download, you're on your own pissboy, The serial will always be considered valid.
		revid = CODEX_SERIAL_ALWAYS_VALID

	//Insert the revision header.
	init_cursor.Add("INSERT INTO _info (revision) VALUES (?)", revid)
	if(!init_cursor.Execute(codex_index))
		to_chat(world, span_debug("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]"))
		return

/datum/controller/subsystem/codex/proc/build_db_index()
	to_chat(world, span_debug("Codex: Building search index."))

	var/database/query/cursor = new
	var/total_entries = length(all_entries)
	to_chat(world, span_debug("\tCodex: Collating [total_entries] records..."))
	var/record_id = 0 //Counter for debugging.
	for(var/datum/codex_entry/entry as anything in all_entries)
		cursor.Add(
			"INSERT INTO codex_entries (name, lore_text, mechanics_text, antag_text) VALUES (?,?,?,?)",
			entry.name,
			entry.lore_text,
			entry.mechanics_text,
			entry.antag_text
		)

		if(!cursor.Execute(codex_index))
			to_chat(world, span_debug("Codex: ABORTING! Database error: [cursor.Error()] | [cursor.ErrorMsg()]"))
			return

		record_id++
		if((!(record_id % 100)) || (record_id == total_entries))
			to_chat(world, span_debug("\tCodex: [record_id]/[total_entries]..."))

		CHECK_TICK //We'd deadlock the server otherwise.

#undef CODEX_SEARCH_INDEX_FILE
#undef CODEX_ENTRY_LIMIT
