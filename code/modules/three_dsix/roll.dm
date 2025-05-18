GLOBAL_DATUM_INIT(success_roll, /datum/roll_result/success, new)
/**
 * Perform a stat roll, returning a roll result datum.
 *
 *
 * args:
 * * requirement (int) The baseline value required to roll a Success.
 * * stat (string) The stat, if applicable, to take into account.
 * * modifier (int) A modifier applied to the value after roll. Lower means the roll is more difficult.
 * * crit_fail_modifier (int) A value subtracted from the requirement, which dictates the crit fail threshold.
 */
/mob/living/proc/stat_roll(requirement = STATS_BASELINE_VALUE, datum/rpg_skill/skill_path, modifier = 0, crit_fail_modifier = -10, mob/living/defender)
	RETURN_TYPE(/datum/roll_result)

	var/skill_mod = skill_path ? stats.get_skill_modifier(skill_path) : 0
	var/stat_mod = skill_path ? stats.get_stat_modifier(initial(skill_path.parent_stat_type)) : 0

	if(defender && skill_path)
		skill_mod -= defender.stats?.get_skill_modifier(skill_path) || 0
		stat_mod += defender.stats?.get_stat_modifier(initial(skill_path.parent_stat_type)) || 0

	requirement -= stat_mod

	return roll_3d6(requirement, (skill_mod + modifier), crit_fail_modifier, skill_type_used = skill_path)

// Handy probabilities for you!
// 3 - 100.00
// 4 - 99.54
// 5 - 98.15
// 6 - 95.37
// 7 - 90.74
// 8 - 83.80
// 9 - 74.07
// 10 - 62.50
// 11 - 50.00
// 12 - 37.50
// 13 - 25.93
// 14 - 16.20
// 15 - 9.26
// 16 - 4.63
// 17 - 1.85
// 18 - 0.46
/proc/roll_3d6(requirement = STATS_BASELINE_VALUE, modifier, crit_fail_modifier = -10, datum/rpg_skill/skill_type_used)
	RETURN_TYPE(/datum/roll_result)

	var/dice = roll("3d6")
	var/dice_after_mod = dice + modifier
	var/crit_fail = max((requirement + crit_fail_modifier), 4)
	var/crit_success = min((requirement + 7), 17)

	// if(dice >= requirement)
	// 	var/list/out = list(
	// 		"ROLL: [dice] ([modifier >= 0 ? "+[modifier]" : "-[modifier]"])",
	// 		"SUCCESS PROB: %[round(dice_probability(3, 6, requirement - modifier), 0.01)]",
	// 		"CRIT SP: %[round(dice_probability(3, 6, crit_success), 0.01)]",
	// 		"MOD: [modifier]",
	// 		"LOWEST POSSIBLE: [3 + modifier]",
	// 		"HIGHEST POSSIBLE:[18 + modifier]",
	// 		"CRIT SUCCESS: [crit_success]",
	// 		"SUCCESS: [requirement]",
	// 		"FAIL: [requirement-1]",
	// 		"CRIT FAIL:[crit_fail]",
	// 		"~~~~~~~~~~~~~~~"
	// 	)
	// 	to_chat(world, span_adminnotice(jointext(out, "")))

	var/datum/roll_result/result = new()
	result.roll = dice
	result.modifier = modifier
	result.requirement = requirement
	result.skill_type_used = skill_type_used
	result.calculate_probability()

	if(dice_after_mod >= requirement)
		if(dice_after_mod >= crit_success)
			result.outcome = CRIT_SUCCESS
		else
			result.outcome = SUCCESS

	else
		if(dice_after_mod <= crit_fail)
			result.outcome = CRIT_FAILURE
		else
			result.outcome = FAILURE

	return result

/datum/roll_result
	/// Outcome of the roll, failure, success, etc.
	var/outcome
	/// The % chance to have rolled a success (0-100)
	var/success_prob
	/// The numerical value rolled.
	var/roll
	/// The value required to pass the roll.
	var/requirement
	/// The modifier attached to the roll.
	var/modifier

	/// Typepath of the skill used. Optional.
	var/datum/rpg_skill/skill_type_used

	/// How many times this result was pulled from a result cache.
	var/cache_reads = 0

/datum/roll_result/proc/calculate_probability()
	success_prob = round(dice_probability(3, 6, clamp(requirement - modifier, 0, 18)), 0.01)

