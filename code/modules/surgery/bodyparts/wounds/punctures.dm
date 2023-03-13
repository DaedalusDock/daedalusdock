/** PUNCTURES **/
/datum/wound/puncture
	bleed_threshold = 10
	wound_type = WOUND_PIERCE

/datum/wound/puncture/can_worsen(damage_type, damage)
	return 0 //puncture wounds cannot be enlargened

/datum/wound/puncture/small
	max_bleeding_stage = 2
	stages = list(
		"puncture" = 5,
		"healing puncture" = 2,
		"small scab" = 0
		)

/datum/wound/puncture/flesh
	max_bleeding_stage = 2
	stages = list(
		"puncture wound" = 15,
		"blood soaked clot" = 5,
		"large scab" = 2,
		"small round scar" = 0
		)

/datum/wound/puncture/gaping
	max_bleeding_stage = 3
	stages = list(
		"gaping hole" = 30,
		"large blood soaked clot" = 15,
		"blood soaked clot" = 10,
		"small angry scar" = 5,
		"small round scar" = 0
		)

/datum/wound/puncture/gaping_big
	max_bleeding_stage = 3
	stages = list(
		"big gaping hole" = 50,
		"healing gaping hole" = 20,
		"large blood soaked clot" = 15,
		"large angry scar" = 10,
		"large round scar" = 0
		)

/datum/wound/puncture/massive
	max_bleeding_stage = 3
	stages = list(
		"massive wound" = 60,
		"massive healing wound" = 30,
		"massive blood soaked clot" = 25,
		"massive angry scar" = 10,
		"massive jagged scar" = 0
		)
