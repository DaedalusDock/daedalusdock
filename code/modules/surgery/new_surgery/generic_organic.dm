/datum/surgery_step/generic_organic
	can_infect = 1
	shock_level = 10
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP
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
	allowed_tools = list(
		/obj/item/scalpel/advanced = 100,
		/obj/item/melee/energy/sword = 5
	)
	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic_organic/laser_incise/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
	"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")

	return ..()

/datum/surgery_step/generic_organic/laser_incise/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has made a bloodless incision on [target]'s [affected.name] with \the [tool]."), \
	span_notice("You have made a bloodless incision on [target]'s [affected.name] with \the [tool]."),)
	affected.create_wound(WOUND_CUT, affected.minimum_break_damage/2, TRUE)
	affected.clamp_wounds()
	//spread_germs_to_organ(affected, user)

/datum/surgery_step/generic_organic/laser_incise/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!"), \
	span_warning("Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!"))
	affected.receive_damage(15, 5, sharpness = SHARP_EDGED|SHARP_POINTY)

//////////////////////////////////////////////////////////////////
//	 scalpel surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/incise
	name = "Make incision"
	allowed_tools = list(
		TOOL_SCALPEL = 100,
		/obj/item/knife = 75,
		/obj/item/broken_bottle = 50,
		/obj/item/shard = 50
	)
	min_duration = 90
	max_duration = 110
	var/fail_string = "slicing open"
	var/access_string = "an incision"

/datum/surgery_step/generic_organic/incise/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/bodypart/affected = .
		if(affected.how_open())
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, span_notice("The [incision.desc] provides enough access."))
			return FALSE

/datum/surgery_step/generic_organic/incise/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message("[user] starts [access_string] on [target]'s [affected.name] with \the [tool].", \
	"You start [access_string] on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/generic_organic/incise/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has made [access_string] on [target]'s [affected.name] with \the [tool]."), \
	span_notice("You have made [access_string] on [target]'s [affected.name] with \the [tool]."),)
	affected.create_wound(WOUND_CUT, affected.minimum_break_damage/2, TRUE)
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

/datum/surgery_step/generic_organic/incise/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!"), \
	span_warning("Your hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!"))
	affected.receive_damage(10, sharpness = SHARP_EDGED|SHARP_POINTY)

//////////////////////////////////////////////////////////////////
//	 bleeder clamping surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/clamp_bleeders
	name = "Clamp bleeders"
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/assembly/mousetrap = 20
	)
	min_duration = 40
	max_duration = 60
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION
	strict_access_requirement = FALSE

/datum/surgery_step/generic_organic/clamp_bleeders/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && !affected.clamped())
		return affected

/datum/surgery_step/generic_organic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
	"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/generic_organic/clamp_bleeders/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] clamps bleeders in [target]'s [affected.name] with \the [tool]."),	\
	span_notice("You clamp bleeders in [target]'s [affected.name] with \the [tool]."))
	affected.clamp_wounds()
	//spread_germs_to_organ(affected, user)
	playsound(target.loc, 'sound/items/Welder.ogg', 15, 1)


//////////////////////////////////////////////////////////////////
//	 retractor surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/retract_skin
	name = "Widen incision"
	allowed_tools = list(
		TOOL_RETRACTOR = 100,
		TOOL_CROWBAR = 75,
		/obj/item/knife = 50,
		/obj/item/kitchen/fork = 50
	)
	min_duration = 30
	max_duration = 40
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION
	strict_access_requirement = TRUE

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
	user.visible_message("[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool].",	\
	"You start to pry open the incision on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/generic_organic/retract_skin/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] keeps the incision open on [target]'s [affected.name] with \the [tool]."),	\
	span_notice("You keep the incision open on [target]'s [affected.name] with \the [tool]."))
	affected.open_incision()

/datum/surgery_step/generic_organic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!"),	\
	span_warning("Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!"))
	affected.receive_damage(12, sharpness = SHARP_EDGED|SHARP_POINTY)

//////////////////////////////////////////////////////////////////
//	 skin cauterization surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic_organic/cauterize
	name = "Cauterize incision"
	allowed_tools = list(
		TOOL_CAUTERY = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		TOOL_WELDER = 25
	)
	min_duration = 70
	max_duration = 100
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL
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
			to_chat(user, span_warning("There are no incisions on [target]'s [affected.name] that can be closed cleanly with \the [tool]!"))
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
	user.visible_message("[user] is beginning to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/generic_organic/cauterize/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message(span_notice("[user] [post_cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool]."), \
	span_notice("You [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool]."))

	if(istype(W))
		W.close_wound()
		affected.update_damage()

	if(affected.is_stump)
		affected.bodypart_flags &= ~BP_ARTERY_CUT

	if(affected.clamped())
		affected.remove_clamps()

/datum/surgery_step/generic_organic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!"), \
	span_warning("Your hand slips, damaging [target]'s [affected.name] with \the [tool]!"))
	affected.receive_damage(0, 3)


//////////////////////////////////////////////////////////////////
//	 limb amputation surgery step
//////////////////////////////////////////////////////////////////

/datum/surgery_step/generic_organic/amputate
	name = "Amputate limb"
	allowed_tools = list(
		TOOL_SAW = 100,
		/obj/item/hatchet = 75
	)
	min_duration = 110
	max_duration = 160
	surgery_candidate_flags = 0

/datum/surgery_step/generic_organic/amputate/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && (affected.dismemberable) && !affected.how_open())
		return affected

/datum/surgery_step/generic_organic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message("[user] is beginning to amputate [target]'s [affected.name] with \the [tool]." , \
	span_notice("You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool]."))
	..()

/datum/surgery_step/generic_organic/amputate/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool]."), \
	span_notice("You amputate [target]'s [affected.name] with \the [tool]."))
	affected.dismember(DROPLIMB_EDGE, clean = TRUE)

/datum/surgery_step/generic_organic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!"), \
	span_warning("Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!"))
	affected.receive_damage(30, sharpness = SHARP_EDGED|SHARP_POINTY)
	affected.break_bones()

