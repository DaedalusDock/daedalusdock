/datum/slapcraft_recipe/bola
	name = "bola"
	examine_hint = "You could tie some weighted balls together with cable to make a bola..."
	category = SLAP_CAT_WEAPONS
	steps = list(
		//this looks deranged but it makes more sense to use cable on a ball, rather then the other way around.
		/datum/slapcraft_step/item/metal_ball,
		/datum/slapcraft_step/stack/cable/fifteen,
		/datum/slapcraft_step/item/metal_ball,
		/datum/slapcraft_step/item/metal_ball
	)
	result_type = /obj/item/restraints/legcuffs/bola
