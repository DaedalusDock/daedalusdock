/** PUNCTURES **/
/datum/wound/puncture
	pain_factor = 1.25
	always_bleed_threshold = 10
	wound_type = WOUND_PIERCE

/datum/wound/puncture/can_worsen(damage_type, damage)
	return 0 //puncture wounds cannot be enlargened

/datum/wound/puncture/small
	min_bleeding_stage = 2
	stages = list(
		"small scab" = 0,
		"healing puncture" = 2,
		"puncture" = 5,
	)

/datum/wound/puncture/flesh
	min_bleeding_stage = 3
	stages = list(
		"small round scar" = 0,
		"large scab" = 2,
		"blood soaked clot" = 5,
		"puncture wound" = 15,
	)

/datum/wound/puncture/gaping
	min_bleeding_stage = 3
	stages = list(
		"small round scar" = 0,
		"small angry scar" = 5,
		"blood soaked clot" = 10,
		"large blood soaked clot" = 15,
		"gaping hole" = 30,
	)

/datum/wound/puncture/gaping_big
	min_bleeding_stage = 3
	stages = list(
		"large round scar" = 0,
		"large angry scar" = 10,
		"large blood soaked clot" = 15,
		"healing gaping hole" = 20,
		"big gaping hole" = 50,
	)

/datum/wound/puncture/massive
	min_bleeding_stage = 3
	stages = list(
		"massive jagged scar" = 0,
		"massive angry scar" = 10,
		"massive blood soaked clot" = 25,
		"massive healing wound" = 30,
		"massive wound" = 60,
	)
