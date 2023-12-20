/datum/unit_test/slapcraft_recipe_sanity/Run()

	for(var/datum/slapcraft_recipe/R as anything in typesof(/datum/slapcraft_recipe))
		if(isabstract(R))
			continue

		R = new R()
		// Check if the recipe has atleast 2 steps.
		if(length(R.steps) < 2)
			TEST_FAIL("Slapcrafting recipe of type [R.type] has less than 2 steps. This is wrong.")

		// Check if the first step is type checked, this is currently required because an optimization cache lookup works based off this.
		// And also required for the examine hints to work properly.
		var/datum/slapcraft_step/step_one = SLAPCRAFT_STEP(R.steps[1])
		if(!step_one.check_types)
			TEST_FAIL("Slapcrafting recipe of type [R.type] has first step [step_one.type] which doesn't type check. This is incompatible with an optimization cache.")

		// Make sure all steps are unique
		var/list/assoc_check = list()
		for(var/step_type in R.steps)
			if(assoc_check[step_type])
				TEST_FAIL("Slapcrafting recipe of type [R.type] has duplicate step [step_type]. Steps within a recipe must be unique!")
			assoc_check[step_type] = TRUE

		// Make sure any optional steps are not invalid.
		var/step_count = 0
		for(var/step_type in R.steps)
			step_count++
			var/datum/slapcraft_step/iterated_step = SLAPCRAFT_STEP(step_type)
			if(!iterated_step.optional)
				continue
			switch(R.step_order)
				if(SLAP_ORDER_STEP_BY_STEP, SLAP_ORDER_FIRST_AND_LAST)
					// If first, or last
					if(step_count == 1 || step_count == R.steps.len)
						TEST_FAIL("Slapcrafting recipe of type [R.type] has an optional step [step_type] as first or last step. This is forbidden!")
				if(SLAP_ORDER_FIRST_THEN_FREEFORM)
					TEST_FAIL("Slapcrafting recipe of type [R.type] has an optional step [step_type] while the order is SLAP_ORDER_FIRST_THEN_FREEFORM. This is forbidden!")
