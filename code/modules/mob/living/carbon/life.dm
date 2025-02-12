/mob/living/carbon/Life(delta_time = SSMOBS_DT, times_fired)

	if(notransform)
		return

	if(damageoverlaytemp)
		damageoverlaytemp = 0
		update_damage_hud()

	. = ..()
	if(!IS_IN_STASIS(src))
		handle_organs(delta_time, times_fired)

		if(QDELETED(src))
			return

		if(.) //not dead
			handle_blood(delta_time, times_fired)

		if(stat != DEAD)
			handle_brain_damage(delta_time, times_fired)

		var/bodyparts_action = handle_bodyparts(delta_time, times_fired)
		if(bodyparts_action & BODYPART_LIFE_UPDATE_HEALTH)
			updatehealth()

		else if(bodyparts_action & BODYPART_LIFE_UPDATE_HEALTH_HUD)
			update_health_hud()

	if(stat == DEAD)
		stop_sound_channel(CHANNEL_HEARTBEAT)

	if(stat != DEAD && !(IS_IN_STASIS(src)))
		handle_shock()
		handle_pain()
		if(shock_stage >= SHOCK_TIER_1)
			add_movespeed_modifier(/datum/movespeed_modifier/shock, TRUE)
		else
			remove_movespeed_modifier(/datum/movespeed_modifier/shock, TRUE)

	check_cremation(delta_time, times_fired)

	if(. && mind) //. == not dead
		for(var/key in mind.addiction_points)
			var/datum/addiction/addiction = SSaddiction.all_addictions[key]
			addiction.process_addiction(src, delta_time, times_fired)
	if(stat != DEAD)
		return 1

///////////////
// BREATHING //
///////////////

//Start of a breath chain, calls breathe()
/mob/living/carbon/handle_breathing(times_fired)
	var/next_breath = 4
	var/obj/item/organ/lungs/L = getorganslot(ORGAN_SLOT_LUNGS)
	var/obj/item/organ/heart/H = getorganslot(ORGAN_SLOT_HEART)
	if(L)
		if(L.damage > (L.high_threshold * L.maxHealth))
			next_breath--
	if(H)
		if(H.damage > (H.high_threshold * H.maxHealth))
			next_breath--

	if((times_fired % next_breath) == 0 || failed_last_breath)
		breathe() //Breathe per 4 ticks if healthy, down to 2 if our lungs or heart are damaged, unless suffocating
	else
		if(istype(loc, /obj/))
			var/obj/location_as_object = loc
			location_as_object.handle_internal_lifeform(src,0)

//Second link in a breath chain, calls check_breath()
/mob/living/carbon/proc/breathe(forced)
	var/obj/item/organ/lungs = getorganslot(ORGAN_SLOT_LUNGS)

	SEND_SIGNAL(src, COMSIG_CARBON_PRE_BREATHE)

	var/datum/gas_mixture/environment
	if(loc)
		environment = loc.return_air()

	var/datum/gas_mixture/breath
	var/asystole = undergoing_cardiac_arrest()
	if(!forced)
		if(asystole && !CHEM_EFFECT_MAGNITUDE(src, CE_STABLE))
			losebreath = max(2, losebreath + 1)

		else if(!getorganslot(ORGAN_SLOT_BREATHING_TUBE))
			if(HAS_TRAIT(src, TRAIT_KILL_GRAB) || (lungs?.organ_flags & ORGAN_DEAD))
				losebreath++  //You can't breath at all when in critical or when being choked, so you're going to miss a breath

	// Recover from breath loss
	if(losebreath >= 1)
		losebreath--
		if(!forced && !asystole && prob(10))
			spawn(-1)
				emote("gasp")

		if(istype(loc, /obj))
			var/obj/loc_as_obj = loc
			loc_as_obj.handle_internal_lifeform(src,0)
	else
		//Breathe from internal
		breath = get_breath_from_internal(BREATH_VOLUME)

		if(isnull(breath)) //in case of 0 pressure internals

			if(isobj(loc)) //Breathe from loc as object
				var/obj/loc_as_obj = loc
				breath = loc_as_obj.handle_internal_lifeform(src, BREATH_VOLUME)

			else if(isturf(loc)) //Breathe from loc as turf
				var/breath_moles = 0
				if(environment)
					breath_moles = environment.total_moles*BREATH_PERCENTAGE

				breath = loc.remove_air(breath_moles)
		else //Breathe from loc as obj again
			if(breath == 0)
				breath = null //get_breath_from_internal() returns 0 conditionally, so we need to reset it to null

			if(istype(loc, /obj/))
				var/obj/loc_as_obj = loc
				loc_as_obj.handle_internal_lifeform(src,0)

	// Pass reagents from the gas into our body.
	// Presumably if you breathe it you have a specialized metabolism for it, so we drop/ignore breath_type. Also avoids
	// humans processing thousands of units of oxygen over the course of a round for the sole purpose of poisoning vox.
	if(lungs && !isnull(breath))
		var/breath_type = dna?.species?.breathid
		for(var/gasname in breath.gas - breath_type)
			var/breathed_product = xgm_gas_data.breathed_product[gasname]
			if(breathed_product)
				var/reagent_amount = breath.gas[gasname] * REAGENT_GAS_EXCHANGE_FACTOR
				// Little bit of sanity so we aren't trying to add 0.0000000001 units of CO2, and so we don't end up with 99999 units of CO2.
				if(reagent_amount >= 0.05)
					reagents.add_reagent(breathed_product, reagent_amount)
					breath.adjustGas(gasname, -breath.gas[gasname], update = 0) //update after

	. = check_breath(breath, forced)

	if(breath?.total_moles)
		breath.garbageCollect()
		loc.assume_air(breath)

	var/static/sound/breathing = sound('sound/voice/breathing.ogg', volume = 50, channel = CHANNEL_BREATHING)
	if((!forced && . && COOLDOWN_FINISHED(src, breath_sound_cd) && environment?.returnPressure() < SOUND_MINIMUM_PRESSURE))
		src << breathing
		COOLDOWN_START(src, breath_sound_cd, 3.5 SECONDS)

