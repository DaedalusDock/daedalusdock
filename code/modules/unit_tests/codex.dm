/datum/unit_test/codex_links

/datum/unit_test/codex_links/Run()
	for(var/datum/codex_entry/entry in SScodex.all_entries)
		var/entry_body = jointext(entry.get_codex_body(), null)
		while(SScodex.linkRegex.Find(entry_body))
			var/regex_key = SScodex.linkRegex.group[4]
			if(SScodex.linkRegex.group[2])
				regex_key = SScodex.linkRegex.group[3]
			regex_key = codex_sanitize(regex_key)
			var/datum/codex_entry/linked_entry = SScodex.get_entry_by_string(regex_key)
			if(!linked_entry)
				TEST_FAIL("Bad codex link: '[regex_key]' in [entry.type]")
