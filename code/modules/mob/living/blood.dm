#define BLOOD_DRIP_RATE_MOD 90 //Greater number means creating blood drips more often while bleeding

/****************************************************
				BLOOD SYSTEM
****************************************************/

/// Adjusts blood volume, returning the difference.
/mob/living/proc/adjustBloodVolume(adj)
	var/old_blood_volume = blood_volume
	blood_volume = clamp(blood_volume + adj, 0, BLOOD_VOLUME_ABSOLUTE_MAX)
	return old_blood_volume - blood_volume

/mob/living/proc/adjustBloodVolumeUpTo(adj, max)
	if(blood_volume >= max)
		return 0
	return adjustBloodVolume(min(max-blood_volume, adj))

/mob/living/proc/setBloodVolume(amt)
	return adjustBloodVolume(amt - blood_volume)

// Takes care blood loss and regeneration
/mob/living/carbon/human/handle_blood(delta_time, times_fired)

	if((NOBLOOD in dna.species.species_traits) || HAS_TRAIT(src, TRAIT_NOBLEED) || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		return

	if(bodytemperature < TCRYO || (HAS_TRAIT(src, TRAIT_HUSK))) //cryosleep or husked people do not pump the blood.
		return

	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!heart || (heart.pulse == PULSE_NONE && !(heart.organ_flags & ORGAN_SYNTHETIC)))
		return

	var/pulse_mod = 1
	switch(heart.pulse)
		if(PULSE_SLOW)
			pulse_mod = 0.8
		if(PULSE_FAST)
			pulse_mod = 1.25
		if(PULSE_2FAST, PULSE_THREADY)
			pulse_mod = 1.5

	var/temp_bleed = 0

	var/list/obj/item/bodypart/spray_candidates
	//Bleeding out
	for(var/obj/item/bodypart/iter_part as anything in bodyparts)
		var/needs_bleed_update = FALSE
		var/iter_bleed_rate = iter_part.get_modified_bleed_rate() * pulse_mod
		var/bleed_amt = iter_part.bandage?.absorb_blood(iter_bleed_rate, src)

		if(isnull(bleed_amt))
			bleed_amt = iter_bleed_rate

		if(iter_part.bodypart_flags & BP_HAS_BLOOD)
			if(bleed_amt > 3 && (iter_part.bodypart_flags & BP_ARTERY_CUT))
				LAZYADD(spray_candidates, iter_part)

			for(var/datum/wound/W as anything in iter_part.wounds)
				if(W.bleeding() && W.bleed_timer > 0)
					W.bleed_timer--
					if(!W.bleeding())
						needs_bleed_update = TRUE

		if(needs_bleed_update)
			iter_part.refresh_bleed_rate()

		if(!bleed_amt)
			continue

		temp_bleed += bleed_amt

		if(iter_part.generic_bleedstacks) // If you don't have any bleedstacks, don't try and heal them
			iter_part.adjustBleedStacks(-1, 0)

	var/bled
	if(temp_bleed)
		bled = bleed(temp_bleed)
		bleed_warn(temp_bleed)

	if(bled && COOLDOWN_FINISHED(src, blood_spray_cd) && LAZYLEN(spray_candidates))
		var/obj/item/bodypart/spray_part = pick(spray_candidates)
		spray_blood(pick(GLOB.alldirs))
		visible_message(
			span_danger("Blood sprays out from \the [src]'s [spray_part.plaintext_zone]!"),
			span_userdanger("Blood sprays out from your [spray_part.plaintext_zone]!"),
		)
		COOLDOWN_START(src, blood_spray_cd, 8 SECONDS)


/// Has each bodypart update its bleed/wound overlay icon states
/mob/living/carbon/proc/update_bodypart_bleed_overlays()
	for(var/obj/item/bodypart/iter_part as anything in bodyparts)
		iter_part.update_part_wound_overlay()

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/proc/bleed(amt)
	if(!blood_volume)
		return

	. = adjustBloodVolume(-amt)

	//Blood loss still happens in locker, floor stays clean
	if(isturf(loc) && prob(sqrt(amt)*BLOOD_DRIP_RATE_MOD))
		add_splatter_floor(loc, (amt <= 10))

