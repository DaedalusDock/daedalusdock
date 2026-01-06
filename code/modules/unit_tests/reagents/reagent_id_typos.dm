
/datum/unit_test/reagents/reactions_must_have_valid_component_ids/Run()
	for(var/I in SSreagents.chemical_reactions_list_reactant_index)
		for(var/V in SSreagents.chemical_reactions_list_reactant_index[I])
			var/datum/chemical_reaction/R = V
			for(var/id in (R.required_reagents + R.required_catalysts))
				if(!SSreagents.chemical_reagents_list[id])
					TEST_FAIL("Unknown chemical id \"[id]\" in recipe [R.type]")
