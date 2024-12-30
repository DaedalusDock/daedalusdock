/// Tests to make sure humans can breath in normal situations
/// Built to prevent regression on an issue surrounding QUANTIZE() and BREATH_VOLUME
/// See the comment on BREATH_VOLUME for more details
/datum/unit_test/breath_sanity

/datum/unit_test/breath_sanity/Run()
	var/mob/living/carbon/human/lab_rat = allocate(/mob/living/carbon/human)
	var/obj/item/clothing/mask/breath/tube = allocate(/obj/item/clothing/mask/breath)
	var/obj/item/tank/internals/emergency_oxygen/source = allocate(/obj/item/tank/internals/emergency_oxygen)

	lab_rat.equip_to_slot_if_possible(tube, ITEM_SLOT_MASK)
	lab_rat.equip_to_slot_if_possible(source, ITEM_SLOT_HANDS)
	source.toggle_internals(lab_rat)

	lab_rat.breathe()

	TEST_ASSERT(!lab_rat.has_alert(ALERT_NOT_ENOUGH_OXYGEN), "Humans can't get a full breath from standard o2 tanks")
	lab_rat.clear_alert(ALERT_NOT_ENOUGH_OXYGEN)

	//Prep the mob
	lab_rat.forceMove(run_loc_floor_bottom_left)
	source.toggle_internals(lab_rat)
	TEST_ASSERT(!lab_rat.internal, "toggle_internals() failed to toggle internals")

	var/turf/open/to_fill = run_loc_floor_bottom_left
	//Prep the floor
	to_fill.initial_gas = OPENTURF_DEFAULT_ATMOS
	to_fill.make_air()

	lab_rat.breathe()

	TEST_ASSERT(!lab_rat.has_alert(ALERT_NOT_ENOUGH_OXYGEN), "Humans can't get a full breath from the standard initial_gas on a turf. Turf: [to_fill.type] | Air: [json_encode(to_fill.air.gas)] | Returned Air: [json_encode(to_fill.return_air().gas)]")

/// Tests to make sure vox can breath from their internal tanks
/datum/unit_test/breath_sanity_vox

/datum/unit_test/breath_sanity_vox/Run()
	var/mob/living/carbon/human/species/vox/lab_rat = allocate(/mob/living/carbon/human/species/vox)
	var/obj/item/clothing/mask/breath/tube = allocate(/obj/item/clothing/mask/breath)
	var/obj/item/tank/internals/nitrogen/source = allocate(/obj/item/tank/internals/nitrogen)

	lab_rat.equip_to_slot_if_possible(tube, ITEM_SLOT_MASK)
	lab_rat.equip_to_slot_if_possible(source, ITEM_SLOT_HANDS)
	source.toggle_internals(lab_rat)

	lab_rat.breathe()

	TEST_ASSERT(!lab_rat.has_alert(ALERT_NOT_ENOUGH_PLASMA), "Vox can't get a full breath from a standard plasma tank")
	lab_rat.clear_alert(ALERT_NOT_ENOUGH_PLASMA)

	//Prep the mob
	source.toggle_internals(lab_rat)
	TEST_ASSERT(!lab_rat.internal, "Vox toggle_internals() failed to toggle internals")
