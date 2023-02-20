/** CUTS **/
/datum/wound/cut
	bleed_threshold = 5
	wound_type = WOUND_CUT

/datum/wound/cut/bandage()
	..()
	if(!autoheal_cutoff)
		autoheal_cutoff = initial(autoheal_cutoff)

/datum/wound/cut/is_surgical()
	return autoheal_cutoff == 0

/datum/wound/cut/close_wound()
	current_stage = max_bleeding_stage + 1
	desc = desc_list[current_stage]
	min_damage = damage_list[current_stage]
	if(damage > min_damage)
		heal_damage(damage-min_damage)

/datum/wound/cut/small
	// link wound descriptions to amounts of damage
	// Minor cuts have max_bleeding_stage set to the stage that bears the wound type's name.
	// The major cut types have the max_bleeding_stage set to the clot stage (which is accordingly given the "blood soaked" descriptor).
	max_bleeding_stage = 3
	stages = list(
		"ugly ripped cut" = 20,
		"ripped cut" = 10,
		"cut" = 5,
		"healing cut" = 2,
		"small scab" = 0
		)

/datum/wound/cut/deep
	max_bleeding_stage = 3
	stages = list(
		"ugly deep ripped cut" = 25,
		"deep ripped cut" = 20,
		"deep cut" = 15,
		"clotted cut" = 8,
		"scab" = 2,
		"fresh skin" = 0
		)

/datum/wound/cut/flesh
	max_bleeding_stage = 4
	stages = list(
		"ugly ripped flesh wound" = 35,
		"ugly flesh wound" = 30,
		"flesh wound" = 25,
		"blood soaked clot" = 15,
		"large scab" = 5,
		"fresh skin" = 0
		)

/datum/wound/cut/gaping
	max_bleeding_stage = 3
	stages = list(
		"gaping wound" = 50,
		"large blood soaked clot" = 25,
		"blood soaked clot" = 15,
		"small angry scar" = 5,
		"small straight scar" = 0
		)

/datum/wound/cut/gaping_big
	max_bleeding_stage = 3
	stages = list(
		"big gaping wound" = 60,
		"healing gaping wound" = 40,
		"large blood soaked clot" = 25,
		"large angry scar" = 10,
		"large straight scar" = 0
		)

/datum/wound/cut/massive
	max_bleeding_stage = 3
	stages = list(
		"massive wound" = 70,
		"massive healing wound" = 50,
		"massive blood soaked clot" = 25,
		"massive angry scar" = 10,
		"massive jagged scar" = 0
		)
