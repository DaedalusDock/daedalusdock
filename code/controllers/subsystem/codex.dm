SUBSYSTEM_DEF(codex)
	name = "Codex"
	flags = SS_HIBERNATE | SS_BACKGROUND | SS_TICKER
	init_order = INIT_ORDER_CODEX
	priority = FIRE_PRIORITY_CODEX
	wait = 1

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
	/// All dynamic codex entries, Unkeyed.
	var/list/datum/codex_entry/dynamic_entries = list()
	/// Queued dynamic codex entries, Unkeyed.
	var/list/datum/codex_entry/unregistered_dynamic_entries = list()

	/// Codex Database Connection
	VAR_PRIVATE/database/codex_index
	/// Search Index breaker var, Automatically set if the DB index ever throws an error.
	VAR_PRIVATE/index_disabled = FALSE
	/// If the index is being built and a dynamic entry tries to register, queue it.
	VAR_PRIVATE/index_generating = TRUE


/datum/controller/subsystem/codex/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_REGENERATE_CODEX, "Regenerate Search Database")

/datum/controller/subsystem/codex/vv_do_topic(href_list)
	. = ..()
	if(href_list[VV_HK_REGENERATE_CODEX])
		var/regen_message
		if(index_disabled)
			regen_message = "The codex index is marked as failed or disabled, Regenerating will attempt to re-enable it. Are you sure?"
		else
			regen_message = "Are you sure you want to regenerate the search index? This will almost certainly cause lag."
		if(tgui_alert(usr, regen_message, "Regenerate Index", list("Yes", "No")) == "Yes")
			index_disabled = FALSE
			prepare_search_database(TRUE)


/datum/controller/subsystem/codex/Initialize()

	hibernate_checks = list(
		NAMEOF(src, unregistered_dynamic_entries)
	)

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
	if(!codex_index)
		can_fire = FALSE
	. = ..()

/datum/controller/subsystem/codex/stat_entry(msg)
	if(!codex_index && initialized)
		return "DISABLED" //Skip the upstream info if we're disabled. We should also be can_fire=0 by that point as well.
	msg = "{A:[length(all_entries)]|DQ:[length(unregistered_dynamic_entries)]|DR:[length(dynamic_entries)]}"
	return ..()

