//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic ribcage surgery step datum
//////////////////////////////////////////////////////////////////
/datum/surgery_step/open_encased
	name = "Saw through bone"
	desc = "Surgerically fractures the bones of a patient's limb, granting access to any organs underneath."
	allowed_tools = list(
		TOOL_SAW = 100,
		/obj/item/knife = 50,
		/obj/item/hatchet = 75
	)
	can_infect = 1
	min_duration = 5 SECONDS
	max_duration = 7 SECONDS
	pain_given = PAIN_AMT_AGONIZING
	delicate = 1
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_RETRACTED | SURGERY_BLOODY_BODY
	strict_access_requirement = TRUE

	preop_sound = list(
		/obj/item/circular_saw = 'sound/surgery/saw.ogg',
		/obj/item/fireaxe = 'sound/surgery/scalpel1.ogg',
		/obj/item/hatchet = 'sound/surgery/scalpel1.ogg',
		/obj/item/knife = 'sound/surgery/scalpel1.ogg',
	)

/datum/surgery_step/open_encased/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.encased)
		return affected

/datum/surgery_step/open_encased/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] begins to cut through [target]'s [affected.encased] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/open_encased/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has cut [target]'s [affected.encased] open with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.break_bones(FALSE)
	..()

/datum/surgery_step/open_encased/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, cracking [target]'s [affected.encased] with \the [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(15, sharpness = SHARP_EDGED|SHARP_POINTY)
	affected.break_bones()
	..()
