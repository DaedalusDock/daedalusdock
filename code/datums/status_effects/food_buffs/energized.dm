/datum/status_effect/food/energized
	id = "energized"

	var/stamina_change = 25

/datum/status_effect/food/energized/on_apply()
	. = ..()
	to_chat(owner, span_notice("You feel energized."))
	owner.stamina?.add_max_modifier(ref(src), stamina_change)

/datum/status_effect/food/energized/on_remove()
	. = ..()
	to_chat(owner, span_notice("You no longer feel energized."))
	owner.stamina?.remove_max_modifier(ref(src))

/datum/status_effect/food/energized/plus
	id = "energizedplus"
	stamina_change = 40