/mob/living/carbon/proc/has_smoke_protection()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return TRUE
	return FALSE


//Third link in a breath chain, calls handle_breath_temperature()
/mob/living/carbon/proc/check_breath(datum/gas_mixture/breath, forced = FALSE)
	if(status_flags & GODMODE)
		failed_last_breath = FALSE
		clear_alert(ALERT_NOT_ENOUGH_OXYGEN)
		return FALSE

	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return FALSE

	var/obj/item/organ/lungs = getorganslot(ORGAN_SLOT_LUNGS)


	if(!forced)
		if(!breath || (breath.total_moles == 0) || !lungs || nervous_system_failure())
			if(!HAS_TRAIT(src, TRAIT_NOCRITDAMAGE))
				adjustOxyLoss(HUMAN_FAILBREATH_OXYLOSS)

			failed_last_breath = TRUE
			throw_alert(ALERT_NOT_ENOUGH_OXYGEN, /atom/movable/screen/alert/not_enough_oxy)
			return FALSE

	var/list/breath_gases = breath.gas
	var/safe_oxy_min = 16
	var/safe_co2_max = 10
	var/safe_plas_max = 0.05
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/oxygen_used = 0
	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

	if(CHEM_EFFECT_MAGNITUDE(src, CE_BREATHLOSS) && !HAS_TRAIT(src, TRAIT_NOCRITDAMAGE))
		safe_oxy_min *= 1 + rand(1, 4) * CHEM_EFFECT_MAGNITUDE(src, CE_BREATHLOSS)

	var/O2_partialpressure = (breath_gases[GAS_OXYGEN]/breath.total_moles)*breath_pressure
	var/Plasma_partialpressure = (breath_gases[GAS_PLASMA]/breath.total_moles)*breath_pressure
	var/CO2_partialpressure = (breath_gases[GAS_CO2]/breath.total_moles)*breath_pressure


	//OXYGEN
	if(O2_partialpressure < safe_oxy_min) //Not enough oxygen
		if(O2_partialpressure > 0)
			var/ratio = 1 - O2_partialpressure/safe_oxy_min
			adjustOxyLoss(min(5*ratio, 3))
			failed_last_breath = TRUE
			oxygen_used = breath_gases[GAS_OXYGEN]*ratio
		else
			adjustOxyLoss(3)
			failed_last_breath = TRUE
		throw_alert(ALERT_NOT_ENOUGH_OXYGEN, /atom/movable/screen/alert/not_enough_oxy)

	else //Enough oxygen
		failed_last_breath = FALSE
		if(health >= crit_threshold)
			adjustOxyLoss(-5)
		oxygen_used = breath_gases[GAS_OXYGEN]
		clear_alert(ALERT_NOT_ENOUGH_OXYGEN)

	breath.adjustGas(GAS_OXYGEN, -oxygen_used, update = 0)
	breath.adjustGas(GAS_CO2, oxygen_used, update = 0)

	//CARBON DIOXIDE
	if(CO2_partialpressure > safe_co2_max)
		if(!co2overloadtime)
			co2overloadtime = world.time
		else if(world.time - co2overloadtime > 120)
			Unconscious(60)
			adjustOxyLoss(3)
			if(world.time - co2overloadtime > 300)
				adjustOxyLoss(8)
		if(prob(20))
			emote("cough")

	else
		co2overloadtime = 0

	//PLASMA
	if(Plasma_partialpressure > safe_plas_max)
		var/ratio = breath.gas[GAS_PLASMA]/safe_plas_max * 10
		adjustToxLoss(clamp(ratio, MIN_TOXIC_GAS_DAMAGE, MAX_TOXIC_GAS_DAMAGE), cause_of_death ="Plasma poisoning")
		throw_alert(ALERT_TOO_MUCH_PLASMA, /atom/movable/screen/alert/too_much_plas)
	else
		clear_alert(ALERT_TOO_MUCH_PLASMA)

	//NITROUS OXIDE
	if(breath_gases[GAS_N2O])
		var/SA_partialpressure = (breath_gases[GAS_N2O]/breath.total_moles)*breath_pressure
		if(SA_partialpressure > SA_para_min)
			throw_alert(ALERT_TOO_MUCH_N2O, /atom/movable/screen/alert/too_much_n2o)
			Unconscious(60)
			if(SA_partialpressure > SA_sleep_min)
				Sleeping(max(AmountSleeping() + 40, 200))
		else if(SA_partialpressure > 0.01)
			clear_alert(ALERT_TOO_MUCH_N2O)
			if(prob(20))
				emote(pick("giggle","laugh"))
		else
			clear_alert(ALERT_TOO_MUCH_N2O)
	else
		clear_alert(ALERT_TOO_MUCH_N2O)

	//BREATH TEMPERATURE
	handle_breath_temperature(breath)

	return TRUE

