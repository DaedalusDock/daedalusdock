/// Test that all reagent names are different in order to prevent tgstation#65231
/datum/unit_test/reagents/names_must_be_unique

/datum/unit_test/reagents/names_must_be_unique/Run()
	var/used_names = list()

	for (var/datum/reagent/reagent as anything in subtypesof(/datum/reagent))
		var/name = initial(reagent.name)
		if (!name)
			continue

		if (name in used_names)
			TEST_FAIL("[used_names[name]] shares a name with [reagent] ([name])")
		else
			used_names[name] = reagent
