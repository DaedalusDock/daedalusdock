/datum/unit_test/combat/quick_equip_sanity
	name = "COMBAT/INTERACTION: Quick Equip Shall Be Sane"

/datum/unit_test/combat/quick_equip_sanity/Run()
	var/mob/living/carbon/human/user = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/clothing/gloves/color/yellow/gloves = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/clothing/gloves/color/red/other_gloves = ALLOCATE_BOTTOM_LEFT()

	user.put_in_active_hand(gloves)
	TEST_ASSERT(user.get_active_held_item() == gloves, "Mob is not holding the gloves, found [user.get_active_held_item() || "NULL"] instead.")

	user.execute_quick_equip()
	if(user.get_item_by_slot(ITEM_SLOT_GLOVES) != gloves)
		var/failure = "Mob did not equip the gloves to the gloves slot"
		if(user.is_holding(gloves))
			failure += " and is still holding them."
		else if(user.get_slot_by_item(gloves))
			failure += " and the gloves are in the following slot instead: [make_bitfield_readable(nameof(/obj/item::slot_flags), user.get_slot_by_item(gloves))[1]]."
		else
			failure += " and the gloves are located inside of [gloves.loc || "NULL"]."

		return TEST_FAIL(failure)

	user.put_in_active_hand(other_gloves)
	if(user.execute_quick_equip())
		var/failure = "Mob succeeded in equipping other gloves while already wearing gloves"
		if(user.is_holding(other_gloves))
			failure += " and is still holding them."
		else if(user.get_slot_by_item(other_gloves))
			failure += " and the gloves are in the following slot: [make_bitfield_readable(nameof(/obj/item::slot_flags), user.get_slot_by_item(other_gloves))[1]]."
		else
			failure += " and the gloves are located inside of [other_gloves.loc || "NULL"]."

		return TEST_FAIL(failure)