//Fourth and final link in a breath chain
/mob/living/carbon/proc/handle_breath_temperature(datum/gas_mixture/breath)
	// The air you breathe out should match your body temperature
	breath.temperature = bodytemperature

/mob/living/carbon/proc/get_breath_from_internal(volume_needed)
	if(invalid_internals())
		// Unexpectely lost breathing apparatus and ability to breathe from the internal air tank.
		cutoff_internals()
		return
	if (external)
		. = external.remove_air_volume(volume_needed)
	else if (internal)
		. = internal.remove_air_volume(volume_needed)
	else
		// Return without taking a breath if there is no air tank.
		return
	// To differentiate between no internals and active, but empty internals.
	return . || FALSE

/mob/living/carbon/proc/handle_blood(delta_time, times_fired)
	return

/mob/living/carbon/proc/handle_bodyparts(delta_time, times_fired)
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		. |= limb.on_life(delta_time, times_fired)

/mob/living/carbon/proc/handle_organs(delta_time, times_fired)
	var/update
	if(stat == DEAD)
		for(var/obj/item/organ/organ as anything in processing_organs)
			update += organ.on_death(delta_time, times_fired) //Needed so organs decay while inside the body.
		return
	else
		// NOTE: processing_organs is sorted by GLOB.organ_process_order on insertion
		for(var/obj/item/organ/organ as anything in processing_organs)
			if(organ?.owner) // This exist mostly because reagent metabolization can cause organ reshuffling
				update += organ.on_life(delta_time, times_fired)

	if(update)
		updatehealth()

/mob/living/carbon/handle_diseases(delta_time, times_fired)
	for(var/datum/pathogen/D as anything in diseases)
		if(DT_PROB(D.infectivity, delta_time))
			D.airborne_spread()

		if(stat != DEAD || D.process_dead)
			D.on_process(delta_time, times_fired)

