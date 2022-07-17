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

/// Tests to make sure plasmaman can breath from their internal tanks
/datum/unit_test/breath_sanity_plasmamen

/datum/unit_test/breath_sanity_plasmamen/Run()
	var/mob/living/carbon/human/species/plasma/lab_rat = allocate(/mob/living/carbon/human/species/plasma)
	var/obj/item/clothing/mask/breath/tube = allocate(/obj/item/clothing/mask/breath)
	var/obj/item/tank/internals/plasmaman/source = allocate(/obj/item/tank/internals/plasmaman)

	lab_rat.equip_to_slot_if_possible(tube, ITEM_SLOT_MASK)
	lab_rat.equip_to_slot_if_possible(source, ITEM_SLOT_HANDS)
	source.toggle_internals(lab_rat)

	lab_rat.breathe()

	TEST_ASSERT(!lab_rat.has_alert(ALERT_NOT_ENOUGH_PLASMA), "Plasmamen can't get a full breath from a standard plasma tank")
	lab_rat.clear_alert(ALERT_NOT_ENOUGH_PLASMA)

	//Prep the mob
	source.toggle_internals(lab_rat)
	TEST_ASSERT(!lab_rat.internal, "Plasmaman toggle_internals() failed to toggle internals")

/// Tests to make sure ashwalkers can breath from the lavaland air
/datum/unit_test/breath_sanity_ashwalker

/datum/unit_test/breath_sanity_ashwalker/Run()
	var/mob/living/carbon/human/species/lizard/ashwalker/lab_rat = allocate(/mob/living/carbon/human/species/lizard/ashwalker)

	//Prep the mob
	lab_rat.forceMove(run_loc_floor_bottom_left)

	var/turf/open/to_fill = run_loc_floor_bottom_left
	//Prep the floor
	to_fill.initial_gas = SSzas.lavaland_atmos.gas
	to_fill.make_air()

	lab_rat.breathe()
	var/list/reason
	if(lab_rat.has_alert(ALERT_NOT_ENOUGH_OXYGEN))
		if(!to_fill.return_air())
			return Fail("Assertion Failed: Turf failed to return air. Type: [to_fill.type], Initial Gas: [json_encode(to_fill.initial_gas)]")

		var/datum/gas_mixture/turf_gas = to_fill.return_air()
		LAZYADD(reason, "Turf mix: [json_encode(turf_gas.gas)] | T: [turf_gas.temperature] | P: [turf_gas.returnPressure()] | Initial Gas: [json_encode(to_fill.initial_gas)]")

		if(lab_rat.loc != to_fill)
			LAZYADD(reason, "Rat was not located on it's intended turf!")

	if(reason)
		return Fail("Assertion Failed: [reason.Join(";")]", __FILE__, __LINE__)

/datum/unit_test/breath_sanity_ashwalker/Destroy()
	//Reset initial_gas to avoid future issues on other tests
	var/turf/open/to_fill = run_loc_floor_bottom_left
	to_fill.initial_gas = OPENTURF_DEFAULT_ATMOS
	return ..()
