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
/mob/living/proc/stat_roll(requirement = STATS_BASELINE_VALUE, datum/rpg_skill/skill_path, modifier = 0, crit_fail_modifier = -10, mob/living/defender, probability_out)
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

	var/dice = roll("3d6") + modifier
	var/crit_fail = max((requirement + crit_fail_modifier), 4)
	var/crit_success = min((requirement + 7), 17)

	// if(dice >= requirement)
	// 	var/list/out = list(
	// 		"ROLL: [dice]",
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
	result.success_prob = round(dice_probability(3, 6, requirement - modifier), 0.01)
	result.crit_success_prob = round(dice_probability(3, 6, crit_success), 0.01)
	result.roll = dice
	result.requirement = requirement
	result.skill_type_used = skill_type_used

	if(dice >= requirement)
		if(dice >= crit_success)
			result.outcome = CRIT_SUCCESS
		else
			result.outcome = SUCCESS

	else
		if(dice <= crit_fail)
			result.outcome = CRIT_FAILURE
		else
			result.outcome = FAILURE

	return result

/datum/roll_result
	/// Outcome of the roll, failure, success, etc.
	var/outcome
	/// The % chance to have rolled a success (0-100)
	var/success_prob
	/// The % chance to have rolled a critical success (0-100)
	var/crit_success_prob
	/// The numerical value rolled.
	var/roll
	/// The value required to pass the roll.
	var/requirement

	/// Typepath of the skill used. Optional.
	var/datum/rpg_skill/skill_type_used

/datum/roll_result/proc/create_tooltip(body)
	if(!skill_type_used)
		if(outcome >= SUCCESS)
			body = span_statsgood(body)
		else
			body = span_statsbad(body)
		return body

	var/prefix
	if(outcome >= SUCCESS)
		prefix = span_statsgood("[uppertext(initial(skill_type_used.name))] (%[success_prob]):")
		body = span_statsgood(body)
	else
		prefix = span_statsbad("[uppertext(initial(skill_type_used.name))] (%[success_prob]):")
		body = span_statsbad(body)

	var/span = (outcome >= SUCCESS) ? "good" : "bad"
	var/tooltip_html = "Result:<span class='[span]'><b>[roll]</b></span> | Check: <b>[requirement]</b>"
	. = "<span data-component=\"Tooltip\" data-innerHTML=\"[tooltip_html]\" class=\"tooltip\">[prefix]</span> [body]"

/// Returns a number between 0 and 100 to roll the desired value when rolling the given dice.
/proc/dice_probability(num, sides, desired)
	var/static/list/outcomes_cache = new /list(0, 0)
	var/static/list/desired_cache = list()

	. = desired_cache["[num][sides][desired]"]
	if(!isnull(.))
		return .

	if(desired < num)
		. = desired_cache["[num][sides][desired]"] = 0
		return

	if(desired > num * sides)
		. = desired_cache["[num][sides][desired]"] = 100
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
