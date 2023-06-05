/datum/unit_test/codex_string_uniqueness

/datum/unit_test/codex_string_uniqueness/Run()
	var/list/seen_strings = list()
	for(var/datum/codex_entry/entry as anything in SScodex.all_entries)
		for(var/associated_string in entry.associated_strings)
			if(seen_strings[associated_string])
				TEST_FAIL("Codex String Not Unique:'[associated_string]' - [entry.type]|[entry.name] - first seen: [seen_strings[associated_string]]")
			else
				seen_strings[associated_string] = "[entry.type]|[entry.name]"

/datum/unit_test/codex_overlap

/datum/unit_test/codex_overlap/Run()
	for(var/check_string in SScodex.entries_by_string)
		var/clean_check_string = lowertext(check_string)
		for(var/other_string in SScodex.entries_by_string)
			var/clean_other_string = lowertext(other_string)
			if(clean_other_string != clean_check_string && SScodex.entries_by_string[other_string] != SScodex.entries_by_string[check_string])
				if(findtext(clean_check_string, clean_other_string))
					TEST_FAIL("Codex Overlap: [check_string], [other_string]")
				else if(findtext(clean_other_string, clean_check_string))
					TEST_FAIL("Codex Overlap: [other_string], [check_string]")


/datum/unit_test/codex_links

/datum/unit_test/codex_links/Run()
	var/list/failures = list()
	for(var/datum/codex_entry/entry in SScodex.all_entries)
		var/entry_body = jointext(entry.get_codex_body(), null)
		while(SScodex.linkRegex.Find(entry_body))
			var/regex_key = SScodex.linkRegex.group[4]
			if(SScodex.linkRegex.group[2])
				regex_key = SScodex.linkRegex.group[3]
			regex_key = codex_sanitize(regex_key)
			var/replacement = SScodex.linkRegex.group[4]
			var/datum/codex_entry/linked_entry = SScodex.get_entry_by_string(regex_key)
			if(!linked_entry)
				TEST_FAIL("[entry.name] - [replacement]")
