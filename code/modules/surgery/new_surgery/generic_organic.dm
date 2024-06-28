/datum/surgery_step/generic_organic
	can_infect = 1
	pain_given =10
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP
	abstract_type = /datum/surgery_step/generic_organic

/datum/surgery_step/generic_organic/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(target_zone != BODY_ZONE_PRECISE_EYES) //there are specific steps for eye surgery
		return ..()


//////////////////////////////////////////////////////////////////
//	laser scalpel surgery step
//	acts as both cutting and bleeder clamping surgery steps
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/laser_incise
	name = "Make laser incision"
	desc = "Creates an incision on a patient without causing bleeding."
	allowed_tools = list(
		/obj/item/scalpel/advanced = 100,
		/obj/item/melee/energy/sword = 5
	)
	min_duration = 2 SECONDS
	max_duration = 4 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/generic_organic/laser_incise/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts the bloodless incision on [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)

	return ..()

/datum/surgery_step/generic_organic/laser_incise/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has made a bloodless incision on [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.create_wound(WOUND_CUT, affected.minimum_break_damage/2, TRUE)
	affected.clamp_wounds()
	//spread_germs_to_organ(affected, user)
	..()

/datum/surgery_step/generic_organic/laser_incise/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.plaintext_zone] with [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(15, 5, sharpness = SHARP_EDGED|SHARP_POINTY)
	..()

//////////////////////////////////////////////////////////////////
//	 scalpel surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/incise
	name = "Make incision"
	desc = "Creates a surgerical cut on a patient, can be widened to operate deeper in their body."
	allowed_tools = list(
		TOOL_SCALPEL = 100,
		/obj/item/knife = 75,
		/obj/item/broken_bottle = 50,
		/obj/item/shard = 50
	)
	min_duration = 3 SECONDS
	max_duration = 5.5 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

	var/fail_string = "slicing open"
	var/access_string = "an incision"

/datum/surgery_step/generic_organic/incise/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/bodypart/affected = .
		if(affected.how_open())
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, span_notice("The [incision.desc] provides enough access to the [affected.plaintext_zone]."))
			return FALSE

/datum/surgery_step/generic_organic/incise/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts [access_string] on [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/generic_organic/incise/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has made [access_string] on [target]'s [affected.plaintext_zone] with  [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.create_wound(WOUND_CUT, affected.minimum_break_damage/2, TRUE)
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 15, 1)
	..()

/datum/surgery_step/generic_organic/incise/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, [fail_string] \the [target]'s [affected.plaintext_zone] in the wrong place with [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(10, sharpness = SHARP_EDGED|SHARP_POINTY)
	..()

//////////////////////////////////////////////////////////////////
//	 bleeder clamping surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/clamp_bleeders
	name = "Clamp bleeders"
	desc = "Clamps bleeding tissue to prevent blood loss during an operation."
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/assembly/mousetrap = 20
	)
	min_duration = 3 SECONDS
	max_duration = 5 SECONDS
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION
	strict_access_requirement = FALSE
	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/generic_organic/clamp_bleeders/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && !affected.clamped())
		return affected

/datum/surgery_step/generic_organic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts clamping bleeders in [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/generic_organic/clamp_bleeders/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] clamps bleeders in [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.clamp_wounds()
	//spread_germs_to_organ(affected, user)
	..()


//////////////////////////////////////////////////////////////////
//	 retractor surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/retract_skin
	name = "Widen incision"
	desc = "Retracts the flesh of a patient to grant access to deeper portions of the body."
	allowed_tools = list(
		TOOL_RETRACTOR = 100,
		TOOL_CROWBAR = 75,
		/obj/item/knife = 50,
		/obj/item/kitchen/fork = 50
	)
	min_duration = 3 SECONDS
	max_duration = 5 SECONDS
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION | SURGERY_BLOODY_GLOVES
	strict_access_requirement = TRUE
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'

/datum/surgery_step/generic_organic/retract_skin/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(affected)
		if(affected.how_open() >= SURGERY_RETRACTED)
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, span_notice("The [incision.desc] provides enough access, a larger incision isn't needed."))
		else
			. = TRUE

