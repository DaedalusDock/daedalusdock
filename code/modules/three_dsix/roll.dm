/**
 * Perform a stat roll, returning one of: CRIT_SUCCESS, SUCCESS, CRIT_FAILURE, FAILURE
 *
 *
 * args:
 * * requirement (int) The baseline value required to roll a Success.
 * * stat (string) The stat, if applicable, to take into account.
 * * skill (string) The skill, if applicable, to take into account.
 * * modifier (int) A modifier applied to the value after roll. Higher means the roll is more difficult.
 * * crit_fail_modifier (int) A value added to requirement, which dictates the crit fail threshold.
 */
/mob/living/proc/stat_roll(requirement = 10, stat, skill, modifier, crit_fail_modifier = 10)
	var/stat_mod = stat ? (gurps_stats.get_stat(stat) - 10) : 0
	var/skill_mod = skill ? -(gurps_stats.get_skill(skill)) : 0

	requirement += stat_mod

	return gurps_roll(requirement, (skill_mod + modifier), crit_fail_modifier)

/proc/gurps_roll(requirement = 10, modifier, crit_fail_modifier = 10)
	var/dice = roll("3d6") + modifier
	var/crit_success = max((requirement - 10), 5)
	var/crit_fail = min((requirement + crit_fail_modifier), 17)

	// to_chat(world, span_adminnotice("<br>ROLL: [dice]<br>SKILL: [skill_mod] | MOD: [modifier]<br>LOWEST POSSIBLE: [3 + skill_mod + modifier]<br>HIGHEST POSSIBLE:[18 + skill_mod + modifier]<br>CRIT SUCCESS: [crit_success]<br>SUCCESS: [requirement]<br>FAIL: [requirement+1]<br>CRIT FAIL:[crit_fail]<br>~~~~~~~~~~~~~~~"))

	if(dice <= requirement)
		if(dice <= crit_success)
			return CRIT_SUCCESS
		return SUCCESS

	else
		if(dice >= crit_fail)
			return CRIT_FAILURE
		return FAILURE