/mob/living/carbon/human/bleed(amt)
	if(NOBLOOD in dna.species.species_traits)
		return
	amt *= physiology.bleed_mod
	. = ..()

/// A helper to see how much blood we're losing per tick
/mob/living/carbon/proc/get_bleed_rate()
	if((NOBLOOD in dna.species.species_traits) || HAS_TRAIT(src, TRAIT_NOBLEED) || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		return 0

	if(bodytemperature < TCRYO || (HAS_TRAIT(src, TRAIT_HUSK)))
		return 0

	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!heart || (heart.pulse == PULSE_NONE && !(heart.organ_flags & ORGAN_SYNTHETIC)))
		return 0

	var/bleed_amt = 0
	for(var/obj/item/bodypart/iter_bodypart as anything in bodyparts)
		bleed_amt += iter_bodypart.get_modified_bleed_rate()

	var/pulse_mod = 1
	switch(heart.pulse)
		if(PULSE_SLOW)
			pulse_mod = 0.8
		if(PULSE_FAST)
			pulse_mod = 1.25
		if(PULSE_2FAST, PULSE_THREADY)
			pulse_mod = 1.5

	return bleed_amt * pulse_mod

/mob/living/carbon/human/get_bleed_rate()
	if((NOBLOOD in dna.species.species_traits))
		return
	. = ..()
	. *= physiology.bleed_mod

/**
 * bleed_warn() is used to for carbons with an active client to occasionally receive messages warning them about their bleeding status (if applicable)
 *
 * Arguments:
 * * bleed_amt- When we run this from [/mob/living/carbon/human/proc/handle_blood] we already know how much blood we're losing this tick, so we can skip tallying it again with this
 * * forced-
 */
/mob/living/carbon/proc/bleed_warn(bleed_amt = 0, forced = FALSE)
	if(!blood_volume || !client || stat != CONSCIOUS)
		return

	if(!COOLDOWN_FINISHED(src, bleeding_message_cd) && !forced)
		return

	if(!bleed_amt) // if we weren't provided the amount of blood we lost this tick in the args
		bleed_amt = get_bleed_rate()

	var/bleeding_severity = ""
	var/next_cooldown = BLEEDING_MESSAGE_BASE_CD
	var/rate_of_change

	switch(bleed_amt)
		if(-INFINITY to 0)
			return
		if(0 to 1)
			bleeding_severity = "You feel light trickles of blood across your skin"
			next_cooldown *= 2.5
		if(1 to 3)
			bleeding_severity = "You feel a small stream of blood running across your body"
			next_cooldown *= 2
		if(3 to 5)
			bleeding_severity = "You skin feels clammy from the flow of blood leaving your body"
			next_cooldown *= 1.7
		if(5 to 7)
			bleeding_severity = "Your body grows more and more numb as blood streams out"
			next_cooldown *= 1.5
		if(7 to INFINITY)
			bleeding_severity = "Your heartbeat thrashes wildly trying to keep up with your bloodloss"

	if(HAS_TRAIT(src, TRAIT_COAGULATING)) // if we have coagulant, we're getting better quick
		rate_of_change = ", but it's clotting up quickly!"

	to_chat(src, span_warning("[bleeding_severity][rate_of_change || "."]"))
	COOLDOWN_START(src, bleeding_message_cd, next_cooldown)

/mob/living/carbon/human/bleed_warn(bleed_amt = 0, forced = FALSE)
	if(!(NOBLOOD in dna.species.species_traits))
		return ..()

/mob/living/proc/restore_blood()
	setBloodVolume(initial(blood_volume))

