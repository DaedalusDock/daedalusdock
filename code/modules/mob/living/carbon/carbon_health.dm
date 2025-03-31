/// Returns TRUE if the mob would have blue hands/feet.
/mob/living/carbon/proc/undergoing_cyanosis()
	return needs_organ(ORGAN_SLOT_HEART) && get_blood_oxygenation() < BLOOD_CIRC_SAFE

/// Returns JAUNDICE_EYES or JAUNDICE_SKIN if the mob would have yellowed skin/eyes.
/mob/living/carbon/proc/undergoing_jaundice()
	if(!needs_organ(ORGAN_SLOT_LIVER))
		return FALSE

	if(HAS_TRAIT(src, TRAIT_JAUNDICE_SKIN))
		return JAUNDICE_SKIN

	var/obj/item/organ/liver/liver = getorganslot(ORGAN_SLOT_LIVER)
	if(liver.damage > (liver.low_threshold * liver.maxHealth))
		return JAUNDICE_EYES

/// Returns TRUE if the mob's nervous system is breaking down.
/mob/living/carbon/proc/undergoing_nervous_system_failure()
	return getBrainLoss() >= maxHealth * 0.75

/mob/living/carbon/proc/undergoing_liver_failure()
	if(!needs_organ(ORGAN_SLOT_LIVER))
		return FALSE

	var/obj/item/organ/liver/liver = getorganslot(ORGAN_SLOT_LIVER)
	if(!liver || (liver.organ_flags & ORGAN_DEAD))
		return TRUE

	if(liver)
	return FALSE

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

/// Returns a fluff blood pressure value based on blood circulation.
/mob/living/carbon/proc/get_blood_pressure()
	if(HAS_TRAIT(src, TRAIT_FAKEDEATH))
		return "[FLOOR(120+rand(-5,5), 1)*0.25]/[FLOOR(80+rand(-5,5)*0.25, 1)]"

	var/blood_result = get_blood_circulation()
	return "[FLOOR((120+rand(-5,5))*(blood_result/100), 1)]/[FLOOR((80+rand(-5,5))*(blood_result/100), 1)]"

/// Returns the pulse of the mob.
/mob/living/carbon/proc/pulse()
	if (stat == DEAD)
		return PULSE_NONE

	var/obj/item/organ/heart/H = getorganslot(ORGAN_SLOT_HEART)
	return H ? H.pulse : PULSE_NONE

/// Returns the pulse of a mob as BPM.
/mob/living/carbon/proc/get_pulse_as_number()
	if(HAS_TRAIT(src, TRAIT_FAKEDEATH))
		return 0

	var/obj/item/organ/heart/heart_organ = getorganslot(ORGAN_SLOT_HEART)
	if(!heart_organ)
		return 0

	switch(pulse())
		if(PULSE_NONE)
			return 0
		if(PULSE_SLOW)
			return rand(40, 60)
		if(PULSE_NORM)
			return rand(60, 90)
		if(PULSE_FAST)
			return rand(90, 120)
		if(PULSE_2FAST)
			return rand(120, 160)
		if(PULSE_THREADY)
			return PULSE_MAX_BPM
	return 0

///generates realistic-ish pulse output based on preset levels as text
/mob/living/carbon/proc/get_pulse(method)	//method 0 is for hands, 1 is for machines, more accurate
	var/obj/item/organ/heart/heart_organ = getorganslot(ORGAN_SLOT_HEART)
	if(!heart_organ)
		// No heart, no pulse
		return "0"

	var/bpm = get_pulse_as_number()
	if(bpm >= PULSE_MAX_BPM)
		return method == GETPULSE_TOOL ? ">[PULSE_MAX_BPM]" : "extremely weak and fast, patient's artery feels like a thread"

	return "[method == GETPULSE_TOOL ? bpm : bpm + rand(-10, 10)]"

/// Wrapper around heart.Restart(), restarts the mob's heart and provides a grace period.
/mob/living/carbon/proc/resuscitate()
	if(!undergoing_cardiac_arrest())
		return FALSE

	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!istype(heart) || (heart.organ_flags & ORGAN_DEAD))
		return FALSE

	if(!undergoing_nervous_system_failure())
		visible_message("\The [src] jerks and gasps for breath!")
	else
		visible_message("\The [src] twitches a bit as \his heart restarts!")

	shock_stage = min(shock_stage, SHOCK_AMT_FOR_FIBRILLATION - 25)

	// Clamp oxy loss to 70 for 200 health mobs. This is a 0.65 modifier for blood oxygenation.
	if(getOxyLoss() >= maxHealth * 0.35)
		setOxyLoss(maxHealth * 0.35)

	COOLDOWN_START(heart, arrhythmia_grace_period, 10 SECONDS)
	heart.Restart()
	heart.handle_pulse()
	return TRUE

/// Returns TRUE if the given damage type can automatically heal over time.
/mob/living/carbon/proc/can_autoheal(damtype)
	if(!damtype)
		CRASH("No damage type given to can_autoheal")

	switch(damtype)
		if(BRUTE)
			return getBruteLoss() < (maxHealth/2)
		if(BURN)
			return getFireLoss() < (maxHealth/2)

/// Returns all wounds.
/mob/living/carbon/proc/get_wounds()
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(LAZYLEN(BP.wounds))
			. += BP.wounds
