///Checks that all achievements have an existing icon state in the achievements icon file.
/datum/unit_test/achievements

/datum/unit_test/achievements/Run()
	var/award_icons = icon_states(ACHIEVEMENTS_SET)
	for(var/datum/award/award as anything in subtypesof(/datum/award))
		if(isabstract(award)) //Skip abstract achievements types
			continue
		var/init_icon = initial(award.icon)
		if(!init_icon || !(init_icon in award_icons))
			TEST_FAIL("Award [initial(award.name)] has an unexistent icon: \"[init_icon || "null"]\"")

/datum/unit_test/achievements_ids/Run()
	for(var/datum/award/award as anything in subtypesof(/datum/award))
		if(isabstract(award)) //Skip abstract achievements types
			continue

		TEST_ASSERT(!isnull(award.database_id),"Award [initial(award.name)] does not have a database ID.")
