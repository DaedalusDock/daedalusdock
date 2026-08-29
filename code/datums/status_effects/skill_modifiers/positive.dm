/// Reward for sanctifying corpses
/datum/status_effect/skill_mod/sanctify_corpse
	id = "sanctifycorpse"
	duration = 20 MINUTES
	status_type = STATUS_EFFECT_EXTEND

	skill_path = /datum/rpg_skill/knuckle_down
	modify_amt = 1
	source = "Sanctified a corpse"

/// Innate to the Private Investigator
/datum/status_effect/skill_mod/detective
	id = "detective"
	duration = -1

	skill_path = /datum/rpg_skill/forensics
	modify_amt = 2
	source = "Experience"

/// Innate to Acolytes
/datum/status_effect/skill_mod/doctor
	id = "doctor"
	duration = -1

	skill_path = /datum/rpg_skill/anatomy
	modify_amt = 2
	source = "Experience"

/datum/status_effect/skill_mod/doctor/augur
	id = "augur"
	modify_amt = 3

/// Innate to the Augur
/datum/status_effect/skill_mod/augur_eyes
	id = "augureyes"
	duration = -1

	skill_path = /datum/rpg_skill/fourteen_eyes
	modify_amt = 1
	source = "Practice"

/// Innate to Engineers
/datum/status_effect/skill_mod/engineer
	id = "engineer"
	duration = -1

	skill_path = /datum/rpg_skill/fine_motor
	modify_amt = 2
	source = "Experience"

/datum/status_effect/skill_mod/engineer/chief
	id = "chiefengineer"
	modify_amt = 3

/// Innate to security officers
/datum/status_effect/skill_mod/security
	id = "security"
	duration = -1

	skill_path = /datum/rpg_skill/bloodsport
	modify_amt = 1 // Side of caution here
	source = "Training"

/// Innate to the security marshal
/datum/status_effect/skill_mod/security_marshal
	id = "securitymarshal"
	skill_path = /datum/rpg_skill/knuckle_down
	modify_amt = 3
	source = "Tenure"

// Weed
/datum/status_effect/skill_mod/cannabis_eyes
	id = "cannabiseyes"
	duration = -1

	skill_path = /datum/rpg_skill/fourteen_eyes
	modify_amt = 1
	source = "Psychadelics"

/datum/status_effect/skill_mod/cannabis_magic
	id = "cannabis magic"
	duration = -1

	skill_path = /datum/rpg_skill/fourteen_eyes
	modify_amt = 1
	source = "Psychadelics"

/datum/status_effect/skill_mod/slip
	id = "slippedandfell"
	status_type = STATUS_EFFECT_REFRESH

	duration = 5 MINUTES

	skill_path = /datum/rpg_skill/theatre
	modify_amt = 1
	source = "Slipped and fell"

/// Given to entertainers, sometimes, when people laugh near them.
/datum/status_effect/skill_mod/laugh
	id = "madesomeonelaugh"
	status_type = STATUS_EFFECT_REFRESH

	duration = 10 MINUTES

	skill_path = /datum/rpg_skill/theatre
	modify_amt = 2
	source = "Made someone laugh"

/datum/status_effect/skill_mod/hallucinating
	id = "hallucinatingskillmod"
	duration = STATUS_EFFECT_PERMANENT
	status_type = STATUS_EFFECT_UNIQUE
	skill_path = /datum/rpg_skill/fourteen_eyes
	modify_amt = 2
	source = "Hallucinations"
