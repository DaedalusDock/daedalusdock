#define MIXED_WEIGHT_TRAITOR 100
#define MIXED_WEIGHT_CHANGELING 0
#define MIXED_WEIGHT_HERETIC 20
#define MIXED_WEIGHT_WIZARD 1

///What percentage of the pop can become antags
#define MIXED_ANTAG_COEFF 0.15

/datum/game_mode/mixed
	name = "Mixed"
	config_key = "og_mixed"
	weight = GAMEMODE_WEIGHT_COMMON

	var/list/antag_weight_map = list(
		/datum/antagonist_selector/traitor = 100,
		/datum/antagonist_selector/vampire = 20,
		/datum/antagonist_selector/wizard = 1,
	)

	var/list/antag_selectors = list()

/datum/game_mode/mixed/New()
	. = ..()
	var/list/for_reference = antag_weight_map.Copy()
	antag_weight_map.Cut()

	for(var/selector_path in for_reference)
		antag_weight_map[new selector_path] = for_reference[selector_path]

/datum/game_mode/mixed/Destroy(force, ...)
	QDEL_LIST(antag_weight_map)
	return ..()

/datum/game_mode/mixed/pre_setup()
	. = ..()

	var/number_of_antags = max(1, round(length(SSticker.ready_players) * MIXED_ANTAG_COEFF))

	var/list/player_pool = SSticker.ready_players.Copy()
	var/list/antagonist_pool = list()

	//Setup a list of antags to try to spawn
	while(number_of_antags)
		antagonist_pool[pick_weight(antag_weight_map)] += 1
		number_of_antags--

	for(var/datum/antagonist_selector/selector in shuffle(antagonist_pool))
		selector.setup(antagonist_pool[selector], player_pool)
		player_pool -= selector.selected_mobs

/datum/game_mode/mixed/setup_antags()
	for(var/datum/antagonist_selector/selector in antag_weight_map)
		selector.give_antag_datums()
	return ..()

/datum/game_mode/mixed/post_setup(report)
	. = ..()
	for(var/datum/antagonist_selector/selector in antag_weight_map)
		selector.post_setup()

#undef MIXED_WEIGHT_TRAITOR
#undef MIXED_WEIGHT_CHANGELING
#undef MIXED_WEIGHT_HERETIC
#undef MIXED_WEIGHT_WIZARD
#undef MIXED_ANTAG_COEFF
