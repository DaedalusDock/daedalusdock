/// Tests that flashes, well, flash.
/datum/unit_test/combat/flash_click
	name = "COMBAT/FLASH: Flashes Shall Deal Stamina Damage"
	var/apply_verb = "while Attacker was not on combat mode"

/datum/unit_test/combat/flash_click/Run()
	var/mob/living/carbon/human/consistent/attacker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/consistent/victim = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/assembly/flash/handheld/flash = ALLOCATE_BOTTOM_LEFT()

	attacker.put_in_active_hand(flash)
	ready_subjects(attacker, victim)
	click_wrapper(attacker, victim)
	check_results(attacker, victim)

/datum/unit_test/combat/flash_click/proc/ready_subjects(mob/living/carbon/human/attacker, mob/living/carbon/human/victim)
	victim.forceMove(locate(attacker.x + 1, attacker.y, attacker.z))
	attacker.face_atom(victim)
	victim.face_atom(attacker)

/datum/unit_test/combat/flash_click/proc/check_results(mob/living/carbon/human/attacker, mob/living/carbon/human/victim)
	TEST_ASSERT_NOTEQUAL(victim.stamina.loss, 0, "Victim should have sustained stamina loss from being flashed head-on [apply_verb].")

/// Tests that flashes flash on combat mode.
/datum/unit_test/combat/flash_click/combat_mode
	name = "COMBAT/FLASH: Flashes Shall Deal Stamina Damage (Combat Mode)"
	apply_verb = "while Attacker was on combat mode"

/datum/unit_test/combat/flash_click/combat_mode/ready_subjects(mob/living/carbon/human/attacker, mob/living/carbon/human/victim)
	. = ..()
	attacker.set_combat_mode(TRUE)

/// Tests that flashes do not flash if wearing protection.
/datum/unit_test/combat/flash_click/flash_protection
	name = "COMBAT/FLASH: Flashes Shall Deal Not Deal Stamina Damage To Flash Immune"
	apply_verb = "while wearing flash protection"

/datum/unit_test/combat/flash_click/flash_protection/ready_subjects(mob/living/carbon/human/attacker, mob/living/carbon/human/victim)
	. = ..()
	var/obj/item/clothing/glasses/sunglasses/glasses = ALLOCATE_BOTTOM_LEFT()
	victim.equip_to_appropriate_slot(glasses)

/datum/unit_test/combat/flash_click/flash_protection/check_results(mob/living/carbon/human/attacker, mob/living/carbon/human/victim)
	TEST_ASSERT_EQUAL(victim.stamina.loss, 0, "Victim should not have sustained stamina loss from being flashed head-on [apply_verb].")
