///This set of tests is focused on ensuring the stability of preference dummies
///And by extension the hacks built to make them fast
///Organ consistency, object pooling via the wardrobe ss, etc

//Test spawning one of every species
/datum/unit_test/dummy_spawn_species

/datum/unit_test/dummy_spawn_species/Run()
	var/mob/living/carbon/human/dummy/lad = allocate(/mob/living/carbon/human/dummy)
	for(var/datum/species/testing_testing as anything in subtypesof(/datum/species))
		lad.set_species(testing_testing, icon_update = FALSE, pref_load = TRUE) //I wonder if I should somehow hook into the species pref here

///Equips and devests our dummy of one of every job outfit
/datum/unit_test/dummy_spawn_outfit

/datum/unit_test/dummy_spawn_outfit/Run()
	var/mob/living/carbon/human/dummy/lad = allocate(/mob/living/carbon/human/dummy)
	for(var/datum/job/one_two_three as anything in subtypesof(/datum/job))
		var/datum/job/can_you_hear_this = SSjob.GetJobType(one_two_three)
		if(!can_you_hear_this)
			log_world("Job type [one_two_three] could not be retrieved from SSjob")
			continue
		lad.job = can_you_hear_this
		lad.dress_up_as_job(can_you_hear_this, TRUE)
		lad.wipe_state() //Nuke it all

/// Wiping a dummy returns its clothes to SSwardrobe for reuse. Hooded clothing must keep its hood when this happens,
/// or whatever pulls that item from the wardrobe next (like the antag preview icons) gets hoodless clothing.
/datum/unit_test/dummy_wipe_keeps_hoods

/datum/unit_test/dummy_wipe_keeps_hoods/Run()
	var/robe_type = /obj/item/clothing/under/aether_robes

	var/mob/living/carbon/human/dummy/consistent/lad = allocate(/mob/living/carbon/human/dummy/consistent)
	lad.equipOutfit(/datum/outfit/job/doctor, visualsOnly = TRUE)

	var/obj/item/clothing/under/robe = lad.w_uniform
	TEST_ASSERT(istype(robe, robe_type), "Doctor outfit did not equip [robe_type], got [robe?.type || "nothing"]")
	var/datum/component/hooded/hooded = robe.GetComponent(/datum/component/hooded)
	TEST_ASSERT_NOTNULL(hooded, "[robe_type] has no hooded component")
	var/obj/item/clothing/head/hood = hooded.hood
	TEST_ASSERT(hooded.hood_active && lad.head == hood, "Doctor outfit did not put up the [robe_type] hood")

	lad.wipe_state()

	TEST_ASSERT_NULL(lad.w_uniform, "Wiping the dummy did not remove its uniform")
	TEST_ASSERT_NULL(lad.head, "Wiping the dummy did not remove its headwear")

	// The wardrobe is allowed to refuse the robe (it then gets deleted along with its hood), there's nothing to reuse in that case.
	if(QDELETED(robe))
		return

	TEST_ASSERT(!QDELETED(hood), "Wiping the dummy kept the robe but deleted its hood")
	TEST_ASSERT_EQUAL(hooded.hood, hood, "Wiping the dummy cleared the robe's hood reference")
	TEST_ASSERT_EQUAL(hood.loc, robe, "The hood was not returned inside the robe")
	TEST_ASSERT(!hooded.hood_active, "The robe still thinks its hood is up")

	if(!SSwardrobe.contains_object(robe))
		return

	// The robe we just stashed is the next one the wardrobe hands out, so a new doctor dummy should get it, with its hood up.
	var/mob/living/carbon/human/dummy/consistent/next_lad = allocate(/mob/living/carbon/human/dummy/consistent)
	next_lad.equipOutfit(/datum/outfit/job/doctor, visualsOnly = TRUE)
	TEST_ASSERT_EQUAL(next_lad.w_uniform, robe, "SSwardrobe did not hand out the stashed robe")
	TEST_ASSERT_EQUAL(next_lad.head, hood, "The reused robe did not put its hood up")