/datum/roll_result/proc/create_tooltip(body, body_only = FALSE)
	if(!skill_type_used)
		if(outcome >= SUCCESS)
			body = span_statsgood(body)
		else
			body = span_statsbad(body)
		return body

	var/prob_string
	switch(success_prob)
		if(0 to 12)
			prob_string = "Impossible"
		if(13 to 24)
			prob_string = "Legendary"
		if(25 to 36)
			prob_string = "Formidable"
		if(37 to 48)
			prob_string = "Challenging"
		if(49 to 60)
			prob_string = "Hard"
		if(61 to 72)
			prob_string = "Medium"
		if(73 to 84)
			prob_string = "Easy"
		if(85 to 100)
			prob_string = "Trivial"

	var/success = ""
	switch(outcome)
		if(CRIT_SUCCESS)
			success = "Critical Success"
		if(SUCCESS)
			success = "Success"
		if(FAILURE)
			success = "Failure"
		if(CRIT_FAILURE)
			success = "Critical Failure"

	var/finished_prob_string = "<span style='color: #bbbbad;font-style: italic'>\[[prob_string]: [success]\]</span>"
	var/prefix
	if(outcome >= SUCCESS)
		prefix = "<span style='font-style: italic;color: #03fca1'>[uppertext(initial(skill_type_used.name))]</span> "
		body = span_statsgood(body)
	else
		prefix = "<span style='font-style: italic;color: #fc4b32'>[uppertext(initial(skill_type_used.name))]</span> "
		body = span_statsbad(body)

	var/modifier_string = ""
	if(modifier != 0)
		var/modifier_string_inner = modifier > 0 ? "+[modifier]" : "[modifier]"
		var/modifier_color = (modifier >= 0) ? "#03fca1" : "#fc4b32"
		modifier_string = " (<span style='font-weight: bold;color: [modifier_color]'>[modifier_string_inner]</span>)"

	var/result_color = (outcome >= SUCCESS) ? "#03fca1" : "#fc4b32"
	var/result_string = "Result: <span style='font-weight: bold;color: [result_color]'><b>[roll]</b></span>[modifier_string]"
	var/tooltip_html = "[success_prob]% | [result_string] | Check: <b>[requirement]</b>"
	var/seperator = "<span style='color: #bbbbad;font-style: italic'>: </span>"

	if(body_only)
		return body
	return "[prefix]<span data-component=\"Tooltip\" data-innerhtml=\"[tooltip_html]\" class=\"tooltip\">[finished_prob_string]</span>[seperator][body]"

/// Play
/datum/roll_result/proc/do_skill_sound(mob/user)
	if(isnull(skill_type_used) || cache_reads)
		return

	var/datum/rpg_stat/stat_path = initial(skill_type_used.parent_stat_type)
	var/sound_path = initial(stat_path.sound)
	SEND_SOUND(user, sound(sound_path))

/datum/roll_result/success
	outcome = SUCCESS
	success_prob = 100
	roll = 18
	requirement = 3

/datum/roll_result/critical_success
	outcome = CRIT_SUCCESS
	success_prob = 100
	roll = 18
	requirement = 3

/datum/roll_result/critical_failure
	outcome = CRIT_FAILURE
	success_prob = 0
	roll = 1
	requirement = 18

/// Returns a number between 0 and 100 to roll the desired value when rolling the given dice.
/proc/dice_probability(num, sides, desired)
	var/static/list/outcomes_cache = new /list(0, 0)
	var/static/list/desired_cache = list()

	. = desired_cache["[num][sides][desired]"]
	if(!isnull(.))
		return .

	if(desired < sides)
		. = desired_cache["[num][sides][desired]"] = 100
		return

	if(desired > num * sides)
		. = desired_cache["[num][sides][desired]"] = 0
		return

	if(num > length(outcomes_cache))
		outcomes_cache.len = num

	if(sides > length(outcomes_cache[num]))
		if(islist(outcomes_cache[num]))
			outcomes_cache[num]:len = sides
		else
			outcomes_cache[num] = new /list(sides)

	var/list/outcomes = outcomes_cache[num][sides]
	if(isnull(outcomes))
		outcomes = outcomes_cache[num][sides] = dice_outcome_map(num, sides)

	var/favorable_outcomes = 0
	for(var/i in desired to num*sides)
		favorable_outcomes += outcomes[i]

	. = desired_cache["[num][sides][desired]"] = (favorable_outcomes / (sides ** num)) * 100

/// Certified LummoxJR code, this returns an array which is a map of outcomes to roll [index] value.
/proc/dice_outcome_map(n, sides)
	var/i,j,k
	var/list/outcomes = new(sides)
	var/list/next
	// 1st die
	for(i in 1 to sides)
		outcomes[i] = 1
	for(k in 2 to n)
		next = new(k*sides)
		for(i in 1 to k-1)
			next[i] = 0
		for(i in 1 to sides)
			for(j in k-1 to length(outcomes))
				next[i+j] += outcomes[j]
		outcomes = next
	return outcomes
