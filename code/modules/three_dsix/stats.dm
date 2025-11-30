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

	VAR_PRIVATE/atom/movable/screen/map_view/byondui/byondui_screen

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

	byondui_screen = new
	byondui_screen.generate_view("byondui_characterstats_[ref(src)]")

/datum/stats/Destroy()
	owner = null
	stats = null
	skills = null
	QDEL_NULL(byondui_screen)
	return ..()

/datum/stats/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	var/mutable_appearance/appearance = new(owner.appearance)
	appearance.dir = SOUTH
	appearance.transform = null
	remove_non_canon_overlays(appearance)
	byondui_screen.rendered_atom.appearance = appearance.appearance

	if(!ui)
		ui = new(user, src, "CharacterStats", "Character Sheet")
		ui.open()
		// ui.set_autoupdate(FALSE)
		byondui_screen.render_to_tgui(user.client, ui.window)

/datum/stats/ui_state(mob/user)
	return GLOB.always_state

/datum/stats/ui_close(mob/user)
	. = ..()
	byondui_screen.hide_from_client(user.client)

#define STATS_COLOR_NEUTRAL 0
#define STATS_COLOR_BAD 1
#define STATS_COLOR_VERY_BAD 2

/datum/stats/ui_data(mob/user)
	var/list/data = list(
		"byondui_map" = byondui_screen.assigned_map,
		"default_skill_value" = STATS_BASELINE_VALUE,
	)

	var/list/mob_data = list()
	data["mob"] = mob_data
	mob_data["name"] = owner.real_name


	var/list/skill_data = list()
	data["skills"] = skill_data

	var/list/stats_data = list()
	data["stats"] = stats_data

	for(var/skill_type in skills)
		var/datum/rpg_skill/skill = skills[skill_type]
		var/datum/rpg_stat/stat = stats[skill.parent_stat_type]

		/// Used as an out-var for get_skill_modifier()
		var/list/skill_modifiers = list()
		var/list/stat_modifiers = list()

		var/list/skill_modifier_data = list()
		var/list/stat_modifier_data = list()

		var/skill_value = get_skill_modifier(skill_type, skill_modifiers)
		var/stat_value = get_stat_modifier(stat.type, stat_modifiers)
		skill_data[++skill_data.len] = list(
			"name" = skill.name,
			"desc" = skill.desc,
			"value" = STATS_BASELINE_VALUE + skill_value + stat_value,
			"modifiers" = skill_modifier_data,
			"parent_stat_name" = stat.name,
			"class" = stat.ui_class,
			"sort_order" = skill.ui_sort_order,
		)

		if(!stats_data[stat.name])
			stats_data[stat.name] = list(
				"name" = stat.name,
				"desc" = stat.desc,
				"value" = STATS_BASELINE_VALUE + stat_value,
				"modifiers" = stat_modifier_data,
				"class" = stat.ui_class,
				"sort_order" = stat.ui_sort_order,
			)

		if(skill.modifiers)
			skill_modifiers += skill.modifiers

		if(stat.modifiers)
			stat_modifiers += stat.modifiers

		for(var/modifier_source,modifier_value in skill_modifiers)
			if(modifier_value == 0)
				continue

			skill_modifier_data[++skill_modifier_data.len] = list(
				"source" = modifier_source,
				"value" = modifier_value
			)

		for(var/modifier_source,modifier_value in stat_modifiers)
			if(modifier_value == 0)
				continue

			// Skills get stat modifiers
			skill_modifier_data[++skill_modifier_data.len] = list(
				"source" = "[modifier_source] ([stat.name])",
				"value" = modifier_value
			)

			stat_modifier_data[++stat_modifier_data.len] = list(
				"source" = "[modifier_source]",
				"value" = modifier_value
			)

	var/list/bodypart_data = list()
	data["bodyparts"] = bodypart_data

	var/list/mob_statuses = list()
	data["mob_statuses"] = mob_statuses
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner

		if(human_owner.stamina.loss)
			if(HAS_TRAIT(human_owner, TRAIT_EXHAUSTED))
				mob_statuses["exhausted"] = STATS_COLOR_NEUTRAL
			else
				mob_statuses["fatigued"] = STATS_COLOR_NEUTRAL

		var/toxloss = human_owner.getToxLoss()
		if(toxloss > 40)
			mob_statuses["malaise+++"] = STATS_COLOR_VERY_BAD
		else if(toxloss > 20)
			mob_statuses["malaise++"] = STATS_COLOR_BAD
		else if(toxloss > 10)
			mob_statuses["malaise"] = STATS_COLOR_BAD

		var/oxyloss = human_owner.getOxyLoss()
		if(oxyloss > 40)
			mob_statuses["Asphyxiating++"] = STATS_COLOR_VERY_BAD
		else if(oxyloss > 20)
			mob_statuses["Asphyxiating+"] = STATS_COLOR_VERY_BAD
		else if(oxyloss > 10)
			mob_statuses["Asphyxiating"] = STATS_COLOR_BAD

		if(!HAS_TRAIT(human_owner, TRAIT_NOHUNGER))
			switch(human_owner.nutrition)
				if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
					mob_statuses["Hungry"] = STATS_COLOR_NEUTRAL
				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
					mob_statuses["Malnourished"] = STATS_COLOR_BAD
				if(0 to NUTRITION_LEVEL_STARVING)
					mob_statuses["Starving"] = STATS_COLOR_VERY_BAD

		if(human_owner.undergoing_cardiac_arrest())
			mob_statuses["Asystole"] = STATS_COLOR_VERY_BAD

		else if(human_owner.needs_organ(ORGAN_SLOT_HEART))
			var/obj/item/organ/heart/heart = human_owner.getorganslot(ORGAN_SLOT_HEART)
			if(heart && heart.pulse != PULSE_NORM)
				mob_statuses[heart.pulse > PULSE_NORM ? "Fast heartbeat" : "Slow heartbeat"] = STATS_COLOR_BAD

		// ----- BODYPARTS -----
		var/list/sorted_parts = list(
			"Head" = locate(/obj/item/bodypart/head) in human_owner.bodyparts,
			"Right Arm" = locate(/obj/item/bodypart/arm/right) in human_owner.bodyparts,
			"Right Leg" = locate(/obj/item/bodypart/leg/right) in human_owner.bodyparts,
			"Chest" = locate(/obj/item/bodypart/chest) in human_owner.bodyparts,
			"Left Arm" = locate(/obj/item/bodypart/arm/left) in human_owner.bodyparts,
			"Left Leg" = locate(/obj/item/bodypart/leg/left) in human_owner.bodyparts,
		)

		for(var/part_name as anything in sorted_parts)
			var/list/part_data = list(
				name = part_name,
			)
			bodypart_data[++bodypart_data.len] = part_data

			var/obj/item/bodypart/part = sorted_parts[part_name]
			if(isnull(part))
				part_data["missing"] = 1
				continue

			var/list/status_strings = list()
			part_data["statuses"] = status_strings

			var/limb_max_damage = part.max_damage
			var/perceived_brute = part.brute_dam
			var/perceived_burn = part.burn_dam

			// Hallucinate more damage.
			if(human_owner.hallucination)
				if(prob(30))
					perceived_brute += rand(30,40)
				if(prob(30))
					perceived_burn += rand(30,40)

			if(part.type in human_owner.hal_screwydoll)
				perceived_brute = (human_owner.hal_screwydoll[part.type] * 0.2) * limb_max_damage

			// Perceived brute damage str
			if(perceived_brute > (limb_max_damage*0.8))
				status_strings["trauma++"] = STATS_COLOR_VERY_BAD
			else if(perceived_brute > (limb_max_damage*0.4))
				status_strings["trauma+"] = STATS_COLOR_BAD
			else if(perceived_brute > 0)
				status_strings["trauma"] = STATS_COLOR_BAD

			// Perceived burn damage str
			if(perceived_burn > (limb_max_damage*0.8))
				status_strings["burned++"] = STATS_COLOR_VERY_BAD
			else if(perceived_burn > (limb_max_damage*0.4))
				status_strings["burned+"] = STATS_COLOR_BAD
			else if(perceived_burn > 0)
				status_strings["burned"] = STATS_COLOR_BAD

			// Disabled
			if(part.bodypart_disabled && !part.is_stump)
				status_strings["disabled"] = STATS_COLOR_VERY_BAD

			// Broken
			if(part.check_bones() & CHECKBONES_BROKEN)
				status_strings["broken"] = STATS_COLOR_VERY_BAD

			// Bleeding
			if(part.get_modified_bleed_rate())
				status_strings["bleeding"] = STATS_COLOR_BAD

			// Bandaged
			if(part.bandage)
				status_strings["bandaged"] = STATS_COLOR_NEUTRAL

			// Splinted
			if(part.splint)
				status_strings["splinted"] = STATS_COLOR_NEUTRAL

			// Dislocated
			if(part.bodypart_flags & BP_DISLOCATED)
				status_strings["dislocated"] = STATS_COLOR_BAD

			// Embedded objects
			for(var/obj/item/embedded as anything in part.embedded_objects)
				status_strings["embedded [embedded.name]"] = STATS_COLOR_BAD


	return data

