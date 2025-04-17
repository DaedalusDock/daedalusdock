/datum/unit_test/miracle/exanguinate
	name = "MIRACLES/EXANGUINATE: Revival Miracle Works."

/datum/unit_test/miracle/exanguinate/Run()
	setup(/obj/effect/aether_rune/exanguinate)

	var/obj/item/reagent_containers/food/drinks/bottle/bottle_to_fill = ALLOCATE_BOTTOM_LEFT()

	start_miracle()

	TEST_ASSERT(bottle_to_fill.reagents.has_reagent(/datum/reagent/blood), "Bottle does not contain any blood.")
	TEST_ASSERT(bottle_to_fill.reagents.holder_full(), "Bottle was not completely filled.")
