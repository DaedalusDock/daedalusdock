/datum/status_effect/skill_mod/witness_death
	status_type = STATUS_EFFECT_REFRESH
	duration = 20 MINUTES

	skill_path = /datum/rpg_skill/willpower
	modify_amt = -1
	source = SKILL_SOURCE_WITNESS_DEATH

/datum/status_effect/skill_mod/witness_death/on_apply()
	if(!owner.stats.cooldown_finished("death_resolve"))
		return FALSE
	return ..()

/datum/status_effect/skill_mod/witness_death/on_remove()
	var/datum/roll_result/result = owner.stat_roll(13, /datum/rpg_skill/willpower)
	switch(result.outcome)
		if(CRIT_SUCCESS, SUCCESS)
			to_chat(owner, result.create_tooltip("You come to terms with past events, strengthing your resolve for the road ahead."))
			owner.stats.set_cooldown("death_resolve", INFINITY)
			owner.stats.set_skill_modifier(1, /datum/rpg_skill/willpower, SKILL_SOURCE_DEATH_RESOLVE)

	return ..()