/mob/living/carbon/handle_mutations(time_since_irradiated, delta_time, times_fired)
	if(!dna?.temporary_mutations.len)
		return

	for(var/mut in dna.temporary_mutations)
		if(dna.temporary_mutations[mut] < world.time)
			if(mut == UI_CHANGED)
				if(dna.previous["UI"])
					dna.unique_identity = merge_text(dna.unique_identity,dna.previous["UI"])
					updateappearance(mutations_overlay_update=1)
					dna.previous.Remove("UI")
				dna.temporary_mutations.Remove(mut)
				continue
			if(mut == UF_CHANGED)
				if(dna.previous["UF"])
					dna.unique_features = merge_text(dna.unique_features,dna.previous["UF"])
					updateappearance(mutcolor_update=1, mutations_overlay_update=1)
					dna.previous.Remove("UF")
				dna.temporary_mutations.Remove(mut)
				continue
			if(mut == UE_CHANGED)
				if(dna.previous["name"])
					set_real_name(dna.previous["name"])
					dna.previous.Remove("name")
				if(dna.previous["UE"])
					dna.unique_enzymes = dna.previous["UE"]
					dna.previous.Remove("UE")
				if(dna.previous["blood_type"])
					dna.blood_type = dna.previous["blood_type"]
					dna.previous.Remove("blood_type")
				dna.temporary_mutations.Remove(mut)
				continue
	for(var/datum/mutation/human/HM in dna.mutations)
		if(HM?.timeout)
			dna.remove_mutation(HM.type)

/mob/living/carbon/handle_chemicals()
	chem_effects.Cut()

	if(status_flags & GODMODE)
		return

	if(touching)
		. += touching.metabolize(src, can_overdose = FALSE, updatehealth = FALSE)

	if(stat != DEAD && !HAS_TRAIT(src, TRAIT_NOMETABOLISM))
		var/obj/item/organ/stomach/S = organs_by_slot[ORGAN_SLOT_STOMACH]
		if(S?.reagents && !(S.organ_flags & ORGAN_DEAD))
			. += S.reagents.metabolize(src, can_overdose = TRUE, updatehealth = FALSE)
		if(bloodstream)
			. += bloodstream.metabolize(src, can_overdose = TRUE, updatehealth = FALSE)

	if(.)
		updatehealth()


/*
Alcohol Poisoning Chart
Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts (i.e. light poisoning inherts from slight poisoning)
In addition, severe effects won't always trigger unless the drink is poisonously strong
All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance

0: Non-alcoholic
1-10: Barely classifiable as alcohol - occassional slurring
11-20: Slight alcohol content - slurring
21-30: Below average - imbiber begins to look slightly drunk
31-40: Just below average - no unique effects
41-50: Average - mild disorientation, imbiber begins to look drunk
51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
71-80: High alcohol content - blurry vision, imbiber completely shitfaced
81-90: Extremely high alcohol content - light brain damage, passing out
91-100: Dangerously toxic - swift death
*/
#define BALLMER_POINTS 5

// This updates all special effects that really should be status effect datums: Druggy, Hallucinations, Drunkenness, Mute, etc..
/mob/living/carbon/handle_status_effects(delta_time, times_fired)
	..()

	var/restingpwr = 1 + 2 * resting

	if (drowsyness > 0)
		adjust_drowsyness(-1 * restingpwr)
		blur_eyes(2)
		if(drowsyness > 10)
			var/zzzchance = min(5, 5*drowsyness/30)
			if((prob(zzzchance) || drowsyness >= 60) || ( drowsyness >= 20 && IsSleeping()))
				if(stat == CONSCIOUS)
					to_chat(src, span_obviousnotice("You feel so tired..."))
				Sleeping(5 SECONDS)

	if(silent)
		silent = max(silent - (0.5 * delta_time), 0)

	if(hallucination)
		handle_hallucinations(delta_time, times_fired)

	if(stasis_level > 1 && drowsyness < stasis_level * 4)
		drowsyness += min(stasis_level, 3)
		if(stat < UNCONSCIOUS && prob(1))
			to_chat(src, span_notice("You feel slow and sluggish..."))

/// Base carbon environment handler, adds natural stabilization
/mob/living/carbon/handle_environment(datum/gas_mixture/environment, delta_time, times_fired)
	var/areatemp = get_temperature(environment)

	if(stat != DEAD) // If you are dead your body does not stabilize naturally
		natural_bodytemperature_stabilization(environment, delta_time, times_fired)

	if(!on_fire || areatemp > bodytemperature) // If we are not on fire or the area is hotter
		adjust_bodytemperature((areatemp - bodytemperature), use_insulation=TRUE, use_steps=TRUE)

