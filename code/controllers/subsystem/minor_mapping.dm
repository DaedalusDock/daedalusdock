SUBSYSTEM_DEF(minor_mapping)
	name = "Minor Mapping"
	init_order = INIT_ORDER_MINOR_MAPPING
	flags = SS_NO_FIRE

/datum/controller/subsystem/minor_mapping/Initialize(timeofday)
	trigger_migration(CONFIG_GET(number/mice_roundstart))
	place_satchels()
	return ..()

/datum/controller/subsystem/minor_mapping/proc/trigger_migration(num_pests=10)
	//this list could use some more mobs
	var/list/spawn_list = list(
		/mob/living/simple_animal/mouse = 5,
		/mob/living/basic/cockroach = 2,
		/mob/living/simple_animal/slug = 2,
	)

	var/list/landmarks = list()
	for(var/obj/effect/landmark/pestspawn/C in GLOB.landmarks_list)
		landmarks += C

	while(num_pests > 0 && length(landmarks))
		var/obj/effect/landmark/pestspawn/S = pick_n_take(landmarks)
		var/mob/living/pickedpest = pick_weight(spawn_list)
		pickedpest = new pickedpest (S.loc)
		num_pests -= 1

/datum/controller/subsystem/minor_mapping/proc/place_satchels(amount=10)
	var/list/turfs = find_satchel_suitable_turfs()

	while(turfs.len && amount > 0)
		var/turf/T = pick_n_take(turfs)
		var/obj/item/storage/backpack/satchel/flat/F = new(T)

		SEND_SIGNAL(F, COMSIG_OBJ_HIDE, T.underfloor_accessibility < UNDERFLOOR_VISIBLE)
		amount--

/proc/find_exposed_wires()
	var/list/exposed_wires = list()

	var/list/all_turfs
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		all_turfs += block(locate(1,1,z), locate(world.maxx,world.maxy,z))
	for(var/turf/open/floor/plating/T in all_turfs)
		if(T.is_blocked_turf())
			continue
		if(locate(/obj/structure/cable) in T)
			exposed_wires += T

	return shuffle(exposed_wires)

/proc/find_satchel_suitable_turfs()
	var/list/suitable = list()

	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		for(var/turf/detected_turf as anything in block(locate(1,1,z), locate(world.maxx,world.maxy,z)))
			if(isfloorturf(detected_turf) && detected_turf.underfloor_accessibility == UNDERFLOOR_HIDDEN)
				suitable += detected_turf

	return shuffle(suitable)
