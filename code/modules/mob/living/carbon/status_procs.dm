//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness, ear damage,
//eye_blind, eye_blurry, druggy, TRAIT_BLIND trait, TRAIT_NEARSIGHT trait, and TRAIT_HUSK trait.


/mob/living/carbon/IsParalyzed(include_stamcrit = TRUE)
	return ..() || (include_stamcrit && HAS_TRAIT_FROM(src, TRAIT_INCAPACITATED, STAMINA))

/mob/living/proc/stamina_stun()
	return

/mob/living/proc/exit_stamina_stun()
	SIGNAL_HANDLER
	return

/mob/living/carbon/stamina_stun()
	if(!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE))
		return
	if(HAS_TRAIT_FROM(src, TRAIT_INCAPACITATED, STAMINA)) //Already in stamcrit
		return

	var/chance = STAMINA_SCALING_STUN_BASE + (STAMINA_SCALING_STUN_SCALER * stamina.current * STAMINA_STUN_THRESHOLD_MODIFIER)
	if(!prob(chance))
		return
	if(absorb_stun(1))
		return

	ADD_TRAIT(src, TRAIT_INCAPACITATED, STAMINA)
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, STAMINA)
	ADD_TRAIT(src, TRAIT_FLOORED, STAMINA)
	filters += FILTER_STAMINACRIT

	addtimer(CALLBACK(src, PROC_REF(exit_stamina_stun)), STAMINA_STUN_TIME)

/mob/living/carbon/exit_stamina_stun()
	REMOVE_TRAIT(src, TRAIT_INCAPACITATED, STAMINA)
	REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, STAMINA)
	REMOVE_TRAIT(src, TRAIT_FLOORED, STAMINA)
	filters -= FILTER_STAMINACRIT

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