/**
 * Used to stabilize the body temperature back to normal on living mobs
 *
 * Arguments:
 * - [environemnt][/datum/gas_mixture]: The environment gas mix
 * - delta_time: The amount of time that has elapsed since the last tick
 * - times_fired: The number of times SSmobs has ticked
 */
/mob/living/carbon/proc/natural_bodytemperature_stabilization(datum/gas_mixture/environment, delta_time, times_fired)
	var/areatemp = get_temperature(environment)
	var/body_temperature_difference = get_body_temp_normal() - bodytemperature
	var/natural_change = 0

	// We are very cold, increase body temperature
	if(bodytemperature <= BODYTEMP_COLD_DAMAGE_LIMIT)
		natural_change = max((body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR), \
			BODYTEMP_AUTORECOVERY_MINIMUM)

	// we are cold, reduce the minimum increment and do not jump over the difference
	else if(bodytemperature > BODYTEMP_COLD_DAMAGE_LIMIT && bodytemperature < get_body_temp_normal())
		natural_change = max(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, \
			min(body_temperature_difference, BODYTEMP_AUTORECOVERY_MINIMUM / 4))

	// We are hot, reduce the minimum increment and do not jump below the difference
	else if(bodytemperature > get_body_temp_normal() && bodytemperature <= BODYTEMP_HEAT_DAMAGE_LIMIT)
		natural_change = min(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, \
			max(body_temperature_difference, -(BODYTEMP_AUTORECOVERY_MINIMUM / 4)))

	// We are very hot, reduce the body temperature
	else if(bodytemperature >= BODYTEMP_HEAT_DAMAGE_LIMIT)
		natural_change = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)

	var/thermal_protection = 1 - get_insulation_protection(areatemp) // invert the protection
	if(areatemp > bodytemperature) // It is hot here
		if(bodytemperature < get_body_temp_normal())
			// Our bodytemp is below normal we are cold, insulation helps us retain body heat
			// and will reduce the heat we lose to the environment
			natural_change = (thermal_protection + 1) * natural_change
		else
			// Our bodytemp is above normal and sweating, insulation hinders out ability to reduce heat
			// but will reduce the amount of heat we get from the environment
			natural_change = (1 / (thermal_protection + 1)) * natural_change
	else // It is cold here
		if(!on_fire) // If on fire ignore ignore local temperature in cold areas
			if(bodytemperature < get_body_temp_normal())
				// Our bodytemp is below normal, insulation helps us retain body heat
				// and will reduce the heat we lose to the environment
				natural_change = (thermal_protection + 1) * natural_change
			else
				// Our bodytemp is above normal and sweating, insulation hinders out ability to reduce heat
				// but will reduce the amount of heat we get from the environment
				natural_change = (1 / (thermal_protection + 1)) * natural_change

	// Apply the natural stabilization changes
	adjust_bodytemperature(natural_change * delta_time)

/**
 * Get the insulation that is appropriate to the temperature you're being exposed to.
 * All clothing, natural insulation, and traits are combined returning a single value.
 *
 * required temperature The Temperature that you're being exposed to
 *
 * return the percentage of protection as a value from 0 - 1
**/
/mob/living/carbon/proc/get_insulation_protection(temperature)
	return (temperature > bodytemperature) ? get_heat_protection(temperature) : get_cold_protection(temperature)

/// This returns the percentage of protection from heat as a value from 0 - 1
/// temperature is the temperature you're being exposed to
/mob/living/carbon/proc/get_heat_protection(temperature)
	return heat_protection

/// This returns the percentage of protection from cold as a value from 0 - 1
/// temperature is the temperature you're being exposed to
/mob/living/carbon/proc/get_cold_protection(temperature)
	return cold_protection

/**
 * Have two mobs share body heat between each other.
 * Account for the insulation and max temperature change range for the mob
 *
 * vars:
 * * M The mob/living/carbon that is sharing body heat
 */
/mob/living/carbon/proc/share_bodytemperature(mob/living/carbon/M)
	var/temp_diff = bodytemperature - M.bodytemperature
	if(temp_diff > 0) // you are warm share the heat of life
		M.adjust_bodytemperature((temp_diff * 0.5), use_insulation=TRUE, use_steps=TRUE) // warm up the giver
		adjust_bodytemperature((temp_diff * -0.5), use_insulation=TRUE, use_steps=TRUE) // cool down the reciver

	else // they are warmer leech from them
		adjust_bodytemperature((temp_diff * -0.5) , use_insulation=TRUE, use_steps=TRUE) // warm up the reciver
		M.adjust_bodytemperature((temp_diff * 0.5), use_insulation=TRUE, use_steps=TRUE) // cool down the giver

