#define REVOLUTION_SCALING_COEFF 0.1
///The absolute cap of headrevs.
#define REVOLUTION_MAX_HEADREVS 3

/datum/game_mode/one_antag/revolution
	name = "Revolution"
	config_key = "revolution"

	weight = GAMEMODE_WEIGHT_EPIC
	min_pop = 25

	antagonist_pop_ratio = 0.1
	antag_selector = /datum/antagonist_selector/revolutionary

	var/datum/team/revolution/revolution
	var/round_winner

/datum/game_mode/one_antag/revolution/get_antag_count()
	return min(..(), 3)

/datum/game_mode/one_antag/revolution/setup_antags()
	revolution = new()
	. = ..()

	revolution.update_objectives()
	revolution.update_heads()
	SSshuttle.registerHostileEnvironment(revolution)

/// Checks for revhead loss conditions and other antag datums.
/datum/game_mode/one_antag/revolution/proc/check_eligible(datum/mind/M)
	var/turf/T = get_turf(M.current)
	if(!considered_afk(M) && considered_alive(M) && is_station_level(T.z) && !M.antag_datums?.len && !HAS_TRAIT(M, TRAIT_MINDSHIELD))
		return TRUE
	return FALSE

/datum/game_mode/one_antag/revolution/process(delta_time)
	round_winner = revolution.check_completion()
	if(round_winner)
		datum_flags &= ~DF_ISPROCESSING

/datum/game_mode/one_antag/revolution/check_finished()
	. = ..()
	if(.)
		return
	return !!round_winner

/datum/game_mode/one_antag/revolution/set_round_result()
	. = ..()
	revolution.round_result(round_winner)