/mob/living/carbon/restore_blood()
	setBloodVolume(BLOOD_VOLUME_NORMAL)
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		BP.setBleedStacks(0)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to a container or other mob, preserving all data in it.
/mob/living/proc/transfer_blood_to(atom/movable/AM, amount, forced)
	if(!blood_volume || !AM.reagents)
		return FALSE
	if(blood_volume < BLOOD_VOLUME_BAD && !forced)
		return FALSE

	if(blood_volume < amount)
		amount = blood_volume

	var/blood_id = get_blood_id()
	if(!blood_id)
		return FALSE

	blood_volume -= amount

	var/list/blood_data = get_blood_data(blood_id)

	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		if(blood_id == C.get_blood_id())//both mobs have the same blood substance
			if(blood_id == /datum/reagent/blood) //normal blood
				for(var/datum/pathogen/D as anything in blood_data["viruses"])
					if((D.spread_flags & PATHOGEN_SPREAD_SPECIAL) || (D.spread_flags & PATHOGEN_SPREAD_NON_CONTAGIOUS))
						continue
					C.try_contract_pathogen(D)

				if(!C.dna.blood_type.is_compatible(blood_data["blood_type"]:type))
					C.reagents.add_reagent(/datum/reagent/toxin, amount * 0.5)
					return TRUE

			C.adjustBloodVolumeUpTo(0.1)
			return TRUE

	AM.reagents.add_reagent(blood_id, amount, blood_data, bodytemperature)
	return TRUE


/mob/living/proc/get_blood_data(blood_id)
	return list()

/mob/living/carbon/get_blood_data(blood_id)
	if(blood_id != /datum/reagent/blood) //actual blood reagent
		return list()

	var/blood_data = list()
	//set the blood data
	blood_data["viruses"] = list()

	for(var/thing in diseases)
		var/datum/pathogen/D = thing
		blood_data["viruses"] += D.Copy()

	blood_data["blood_DNA"] = dna.unique_enzymes
	if(LAZYLEN(disease_resistances))
		blood_data["resistances"] = disease_resistances.Copy()
	var/list/temp_chem = list()
	for(var/datum/reagent/R in reagents.reagent_list)
		temp_chem[R.type] = R.volume
	blood_data["trace_chem"] = list2params(temp_chem)
	if(mind)
		blood_data["mind"] = mind
	else if(last_mind)
		blood_data["mind"] = last_mind
	if(ckey)
		blood_data["ckey"] = ckey
	else if(last_mind)
		blood_data["ckey"] = ckey(last_mind.key)

	if(!suiciding)
		blood_data["cloneable"] = 1
	blood_data["blood_type"] = dna.blood_type
	blood_data["gender"] = gender
	blood_data["real_name"] = real_name
	blood_data["features"] = dna.features
	blood_data["factions"] = faction
	blood_data["quirks"] = list()
	for(var/V in quirks)
		var/datum/quirk/T = V
		blood_data["quirks"] += T.type
	return blood_data

//get the id of the substance this mob use as blood.
/mob/proc/get_blood_id()
	return

/mob/living/simple_animal/get_blood_id()
	if(blood_volume)
		return /datum/reagent/blood

/mob/living/carbon/human/get_blood_id()
	if(HAS_TRAIT(src, TRAIT_HUSK))
		return
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS] && is_clown_job(mind?.assigned_role))
		return /datum/reagent/colorful_reagent
	if(dna.species.exotic_blood)
		return dna.species.exotic_blood
	else if((NOBLOOD in dna.species.species_traits))
		return
	return /datum/reagent/blood

//to add a splatter of blood or other mob liquid.
/mob/living/proc/add_splatter_floor(turf/T, small_drip)
	if(get_blood_id() != /datum/reagent/blood)
		return

	if(!T)
		T = get_turf(src)

	if(small_drip)
		new /obj/effect/decal/cleanable/blood/drip(T, get_static_viruses(), get_blood_dna_list())
		return

	// Find a blood decal or create a new one.
	var/obj/effect/decal/cleanable/blood/B = locate() in T
	if(!B)
		B = new /obj/effect/decal/cleanable/blood/splatter(T, get_static_viruses(), get_blood_dna_list())

	if(QDELETED(B)) //Give it up
		return

	B.bloodiness = min((B.bloodiness + BLOOD_AMOUNT_PER_DECAL), BLOOD_POOL_MAX)

