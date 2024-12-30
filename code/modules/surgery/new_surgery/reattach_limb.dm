//Procedures in this file: Robotic limbs attachment, meat limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//	 generic limb surgery step datum
//////////////////////////////////////////////////////////////////
/datum/surgery_step/limb
	can_infect = 0
	delicate = 1
	abstract_type = /datum/surgery_step/limb

/datum/surgery_step/limb/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return TRUE

//////////////////////////////////////////////////////////////////
//	 limb attachment surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/limb/attach
	name = "Attach limb"
	desc = "Affixes a limb to a patient, where it can then be " + CODEX_LINK("connected", "connect limb") + "." //String interpolation isn't const folded
	allowed_tools = list(/obj/item/bodypart = 100)
	min_duration = 50
	max_duration = 70

/datum/surgery_step/limb/attach/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/BP = target.get_bodypart(target_zone)
	if(BP)
		to_chat(user, span_warning("There is already [BP.plaintext_zone]!"))
		return FALSE
	return TRUE

/datum/surgery_step/limb/attach/can_operate(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/bodypart/BP = tool
		var/obj/item/bodypart/chest/mob_chest = target.get_bodypart(BODY_ZONE_CHEST)
		if(!(mob_chest.acceptable_bodytype & BP.bodytype))
			return FALSE

/datum/surgery_step/limb/attach/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/BP = tool
	user.visible_message(span_notice("[user] starts attaching the [BP.plaintext_zone] to [target]'s [BP.amputation_point]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/limb/attach/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!user.temporarilyRemoveItemFromInventory(tool))
		return
	var/obj/item/bodypart/BP = tool
	user.visible_message(span_notice("[user] has attached the [BP.plaintext_zone] to [target]'s [BP.amputation_point]."), vision_distance = COMBAT_MESSAGE_RANGE)
	BP.attach_limb(target)
	..()

/datum/surgery_step/limb/attach/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/BP = target.get_bodypart(target_zone, TRUE)
	user.visible_message(span_warning("[user]'s hand slips, damaging [target]'s [BP.amputation_point]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	target.apply_damage(10, BRUTE, BODY_ZONE_CHEST, sharpness = SHARP_EDGED)
	..()

//////////////////////////////////////////////////////////////////
//	 limb connecting surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/limb/connect
	name = "Connect limb"
	desc = "Connects a limb to a patient's nervous system, granting them the ability to use it."
	allowed_tools = list(
		/obj/item/fixovein = 100,
		/obj/item/stack/cable_coil = 75,
	)
	can_infect = 1
	min_duration = 10 SECONDS
	max_duration = 12 SECONDS
	pain_given = PAIN_AMT_AGONIZING //THEMS ARE NERVES

/datum/surgery_step/limb/connect/can_operate(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/bodypart/BP = target.get_bodypart(target_zone)
		return BP && !BP.is_stump && (BP.bodypart_flags & BP_CUT_AWAY)

/datum/surgery_step/limb/connect/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/BP = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts connecting tendons and muscles in [target]'s [BP.amputation_point] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/limb/connect/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/BP = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has connected tendons and muscles in [target]'s [BP.amputation_point] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	BP.bodypart_flags &= ~BP_CUT_AWAY
	BP.update_disabled()
	..()

/datum/surgery_step/limb/connect/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/BP = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, damaging [target]'s [BP.amputation_point]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	target.apply_damage(10, BRUTE, BODY_ZONE_CHEST, sharpness = tool.sharpness)
	..()
