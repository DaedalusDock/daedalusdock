/** BRUISES **/
/datum/wound/bruise
	pain_factor = 1.25
	stages = list(
		"tiny bruise" = 5,
		"small bruise" = 10,
		"moderate bruise" = 20,
		"large bruise" = 30,
		"huge bruise" = 50,
		"monumental bruise" = 80,
		)

	always_bleed_threshold = 20
	min_bleeding_stage = 3 //only large bruise and above can bleed.
	autoheal_cutoff = 30
	wound_type = WOUND_BRUISE
