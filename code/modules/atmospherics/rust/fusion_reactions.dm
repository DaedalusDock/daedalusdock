GLOBAL_LIST_EMPTY(fusion_reactions)

/datum/fusion_reaction
	var/p_react = "" // Primary reactant.
	var/s_react = "" // Secondary reactant.
	var/minimum_energy_level = 1
	var/energy_consumption = 0
	var/energy_production = 0
	var/radiation = 0
	var/instability = 0
	var/list/products = list()
	var/minimum_reaction_temperature = 100
	var/priority = 100

/datum/fusion_reaction/proc/handle_reaction_special(obj/effect/reactor_em_field/holder)
	return 0

/proc/get_fusion_reaction(p_react, s_react)
	return GLOB.fusion_reactions[p_react]?[s_react]

/datum/fusion_reaction/deuterium_lithium
	p_react = GAS_DEUTERIUM
	//s_react = "lithium"
	s_react = GAS_NEON //DEBUG PURPOSES
	energy_consumption = 0
	energy_production = 2
	radiation = 3
	products = list(GAS_TRITIUM= 1)
	instability = 1
