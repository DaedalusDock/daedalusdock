/datum/stats
	var/mob/living/owner

	// Higher is better with stats. 11 is the baseline.
	/// A lazylist
	VAR_PRIVATE/list/stats = list()

	// Higher is better with skills. 0 is the baseline.
	VAR_PRIVATE/list/skills = list()

	VAR_PRIVATE/list/stat_cooldowns = list()

	/// Cached results.
	VAR_PRIVATE/list/result_stash = list()

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

/// Returns a cached result datum pr null
/datum/stats/proc/get_stashed_result(id)
	RETURN_TYPE(/datum/roll_result)
	var/datum/roll_result/result = result_stash[id]
	if(result)
		result.cache_reads++
		return result

/// Cache a result datum. Duration <1 means infinite duration.
/datum/stats/proc/cache_result(id, datum/roll_result/result, duration = -1)
	result_stash[id] = result
	if(duration > 0)
		addtimer(CALLBACK(src, PROC_REF(uncache_result), id), duration, TIMER_UNIQUE|TIMER_OVERRIDE)

/// Removes a result from the result cache.
/datum/stats/proc/uncache_result(id)
	result_stash -= id


/** Get and use cached result datums for examining objects in the world.
 * Args:
 * * id - A string identifier to cache.
 * * requirement - The roll difficulty.
 * * skill_path - Skill type to use.
 * * modifier - See stat_roll().
 * * trait_succeed - If the mob has this trait, it will automatically score a critical success.
 * * trait_fail - If the mob has this trait, it will automatically score a critical failure.
 * * only_once - If TRUE, this proc will only return a result for the given ID if it was not already returned before.
 */
/mob/proc/get_examine_result(id, requirement = 14, datum/rpg_skill/skill_path = /datum/rpg_skill/fourteen_eyes, modifier, trait_succeed, trait_fail, only_once)
	RETURN_TYPE(/datum/roll_result)
	return null

/mob/living/get_examine_result(id, requirement = 14, datum/rpg_skill/skill_path = /datum/rpg_skill/fourteen_eyes, modifier, trait_succeed, trait_fail, only_once)
	if(!stats || !mind)
		return null

	id = "[id]_[skill_path]_[requirement]_examine"

	var/datum/roll_result/returned_result = stats.get_stashed_result(id)
	if(returned_result)
		if(only_once)
			return null
		return returned_result

	// Trait that automatically triggers a critical success.
	if(HAS_TRAIT(src, TRAIT_BIGBRAIN) || (trait_succeed && (HAS_TRAIT(src, trait_succeed) || HAS_TRAIT(mind, trait_succeed))))
		returned_result = new /datum/roll_result/critical_success
		returned_result.requirement = requirement
		returned_result.skill_type_used = skill_path
		returned_result.calculate_probability()

	if(trait_fail && (HAS_TRAIT(src, trait_fail) || HAS_TRAIT(mind, trait_fail)))
		returned_result = new /datum/roll_result/critical_failure
		returned_result.requirement = requirement
		returned_result.skill_type_used = skill_path
		returned_result.calculate_probability()

	returned_result ||= stat_roll(requirement, skill_path, modifier)
	stats.cache_result(id, returned_result, -1)
	return returned_result

