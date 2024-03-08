/datum/unit_test/grab_basic/Run()
	var/mob/living/carbon/human/assailant = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/victim = allocate(__IMPLIED_TYPE__)

	victim.set_combat_mode(TRUE)
	assailant.try_make_grab(victim)

	var/obj/item/hand_item/grab/the_grab = assailant.is_grabbing(victim)
	TEST_ASSERT(!isnull(the_grab), "Assailant failed to grab victim.")

	// Test upgrading works
	var/expected_grab_level = the_grab.current_grab.upgrab
	assailant.set_combat_mode(TRUE)

	while(expected_grab_level)
		the_grab.attack_self(assailant)

		TEST_ASSERT(!QDELETED(the_grab), "Grab object qdeleted unexpectedly.")

		// Struggle grabs are special and need to be treated as such.
		if(istype(the_grab.current_grab, /datum/grab/normal/struggle))
			sleep(2) // Give the struggle a chance to resolve

		TEST_ASSERT(the_grab.current_grab == expected_grab_level, "Grab is not at the expected grab level, expected: [expected_grab_level] | got: [the_grab.current_grab || "NULL"]")

		expected_grab_level = the_grab.current_grab.upgrab
		COOLDOWN_RESET(the_grab, upgrade_cd)


	// Test downgrading works
	assailant.set_combat_mode(FALSE)
	expected_grab_level = the_grab.current_grab.downgrab

	while(TRUE)
		the_grab.attack_self(assailant)

		if(expected_grab_level)
			TEST_ASSERT(!QDELETED(the_grab), "Grab object qdeleted unexpectedly.")
			TEST_ASSERT(the_grab.current_grab == expected_grab_level, "Grab is not at the expected grab level, expected: [expected_grab_level] | got: [the_grab.current_grab || "NULL"]")

			expected_grab_level = the_grab.current_grab.upgrab
		else
			TEST_ASSERT(QDELETED(the_grab), "Grab object was not qdeleted after attempting to downgrade to nothing.")
			break

	the_grab = null

/datum/unit_test/grab_contest/Run()
	var/mob/living/carbon/human/assailant = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/victim = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/competitor = allocate(__IMPLIED_TYPE__)

	// Start off by making sure both basic grabs work
	assailant.try_make_grab(victim)
	TEST_ASSERT(assailant.is_grabbing(victim), "Assailant failed to grab victim.")

	competitor.try_make_grab(victim)
	TEST_ASSERT(competitor.is_grabbing(victim), "Competitor failed to grab victim.")
	TEST_ASSERT(assailant.is_grabbing(victim), "Competitor grab removed initial grab.")

	// Ensure that raising grab level correctly deletes opposition
	var/obj/item/hand_item/grab/assailant_grab = assailant.is_grabbing(victim)
	assailant.set_combat_mode(TRUE)
	assailant_grab.attack_self(assailant)

	TEST_ASSERT(!competitor.is_grabbing(victim), "Competitor is still grabbing victim after initial grabber raised to aggressive.")

	// Ensure that grabbing with a higher pull force replaces the initial grab
	competitor.pull_force = assailant.pull_force + 1
	competitor.try_make_grab(victim)

	TEST_ASSERT(competitor.is_grabbing(victim), "Competitor failed to grab victim despite having a superior pull force.")
	TEST_ASSERT(!assailant.is_grabbing(victim), "Initial grabber still has a grip on victim despite a superior pull force taking over.")

	// Ensure that a weaker pull force wont take away
	assailant.try_make_grab(victim)
	TEST_ASSERT(!assailant.is_grabbing(victim), "Initial grabber was able to re-grab victim despite having a weaker pull force.")

