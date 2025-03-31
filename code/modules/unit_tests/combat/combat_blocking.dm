/// Test that items can block unarmed attacks
/datum/unit_test/combat/unarmed_blocking
	name = "COMBAT/BLOCKING: Items Must Block Unarmed Attacks"

/datum/unit_test/combat/unarmed_blocking/Run()
	var/mob/living/carbon/human/consistent/attacker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/consistent/victim = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/chair/chair = ALLOCATE_BOTTOM_LEFT()
	chair.block_chance = 100
	victim.put_in_active_hand(chair)
	attacker.set_combat_mode(TRUE)
	ADD_TRAIT(attacker, TRAIT_PERFECT_ATTACKER, TRAIT_SOURCE_UNIT_TESTS)

	click_wrapper(attacker, victim)
	TEST_ASSERT_EQUAL(victim.getBruteLoss(), 0, "Victim took damage from being punched despite having a 100% block chance chair in their hands.")

/// Test that items can block weapon attacks
/datum/unit_test/combat/armed_blocking
	name = "COMBAT/BLOCKING: Items Must Block Armed Attacks"

/datum/unit_test/combat/armed_blocking/Run()
	var/mob/living/carbon/human/consistent/attacker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/consistent/victim = ALLOCATE_BOTTOM_LEFT()

	var/obj/item/shield/riot/shield = ALLOCATE_BOTTOM_LEFT()
	shield.block_chance = INFINITY
	victim.put_in_active_hand(shield)
	attacker.set_combat_mode(TRUE)
	ADD_TRAIT(attacker, TRAIT_PERFECT_ATTACKER, TRAIT_SOURCE_UNIT_TESTS)

	click_wrapper(attacker, victim)
	TEST_ASSERT_EQUAL(victim.getBruteLoss(), 0, "Victim took damage from being punched despite having a 100% block chance shield in their hands.")

	var/obj/item/storage/toolbox/weapon = ALLOCATE_BOTTOM_LEFT()
	attacker.put_in_active_hand(weapon)

	click_wrapper(attacker, victim)
	TEST_ASSERT_EQUAL(victim.getBruteLoss(), 0, "Victim took damage from being hit with a weapon despite having a 100% block chance shield in their hands.")
