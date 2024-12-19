/// Tests that handcuffs can be applied.
/datum/unit_test/combat/apply_cuffs
	name = "LONGER COMBAT/HANDCUFFS: Handcuffs Should Apply"
	priority = TEST_LONGER

/datum/unit_test/combat/apply_cuffs/Run()
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

/// Tests handcuffed (HANDS_BLOCKED) mobs cannot punch
/datum/unit_test/combat/handcuff_punch
	name = "COMBAT/HANDCUFFS: Cuffed Mobs Can't Punch"

/datum/unit_test/combat/handcuff_punch/Run()
	var/mob/living/carbon/human/attacker = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human/consistent)
	ADD_TRAIT(attacker, TRAIT_PERFECT_ATTACKER, TRAIT_SOURCE_UNIT_TESTS)
	ADD_TRAIT(attacker, TRAIT_HANDS_BLOCKED, TRAIT_SOURCE_UNIT_TESTS)

	attacker.set_combat_mode(TRUE)
	attacker.ClickOn(victim)

	TEST_ASSERT_EQUAL(victim.getBruteLoss(), 0, "Victim took brute damage from being punched by a handcuffed attacker")
	attacker.next_move = -1
	attacker.next_click = -1
	attacker.ClickOn(attacker)

	TEST_ASSERT_EQUAL(attacker.getBruteLoss(), 0, "Attacker took brute damage from self-punching while handcuffed")

/// Tests handcuffed (HANDS_BLOCKED) monkeys can still bite despite being cuffed
/datum/unit_test/combat/handcuff_bite
	name = "COMBAT/HANDCUFFS: Cuffed Monkeys Can't Bite"


/datum/unit_test/combat/handcuff_bite/Run()
	var/mob/living/carbon/human/attacker = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human/consistent)

	ADD_TRAIT(attacker, TRAIT_PERFECT_ATTACKER, TRAIT_SOURCE_UNIT_TESTS)
	ADD_TRAIT(attacker, TRAIT_HANDS_BLOCKED, TRAIT_SOURCE_UNIT_TESTS)

	attacker.set_combat_mode(TRUE)
	attacker.set_species(/datum/species/monkey)
	attacker.ClickOn(victim)

	TEST_ASSERT_NOTEQUAL(victim.getBruteLoss(), 0, "Victim took no brute damage from being bit by a handcuffed monkey, which is incorrect, as it's a bite attack")
