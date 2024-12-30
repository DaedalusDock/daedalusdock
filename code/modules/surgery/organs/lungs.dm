/obj/item/organ/lungs
	name = "lungs"
	icon_state = "lungs"
	visual = FALSE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	maxHealth = 70
	high_threshold = 0.5
	low_threshold = 0.35
	relative_size = 60

	decay_factor = STANDARD_ORGAN_DECAY * 0.9 // fails around 16.5 minutes, lungs are one of the last organs to die (of the ones we have)

	low_threshold_passed = "<span class='warning'>You feel short of breath.</span>"
	high_threshold_passed = "<span class='warning'>You feel some sort of constriction around your chest as your breathing becomes shallow and rapid.</span>"
	now_fixed = "<span class='warning'>Your lungs seem to once again be able to hold air.</span>"
	low_threshold_cleared = "<span class='info'>You can breathe normally again.</span>"
	high_threshold_cleared = "<span class='info'>The constriction around your chest loosens as your breathing calms down.</span>"

	var/operated = FALSE //whether we can still have our damages fixed through surgery


	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/dexalin = 5)

	//Breath damage
	//These thresholds are checked against what amounts to total_mix_pressure * (gas_type_mols/total_mols)

	var/safe_oxygen_min = 16 // Minimum safe partial pressure of O2, in kPa
	var/safe_oxygen_max = 0
	var/safe_nitro_min = 0
	var/safe_nitro_max = 0
	var/safe_co2_min = 0
	var/safe_co2_max = 10 // Yes it's an arbitrary value who cares?
	var/safe_plasma_min = 0
	///How much breath partial pressure is a safe amount of plasma. 0 means that we are immune to plasma.
	var/safe_plasma_max = 0.05
	var/SA_para_min = 1 //Sleeping agent
	var/SA_sleep_min = 5 //Sleeping agent
	var/BZ_trip_balls_min = 1 //BZ gas
	var/BZ_brain_damage_min = 10 //Give people some room to play around without killing the station
	var/gas_stimulation_min = 0.002 //nitrium and Freon
	///Minimum amount of healium to make you unconscious for 4 seconds
	var/healium_para_min = 3
	///Minimum amount of healium to knock you down for good
	var/healium_sleep_min = 6
	///Whether these lungs react negatively to miasma
	var/suffers_miasma = TRUE

	var/oxy_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/oxy_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/oxy_damage_type = OXY
	var/nitro_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/nitro_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/nitro_damage_type = OXY
	var/co2_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/co2_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/co2_damage_type = OXY
	var/plas_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/plas_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/plas_damage_type = TOX

	var/tritium_irradiation_moles_min = 1
	var/tritium_irradiation_moles_max = 15
	var/tritium_irradiation_probability_min = 10
	var/tritium_irradiation_probability_max = 60

	var/cold_message = "your face freezing and an icicle forming"
	var/cold_level_1_threshold = 260
	var/cold_level_2_threshold = 200
	var/cold_level_3_threshold = 120
	var/cold_level_1_damage = COLD_GAS_DAMAGE_LEVEL_1 //Keep in mind with gas damage levels, you can set these to be negative, if you want someone to heal, instead.
	var/cold_level_2_damage = COLD_GAS_DAMAGE_LEVEL_2
	var/cold_level_3_damage = COLD_GAS_DAMAGE_LEVEL_3
	var/cold_damage_type = BURN

	var/hot_message = "your face burning and a searing heat"
	var/heat_level_1_threshold = 360
	var/heat_level_2_threshold = 400
	var/heat_level_3_threshold = 1000
	var/heat_level_1_damage = HEAT_GAS_DAMAGE_LEVEL_1
	var/heat_level_2_damage = HEAT_GAS_DAMAGE_LEVEL_2
	var/heat_level_3_damage = HEAT_GAS_DAMAGE_LEVEL_3
	var/heat_damage_type = BURN