/datum/surgery_step/generic_organic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts to pry open the incision on [target]'s [affected.plaintext_zone] with \the [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/generic_organic/retract_skin/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] keeps the incision open on [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.open_incision()
	..()

/datum/surgery_step/generic_organic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.plaintext_zone] with [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(12, sharpness = SHARP_EDGED|SHARP_POINTY)
	..()

//////////////////////////////////////////////////////////////////
//	 skin cauterization surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/cauterize
	name = "Cauterize incision"
	desc = "Mends any surgical incisions on a patient's limb."
	allowed_tools = list(
		TOOL_CAUTERY = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		TOOL_WELDER = 25
	)
	min_duration = 4 SECONDS
	max_duration = 6 SECONDS
	surgery_flags = SURGERY_NO_ROBOTIC
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

	var/cauterize_term = "cauterize"
	var/post_cauterize_term = "cauterized"

/datum/surgery_step/generic_organic/cauterize/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(affected)
		if(affected.is_stump)
			if(affected.bodypart_flags & BP_ARTERY_CUT)
				. = TRUE
			else
				to_chat(user, span_warning("There is no bleeding to repair within this stump."))
		else if(!affected.get_incision(1))
			to_chat(user, span_warning("There are no incisions on [target]'s [affected.plaintext_zone] that can be closed cleanly with \the [tool]!"))
		else
			. = TRUE

/datum/surgery_step/generic_organic/cauterize/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected)
		if(affected.is_stump)
			if(affected.bodypart_flags & BP_ARTERY_CUT)
				return affected
		else if(affected.how_open())
			return affected

/datum/surgery_step/generic_organic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message(span_notice("[user] begins to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/generic_organic/cauterize/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message(span_notice("[user] [post_cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)

	if(istype(W))
		W.close_wound()

	if(affected.is_stump)
		affected.set_sever_artery(FALSE)

	if(affected.clamped())
		affected.remove_clamps()
	..()

/datum/surgery_step/generic_organic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, damaging [target]'s [affected.plaintext_zone] with [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(0, 3)
	..()


//////////////////////////////////////////////////////////////////
//	 limb amputation surgery step
//////////////////////////////////////////////////////////////////

/datum/surgery_step/generic_organic/amputate
	name = "Amputate limb"
	desc = "Removes a patient's limb."
	allowed_tools = list(
		TOOL_SAW = 100,
		/obj/item/fireaxe = 95,
		/obj/item/hatchet = 75,
		/obj/item/knife/butcher = 40,
		/obj/item/knife = 20
	)
	min_duration = 11 SECONDS
	max_duration = 16 SECONDS
	surgery_flags = NONE
	pain_given = PAIN_AMT_AGONIZING + 30

	preop_sound = list(
		/obj/item/circular_saw = 'sound/surgery/saw.ogg',
		/obj/item/fireaxe = 'sound/surgery/scalpel1.ogg',
		/obj/item/hatchet = 'sound/surgery/scalpel1.ogg',
		/obj/item/knife = 'sound/surgery/scalpel1.ogg',
	)
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/generic_organic/amputate/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && (affected.dismemberable) && !affected.how_open() && !(target_zone == BODY_ZONE_CHEST))
		return affected

/datum/surgery_step/generic_organic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone, TRUE)
	user.visible_message(span_notice("[user] begins to amputate [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/generic_organic/amputate/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone, TRUE)
	user.visible_message(span_notice("[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.dismember(DROPLIMB_EDGE, clean = TRUE)
	..()

/datum/surgery_step/generic_organic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone, TRUE)
	user.visible_message(span_warning("[user]'s hand slips, sawing through the bone in [target]'s [affected.plaintext_zone] with [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(30, sharpness = SHARP_EDGED|SHARP_POINTY)
	affected.break_bones()
	..()
