#define EXTRA_OBJECTIVE_PROB 40
/// Chance the traitor gets a kill objective. If this prob fails, they will get a steal objective instead.
#define KILL_PROB 20
/// If a kill objective is rolled, chance that it is to destroy the AI.
#define DESTROY_AI_PROB(denominator) (100 / denominator)

/// Generates a complete set of traitor objectives up to the traitor objective limit, including non-generic objectives such as hijack.
/datum/antagonist/traitor/proc/forge_traitor_objectives()
	objectives.Cut()

	var/datum/objective/O = new /datum/objective/gimmick
	O.owner = owner
	objectives += O

	if(prob(EXTRA_OBJECTIVE_PROB))
		if(prob(KILL_PROB))
			var/list/active_ais = active_ais()
			if(active_ais.len && prob(DESTROY_AI_PROB(GLOB.joined_player_list.len)))
				O = new /datum/objective/destroy
				O.owner = owner
				O.find_target()
				objectives += O
				return
			O = new /datum/objective/assassinate
			O.owner = owner
			O.find_target()
			objectives += O
			return
		else
			O = new /datum/objective/steal
			O.owner = owner
			O.find_target()
			objectives += O
			return

#undef KILL_PROB
#undef DESTROY_AI_PROB
#undef EXTRA_OBJECTIVE_PROB
