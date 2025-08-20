/// Reward for sanctifying corpses
/datum/status_effect/skill_mod/sanctify_corpse
	duration = 20 MINUTES
	status_type = STATUS_EFFECT_EXTEND

	skill_path = /datum/rpg_skill/willpower
	modify_amt = 1
	source = "Sanctified a corpse."


/// Innate to the Private Investigator
/datum/status_effect/skill_mod/detective
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE

	skill_path = /datum/rpg_skill/forensics
	modify_amt = 2
	source = "Experience."

// Weed
/datum/status_effect/skill_mod/cannabis_eyes
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE

	skill_path = /datum/rpg_skill/fourteen_eyes
	modify_amt = 1
	source = "Psychadelics"

/datum/status_effect/skill_mod/cannabis_magic
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE

	skill_path = /datum/rpg_skill/extrasensory
	modify_amt = 1
	source = "Psychadelics"
