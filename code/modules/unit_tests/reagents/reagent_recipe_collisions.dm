

/datum/unit_test/reagents/recipes_must_not_conflict

/datum/unit_test/reagents/recipes_must_not_conflict/Run()
	var/list/reactions = list()
	for(var/V in SSreagents.chemical_reactions_list_reactant_index)
		reactions += SSreagents.chemical_reactions_list_reactant_index[V]
	for(var/i in 1 to (reactions.len-1))
		for(var/i2 in (i+1) to reactions.len)
			var/datum/chemical_reaction/r1 = reactions[i]
			var/datum/chemical_reaction/r2 = reactions[i2]
			if(chem_recipes_do_conflict(r1, r2))
				TEST_FAIL("Chemical recipe conflict between [r1.type] and [r2.type]")
