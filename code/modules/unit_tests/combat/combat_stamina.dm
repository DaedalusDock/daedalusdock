/datum/unit_test/combat/stamina_swing
	name = "COMBAT/STAMINA: Attacking Shall Consume Stamina"

/datum/unit_test/combat/stamina_swing/Run()
	var/mob/living/carbon/human/consistent/attacker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/consistent/victim = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/chair/chair = ALLOCATE_BOTTOM_LEFT()

	chair.stamina_cost = 50
	attacker.put_in_active_hand(chair)
	attacker.set_combat_mode(TRUE)
	ADD_TRAIT(attacker, TRAIT_PERFECT_ATTACKER, TRAIT_SOURCE_UNIT_TESTS)

	click_wrapper(attacker, victim)

	var/expected_loss = 50
	var/actual_loss = attacker.stamina.loss
	TEST_ASSERT_EQUAL(actual_loss, expected_loss, "Attacker didn't lose 50 stamina, lost [actual_loss] instead.")

/datum/unit_test/combat/stamina_damage
	name = "COMBAT/STAMINA: Melee Victim Shall Lose Stamina"

/datum/unit_test/combat/stamina_damage/Run()
	var/mob/living/carbon/human/consistent/attacker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/consistent/victim = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/chair/chair = ALLOCATE_BOTTOM_LEFT()

	chair.stamina_critical_chance = 0
	chair.stamina_damage = 50
	attacker.put_in_active_hand(chair)
	attacker.set_combat_mode(TRUE)
	ADD_TRAIT(attacker, TRAIT_PERFECT_ATTACKER, TRAIT_SOURCE_UNIT_TESTS)

	click_wrapper(attacker, victim)

	var/expected_loss = 50
	var/actual_loss = victim.stamina.loss
	TEST_ASSERT_EQUAL(actual_loss, expected_loss, "Victim didn't lose 50 stamina, lost [actual_loss] instead.")
