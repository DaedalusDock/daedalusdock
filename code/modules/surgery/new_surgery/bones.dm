//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/bone
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NEEDS_RETRACTED
	abstract_type = /datum/surgery_step/bone
	strict_access_requirement = FALSE

//////////////////////////////////////////////////////////////////
//	bone setting surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/bone/set_bone
	name = "Set bone"
	desc = "Sets a bone in it's correct position to be " + CODEX_LINK("mended", "repair bone") + "."
	allowed_tools = list(
		/obj/item/bonesetter = 100,
		/obj/item/wrench = 75
	)
	min_duration = 3 SECONDS
	max_duration = 6 SECONDS
	pain_given =40
	delicate = 1

/datum/surgery_step/bone/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)

	var/bone = affected.encased ? "\the [target]'s [affected.encased]" : "bones in [target]'s [affected.name]"
	if(affected.encased == "skull")
		user.visible_message(span_notice("[user] begins to piece [bone] back together with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	else
		user.visible_message(span_notice("[user] begins to set [bone] in place with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/bone/set_bone/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)

	var/bone = affected.encased ? "\the [target]'s [affected.encased]" : "bones in \the [target]'s [affected.name]"

	if (affected.check_bones() & CHECKBONES_BROKEN)
		if(affected.encased == "skull")
			user.visible_message(span_notice("[user] pieces [bone] back together with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
		else
			user.visible_message(span_notice("[user] sets [bone] in place with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
		affected.stage = 1
	else
		user.visible_message("[span_notice("[user] sets [bone]")] [span_warning("in the WRONG place with [tool].")]", vision_distance = COMBAT_MESSAGE_RANGE)
		affected.break_bones()
	..()

/datum/surgery_step/bone/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)

	user.visible_message(span_warning("[user]'s hand slips, damaging the [affected.encased ? affected.encased : "bones"] in [target]'s [affected.name] with [tool]!"))
	affected.receive_damage(5)
	affected.break_bones()
	..()

//////////////////////////////////////////////////////////////////
//	post setting bone-gelling surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/bone/finish
	name = "Repair bone"
	desc = "Mends a broken bone."

	surgery_flags = parent_type::surgery_flags | SURGERY_BLOODY_GLOVES

	allowed_tools = list(
		/obj/item/stack/medical/bone_gel = 100,
		/obj/item/stack/sticky_tape/surgical = 100,
		/obj/item/stack/sticky_tape = 75
	)

	can_infect = 1
	min_duration = 2 SECONDS
	max_duration = 3 SECONDS
	pain_given =20

/datum/surgery_step/bone/finish/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && (affected.bodypart_flags & BP_BROKEN_BONES))
		return affected

/datum/surgery_step/bone/finish/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/bone = affected.encased ? "\the [target]'s damaged [affected.encased]" : "damaged bones in \the [target]'s [affected.name]"
	user.visible_message(span_notice("[user] starts to finish mending [bone] with \the [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/bone/finish/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/bone = affected.encased ? "\the [target]'s damaged [affected.encased]" : "damaged bones in [target]'s [affected.name]"
	user.visible_message(span_notice("[user] has mended [bone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.heal_bones()
	..()

/datum/surgery_step/bone/finish/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	..()
