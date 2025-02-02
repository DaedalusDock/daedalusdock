/datum/unit_test/exchange_miracle
	name = "MIRACLES/EXCHANGE: Exchange Miracle Works."

/datum/unit_test/exchange_miracle/Run()
	var/mob/living/carbon/human/invoker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/target = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/aether_tome/tome = ALLOCATE_BOTTOM_LEFT()

	var/obj/item/reagent_containers/glass/bottle/blood_bottle = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/organ/heart/new_heart = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/bodypart/arm/right/new_arm = ALLOCATE_BOTTOM_LEFT()

	var/obj/effect/aether_rune/exchange/exchange_rune = ALLOCATE_BOTTOM_LEFT()

	invoker.forceMove(get_step(invoker, NORTH))
	invoker.put_in_active_hand(tome)
	target.set_body_position(LYING_DOWN)

	blood_bottle.reagents.add_reagent(/datum/reagent/blood, /obj/effect/aether_rune/exchange::required_blood_amt)

	invoker.ClickOn(exchange_rune)
	sleep(1 SECOND)

	TEST_ASSERT(target.getorganslot(ORGAN_SLOT_HEART) == new_heart, "Heart was not swapped.")
	TEST_ASSERT(target.get_bodypart(BODY_ZONE_R_ARM) == new_arm, "Arm was not swapped.")

	TEST_ASSERT(!blood_bottle.reagents.has_reagent(/datum/reagent/blood), "Blood reagent was not consumed by the miracle.")
