/datum/unit_test/miracle/exchange
	name = "MIRACLES/EXCHANGE: Exchange Miracle Works."

/datum/unit_test/miracle/exchange/Run()
	setup(/obj/effect/aether_rune/exchange)

	var/obj/item/organ/heart/new_heart = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/bodypart/arm/right/new_arm = ALLOCATE_BOTTOM_LEFT()

	start_miracle()

	TEST_ASSERT(target.getorganslot(ORGAN_SLOT_HEART) == new_heart, "Heart was not swapped.")
	TEST_ASSERT(target.get_bodypart(BODY_ZONE_R_ARM) == new_arm, "Arm was not swapped.")

	TEST_ASSERT(!blood_bottle.reagents.has_reagent(/datum/reagent/blood), "Blood reagent was not consumed by the miracle.")
