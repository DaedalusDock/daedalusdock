/// Tests that handcuffs can be applied.
/datum/unit_test/apply_cuffs
	priority = TEST_LONGER

/datum/unit_test/apply_cuffs/Run()
	var/mob/living/carbon/human/consistent/attacker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/consistent/victim = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/restraints/handcuffs/cuffs = ALLOCATE_BOTTOM_LEFT()

	cuffs.handcuff_time = 0.2 SECONDS
	attacker.put_in_active_hand(cuffs)
	click_wrapper(attacker, victim)
	TEST_ASSERT_EQUAL(victim.handcuffed, cuffs, "Handcuff attempt (non-combat-mode) failed in an otherwise valid setup.")

	victim.clear_cuffs(cuffs)
	attacker.put_in_active_hand(cuffs)
	attacker.set_combat_mode(TRUE)
	click_wrapper(attacker, victim)
	TEST_ASSERT_EQUAL(victim.handcuffed, cuffs, "Handcuff attempt (combat-mode) failed in an otherwise valid setup.")
