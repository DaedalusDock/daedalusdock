/datum/status_effect/food/refreshed
	id = "refreshedfood"

/datum/status_effect/food/refreshed/on_apply()
	. = ..()
	to_chat(owner, span_notice("You feel refreshed."))
	owner.stamina?.add_regen_modifier(ref(src), 2)

/datum/status_effect/food/refreshed/on_remove()
	. = ..()
	to_chat(owner, span_notice("You no longer feel refreshed."))
	owner.stamina?.remove_regen_modifier(ref(src))
