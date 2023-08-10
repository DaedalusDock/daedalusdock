
/*****BRUTE*****/
//oops no theme - standard reactions with no whistles

/datum/chemical_reaction/medicine/helbital
	results = list(/datum/reagent/medicine/c2/helbital = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/fluorine = 1, /datum/reagent/carbon = 1)
	mix_message = "The mixture turns into a thick, yellow powder."
	//FermiChem vars:
	required_temp = 250
	optimal_temp = 1000
	overheat_temp = 550
	temp_exponent_factor = 1
	thermic_constant = 100
	rate_up_lim = 55
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_BRUTE

/datum/chemical_reaction/medicine/helbital/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()//drains product
	explode_fire_vortex(holder, equilibrium, 2, 2, "overheat", TRUE)

/datum/chemical_reaction/medicine/probital
	results = list(/datum/reagent/medicine/c2/probital = 4)
	required_reagents = list(/datum/reagent/copper = 1, /datum/reagent/acetone = 2,  /datum/reagent/phosphorus = 1)
	required_temp = 225
	optimal_temp = 700
	overheat_temp = 750
	temp_exponent_factor = 0.75
	thermic_constant = 50
	rate_up_lim = 30
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_BRUTE


/datum/chemical_reaction/medicine/aiuri
	results = list(/datum/reagent/medicine/c2/aiuri = 4)
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/toxin/acid = 1, /datum/reagent/hydrogen = 2)
	required_temp = 50
	optimal_temp = 300
	overheat_temp = 315
	temp_exponent_factor = 5
	thermic_constant = -400
	rate_up_lim = 35
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_BURN

/datum/chemical_reaction/medicine/aiuri/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()
	for(var/mob/living/living_mob in orange(3, get_turf(holder.my_atom)))
		if(living_mob.flash_act(1, length = 5))
			living_mob.set_blurriness(10)
	holder.my_atom.audible_message(span_notice("[icon2html(holder.my_atom, viewers(DEFAULT_MESSAGE_RANGE, src))] The [holder.my_atom] lets out a loud bang!"))
	playsound(holder.my_atom, 'sound/effects/explosion1.ogg', 50, 1)

/datum/chemical_reaction/medicine/hercuri
	results = list(/datum/reagent/medicine/c2/hercuri = 5)
	required_reagents = list(/datum/reagent/cryostylane = 3, /datum/reagent/bromine = 1, /datum/reagent/lye = 1)
	is_cold_recipe = TRUE
	required_temp = 47
	optimal_temp = 10
	overheat_temp = 5
	optimal_ph_min = 6
	optimal_ph_max = 10
	determin_ph_range = 1
	temp_exponent_factor = 3
	thermic_constant = -40
	H_ion_release = 3.7
	rate_up_lim = 50
	purity_min = 0.15
	reaction_flags = REACTION_PH_VOL_CONSTANT | REACTION_CLEAR_INVERSE
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_BURN

/datum/chemical_reaction/medicine/hercuri/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	if(off_cooldown(holder, equilibrium, 2, "hercuri_freeze"))
		return
	playsound(holder.my_atom, 'sound/magic/ethereal_exit.ogg', 50, 1)
	holder.my_atom.visible_message("The reaction frosts over, releasing it's chilly contents!")
	var/radius = max((equilibrium.step_target_vol/50), 1)
	freeze_radius(holder, equilibrium, 200, radius, 60 SECONDS) //drying agent exists
	explode_shockwave(holder, equilibrium, sound_and_text = FALSE)

/*****OXY*****/
//These react faster with optional oxygen, and have blastback effects! (the oxygen makes their fail states deadlier)

/datum/chemical_reaction/medicine/tirimol
	results = list(/datum/reagent/medicine/c2/tirimol = 5)
	required_reagents = list(/datum/reagent/nitrogen = 3, /datum/reagent/acetone = 2)
	required_catalysts = list(/datum/reagent/toxin/acid = 1)
	mix_message = "The mixture turns into a tired reddish pink liquid."
	optimal_temp = 1
	optimal_temp = 900
	overheat_temp = 720
	thermic_constant = -20
	rate_up_lim = 50
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_OXY

