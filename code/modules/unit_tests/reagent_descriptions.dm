/datum/unit_test/reagent_must_have_description/Run()
	for (var/datum/reagent/reagent as anything in subtypesof(/datum/reagent))
		// Does it have one.
		if(initial(reagent.description))
			continue
		// Abstract reagents don't need descriptions.
		if(initial(reagent.abstract_type) == reagent)
			continue
		TEST_FAIL("[reagent] has no description set and is not abstract")
