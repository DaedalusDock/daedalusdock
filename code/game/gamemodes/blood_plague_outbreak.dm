/datum/game_mode/one_antag/blood_plague
	name = "Sanguine Plague Outbreak"

	weight = GAMEMODE_WEIGHT_COMMON

	antagonist_pop_ratio = 0.1
	antag_selector = /datum/antagonist_selector/vampire

/datum/game_mode/one_antag/blood_plague/check_finished()
	. = ..()
	if(.)
		return

	if(EMERGENCY_AT_LEAST_DOCKED || SSshuttle.emergency?.mode == SHUTTLE_CALL)
		return TRUE

	// If there's no non-vampires left alive, end the round.
	// If this becomes too common, something is wrong, this is NOT a conversion antagonist.
	for(var/mob/living/carbon/human in GLOB.human_list)
		if(!human.ckey)
			continue

		var/turf/pos = get_turf(human)
		if(isnull(pos) || !(is_station_level(pos.z) || isshuttleturf(pos)))
			continue

		if(IS_VAMPIRE(human))
			continue

		return FALSE

	return TRUE
