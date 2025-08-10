/datum/movespeed_modifier/obesity
	modifier = -0.68

/datum/movespeed_modifier/monkey_reagent_speedmod
	variable = TRUE

/datum/movespeed_modifier/monkey_health_speedmod
	variable = TRUE

/datum/movespeed_modifier/monkey_temperature_speedmod
	variable = TRUE

/datum/movespeed_modifier/hunger
	variable = TRUE

/datum/movespeed_modifier/slaughter
	modifier = 0.83

/datum/movespeed_modifier/resonance
	modifier = -0.4

/datum/movespeed_modifier/pain
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/shock
	modifier = -1
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/asystole
	#warn TODO: make this multiplicative
	modifier = -2
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/equipment_speedmod
	variable = TRUE
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/grab_slowdown
	id = MOVESPEED_ID_MOB_GRAB_STATE
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/grab_slowdown/aggressive
	modifier = -1

/datum/movespeed_modifier/grab_slowdown/neck
	modifier = -1.5

/datum/movespeed_modifier/grab_slowdown/kill
	slowdown = -2

/datum/movespeed_modifier/slime_reagentmod
	variable = TRUE

/datum/movespeed_modifier/slime_healthmod
	variable = TRUE

/datum/movespeed_modifier/move_intent
	id = MOVESPEED_ID_MOB_WALK_RUN
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/move_intent/walk
	slowdown = WALK_SPEED

/datum/movespeed_modifier/move_intent/run
	slowdown = RUN_SPEED

/datum/movespeed_modifier/move_intent/sprint
	slowdown = SPRINT_SPEED

/datum/movespeed_modifier/turf_slowdown
	movetypes = GROUND
	blacklisted_movetypes = (FLYING|FLOATING)
	variable = TRUE

/datum/movespeed_modifier/grabbing
	variable = TRUE

/datum/movespeed_modifier/cold
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/shove
	modifier = SHOVE_SLOWDOWN_MOVESPEED

/datum/movespeed_modifier/human_carry
	modifier = HUMAN_CARRY_MOVESPEED

/datum/movespeed_modifier/limbless
	variable = TRUE
	movetypes = GROUND
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/simplemob_varspeed
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/tarantula_web
	modifier = -1.4

/datum/movespeed_modifier/gravity
	blacklisted_movetypes = FLOATING
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/carbon_softcrit
	slowdown = SOFTCRIT_MOVESPEED
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/slime_tempmod
	variable = TRUE

/datum/movespeed_modifier/living_exhaustion
	#warn TODO make a multiplier?
	slowdown = STAMINA_EXHAUSTION_MOVESPEED
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/carbon_crawling
	#warn TODO make a multiplier?
	modifier = CRAWLING_MOVESPEED
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/mob_config_speedmod
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/metabolicboost
	modifier = 1.5

/datum/movespeed_modifier/dragon_rage
	modifier = 0.35

/datum/movespeed_modifier/dragon_depression
	modifier = -1.4

/datum/movespeed_modifier/morph_disguised
	modifier = -0.5

/datum/movespeed_modifier/auto_wash
	modifier = -1

/datum/movespeed_modifier/atmos_pressure
	modifier = -1
	id = MOVESPEED_ID_MOB_ATMOS_AFFLICTION
	variable = TRUE

/datum/movespeed_modifier/flockphase
	modifier = 0.27
