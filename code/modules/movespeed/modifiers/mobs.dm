/datum/movespeed_modifier/obesity
	slowdown = 1.5

/datum/movespeed_modifier/monkey_reagent_speedmod
	variable = TRUE

/datum/movespeed_modifier/monkey_health_speedmod
	variable = TRUE

/datum/movespeed_modifier/monkey_temperature_speedmod
	variable = TRUE

/datum/movespeed_modifier/hunger
	variable = TRUE

/datum/movespeed_modifier/slaughter
	slowdown = -1

/datum/movespeed_modifier/resonance
	slowdown = 0.75

/datum/movespeed_modifier/pain
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/shock
	slowdown = 3
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/asystole
	slowdown = 10
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/equipment_speedmod
	variable = TRUE
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/grab_slowdown
	id = MOVESPEED_ID_MOB_GRAB_STATE
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/grab_slowdown/aggressive
	slowdown = 3

/datum/movespeed_modifier/grab_slowdown/neck
	slowdown = 6

/datum/movespeed_modifier/grab_slowdown/kill
	slowdown = 9

/datum/movespeed_modifier/slime_reagentmod
	variable = TRUE

/datum/movespeed_modifier/slime_healthmod
	variable = TRUE

/datum/movespeed_modifier/config_walk_run
	slowdown = 1
	id = MOVESPEED_ID_MOB_WALK_RUN
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/config_walk_run/proc/sync()

/datum/movespeed_modifier/config_walk_run/walk/sync()
	var/mod = CONFIG_GET(number/movedelay/walk_delay)
	slowdown = isnum(mod)? mod : initial(slowdown)

/datum/movespeed_modifier/config_walk_run/run/sync()
	var/mod = CONFIG_GET(number/movedelay/run_delay)
	slowdown = isnum(mod)? mod : initial(slowdown)

/datum/movespeed_modifier/config_walk_run/sprint/sync()
	var/mod = CONFIG_GET(number/movedelay/sprint_delay)
	slowdown = isnum(mod) ? mod : initial(slowdown)

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
	slowdown = SHOVE_SLOWDOWN_STRENGTH

/datum/movespeed_modifier/human_carry
	slowdown = HUMAN_CARRY_SLOWDOWN

/datum/movespeed_modifier/limbless
	variable = TRUE
	movetypes = GROUND
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/simplemob_varspeed
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/tarantula_web
	slowdown = 5

/datum/movespeed_modifier/gravity
	blacklisted_movetypes = FLOATING
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/carbon_softcrit
	slowdown = SOFTCRIT_ADD_SLOWDOWN
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/slime_tempmod
	variable = TRUE

/datum/movespeed_modifier/living_exhaustion
	slowdown = STAMINA_EXHAUSTION_MOVESPEED_SLOWDOWN
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/carbon_crawling
	slowdown = CRAWLING_ADD_SLOWDOWN
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/mob_config_speedmod
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/metabolicboost
	slowdown = -1.5

/datum/movespeed_modifier/dragon_rage
	slowdown = -0.5

/datum/movespeed_modifier/dragon_depression
	slowdown = 5

/datum/movespeed_modifier/morph_disguised
	slowdown = 1

/datum/movespeed_modifier/auto_wash
	slowdown = 3

/datum/movespeed_modifier/atmos_pressure
	slowdown = 3
	id = MOVESPEED_ID_MOB_ATMOS_AFFLICTION
	variable = TRUE

/datum/movespeed_modifier/flockphase
	slowdown = -0.4
