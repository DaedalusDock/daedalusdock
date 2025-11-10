/datum/status_effect/food
	max_duration = 30 MINUTES
	tick_interval = 2 SECONDS
	alert_type = null

	/// Examine property to apply to the food item.
	var/examine_property

	/// Will remove an existing effect if present
	var/overrides_type
	/// Will not be applied if this type of effect is present.
	var/overridden_by_type

/datum/status_effect/food/on_creation(mob/living/new_owner, set_duration, ...)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()

/datum/status_effect/food/on_apply()
	. = ..()
	if(overridden_by_type && owner.has_status_effect(overridden_by_type))
		return FALSE

	if(overrides_type)
		owner.remove_status_effect(overrides_type)
