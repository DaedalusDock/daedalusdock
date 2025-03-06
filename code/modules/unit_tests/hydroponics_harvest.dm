// /**
//  * A test to make sure harvesting plants in hydroponics results in the correct number of plants with the correct chemicals inside of it.
//  *
//  * We plant a seed into a tray and harvest it with a human.
//  * This seed is set to have the maximum potency and yield with no instability to prevent mutations.
//  * Then we check how many products we got from the harvest. For most plants, this should be 10 products, as we have a yield of 10.
//  * Alternatively, if the plant has a trait that halves the products on harvest, it should result in 5 products.
//  *
//  * After we harvest our seed, we check for the plant's nutriments and vitamins.
//  * Most plants have nutriments, so most plants should result in a number of nutriments.
//  * Some plants have vitamins and some don't, so we then check the number of vitamins.
//  * Additionally, the plant may have traits that double the amount of chemicals it can hold. We check the max volume in that case and adjust accordingly.
//  * Plants may have additional chemicals genes that we don't check.
//  * Plants may have traits that effect the final product's contents that we don't check.
//  * Chemicals may react inside of the plant on harvest, which we don't check.
//  *
//  * After we check the harvest and the chemicals in the harvest, we go ahead and clean up the harvested products and remove the seed if it has perennial growth.
//  *
//  * This test checks both /obj/item/food/grown items and /obj/item/grown items since, despite both being used in hydroponics,
//  * they aren't the same type so everything that works with one isn't guaranteed to work with the other.
//  */
/datum/unit_test/hydroponics_harvest
	name = "HYDROPONICS: Plants Shall Have Correct Stats On Harvest"

/datum/unit_test/hydroponics_harvest/Run()
	var/obj/machinery/hydroponics/hydroponics_tray = allocate(/obj/machinery/hydroponics)
	var/obj/item/seeds/planted_food_seed = allocate(/obj/item/seeds/apple) //grown food
	var/obj/item/seeds/planted_not_food_seed = allocate(/obj/item/seeds/sunflower) //grown inedible
	var/obj/item/seeds/planted_densified_seed = allocate(/obj/item/seeds/redbeet) //grown + densified chemicals

	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)

	hydroponics_tray.forceMove(run_loc_floor_bottom_left)
	human.forceMove(locate((run_loc_floor_bottom_left.x + 1), run_loc_floor_bottom_left.y, run_loc_floor_bottom_left.z))

	// Apples should harvest 10 apples with 10u nutrients and 4u vitamins.
	test_seed(hydroponics_tray, planted_food_seed, human)
	// Sunflowers should harvest 10 sunflowers with 4u nutriment and 0u vitamins. It should also have 8u corn oil.
	test_seed(hydroponics_tray, planted_not_food_seed, human)
	// Redbeets should harvest 5 beets (10 / 2) with 10u nutriments (5 x 2) and 10u vitamins (5 x 2) thanks to densified chemicals.
	test_seed(hydroponics_tray, planted_densified_seed, human)

/datum/unit_test/hydroponics_harvest/proc/plant_and_update_seed(obj/machinery/hydroponics/tray, obj/item/seeds/seed)
	seed.plant_datum.set_base_stat(PLANT_STAT_YIELD, 10) // Sets the seed yield to 10. This gets clamped to 5 if the plant has traits to half the yield.
	seed.plant_datum.set_base_stat(PLANT_STAT_POTENCY, 100) // Sets the seed potency to 100.

	tray.plant_seed(seed)
	tray.growth = 20
	seed.plant_datum.plant_status = PLANT_HARVESTABLE

/datum/unit_test/hydroponics_harvest/proc/test_seed(obj/machinery/hydroponics/tray, obj/item/seeds/seed, mob/living/carbon/user)
	plant_and_update_seed(tray, seed)
	var/saved_name = tray.name // Name gets cleared when some plants are harvested.

	var/datum/plant/planted = tray.growing
	if(!tray.growing)
		TEST_FAIL("Hydroponics harvest from [saved_name] has no plant datum set properly to test.")

	if(!tray.seed)
		TEST_FAIL("Hydroponics harvest from [saved_name] had no seed set properly to test.")

	if(tray.seed != seed)
		TEST_FAIL("Hydroponics harvest from [saved_name] had [tray.seed] planted when it was testing [seed].")

	var/double_chemicals = planted.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/maxchem)
	var/expected_yield = planted.get_effective_stat(PLANT_STAT_YIELD)
	var/max_volume = 100 //For 99% of plants, max volume is 100.

	if(double_chemicals)
		max_volume *= 2

	tray.attack_hand(user)
	var/list/obj/item/all_harvested_items = list()
	var/list/obj/item/harvested_seeds = list()
	var/list/obj/item/produce = list()
	for(var/obj/item/harvested_food in user.drop_location())
		all_harvested_items += harvested_food
		if(istype(harvested_food, /obj/item/seeds))
			harvested_seeds += harvested_food
		else
			produce += harvested_food

	if(!produce.len)
		TEST_FAIL("Hydroponics harvest from [saved_name] resulted in 0 harvest.")

	TEST_ASSERT_EQUAL(produce.len, expected_yield, "Hydroponics harvest from [saved_name] harvested [all_harvested_items.len] items instead of [expected_yield] items.")
	TEST_ASSERT(produce[1].reagents, "Hydroponics harvest from [saved_name] had no reagent container.")
	TEST_ASSERT_EQUAL(produce[1].reagents.maximum_volume, max_volume, "Hydroponics harvest from [saved_name] [double_chemicals ? "did not have its reagent capacity doubled to [max_volume] properly." : "did not have its reagents capped at [max_volume] properly."]")

	var/expected_nutriments = planted.reagents_per_potency[/datum/reagent/consumable/nutriment] * max_volume * (POTENCY_SCALE_AT_100 / 100)
	var/expected_vitamins = planted.reagents_per_potency[/datum/reagent/consumable/nutriment/vitamin] * max_volume * (POTENCY_SCALE_AT_100 / 100)

	var/found_nutriments = produce[1].reagents.get_reagent_amount(/datum/reagent/consumable/nutriment)
	var/found_vitamins = produce[1].reagents.get_reagent_amount(/datum/reagent/consumable/nutriment/vitamin)
	QDEL_LIST(all_harvested_items) //We got everything we needed from our harvest, we can clean it up.

	TEST_ASSERT_EQUAL(found_nutriments, expected_nutriments, "Hydroponics harvest from [saved_name] has a [expected_nutriments] nutriment gene (expecting [expected_nutriments]) but only had [found_nutriments] units of nutriment inside.")
	TEST_ASSERT_EQUAL(found_vitamins, expected_vitamins, "Hydroponics harvest from [saved_name] has a [expected_vitamins] vitamin gene (expecting [expected_vitamins]) but only had [found_vitamins] units of vitamins inside.")

	if(tray.seed)
		tray.clear_plant(null)
		tray.update_appearance()
