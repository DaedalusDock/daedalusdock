/datum/unit_test/revival_miracle
	name = "MIRACLES/REVIVAL: Revival Miracle Works."

/datum/unit_test/revival_miracle/Run()
	var/mob/living/carbon/human/invoker = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/target = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/aether_tome/tome = ALLOCATE_BOTTOM_LEFT()

	var/obj/item/reagent_containers/glass/bottle/blood_bottle = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/reagent_containers/glass/bottle/woundseal_bottle = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/organ/heart/heart = ALLOCATE_BOTTOM_LEFT()

	var/obj/effect/aether_rune/revival/revival_rune = ALLOCATE_BOTTOM_LEFT()

	invoker.forceMove(get_step(invoker, NORTH))
	invoker.put_in_active_hand(tome)

	target.death()

	blood_bottle.reagents.add_reagent(/datum/reagent/blood, /obj/effect/aether_rune/revival::required_blood_amt)
	woundseal_bottle.reagents.add_reagent(
		/datum/reagent/tincture/woundseal,
		/obj/effect/aether_rune/revival::required_woundseal_amt,
		list("potency" = /obj/effect/aether_rune/revival::required_woundseal_potency),
	)

	invoker.ClickOn(revival_rune)
	sleep(1 SECOND)

	TEST_ASSERT(target.stat != DEAD, "Target was not revived by the miracle.")

	TEST_ASSERT(QDELETED(heart), "Heart was not consumed by the miracle.")

	TEST_ASSERT(!blood_bottle.reagents.has_reagent(/datum/reagent/blood), "Blood reagent was not consumed by the miracle.")
	TEST_ASSERT(!woundseal_bottle.reagents.has_reagent(/datum/reagent/tincture/woundseal), "Blood reagent was not consumed by the miracle.")
