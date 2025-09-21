/datum/status_effect/food/cold
	id = "coldfood"
	max_duration = 5 MINUTES

/datum/status_effect/food/cold/on_apply()
	. = ..()
	owner.add_body_temperature_change(ref(src), -5)
	to_chat(owner, span_notice("You feel chilly."))

/datum/status_effect/food/cold/on_remove()
	. = ..()
	owner.remove_body_temperature_change(ref(src))
	to_chat(owner, span_notice("You no longer feel chilly."))

/datum/status_effect/food/warm
	id = "warmfood"
	max_duration = 5 MINUTES

/datum/status_effect/food/warm/on_apply()
	. = ..()
	owner.add_body_temperature_change(ref(src), 4)
	to_chat(owner, span_notice("You feel warm."))

/datum/status_effect/food/warm/on_remove()
	. = ..()
	owner.remove_body_temperature_change(ref(src))
	to_chat(owner, span_notice("You no longer feel warm."))
