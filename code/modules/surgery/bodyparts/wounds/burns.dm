/** BURNS **/
/datum/wound/burn
	pain_factor = 1.875
	wound_type = WOUND_BURN
	min_bleeding_stage = INFINITY

/datum/wound/burn/bleeding()
	return FALSE

/datum/wound/burn/moderate
	stages = list(
		"fresh skin" = 0,
		"healing moderate burn" = 2,
		"moderate burn" = 5,
		"ripped burn" = 10,
	)

/datum/wound/burn/large
	stages = list(
		"fresh skin" = 0,
		"healing large burn" = 5,
		"large burn" = 15,
		"ripped large burn" = 20,
	)

/datum/wound/burn/severe
	stages = list(
		"burn scar" = 0,
		"healing severe burn" = 10,
		"severe burn" = 30,
		"ripped severe burn" = 35,
	)

/datum/wound/burn/deep
	stages = list(
		"large burn scar" = 0,
		"healing deep burn" = 15,
		"deep burn" = 40,
		"ripped deep burn" = 45,
	)

/datum/wound/burn/carbonised
	stages = list(
		"massive burn scar" = 0,
		"healing carbonised area" = 20,
		"carbonised area" = 50,
	)
