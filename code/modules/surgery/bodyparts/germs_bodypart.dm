//Updating germ levels. Handles organ germ levels and necrosis.
/*
The INFECTION_LEVEL values defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 15 minutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245. Note that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level nothing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs and rest will be required to recover
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on spaceacillin and get rest to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/bodypart/proc/update_germs()
	if(!IS_ORGANIC_LIMB(src)) //Robotic limbs shouldn't be infected, nor should nonexistant limbs.
		germ_level = 0
		return

	if(owner.bodytemperature > TCRYO)	//cryo stops germs from moving and doing their bad stuffs
		// Syncing germ levels with external wounds
		handle_germ_sync()

		if(germ_level && CHEM_EFFECT_MAGNITUDE(owner, CE_ANTIBIOTIC))
			// Handle antibiotics and curing infections
			handle_antibiotics()

		if(germ_level)
			// Handle the effects of infections
			. = handle_germ_effects()

/// Syncing germ levels with external wounds
/obj/item/bodypart/proc/handle_germ_sync()
	if(!length(wounds))
		return

	// Infection can occur even while on anti biotics
	for(var/datum/wound/W as anything in wounds)
		if((2*owner.germ_level > W.germ_level) && W.infection_check())
			W.germ_level++

	if(!CHEM_EFFECT_MAGNITUDE(owner, CE_ANTIBIOTIC))
		// Spread germs from wounds to bodypart
		for(var/datum/wound/W as anything in wounds)
			if (W.germ_level > germ_level || prob(min(W.germ_level, 30)))
				germ_level++
				break // max 1 germ per cycle

/// Handle antibiotics and curing infections
/obj/item/bodypart/proc/handle_antibiotics()
	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 5	//at germ_level == 500, this should cure the infection in 5 minutes
	else
		germ_level -= 3 //at germ_level == 1000, this will cure the infection in 10 minutes
	if(owner.body_position == LYING_DOWN)
		germ_level -= 2
	germ_level = max(0, germ_level)

/// Handle the effects of infections
/obj/item/bodypart/proc/handle_germ_effects()
	var/antibiotics = CHEM_EFFECT_MAGNITUDE(owner, CE_ANTIBIOTIC)
	//** Handle the effects of infections
	if(germ_level < INFECTION_LEVEL_TWO)
		if(isnull(owner) || owner.stat != DEAD)
			if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(0.3))
				germ_level--

		if (germ_level >= INFECTION_LEVEL_ONE/2)
			//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes, when immunity is full.
			if(antibiotics < 5 && prob(round(germ_level/6 * 0.01)))
				germ_level += 1

		if(germ_level >= INFECTION_LEVEL_ONE)
			var/fever_temperature = (owner.dna.species.heat_level_1 - owner.dna.species.bodytemp_normal - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.dna.species.bodytemp_normal
			owner.bodytemperature += clamp((fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, 0, fever_temperature - owner.bodytemperature)

		return

	if(germ_level >= INFECTION_LEVEL_TWO)
		//spread the infection to internal organs
		var/obj/item/organ/target_organ = null	//make internal organs become infected one at a time instead of all at once
		for (var/obj/item/organ/I as anything in contained_organs)
			if(I.cosmetic_only)
				continue
			if (I.germ_level > 0 && I.germ_level < min(germ_level, INFECTION_LEVEL_TWO)) //once the organ reaches whatever we can give it, or level two, switch to a different one
				if (!target_organ || I.germ_level > target_organ.germ_level) //choose the organ with the highest germ_level
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/obj/item/organ/I in contained_organs)
				if(I.cosmetic_only)
					continue
				if (I.germ_level < germ_level)
					candidate_organs |= I
			if (length(candidate_organs))
				target_organ = pick(candidate_organs)

		if (target_organ)
			target_organ.germ_level++

		if(istype(src, /obj/item/bodypart/chest))
			for (var/obj/item/bodypart/child as anything in owner.bodyparts)
				if(child == src || !IS_ORGANIC_LIMB(child))
					continue
				if (child.germ_level < germ_level)
					if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
						child.germ_level++
		else

			var/obj/item/bodypart/chest/parent = owner.get_bodypart(BODY_ZONE_CHEST)
			if (parent.germ_level < germ_level && IS_ORGANIC_LIMB(parent))
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(germ_level >= INFECTION_LEVEL_THREE && antibiotics < 30)	//overdosing is necessary to stop severe infections
		if (!(bodypart_flags & BP_NECROTIC))
			bodypart_flags |= BP_NECROTIC
			to_chat(owner, span_warning("You can't feel your [plaintext_zone] anymore..."))
			update_disabled()

		germ_level++
		if(owner.adjustToxLoss(1, FALSE, cause_of_death = "Necrosis"))
			return BODYPART_LIFE_UPDATE_HEALTH
