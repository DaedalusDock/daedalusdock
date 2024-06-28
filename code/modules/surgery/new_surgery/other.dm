//Procedures in this file: Internal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	 Tendon fix surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/fix_tendon
	name = "Repair tendon"
	desc = "Repairs the tendon of a patient's limb."
	allowed_tools = list(
		/obj/item/fixovein = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/stack/sticky_tape = 50
	)
	can_infect = 1
	min_duration = 5 SECONDS
	max_duration = 8 SECONDS
	pain_given =40
	delicate = 1
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_RETRACTED | SURGERY_BLOODY_GLOVES

/datum/surgery_step/fix_tendon/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && (affected.bodypart_flags & BP_TENDON_CUT))
		return affected

/datum/surgery_step/fix_tendon/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts reattaching the damaged [affected.tendon_name] in [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/fix_tendon/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has reattached the [affected.tendon_name] in [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.set_sever_tendon(FALSE)
	..()

/datum/surgery_step/fix_tendon/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.plaintext_zone]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(5, sharpness = tool.sharpness)
	..()

//////////////////////////////////////////////////////////////////
//	 IB fix surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/fix_vein
	name = "Repair arterial bleeding"
	desc = "Stops bleeding from an artery in a patient's limb."
	allowed_tools = list(
		/obj/item/fixovein = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/stack/sticky_tape = 50
	)
	can_infect = 1
	min_duration = 5 SECONDS
	max_duration = 8 SECONDS
	pain_given =40
	delicate = 1
	strict_access_requirement = FALSE
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_RETRACTED | SURGERY_BLOODY_BODY

/datum/surgery_step/fix_vein/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && (affected.bodypart_flags & BP_ARTERY_CUT))
		return affected

/datum/surgery_step/fix_vein/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts patching the damaged [affected.artery_name] in [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/fix_vein/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has patched the [affected.artery_name] in [target]'s [affected.plaintext_zone] with \the [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.set_sever_artery(FALSE)
	..()

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.plaintext_zone]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(5, sharpness = tool.sharpness)
	..()
