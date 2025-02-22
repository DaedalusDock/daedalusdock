/** CUTS **/
/datum/wound/cut
	pain_factor = 1.25
	always_bleed_threshold = 5
	wound_type = WOUND_CUT

/datum/wound/cut/is_surgical()
	return autoheal_cutoff == 0

/datum/wound/cut/close_wound()
	current_stage = min_bleeding_stage - 1
	desc = desc_list[current_stage]
	min_damage = damage_list[current_stage]
	if(damage > min_damage)
		heal_damage(damage-min_damage)

	parent.update_damage()

/datum/wound/cut/small
	// link wound descriptions to amounts of damage
	// Minor cuts have min_bleeding_stage set to the stage that bears the wound type's name.
	// The major cut types have the min_bleeding_stage set to the clot stage (which is accordingly given the "blood soaked" descriptor).
	min_bleeding_stage = 3
	stages = list(
		"small scab" = 0,
		"healing cut" = 2,
		"cut" = 5,
		"ripped cut" = 10,
		"ugly ripped cut" = 20,
	)

/datum/wound/cut/deep
	min_bleeding_stage = 3
	stages = list(
		"fresh skin" = 0,
		"scab" = 2,
		"clotted cut" = 8,
		"deep cut" = 15,
		"deep ripped cut" = 20,
		"ugly deep ripped cut" = 25,
	)

/datum/wound/cut/flesh
	min_bleeding_stage = 3
	stages = list(
		"fresh skin" = 0,
		"large scab" = 5,
		"blood soaked clot" = 15,
		"flesh wound" = 25,
		"ugly flesh wound" = 30,
		"ugly ripped flesh wound" = 35,
	)

/datum/wound/cut/gaping
	min_bleeding_stage = 3
	stages = list(
		"small straight scar" = 0,
		"small angry scar" = 5,
		"blood soaked clot" = 15,
		"large blood soaked clot" = 25,
		"gaping wound" = 50,
	)

/datum/wound/cut/gaping_big
	min_bleeding_stage = 3
	stages = list(
		"large straight scar" = 0,
		"large angry scar" = 10,
		"large blood soaked clot" = 25,
		"healing gaping wound" = 40,
		"big gaping wound" = 60,
	)

/datum/wound/cut/massive
	min_bleeding_stage = 3
	stages = list(
		"massive jagged scar" = 0,
		"massive angry scar" = 10,
		"massive blood soaked clot" = 25,
		"massive healing wound" = 50,
		"massive wound" = 70,
	)
