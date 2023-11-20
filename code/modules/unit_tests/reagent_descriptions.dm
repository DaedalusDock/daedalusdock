/datum/unit_test/reagent_must_have_description/Run()
	for (var/datum/reagent/reagent as anything in subtypesof(/datum/reagent))
		// Abstract reagents don't need descriptions.
		// Otherwise, Does it have one.
		if(isabstract(reagent) || initial(reagent.description))
			continue
		TEST_FAIL("[reagent] has no description set and is not abstract")
