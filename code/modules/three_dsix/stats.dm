/datum/stats
	var/mob/living/owner

	// Higher is better with stats. 11 is the baseline.
	/// A lazylist
	VAR_PRIVATE/list/stats = list()

	// Higher is better with skills. 0 is the baseline.
	VAR_PRIVATE/list/skills = list()

	VAR_PRIVATE/list/stat_cooldowns = list()

	/// A list of weakrefs to examined objects. Used for forensic rolls. THIS DOES JUST KEEP GETTING BIGGER, SO, CAREFUL.
	var/list/examined_object_weakrefs = list()

/datum/stats/New(owner)
	. = ..()
	src.owner = owner

	for(var/datum/path as anything in typesof(/datum/rpg_stat))
		if(isabstract(path))
			continue
		stats[path] = new path

	for(var/datum/path as anything in typesof(/datum/rpg_skill))
		if(isabstract(path))
			continue
		skills[path] += new path

/datum/stats/Destroy()
	owner = null
	stats = null
	skills = null
	return ..()

/// Return a given stat value.
/datum/stats/proc/get_stat_modifier(stat)
	var/datum/rpg_stat/S = stats[stat]
	return S.get(owner)

/// Return a given skill value modifier.
/datum/stats/proc/get_skill_modifier(skill)
	var/datum/rpg_skill/S = skills[skill]
	return S.get(owner)

/// Add a stat modifier from a given source
/datum/stats/proc/set_stat_modifier(amount, datum/rpg_stat/stat_path, source)
	if(!source)
		CRASH("No source passed into set_modifiers()")
	if(!ispath(stat_path))
		CRASH("Bad stat: [stat_path]")

	var/datum/rpg_stat/S = stats[stat_path]
	LAZYSET(S.modifiers, source, amount)
	S.update_modifiers()

/// Remove all stat modifiers given by a source.
/datum/stats/proc/remove_stat_modifier(datum/rpg_stat/stat_path, source)
	if(!source)
		CRASH("No source passed into remove_modifiers()")
	if(!ispath(stat_path))
		CRASH("Bad stat: [stat_path]")

	var/datum/rpg_stat/S = stats[stat_path]
	if(LAZYACCESS(S.modifiers, source))
		S.modifiers -= source
		S.update_modifiers()

/datum/stats/proc/set_skill_modifier(amount, datum/rpg_skill/skill, source)
	if(!source)
		CRASH("No source passed into set_skill_modifier()")
	if(!ispath(skill))
		CRASH("Bad skill: [skill]")

	var/datum/rpg_skill/S = skills[skill]
	LAZYSET(S.modifiers, source, amount)
	S.update_modifiers()

/datum/stats/proc/remove_skill_modifier(datum/rpg_skill/skill, source)
	if(!source)
		CRASH("No source passed into remove_skill()")
	if(!ispath(skill))
		CRASH("Bad skill: [skill]")

	var/datum/rpg_skill/S = skills[skill]
	if(LAZYACCESS(S.modifiers, source))
		LAZYREMOVE(S.modifiers, source)
		S.update_modifiers()

/datum/stats/proc/cooldown_finished(index)
	return COOLDOWN_FINISHED(src, stat_cooldowns[index])

/datum/stats/proc/set_cooldown(index, value)
	COOLDOWN_START(src, stat_cooldowns[index], value)
