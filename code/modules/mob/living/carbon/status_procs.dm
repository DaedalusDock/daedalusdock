//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness, ear damage,
//eye_blind, eye_blurry, druggy, TRAIT_BLIND trait, TRAIT_NEARSIGHT trait, and TRAIT_HUSK trait.


/mob/living/carbon/IsParalyzed(include_stamcrit = TRUE)
	return ..() || (include_stamcrit && HAS_TRAIT_FROM(src, TRAIT_INCAPACITATED, STAMINA))

/mob/living/proc/stamina_stun()
	return

/mob/living/carbon/stamina_stun()
	var/threshold = stamina.maximum * STAMINA_STUN_THRESHOLD_MODIFIER
	var/chance = STAMINA_SCALING_STUN_BASE + STAMINA_SCALING_STUN_SCALER * (1 - stamina.current / threshold)
	if(prob(chance))
		apply_status_effect(/datum/status_effect/incapacitating/stamcrit)

/mob/living/carbon/adjust_disgust(amount)
	disgust = clamp(disgust+amount, 0, DISGUST_LEVEL_MAXEDOUT)

/mob/living/carbon/set_disgust(amount)
	disgust = clamp(amount, 0, DISGUST_LEVEL_MAXEDOUT)

////////////////////////////////////////TRAUMAS/////////////////////////////////////////

/mob/living/carbon/proc/get_traumas()
	. = list()
	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		. = B.traumas

/mob/living/carbon/proc/has_trauma_type(brain_trauma_type, resilience)
	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		. = B.has_trauma_type(brain_trauma_type, resilience)

/mob/living/carbon/proc/gain_trauma(datum/brain_trauma/trauma, resilience, ...)
	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		var/list/arguments = list()
		if(args.len > 2)
			arguments = args.Copy(3)
		. = B.brain_gain_trauma(trauma, resilience, arguments)

/mob/living/carbon/proc/gain_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience)
	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		. = B.gain_trauma_type(brain_trauma_type, resilience)

/mob/living/carbon/proc/cure_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience)
	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		. = B.cure_trauma_type(brain_trauma_type, resilience)

/mob/living/carbon/proc/cure_all_traumas(resilience)
	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		. = B.cure_all_traumas(resilience)
