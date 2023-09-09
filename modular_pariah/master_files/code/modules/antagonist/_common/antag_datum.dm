/// Chance the traitor gets a kill objective. If this prob fails, they will get a steal objective instead.
#define KILL_PROB 10
/// If a kill objective is rolled, chance that it is to destroy the AI.
#define DESTROY_AI_PROB(denominator) (100 / denominator)
/// If the destroy AI objective doesn't roll, chance that we'll get a maroon instead. If this prob fails, they will get a generic assassinate objective instead.
#define MAROON_PROB 0

/// Generates a complete set of traitor objectives up to the traitor objective limit, including non-generic objectives such as hijack.
/datum/antagonist/traitor/proc/forge_traitor_objectives()
	objectives.Cut()

	var/objective_limit = CONFIG_GET(number/traitor_objectives_amount)

	for(var/i in 1 to objective_limit)
		objectives += forge_single_generic_objective()


/// Adds a generic kill or steal objective to this datum's objective list.
/datum/antagonist/traitor/proc/forge_single_generic_objective()
	RETURN_TYPE(/datum/objective)
	if(prob(KILL_PROB))
		var/list/active_ais = active_ais()
		if(active_ais.len && prob(DESTROY_AI_PROB(GLOB.joined_player_list.len)))
			var/datum/objective/destroy/destroy_objective = new
			destroy_objective.owner = owner
			destroy_objective.find_target()
			return destroy_objective

		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = owner
		kill_objective.find_target()
		return kill_objective

	if(prob(90))
		var/datum/objective/gimmick/gimmick_objective = new
		gimmick_objective.owner = owner
		return gimmick_objective
	else
		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = owner
		steal_objective.find_target()
		return steal_objective

#undef KILL_PROB
#undef DESTROY_AI_PROB
#undef MAROON_PROB
