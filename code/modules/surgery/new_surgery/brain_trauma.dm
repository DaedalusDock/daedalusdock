/datum/surgery_step/brain_trauma
	name = "Repair brain trauma"
	desc = "Repairs physiological and psychological damage to a patient's brain."
	surgery_flags = SURGERY_NEEDS_DEENCASEMENT
	allowed_tools = list(
		TOOL_HEMOSTAT = 85,
		TOOL_SCREWDRIVER = 35
	)

/datum/surgery_step/brain_trauma/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(!affected)
		return
	if(affected.body_zone == BODY_ZONE_HEAD)
		return TRUE

/datum/surgery_step/brain_trauma/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	var/obj/item/organ/brain/target_brain = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		to_chat(user, span_warning("[target] doesn't have a brain."))
		return FALSE

/datum/surgery_step/brain_trauma/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	user.visible_message(span_notice("[user] begins to repair [target]'s brain."), vision_distance = COMBAT_MESSAGE_RANGE)

/datum/surgery_step/brain_trauma/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/brain/brain = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!brain)
		return
	if(target.mind?.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	target.setOrganLoss(ORGAN_SLOT_BRAIN, target.getOrganLoss(ORGAN_SLOT_BRAIN) - 50)
	target.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
	if(target.getOrganLoss(ORGAN_SLOT_BRAIN) > 0)
		to_chat(user, "[target]'s brain looks like it could be fixed further.")
	..()

/datum/surgery_step/brain_trauma/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(target.getorganslot(ORGAN_SLOT_BRAIN))
		user.visible_message(span_warning("[user] screws up, scraping [target]'s brain!"), vision_distance = COMBAT_MESSAGE_RANGE)
		if(target.stat < UNCONSCIOUS)
			to_chat(target, span_userdanger("Your head throbs with horrible pain; thinking hurts!"))
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_SURGERY)
	else
		user.visible_message(span_warning("[user] suddenly notices that the brain [user.p_they()] [user.p_were()] working on is not there anymore."), vision_distance = COMBAT_MESSAGE_RANGE)
