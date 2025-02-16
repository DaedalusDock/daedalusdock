/// Used by the Neck Bite ability.
/datum/wound/neck_bite
	pain_factor = 0
	bleed_threshold = 0
	wound_type = WOUND_PIERCE

	autoheal_cutoff = 10
	max_bleeding_stage = 1
	stages = list(
		"afflicted bite" = 5,
		"fading bite mark" = 0,
	)

/datum/wound/neck_bite/can_worsen(damage_type, damage)
	return FALSE

/datum/wound/neck_bite/can_merge(datum/wound/other)
	return FALSE

/datum/wound/neck_bite/wound_location()
	return "neck"