#undef STATS_COLOR_NEUTRAL
#undef STATS_COLOR_BAD
#undef STATS_COLOR_VERY_BAD

/// Return a given stat value.
/datum/stats/proc/get_stat_modifier(stat, list/out_sources)
	var/datum/rpg_stat/S = stats[stat]
	return S.get(owner, out_sources)

/// Return a given skill value modifier.
/datum/stats/proc/get_skill_modifier(skill, list/out_sources)
	var/datum/rpg_skill/S = skills[skill]
	return S.get(owner, out_sources)

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

/**
 * Returns a scalar value based on the given skill's current value.
 * max_scalar defines the scalar at a skill sum of 18.
 * A skill sum of 3 will return the inverse of the max_scalar (1 / max_scalar)
**/
/datum/stats/proc/get_skill_as_scalar(datum/rpg_skill/skill, max_scalar = 0, inverse = FALSE)
	if(!max_scalar)
		. = 0
		CRASH("Bad max scalar: [max_scalar]")

	var/skill_value = clamp(get_skill_modifier(skill) + STATS_BASELINE_VALUE, STATS_MINIMUM_VALUE, STATS_MAXIMUM_VALUE)
	if(skill_value == STATS_BASELINE_VALUE)
		return 1

	var/min_scalar = round(1 / max_scalar, 0.01)
	if(!inverse)
		if(skill_value > STATS_BASELINE_VALUE)
			return 1 + (skill_value - STATS_BASELINE_VALUE) * (max_scalar - 1) / (STATS_MAXIMUM_VALUE - STATS_BASELINE_VALUE)

		else
			return min_scalar + (skill_value - STATS_MINIMUM_VALUE) * (1 - min_scalar) / (STATS_BASELINE_VALUE - 3)
	else
		if(skill_value > STATS_BASELINE_VALUE)
			return 1 - (skill_value - STATS_BASELINE_VALUE) * (1 - min_scalar) / (STATS_MAXIMUM_VALUE - STATS_BASELINE_VALUE)
		else
			return max_scalar - (skill_value - STATS_MINIMUM_VALUE) * (max_scalar - 1) / (STATS_BASELINE_VALUE - 3)

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
	if(HAS_MIND_TRAIT(src, TRAIT_BIGBRAIN) || (trait_succeed && (HAS_MIND_TRAIT(src, trait_succeed) || HAS_MIND_TRAIT(src, trait_succeed))))
		returned_result = new /datum/roll_result/critical_success
		returned_result.requirement = requirement
		returned_result.skill_type_used = skill_path
		returned_result.calculate_probability()

	if(trait_fail && (HAS_MIND_TRAIT(src, trait_fail) || HAS_MIND_TRAIT(src, trait_fail)))
		returned_result = new /datum/roll_result/critical_failure
		returned_result.requirement = requirement
		returned_result.skill_type_used = skill_path
		returned_result.calculate_probability()

	returned_result ||= stat_roll(requirement, skill_path, modifier)
	stats.cache_result(id, returned_result, -1)

	if(returned_result.outcome >= SUCCESS)
		client?.give_award(/datum/award/achievement/disco_inferno)
	return returned_result



/mob/living/carbon/human/verb/check_skills()
	set name = "Character Sheet"
	set category = "IC"

	stats.ui_interact(src)