/datum/controller/subsystem/codex/fire(resumed)

	var/database/query/cursor = new //Prep the cursor so we don't churn it.

	for(var/datum/codex_entry/dyn_record in unregistered_dynamic_entries)
		// Take it out immediately
		unregistered_dynamic_entries -= dyn_record
		// Insert the new search record.
		cursor.Add(
			"INSERT INTO dynamic_codex_entries (name, lore_text, mechanics_text, antag_text) VALUES (?,?,?,?)",
			dyn_record.name,
			dyn_record.lore_text,
			dyn_record.mechanics_text,
			dyn_record.antag_text
		)
		if(!cursor.Execute(codex_index))
			message_admins("A dynamic codex entry failed to register. The codex search index may be unsafe, and has been disabled.")
			index_disabled = TRUE
			search_cache.Cut()
			stack_trace("Codex: ABORTING! Database error: [cursor.Error()] | [cursor.ErrorMsg()]")
			can_fire = FALSE
			pause() // A sleep it will never wake up from.
			return

		//Add the new entry to the tracking list
		dynamic_entries += dyn_record
		//Log it into the index file.
		index_file[dyn_record.name] = dyn_record
		if(MC_TICK_CHECK)
			return

	//Finally, clear the search cache.
	search_cache.Cut()


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
	if(!codex_index || index_generating) //No codex DB loaded. Use the fallback search.
		return text_search_no_db(searching)

	// -- Static Start

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
		OR mechanics_text LIKE ?
		OR antag_text LIKE ?
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

	// -- Static End
	// -- Dynamic Start

	// Search by name to build the priority entries first
	cursor.Add(
		{"SELECT name FROM dynamic_codex_entries
		WHERE name LIKE ?
		ORDER BY name asc
		LIMIT [CODEX_ENTRY_LIMIT]"},
		search_string
		)
	// Execute the query, returning us a list of types we can retrieve from the list indexes.
	cursor.Execute(codex_index)

	// God this sucks.
	while(cursor.NextRow())
		var/row = cursor.GetRowData()
		priority_results += index_file[row["name"]]
		CHECK_TICK

	// Now the awful slow ones.
	cursor.Add(
		{"SELECT name FROM dynamic_codex_entries
		WHERE lore_text LIKE ?
		OR mechanics_text LIKE ?
		OR antag_text LIKE ?
		ORDER BY name asc
		LIMIT [CODEX_ENTRY_LIMIT]"},
		search_string,
		search_string,
		search_string
		)
	// Execute the query, returning us a list of types we can retrieve from the list indexes.
	cursor.Execute(codex_index)
	while(cursor.NextRow())
		var/row = cursor.GetRowData()
		fulltext_results += index_file[row["name"]]
		CHECK_TICK

	// -- Dynamic End

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
#define CODEX_SERIAL_FALLBACK "I_DOWNLOADED_A_ZIP_INSTEAD_OF_USING_GIT"
/// Prepare the search database.
/datum/controller/subsystem/codex/proc/prepare_search_database(drop_existing = FALSE)
	if(GLOB.is_debug_server && !FORCE_CODEX_DATABASE)
		index_disabled = TRUE
		to_chat(world, span_debug("Codex: Debug server detected. DB operation disabled. See _compile_options.dm."))
		log_world("Codex: Codex DB generation Skipped")
		return
	#ifdef FORCE_CODEX_DATABASE
	to_chat(world, span_debug("Codex: Debug server detected. Override flag set, Dropping and regenerating index."))
	log_world("Codex: Codex DB generation forced by compile flag.")
	drop_existing = TRUE
	#endif
	if(index_disabled)
		message_admins("Codex DB Indexing has been disabled, This doesn't seem right. Bailing.")
		CRASH("Attempted to prepare search database, but codex index was disabled.")
	if(drop_existing)
		to_chat(world, span_debug("Codex: Deleting old index..."))
		//Check if we've already opened one this round, if so, get rid of it.
		if(codex_index)
			log_world("Codex: Deleting old index file.")
			del(codex_index)
		fdel(CODEX_SEARCH_INDEX_FILE)
	else
		to_chat(world, span_debug("Codex: Preparing Search Database"))
		log_world("Codex: Preparing Search Database")

	index_generating = TRUE
	if(!rustg_file_exists(CODEX_SEARCH_INDEX_FILE))
		if(!drop_existing)
			to_chat(world, span_debug("Codex: Database missing, building..."))
		else
			to_chat(world, span_debug("Codex: Building new database..."))
		create_db()
		build_db_index()

	if(!codex_index) //If we didn't just create it, we need to load it.
		codex_index = new(CODEX_SEARCH_INDEX_FILE)

	var/database/query/cursor = new("SELECT * FROM _info")
	if(!cursor.Execute(codex_index))
		index_disabled = TRUE
		can_fire = FALSE
		to_chat(world, span_debug("Codex: ABORTING! Database error: [cursor.Error()] | [cursor.ErrorMsg()]"))
		CRASH("Codex: ABORTING! Database error: [cursor.Error()] | [cursor.ErrorMsg()]")

	cursor.NextRow()
	var/list/revline = cursor.GetRowData()
	var/db_serial = revline["revision"]
	if(db_serial != GLOB.revdata.commit)
		if(db_serial == CODEX_SERIAL_FALLBACK)
			to_chat(world, span_debug("Codex: Fallback Database Serial detected. Data may be inaccurate or out of date."))
		else
			if(drop_existing)
				CRASH("Codex DB generation issue. Freshly generated index serial is bad. Is: [db_serial] | Expected: [GLOB.revdata.commit]")
			to_chat(world, span_debug("Codex: Database out of date, Rebuilding..."))
			prepare_search_database(TRUE) //recursiveness funny,,
			return

	if(!drop_existing)
		//Loading an old database, we need to flush the dynamic cache.
		to_chat(world, span_debug("Codex: Flushing Dynamic Index"))
		cursor.Add("DELETE FROM dynamic_codex_entries") // Without a where, this is functionally TRUNCATE
		if(!cursor.Execute(codex_index))
			to_chat(world, span_debug("Codex: ABORTING! Database error: [cursor.Error()] | [cursor.ErrorMsg()]"))
			CRASH("Codex: ABORTING! Database error: [cursor.Error()] | [cursor.ErrorMsg()]")


	index_generating = FALSE //The database is now in a safe stuff for us to begin processing dynamic entries.


	if(drop_existing)
		to_chat(world, span_debug("Codex: Collation complete.\nCodex: Index ready."))
	else
		to_chat(world, span_debug("Codex: Database Serial validated.\nCodex: Loading complete."))

/datum/controller/subsystem/codex/proc/create_db()
	// No index? Make one.

	to_chat(world, span_debug("Codex: Writing new database file..."))
	//We explicitly store the DB in the root directory, so that TGS builds wipe it.
	codex_index = new(CODEX_SEARCH_INDEX_FILE)

	to_chat(world, span_debug("Codex: Writing Schema (1/3): Metadata"))
	/// Holds the revision the index was compiled for. If it's different then live, we need to regenerate the index.
	var/static/create_info_schema = {"
	CREATE TABLE "_info" (
		"revision"	TEXT
	);"}

	//Create the initial schema
	var/database/query/init_cursor = new(create_info_schema)

	if(!init_cursor.Execute(codex_index))
		to_chat(world, span_debug("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]"))
		CRASH("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]")

	to_chat(world, span_debug("Codex: Writing Schema (2/3): Baked Index"))
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
		CRASH("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]")

	to_chat(world, span_debug("Codex: Writing Schema (3/3): Dynamic Index"))
	// Holds all dynamic codex entries to enable accelerated text search.
	var/static/create_dynamic_codex_schema = {"
	CREATE TABLE "dynamic_codex_entries" (
		"name"	TEXT NOT NULL,
		"lore_text"	TEXT,
		"mechanics_text"	TEXT,
		"antag_text"	TEXT,
		PRIMARY KEY("name")
	);"}

	init_cursor.Add(create_dynamic_codex_schema)
	if(!init_cursor.Execute(codex_index))
		to_chat(world, span_debug("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]"))
		CRASH("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]")



	var/revid = GLOB.revdata.commit //Ask TGS for the current commit. This is (intentionally) affected by testmerges.
	if(!revid) //zip download, you're on your own pissboy, The serial is special and the database will never regenerate.
		revid = CODEX_SERIAL_FALLBACK

	to_chat(world, span_debug("Codex: Schema complete, Writing serial..."))
	//Insert the revision header.
	init_cursor.Add("INSERT INTO _info (revision) VALUES (?)", revid)
	if(!init_cursor.Execute(codex_index))
		to_chat(world, span_debug("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]"))
		CRASH("Codex: ABORTING! Database error: [init_cursor.Error()] | [init_cursor.ErrorMsg()]")

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
			CRASH("Codex: ABORTING! Database error: [cursor.Error()] | [cursor.ErrorMsg()]")

		record_id++
		if((!(record_id % 100)) || (record_id == total_entries))
			to_chat(world, span_debug("\tCodex: [record_id]/[total_entries]..."))

		CHECK_TICK //We'd deadlock the server otherwise.

/// Queue a new dynamic record for insertion to the dynamic search index.
/datum/controller/subsystem/codex/proc/cache_dynamic_record(datum/codex_entry/dyn_record)
	if(!codex_index || index_disabled) // Initialized but no index, or we tripped the breaker.
		index_file[dyn_record.name] = dyn_record //Insert it into the legacy index
		search_cache.Cut() //And flush the search cache
		return
	unregistered_dynamic_entries += dyn_record
	return

#undef CODEX_SEARCH_INDEX_FILE
#undef CODEX_ENTRY_LIMIT
