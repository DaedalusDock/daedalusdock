/datum/rpg_stat
	abstract_type = /datum/rpg_stat
	var/name = ""
	var/desc = ""

	var/value = STATS_BASELINE_VALUE
	var/list/modifiers

	var/sound

/datum/rpg_stat/proc/get(mob/living/user)
	return value - STATS_BASELINE_VALUE

/// Update the modified value with modifiers.
/datum/rpg_stat/proc/update_modifiers()
	SHOULD_NOT_OVERRIDE(TRUE)
	value = initial(value)
	for(var/source in modifiers)
		value += modifiers[source]
