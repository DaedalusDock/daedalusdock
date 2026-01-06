/datum/unit_test/miracle/revival
	name = "MIRACLES/REVIVAL: Revival Miracle Works."

/datum/unit_test/miracle/revival/Run()
	setup(/obj/effect/aether_rune/revival)

	var/obj/item/reagent_containers/cup/bottle/woundseal_bottle = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/organ/heart/heart = ALLOCATE_BOTTOM_LEFT()

	target.death()

	woundseal_bottle.reagents.add_reagent(
		/datum/reagent/tincture/woundseal,
		/obj/effect/aether_rune/revival::required_woundseal_amt,
		list("potency" = /obj/effect/aether_rune/revival::required_woundseal_potency),
	)

	start_miracle()

	TEST_ASSERT(target.stat != DEAD, "Target was not revived by the miracle.")

	TEST_ASSERT(QDELETED(heart), "Heart was not consumed by the miracle.")

	TEST_ASSERT(!blood_bottle.reagents.has_reagent(/datum/reagent/blood), "Blood reagent was not consumed by the miracle.")
	TEST_ASSERT(!woundseal_bottle.reagents.has_reagent(/datum/reagent/tincture/woundseal), "Blood reagent was not consumed by the miracle.")
