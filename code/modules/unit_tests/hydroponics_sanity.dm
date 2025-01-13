/datum/unit_test/seed_sanity
	name = "HYDROPONICS: Seeds Shall Have plant_type Set"

/datum/unit_test/seed_sanity/Run()
	for(var/obj/item/seeds/seed_type as anything in subtypesof(/obj/item/seeds))
		if(!seed_type.plant_type)
			TEST_FAIL("[seed_type] has no plant_type set.")

		if(!ispath(seed_type.plant_type, /datum/plant))
			TEST_FAIL("[seed_type] has an invalid plant_type set, got: [seed_type.plant_type].")


/datum/unit_test/plant_seed_reciprocal
	name = "HYDROPONICS: Seeds and Plants Shall Reciprocate"

/datum/unit_test/plant_seed_reciprocal/Run()
	var/list/plants_with_seeds = list()

	for(var/obj/item/seeds/S as anything in subtypesof(/obj/item/seeds))
		plants_with_seeds[S.plant_type] = S

	for(var/datum/plant/P as anything in subtypesof(/datum/plant))
		if(isabstract(P))
			continue
		if(!P.seed_path && (P in plants_with_seeds))
			TEST_FAIL("[P] has no seed_path, but [plants_with_seeds[P]] has it as a plant.")

/datum/unit_test/plant_icon_validation
	name = "HYDROPONICS: Plants Shall Have Icons"

/datum/unit_test/plant_icon_validation/Run()
	for(var/datum/plant/path as anything in typesof(/datum/plant))
		if(isabstract(path))
			continue

		var/species = path.species
		var/icon_file = path.growing_icon

		if(isnull(path.growing_icon))
			TEST_FAIL("[path] has no growing icon.")
			continue

		if(!icon_exists(icon_file, "[species]-dead"))
			TEST_FAIL("[path] is missing a dead state.")

		if(!icon_exists(icon_file, "[species]-harvest"))
			TEST_FAIL("[path] is missing a harvest state.")

		for(var/i in 1 to path.growthstages)
			if(!icon_exists(icon_file, "[species]-grow[i]"))
				TEST_FAIL("[path] is missing a growth stage state: [i]")