/datum/chemical_reaction/medicine/tirimol/reaction_step(datum/reagents/holder, datum/equilibrium/reaction, delta_t, delta_ph, step_reaction_vol)
	. = ..()
	var/datum/reagent/oxy = holder.has_reagent(/datum/reagent/oxygen)
	if(oxy)
		holder.remove_reagent(/datum/reagent/oxygen, 0.25)
	else
		holder.adjust_all_reagents_ph(-0.05*step_reaction_vol)//pH drifts faster

//Sleepytime for chem
/datum/chemical_reaction/medicine/tirimol/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, impure = FALSE)
	var/bonus = impure ? 2 : 1
	if(holder.has_reagent(/datum/reagent/oxygen))
		explode_attack_chem(holder, equilibrium, /datum/reagent/inverse/healing/tirimol, 7.5*bonus, 2, ignore_eyes = TRUE) //since we're smoke/air based
		clear_products(holder, 5)//since we attacked

/datum/chemical_reaction/medicine/tirimol/overly_impure(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()
	overheated(holder, equilibrium, TRUE)
	clear_reactants(holder, 2)

/*****TOX*****/
//These all care about purity in their reactions

/datum/chemical_reaction/medicine/seiver
	results = list(/datum/reagent/medicine/c2/seiver = 3)
	required_reagents = list(/datum/reagent/nitrogen = 1, /datum/reagent/potassium = 1, /datum/reagent/aluminium = 1)
	mix_message = "The mixture gives out a goopy slorp."
	is_cold_recipe = TRUE
	required_temp = 320
	optimal_temp = 280
	overheat_temp = NO_OVERHEAT
	temp_exponent_factor = 1
	thermic_constant = -500
	rate_up_lim = 15
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_TOXIN

/datum/chemical_reaction/medicine/syriniver
	results = list(/datum/reagent/medicine/c2/syriniver = 5)
	required_reagents = list(/datum/reagent/sulfur = 1, /datum/reagent/fluorine = 1, /datum/reagent/toxin = 1, /datum/reagent/nitrous_oxide = 2)
	required_temp = 250
	optimal_temp = 310
	overheat_temp = NO_OVERHEAT
	thermic_constant = -20
	rate_up_lim = 20 //affected by pH too
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_TOXIN

/datum/chemical_reaction/medicine/syriniver/reaction_step(datum/reagents/holder, datum/equilibrium/reaction, delta_t, delta_ph, step_reaction_vol)
	. = ..()
	reaction.delta_t = delta_t * delta_ph

/datum/chemical_reaction/medicine/penthrite
	results = list(/datum/reagent/medicine/c2/penthrite = 3)
	required_reagents = list(/datum/reagent/pentaerythritol = 1, /datum/reagent/acetone = 1,  /datum/reagent/toxin/acid/nitracid = 1 , /datum/reagent/wittel = 1)
	required_temp = 255
	optimal_temp = 350
	overheat_temp = 450
	temp_exponent_factor = 1
	thermic_constant = 150
	rate_up_lim = 15
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_HEALING | REACTION_TAG_TOXIN

//overheat beats like a heart! (or is it overbeat?)
/datum/chemical_reaction/medicine/penthrite/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()
	if(off_cooldown(holder, equilibrium, 1, "lub"))
		explode_shockwave(holder, equilibrium, 3, 2)
		playsound(holder.my_atom, 'sound/health/slowbeat.ogg', 50, 1) // this is 2 mintues long (!) cut it up!
	if(off_cooldown(holder, equilibrium, 1, "dub", 0.5))
		explode_shockwave(holder, equilibrium, 3, 2, implosion = TRUE)
		playsound(holder.my_atom, 'sound/health/slowbeat.ogg', 50, 1)
	explode_fire_vortex(holder, equilibrium, 1, 1)

//enabling hardmode
/datum/chemical_reaction/medicine/penthrite/overly_impure(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	holder.chem_temp += 15