/**
 * Adjust the body temperature of a mob
 * expanded for carbon mobs allowing the use of insulation and change steps
 *
 * vars:
 * * amount The amount of degrees to change body temperature by
 * * min_temp (optional) The minimum body temperature after adjustment
 * * max_temp (optional) The maximum body temperature after adjustment
 * * use_insulation (optional) modifies the amount based on the amount of insulation the mob has
 * * use_steps (optional) Use the body temp divisors and max change rates
 * * capped (optional) default True used to cap step mode
 */
/mob/living/carbon/adjust_bodytemperature(amount, min_temp=0, max_temp=INFINITY, use_insulation=FALSE, use_steps=FALSE, capped=TRUE)
	// apply insulation to the amount of change
	if(use_insulation)
		amount *= (1 - get_insulation_protection(bodytemperature + amount))

	// Use the bodytemp divisors to get the change step, with max step size
	if(use_steps)
		amount = (amount > 0) ? (amount / BODYTEMP_HEAT_DIVISOR) : (amount / BODYTEMP_COLD_DIVISOR)
		// Clamp the results to the min and max step size
		if(capped)
			amount = (amount > 0) ? min(amount, BODYTEMP_HEATING_MAX) : max(amount, BODYTEMP_COOLING_MAX)

	if(bodytemperature >= min_temp && bodytemperature <= max_temp)
		bodytemperature = clamp(bodytemperature + amount, min_temp, max_temp)


///////////
//Stomach//
///////////

/mob/living/carbon/get_fullness()
	var/fullness = nutrition

	var/obj/item/organ/stomach/belly = getorganslot(ORGAN_SLOT_STOMACH)
	if(!belly) //nothing to see here if we do not have a stomach
		return fullness

	for(var/bile in belly.reagents.reagent_list)
		var/datum/reagent/bits = bile
		if(istype(bits, /datum/reagent/consumable))
			var/datum/reagent/consumable/goodbit = bile
			fullness += goodbit.nutriment_factor * goodbit.volume / goodbit.metabolization_rate
			continue
		fullness += 0.6 * bits.volume / bits.metabolization_rate //not food takes up space

	return fullness

/mob/living/carbon/has_reagent(reagent, amount = -1, needs_metabolizing = FALSE)
	. = ..()
	if(.)
		return
	var/obj/item/organ/stomach/belly = getorganslot(ORGAN_SLOT_STOMACH)
	if(belly)
		. = belly.reagents.has_reagent(reagent, amount, needs_metabolizing)

	. ||= touching.has_reagent(reagent, amount, needs_metabolizing)


/////////
//LIVER//
/////////

/// Handles having a missing or dead liver.
/mob/living/carbon/proc/handle_liver(delta_time, times_fired)
	if(!dna)
		return

	var/obj/item/organ/liver/liver = getorganslot(ORGAN_SLOT_LIVER)
	if(liver && !(liver.organ_flags & ORGAN_DEAD))
		remove_status_effect(/datum/status_effect/grouped/concussion, DEAD_LIVER_EFFECT)
		return

	if(HAS_TRAIT(src, TRAIT_STABLELIVER) || !needs_organ(ORGAN_SLOT_LIVER))
		remove_status_effect(/datum/status_effect/grouped/concussion, DEAD_LIVER_EFFECT)
		return

	adjustToxLoss(0.6 * delta_time, TRUE, TRUE, cause_of_death = "Lack of a liver")

	// Hepatic Encephalopathy
	set_slurring_if_lower(10 SECONDS)
	if(DT_PROB(2, delta_time))
		set_confusion_if_lower(10 SECONDS)

	if(DT_PROB(5, delta_time))
		adjust_drowsyness(6, 12)

	if(DT_PROB(2, delta_time))
		vomit(50, TRUE, FALSE, 1, TRUE, harm = FALSE, purge_ratio = 1)

	// stoopid micro optimization, don't instantiate a new status effect every life tick for no raisin.
	var/datum/status_effect/grouped/concussion/existing = has_status_effect(/datum/status_effect/grouped/concussion)
	if(isnull(existing) || !(DEAD_LIVER_EFFECT in existing.sources))
		apply_status_effect(/datum/status_effect/grouped/concussion, DEAD_LIVER_EFFECT)

