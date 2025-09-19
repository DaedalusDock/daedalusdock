/datum/status_effect/food
	max_duration = 30 MINUTES
	tick_interval = 2 SECONDS
	alert_type = null

/datum/status_effect/food/on_creation(mob/living/new_owner, set_duration, ...)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()
