/datum/status_effect/food/refreshed
	id = "refreshedfood"
	examine_property = PROPERTY_FOOD_REFRESHING
	overridden_by_type = /datum/status_effect/food/refreshed/plus
	var/regen = 2

/datum/status_effect/food/refreshed/on_apply()
	. = ..()
	to_chat(owner, span_notice("You feel refreshed."))
	owner.stamina?.add_regen_modifier(ref(src), regen)

/datum/status_effect/food/refreshed/on_remove()
	. = ..()
	to_chat(owner, span_notice("You no longer feel refreshed."))
	owner.stamina?.remove_regen_modifier(ref(src), regen)

/datum/status_effect/food/refreshed/plus
	id = "refreshedfoodplus"
	examine_property = PROPERTY_FOOD_REFRESHING_PLUS
	overrides_type = /datum/status_effect/food/refreshed
	regen = 2