/mob/living/carbon/proc/undergoing_liver_failure()
	var/obj/item/organ/liver/liver = getorganslot(ORGAN_SLOT_LIVER)
	if(liver?.organ_flags & ORGAN_DEAD)
		return TRUE

/////////////
//CREMATION//
/////////////
/mob/living/carbon/proc/check_cremation(delta_time, times_fired)
	//Only cremate while actively on fire
	if(!on_fire)
		return

	//Only starts when the chest has taken full damage
	var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
	if(!(chest.get_damage() >= chest.max_damage))
		return

	//Burn off limbs one by one
	var/obj/item/bodypart/limb
	var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/still_has_limbs = FALSE
	for(var/zone in limb_list)
		limb = get_bodypart(zone)
		if(limb)
			still_has_limbs = TRUE
			if(limb.get_damage() >= limb.max_damage)
				limb.cremation_progress += rand(1 * delta_time, 2.5 * delta_time)
				if(limb.cremation_progress >= 100)
					if(IS_ORGANIC_LIMB(limb)) //Non-organic limbs don't burn
						limb.drop_limb()
						limb.visible_message(span_warning("[src]'s [limb.plaintext_zone] crumbles into ash!"))
						qdel(limb)
					else
						limb.drop_limb()
						limb.visible_message(span_warning("[src]'s [limb.plaintext_zone] detaches from [p_their()] body!"))
	if(still_has_limbs)
		return

	//Burn the head last
	var/obj/item/bodypart/head = get_bodypart(BODY_ZONE_HEAD)
	if(head)
		if(head.get_damage() >= head.max_damage)
			head.cremation_progress += rand(1 * delta_time, 2.5 * delta_time)
			if(head.cremation_progress >= 100)
				if(IS_ORGANIC_LIMB(head)) //Non-organic limbs don't burn
					head.drop_limb()
					head.visible_message(span_warning("[src]'s head crumbles into ash!"))
					qdel(head)
				else
					head.drop_limb()
					head.visible_message(span_warning("[src]'s head detaches from [p_their()] body!"))
		return

	//Nothing left: dust the body, drop the items (if they're flammable they'll burn on their own)
	chest.cremation_progress += rand(1 * delta_time, 2.5 * delta_time)
	if(chest.cremation_progress >= 100)
		visible_message(span_warning("[src]'s body crumbles into a pile of ash!"))
		dust(TRUE, TRUE)

////////////////
//BRAIN DAMAGE//
////////////////

/mob/living/carbon/proc/handle_brain_damage(delta_time, times_fired)
	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		BT.on_life(delta_time, times_fired)

/////////////////////////////////////
//MONKEYS WITH TOO MUCH CHOLOESTROL//
/////////////////////////////////////

/mob/living/carbon/proc/can_heartattack()
	if(!needs_organ(ORGAN_SLOT_HEART) || HAS_TRAIT(src, TRAIT_STABLEHEART))
		return FALSE
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!heart || (heart.organ_flags & ORGAN_DEAD))
		return FALSE
	return TRUE

/*
 * The mob is having a heart attack
 *
 * NOTE: this is true if the mob has no heart and needs one, which can be suprising,
 * you are meant to use it in combination with can_heartattack for heart attack
 * related situations (i.e not just cardiac arrest)
 */
/mob/living/carbon/proc/undergoing_cardiac_arrest()
	if(isipc(src))
		var/obj/item/organ/cell/C = getorganslot(ORGAN_SLOT_CELL)
		if(C && ((C.organ_flags & ORGAN_DEAD) || !C.get_percent()))
			return TRUE

	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(istype(heart) && heart.is_working())
		return FALSE
	else if(!needs_organ(ORGAN_SLOT_HEART))
		return FALSE
	return TRUE

/mob/living/carbon/proc/set_heartattack(status)
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!istype(heart))
		return
	if(heart.organ_flags & ORGAN_SYNTHETIC)
		return

	if(status)
		if(heart.pulse)
			heart.Stop()
			return TRUE
	else if(!heart.pulse)
		heart.Restart()
		heart.handle_pulse()
		return TRUE
