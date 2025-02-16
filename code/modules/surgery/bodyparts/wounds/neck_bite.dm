/// Used by the Neck Bite ability.
/datum/wound/neck_bite
	pain_factor = 0
	always_bleed_threshold = 0
	wound_type = WOUND_PIERCE

	autoheal_cutoff = 10
	min_bleeding_stage = 2
	stages = list(
		"fading bite mark" = 0,
		"afflicted bite" = 5,
	)

/datum/wound/neck_bite/can_worsen(damage_type, damage)
	return FALSE

/datum/wound/neck_bite/can_merge(datum/wound/other)
	return FALSE

/datum/wound/neck_bite/wound_location()
	return "neck"