/mob/living/carbon/human/add_splatter_floor(turf/T, small_drip)
	if(!(NOBLOOD in dna.species.species_traits))
		..()

/mob/living/carbon/alien/add_splatter_floor(turf/T, small_drip)
	if(!T)
		T = get_turf(src)
	var/obj/effect/decal/cleanable/xenoblood/B = locate() in T.contents
	if(!B)
		B = new(T)
	B.add_blood_DNA(list("UNKNOWN DNA" = GET_BLOOD_REF(/datum/blood/xenomorph)))

/mob/living/silicon/robot/add_splatter_floor(turf/T, small_drip)
	if(!T)
		T = get_turf(src)
	var/obj/effect/decal/cleanable/oil/B = locate() in T.contents
	if(!B)
		B = new(T)

//Percentage of maximum blood volume, affected by the condition of circulation organs
/mob/living/carbon/proc/get_blood_circulation()
	var/blood_volume_percent = min(blood_volume / BLOOD_VOLUME_NORMAL, 1) * 100
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!heart)
		return 0.25 * blood_volume_percent

	var/recent_pump = LAZYACCESS(heart.external_pump, 1) > world.time - (20 SECONDS)
	var/pulse_mod = 1
	if((HAS_TRAIT(src, TRAIT_FAKEDEATH)) || (heart.organ_flags & ORGAN_SYNTHETIC))
		pulse_mod = 1
	else
		switch(heart.pulse)
			if(PULSE_NONE)
				if(recent_pump)
					pulse_mod = LAZYACCESS(heart.external_pump, 2)
				else
					pulse_mod *= 0.25
			if(PULSE_SLOW)
				pulse_mod *= 0.9
			if(PULSE_FAST)
				pulse_mod *= 1.1
			if(PULSE_2FAST, PULSE_THREADY)
				pulse_mod *= 1.25

	blood_volume_percent *= pulse_mod

	var/min_efficiency = recent_pump ? 0.5 : 0.3
	blood_volume_percent *= max(min_efficiency, (1-(heart.damage / heart.maxHealth)))

	var/blockage = CHEM_EFFECT_MAGNITUDE(src, CE_BLOCKAGE)
	if(blockage)
		blood_volume_percent *= max(0, 1-blockage)

	return round(min(blood_volume_percent, 100), 0.01)

//Percentage of maximum blood volume, affected by the condition of circulation organs, affected by the oxygen loss. What ultimately matters for brain
/mob/living/carbon/proc/get_blood_oxygenation()
	var/blood_volume_percent = get_blood_circulation()
	if(!(NOBLOOD in dna.species.species_traits))
		if(undergoing_cardiac_arrest()) // Heart is missing or isn't beating and we're not breathing (hardcrit)
			return min(blood_volume_percent, BLOOD_CIRC_SURVIVE)

		if(HAS_TRAIT(src, TRAIT_NOBREATH))
			return blood_volume_percent
	else
		blood_volume_percent = 100

	var/blood_volume_mod = max(0, 1 - getOxyLoss()/ maxHealth)
	var/oxygenated_mult = 0
	if(chem_effects[CE_OXYGENATED] == 1) // Dexalin.
		oxygenated_mult = 0.5

	else if(chem_effects[CE_OXYGENATED] >= 2) // Dexplus.
		oxygenated_mult = 0.8

	blood_volume_mod = blood_volume_mod + oxygenated_mult - (blood_volume_mod * oxygenated_mult)
	blood_volume_percent *= blood_volume_mod
	return round(min(blood_volume_percent, 100), 0.01)
