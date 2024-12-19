/**
 * Validates that all shapeshift type spells
 * have a valid possible_shapes setup.
 */
/datum/unit_test/spells/shapeshift_shapes_must_be_valid
	name = "SPELLS:Shapeshift Must Have Valid Forms"

/datum/unit_test/spells/shapeshift_shapes_must_be_valid/Run()

	var/list/types_to_test = subtypesof(/datum/action/cooldown/spell/shapeshift)

	for(var/spell_type in types_to_test)
		var/datum/action/cooldown/spell/shapeshift/shift = new spell_type()
		TEST_ASSERT(LAZYLEN(shift.possible_shapes), "Shapeshift spell: [shift] ([spell_type]) did not have any possible shapeshift options.")

		for(var/shift_type in shift.possible_shapes)
			TEST_ASSERT(ispath(shift_type, /mob/living), "Shapeshift spell: [shift] had an invalid / non-living shift type ([shift_type]) in their possible shapes list.")

		qdel(shift)