/obj/item/organ/lungs/proc/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/breather, forced = FALSE)
	if(breather.status_flags & GODMODE)
		breather.failed_last_breath = FALSE //clear oxy issues
		breather.clear_alert(ALERT_NOT_ENOUGH_OXYGEN)
		return BREATH_OKAY

	if(HAS_TRAIT(breather, TRAIT_NOBREATH))
		return BREATH_OKAY

	. = BREATH_OKAY

	if(!breath || (breath.total_moles == 0))
		if(!HAS_TRAIT(breather, TRAIT_NOCRITDAMAGE))
			breather.adjustOxyLoss(HUMAN_FAILBREATH_OXYLOSS)

		breather.failed_last_breath = TRUE
		if(safe_oxygen_min)
			breather.throw_alert(ALERT_NOT_ENOUGH_OXYGEN, /atom/movable/screen/alert/not_enough_oxy)
		else if(safe_plasma_min)
			breather.throw_alert(ALERT_NOT_ENOUGH_PLASMA, /atom/movable/screen/alert/not_enough_plas)
		else if(safe_co2_min)
			breather.throw_alert(ALERT_NOT_ENOUGH_CO2, /atom/movable/screen/alert/not_enough_co2)
		else if(safe_nitro_min)
			breather.throw_alert(ALERT_NOT_ENOUGH_NITRO, /atom/movable/screen/alert/not_enough_nitro)
		return BREATH_FAILED

	if(istype(breather.wear_mask) && (breather.wear_mask.clothing_flags & GAS_FILTERING) && breather.wear_mask.has_filter)
		breath = breather.wear_mask.consume_filter(breath)

	var/gas_breathed = 0

	var/list/breath_gases = breath.gas
	//Handle subtypes' breath processing
	handle_gas_override(breather, breath, gas_breathed)

	//Molar count cache of our key gases
	var/O2_moles = breath_gases[GAS_OXYGEN]
	var/N2_moles = breath_gases[GAS_NITROGEN]
	var/plasma_moles = breath_gases[GAS_PLASMA]
	var/CO2_moles = breath_gases[GAS_CO2]
	var/SA_moles = breath_gases[GAS_N2O]

	//Partial pressures in our breath
	var/O2_pp = breath.getBreathPartialPressure(O2_moles)
	var/N2_pp = breath.getBreathPartialPressure(N2_moles)
	var/Plasma_pp = breath.getBreathPartialPressure(plasma_moles)
	var/CO2_pp = breath.getBreathPartialPressure(CO2_moles)
	var/SA_pp = breath.getBreathPartialPressure(SA_moles)

	//-- OXY --//

	//Too much oxygen! //Yes, some species may not like it.
	if(safe_oxygen_max)
		if(O2_pp > safe_oxygen_max)
			if(!forced)
				var/ratio = (O2_moles/safe_oxygen_max) * 10
				breather.apply_damage(clamp(ratio, oxy_breath_dam_min, oxy_breath_dam_max), oxy_damage_type, spread_damage = TRUE)
			breather.throw_alert(ALERT_TOO_MUCH_OXYGEN, /atom/movable/screen/alert/too_much_oxy)
			. = BREATH_DAMAGING

		else
			breather.clear_alert(ALERT_TOO_MUCH_OXYGEN)

	//Too little oxygen!
	if(safe_oxygen_min)
		if(O2_pp < safe_oxygen_min)
			gas_breathed = handle_too_little_breath(breather, O2_pp, safe_oxygen_min, O2_moles)
			breather.throw_alert(ALERT_NOT_ENOUGH_OXYGEN, /atom/movable/screen/alert/not_enough_oxy)
			. = BREATH_DAMAGING
		else
			breather.failed_last_breath = FALSE
			if(breather.health >= breather.crit_threshold)
				breather.adjustOxyLoss(-5)
			gas_breathed = O2_moles
			breather.clear_alert(ALERT_NOT_ENOUGH_OXYGEN)

	//Exhale
	breath.adjustGas(GAS_OXYGEN, -gas_breathed, FALSE)
	breath.adjustGas(GAS_CO2, gas_breathed, FALSE)
	gas_breathed = 0

	//-- Nitrogen --//

	//Too much nitrogen!
	if(safe_nitro_max)
		if(N2_pp > safe_nitro_max)
			if(!forced)
				var/ratio = (N2_moles/safe_nitro_max) * 10
				breather.apply_damage(clamp(ratio, nitro_breath_dam_min, nitro_breath_dam_max), nitro_damage_type, spread_damage = TRUE)
			breather.throw_alert(ALERT_TOO_MUCH_NITRO, /atom/movable/screen/alert/too_much_nitro)
			. = BREATH_DAMAGING
		else
			breather.clear_alert(ALERT_TOO_MUCH_NITRO)

	//Too little nitrogen!
	if(safe_nitro_min)
		if(N2_pp < safe_nitro_min)
			gas_breathed = handle_too_little_breath(breather, N2_pp, safe_nitro_min, N2_moles)
			breather.throw_alert(ALERT_NOT_ENOUGH_NITRO, /atom/movable/screen/alert/not_enough_nitro)
			. = BREATH_DAMAGING
		else
			breather.failed_last_breath = FALSE
			if(breather.health >= breather.crit_threshold)
				breather.adjustOxyLoss(-5)
			gas_breathed = N2_moles
			breather.clear_alert(ALERT_NOT_ENOUGH_NITRO)

	//Exhale
	breath.adjustGas(GAS_NITROGEN, -gas_breathed, FALSE)
	breath.adjustGas(GAS_CO2, gas_breathed, FALSE)
	gas_breathed = 0

	//-- CO2 --//

	//CO2 does not affect failed_last_breath. So if there was enough oxygen in the air but too much co2, this will hurt you, but only once per 4 ticks, instead of once per tick.
	if(safe_co2_max)
		if(CO2_pp > safe_co2_max)
			if(!breather.co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
				breather.co2overloadtime = world.time
			else if(world.time - breather.co2overloadtime > 120)
				breather.Unconscious(60)
				breather.apply_damage(3, co2_damage_type, spread_damage = TRUE) // Lets hurt em a little, let them know we mean business
				if(world.time - breather.co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
					breather.apply_damage(8, co2_damage_type, spread_damage = TRUE)
				breather.throw_alert(ALERT_TOO_MUCH_CO2, /atom/movable/screen/alert/too_much_co2)
			. = BREATH_DAMAGING

		else
			breather.co2overloadtime = 0
			breather.clear_alert(ALERT_TOO_MUCH_CO2)

	//Too little CO2!
	if(safe_co2_min)
		if(CO2_pp < safe_co2_min)
			gas_breathed = handle_too_little_breath(breather, CO2_pp, safe_co2_min, CO2_moles)
			breather.throw_alert(ALERT_NOT_ENOUGH_CO2, /atom/movable/screen/alert/not_enough_co2)
			. = BREATH_DAMAGING
		else
			breather.failed_last_breath = FALSE
			if(breather.health >= breather.crit_threshold)
				breather.adjustOxyLoss(-5)
			gas_breathed = CO2_moles
			breather.clear_alert(ALERT_NOT_ENOUGH_CO2)

	//Exhale
	breath.adjustGas(GAS_CO2, -gas_breathed, FALSE)
	breath.adjustGas(GAS_OXYGEN, gas_breathed, FALSE)
	gas_breathed = 0


	//-- PLASMA --//

	//Too much plasma!
	if(safe_plasma_max)
		if(Plasma_pp > safe_plasma_max)
			if(!forced)
				var/ratio = (plasma_moles/safe_plasma_max) * 10
				breather.apply_damage(clamp(ratio, plas_breath_dam_min, plas_breath_dam_max), plas_damage_type, spread_damage = TRUE)
			breather.throw_alert(ALERT_TOO_MUCH_PLASMA, /atom/movable/screen/alert/too_much_plas)
			. = BREATH_DAMAGING
		else
			breather.clear_alert(ALERT_TOO_MUCH_PLASMA)


	//Too little plasma!
	if(safe_plasma_min)
		if(Plasma_pp < safe_plasma_min)
			gas_breathed = handle_too_little_breath(breather, Plasma_pp, safe_plasma_min, plasma_moles)
			breather.throw_alert(ALERT_NOT_ENOUGH_PLASMA, /atom/movable/screen/alert/not_enough_plas)
			. = BREATH_DAMAGING
		else
			breather.failed_last_breath = FALSE
			if(breather.health >= breather.crit_threshold)
				breather.adjustOxyLoss(-5)
			gas_breathed = plasma_moles
			breather.clear_alert(ALERT_NOT_ENOUGH_PLASMA)

	//Exhale
	breath.adjustGas(GAS_PLASMA, -gas_breathed, FALSE)
	breath.adjustGas(GAS_CO2, gas_breathed, FALSE)
	gas_breathed = 0


	//-- TRACES --//
	breath.garbageCollect()
	if(breath.total_moles) // If there's some other shit in the air lets deal with it here.

	// N2O
		if(SA_pp > SA_para_min) // Enough to make us stunned for a bit
			breather.throw_alert(ALERT_TOO_MUCH_N2O, /atom/movable/screen/alert/too_much_n2o)
			breather.Unconscious(60) // 60 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
				breather.Sleeping(min(breather.AmountSleeping() + 100, 200))

		else if(SA_pp > 0.01) // There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			breather.clear_alert(ALERT_TOO_MUCH_N2O)
			if(prob(20))
				breather.emote(pick("giggle", "laugh"))
		else
			breather.clear_alert(ALERT_TOO_MUCH_N2O)

		// Activate mood on first flag, remove on second, do nothing on third.

		handle_breath_temperature(breath, breather)

	return .

///override this for breath handling unique to lung subtypes, breath_gas is the list of gas in the breath while gas breathed is just what is being added or removed from that list, just as they are when this is called in check_breath()
/obj/item/organ/lungs/proc/handle_gas_override(mob/living/carbon/human/breather, datum/gas_mixture/breath, gas_breathed)
	return

/obj/item/organ/lungs/proc/handle_too_little_breath(mob/living/carbon/human/suffocator = null, breath_pp = 0, safe_breath_min = 0, true_pp = 0)
	. = 0
	if(!suffocator || !safe_breath_min) //the other args are either: Ok being 0 or Specifically handled.
		return FALSE

	if(breath_pp > 0)
		var/ratio = safe_breath_min/breath_pp
		suffocator.adjustOxyLoss(min(5*ratio, HUMAN_FAILBREATH_OXYLOSS)) // Don't fuck them up too fast (space only does HUMAN_FAILBREATH_OXYLOSS after all!
		suffocator.failed_last_breath = TRUE
		. = true_pp*ratio/6
	else
		suffocator.adjustOxyLoss(HUMAN_FAILBREATH_OXYLOSS)
		suffocator.failed_last_breath = TRUE


/obj/item/organ/lungs/proc/handle_breath_temperature(datum/gas_mixture/breath, mob/living/carbon/human/breather) // called by human/life, handles temperatures
	var/breath_temperature = breath.temperature

	if(!HAS_TRAIT(breather, TRAIT_RESISTCOLD)) // COLD DAMAGE
		var/cold_modifier = breather.dna.species.coldmod
		if(breath_temperature < cold_level_3_threshold)
			breather.apply_damage(cold_level_3_damage*cold_modifier, cold_damage_type, spread_damage = TRUE)
		if(breath_temperature > cold_level_3_threshold && breath_temperature < cold_level_2_threshold)
			breather.apply_damage(cold_level_2_damage*cold_modifier, cold_damage_type, spread_damage = TRUE)
		if(breath_temperature > cold_level_2_threshold && breath_temperature < cold_level_1_threshold)
			breather.apply_damage(cold_level_1_damage*cold_modifier, cold_damage_type, spread_damage = TRUE)
		if(breath_temperature < cold_level_1_threshold)
			if(prob(20))
				to_chat(breather, span_warning("You feel [cold_message] in your [name]!"))

	if(!HAS_TRAIT(breather, TRAIT_RESISTHEAT)) // HEAT DAMAGE
		var/heat_modifier = breather.dna.species.heatmod
		if(breath_temperature > heat_level_1_threshold && breath_temperature < heat_level_2_threshold)
			breather.apply_damage(heat_level_1_damage*heat_modifier, heat_damage_type, spread_damage = TRUE)
		if(breath_temperature > heat_level_2_threshold && breath_temperature < heat_level_3_threshold)
			breather.apply_damage(heat_level_2_damage*heat_modifier, heat_damage_type, spread_damage = TRUE)
		if(breath_temperature > heat_level_3_threshold)
			breather.apply_damage(heat_level_3_damage*heat_modifier, heat_damage_type, spread_damage = TRUE)
		if(breath_temperature > heat_level_1_threshold)
			if(prob(20))
				to_chat(breather, span_warning("You feel [hot_message] in your [name]!"))

	// The air you breathe out should match your body temperature
	breath.temperature = breather.bodytemperature

/*/obj/item/organ/lungs/proc/handle_helium_speech(owner, list/speech_args)
	SIGNAL_HANDLER
	speech_args[SPEECH_SPANS] |= SPAN_HELIUM
*/

/obj/item/organ/lungs/on_life(delta_time, times_fired)
	. = ..()
	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			spawn(-1)
				owner.emote("cough")		//respitory tract infection

	if(damage >= low_threshold)
		if(prob(2) && owner.blood_volume)
			owner.visible_message("[owner] coughs up blood!", span_warning("You cough up blood."), span_hear("You hear someone coughing."))
			owner.bleed(1)

		else if(prob(4))
			to_chat(owner, span_warning(pick("I can't breathe...", "Air!", "It's getting hard to breathe.")))
			spawn(-1)
				owner.emote("gasp")
			owner.losebreath = max(round(damage/2), owner.losebreath)

/obj/item/organ/lungs/check_damage_thresholds(mob/organ_owner)
	. = ..()
	if(. == high_threshold_passed && owner)
		owner.visible_message(span_danger("[owner] grabs at [owner.p_their()] throat, struggling for breath!"), span_userdanger("You suddenly feel like you can't breathe."))

/obj/item/organ/lungs/slime
	name = "vacuole"
	desc = "A large organelle designed to store oxygen and other important gasses."

	safe_plasma_max = 0 //We breathe this to gain POWER.

/obj/item/organ/lungs/slime/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/breather_slime)
	. = ..()
	if (breath?.getGroupGas(GAS_PLASMA))
		var/plasma_pp = breath.getBreathPartialPressure(breath.getGroupGas(GAS_PLASMA))
		owner.blood_volume += (0.2 * plasma_pp) // 10/s when breathing literally nothing but plasma, which will suffocate you.

/obj/item/organ/lungs/teshari
	name = "teshari lungs"

	// 30 degrees less
	cold_level_1_threshold = 230
	cold_level_2_threshold = 170
	cold_level_3_threshold = 90

/obj/item/organ/lungs/cybernetic
	name = "basic cybernetic lungs"
	desc = "A basic cybernetic version of the lungs found in traditional humanoid entities."
	icon_state = "lungs-c"
	organ_flags = ORGAN_SYNTHETIC

	var/emp_vulnerability = 80 //Chance of permanent effects if emp-ed.

/obj/item/organ/lungs/cybernetic/tier2
	name = "cybernetic lungs"
	desc = "A cybernetic version of the lungs found in traditional humanoid entities. Allows for greater intakes of oxygen than organic lungs, requiring slightly less pressure."
	icon_state = "lungs-c-u"
	maxHealth = 100
	safe_oxygen_min = 13
	emp_vulnerability = 40

/obj/item/organ/lungs/cybernetic/tier3
	name = "upgraded cybernetic lungs"
	desc = "A more advanced version of the stock cybernetic lungs. Features the ability to filter out lower levels of plasma and carbon dioxide."
	icon_state = "lungs-c-u2"
	safe_plasma_max = 20
	safe_co2_max = 20
	maxHealth = 140
	safe_oxygen_min = 13
	emp_vulnerability = 20

	cold_level_1_threshold = 200
	cold_level_2_threshold = 140
	cold_level_3_threshold = 100

/obj/item/organ/lungs/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		owner.losebreath += 20
		COOLDOWN_START(src, severe_cooldown, 30 SECONDS)
	if(prob(emp_vulnerability/severity)) //Chance of permanent effects
		organ_flags |= ORGAN_SYNTHETIC_EMP //Starts organ faliure - gonna need replacing soon.

/obj/item/organ/lungs/ethereal
	name = "aeration reticulum"
	desc = "These exotic lungs seem crunchier than most."
	icon_state = "lungs_ethereal"
	heat_level_1_threshold = FIRE_MINIMUM_TEMPERATURE_TO_SPREAD // 150C or 433k, in line with ethereal max safe body temperature
	heat_level_2_threshold = 473
	heat_level_3_threshold = 1073

/*
/obj/item/organ/lungs/ethereal/handle_gas_override(mob/living/carbon/human/breather, list/breath_gases, gas_breathed)
	// H2O electrolysis
	gas_breathed = breath_gases[/datum/gas/water_vapor][MOLES]
	breath_gases[/datum/gas/oxygen][MOLES] += gas_breathed
	breath_gases[/datum/gas/hydrogen][MOLES] += gas_breathed*2
	breath_gases[/datum/gas/water_vapor][MOLES] -= gas_breathed
*/

/obj/item/organ/lungs/vox
	name = "Vox lungs"
	desc = "They're filled with dust....wow."
	icon_state = "lungs-vox"

	safe_oxygen_min = 0 //We don't breathe this
	safe_oxygen_max = 0.05 //This is toxic to us
	safe_nitro_min = 16 //We breathe THIS!
	oxy_damage_type = TOX //And it poisons us
	oxy_breath_dam_min = 6
	oxy_breath_dam_max = 20

	cold_level_1_threshold = 0 // Vox should be able to breathe in cold gas without issues?
	cold_level_2_threshold = 0
	cold_level_3_threshold = 0
