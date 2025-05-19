/// Tests that guns (bayonetted or otherwise) are able to be used as melee weapons in close range
/datum/unit_test/combat/pistol_whip
	name = "COMBAT/GUNS: Guns Shall Melee With Combat Mode and Point-Blank Without"

/datum/unit_test/combat/pistol_whip/Run()
	var/mob/living/carbon/human/consistent/attacker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/consistent/victim = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/gun/ballistic/automatic/pistol/gun = ALLOCATE_BOTTOM_LEFT()

	attacker.put_in_active_hand(gun, forced = TRUE)
	victim.forceMove(locate(attacker.x + 1, attacker.y, attacker.z))

	var/expected_ammo = gun.magazine.max_ammo + 1
	// These assertions are just here because I don't understand gun code
	TEST_ASSERT(gun.chambered, "Gun spawned without a chambered round.")
	TEST_ASSERT_EQUAL(gun.get_ammo(countchambered = TRUE), expected_ammo, "Gun spawned without a full magazine, \
		when it should spawn with mag size + 1 (chambered) rounds.")

	// Combat mode in melee range -> pistol whip
	attacker.set_combat_mode(TRUE)
	click_wrapper(attacker, victim)
	TEST_ASSERT_NOTEQUAL(victim.getBruteLoss(), 0, "Victim did not take brute damage from being pistol-whipped.")
	TEST_ASSERT_EQUAL(gun.get_ammo(countchambered = TRUE), expected_ammo, "The gun fired a shot when it was used for a pistol whip.")
	victim.fully_heal()

	// No combat mode -> point blank shot
	attacker.set_combat_mode(FALSE)
	click_wrapper(attacker, victim)
	TEST_ASSERT_NOTEQUAL(victim.getBruteLoss(), 0, "Victim did not take brute damage from being fired upon point-blank.")
	TEST_ASSERT(locate(/obj/item/ammo_casing/c9mm) in attacker.loc, "The gun did not eject a casing when it was used for a point-blank shot.")
	TEST_ASSERT_EQUAL(gun.get_ammo(countchambered = TRUE), expected_ammo - 1, "The gun did not fire a shot when it was used for a point-blank shot.")
