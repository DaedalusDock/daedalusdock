/datum/unit_test/snapback_sanity
	name = "Defibrillator Paddles Must Snapback"

/datum/unit_test/snapback_sanity/Run()
	var/mob/living/carbon/human/user = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/defibrillator/defib = ALLOCATE_BOTTOM_LEFT()

	TEST_ASSERT(defib.toggle_paddles(user), "Mob failed to equip defib paddles.")
	user.forceMove(locate(user.x + 2, user.y, user.z))

	TEST_ASSERT(!user.is_holding(defib.paddles), "Mob is still holding defib paddles after moving out of range.")
	TEST_ASSERT(defib.paddles.loc == defib, "Paddles did not return to defibrillator properly, currently located inside a [defib.paddles.loc].")
