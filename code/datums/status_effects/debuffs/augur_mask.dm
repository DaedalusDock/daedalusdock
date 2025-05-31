/datum/status_effect/augur_mask
	id = "augur_mask"

	alert_type = null

/datum/status_effect/augur_mask/on_apply()
	. = ..()

	owner.mob_mood.add_mood_event("augur_mask_wearer", /datum/mood_event/augur_mask)
	addtimer(CALLBACK(src, PROC_REF(here_comes_the_king)), 1 MINUTE)

/datum/status_effect/augur_mask/on_remove()
	. = ..()
	owner.mob_mood.clear_mood_event("augur_mask_wearer")
	owner.remove_status_effect(/datum/status_effect/grouped/king_in_yellow, ref(src))

/// OOOOHHHH YEAAAAHHHH
/datum/status_effect/augur_mask/proc/here_comes_the_king()
	var/datum/status_effect/grouped/king_in_yellow/curse = owner.has_status_effect(/datum/status_effect/grouped/king_in_yellow)
	curse ||= owner.apply_status_effect(/datum/status_effect/grouped/king_in_yellow, ref(src))

	owner.Sleeping(10 SECONDS)
	owner.mob_mood.add_mood_event("augur_mask_wearer", /datum/mood_event/augur_mask_stalk)
