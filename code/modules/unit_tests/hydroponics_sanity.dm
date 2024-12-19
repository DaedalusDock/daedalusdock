/datum/unit_test/seed_sanity/Run()
	for(var/obj/item/seed/seed_type as anything in subtypesof(/obj/item/seed))
		if(!seed_type.plant_type)
			TEST_FAIL("[seed_type] has no plant_type set.")


/datum/unit_test/plant_sanity/Run()
	for(var/datum/plant/P as anything in subtypesof(/datum/plant))
		P = new P()
		if(P.type in P.possible_mutations)
			TEST_FAIL("[P.type] has itself as a possible mutation.")

		qdel(P)

/datum/unit_test/plant_seed_reciprocal/Run()
	var/list/plants_with_seeds = list()

	for(var/obj/item/seed/S as anything in subtypesof(/obj/item/seed))
		plants_with_seeds[S.plant_type] = S

	for(var/datum/plant/P as anything in subtypesof(/datum/plant))
		if(!P.seed_path && (P in plants_with_seeds))
			TEST_FAIL("[P] has no seed_path, but [plants_with_seeds[P]] has it as a plant.")
