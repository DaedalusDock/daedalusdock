/datum/surgery_step/robotics
	can_infect = 0
	surgery_flags = SURGERY_NO_FLESH | SURGERY_NO_STUMP
	abstract_type = /datum/surgery_step/robotics

/datum/surgery_step/robotics/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && !(affected.bodypart_flags & BP_CUT_AWAY))
		return affected

/datum/surgery_step/internal/remove_organ/robotic
	name = "Remove robotic component"
	can_infect = 0
	surgery_flags = SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT

/datum/surgery_step/internal/replace_organ/robotic
	name = "Replace robotic component"
	can_infect = 0
	robotic_surgery = TRUE
	surgery_flags = SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT

//////////////////////////////////////////////////////////////////
//	 unscrew robotic limb hatch surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/unscrew_hatch
	name = "Screw/Unscrew maintenance hatch"
	allowed_tools = list(
		TOOL_SCREWDRIVER = 100,
		/obj/item/coin = 50,
		/obj/item/knife = 50
	)
	min_duration = 4 SECONDS
	max_duration = 6 SECONDS

	success_sound = 'sound/items/screwdriver.ogg'

/datum/surgery_step/robotics/unscrew_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.hatch_state != HATCH_OPENED)
		return affected

/datum/surgery_step/robotics/unscrew_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts to [affected.hatch_state == HATCH_CLOSED ? "unscrew" : "screw"] the maintenance hatch on [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/robotics/unscrew_hatch/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] has [affected.hatch_state == HATCH_CLOSED ? "unscrewed" : "screwed"] the maintenance hatch on [target]'s [affected.plaintext_zone] with \the [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	if(affected.hatch_state == HATCH_CLOSED)
		affected.hatch_state = HATCH_UNSCREWED
	else
		affected.hatch_state = HATCH_CLOSED
	..()

/datum/surgery_step/robotics/unscrew_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s [tool.name] slips, failing to [affected.hatch_state == HATCH_CLOSED ? "unscrew" : "screw"] [target]'s [affected.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

//////////////////////////////////////////////////////////////////
//	open robotic limb surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/open_hatch
	name = "Open/close maintenance hatch"
	allowed_tools = list(
		TOOL_RETRACTOR = 100,
		TOOL_CROWBAR = 100,
		/obj/item/kitchen = 50
	)

	min_duration = 2 SECONDS
	max_duration = 3 SECONDS

	success_sound = 'sound/items/crowbar.ogg'

/datum/surgery_step/robotics/open_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.hatch_state != HATCH_CLOSED)
		return affected

/datum/surgery_step/robotics/open_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts to [affected.hatch_state == HATCH_UNSCREWED ? "pry open" : "close"] the maintenance hatch on [target]'s [affected.name] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/robotics/open_hatch/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] opens the maintenance hatch on [target]'s [affected.name] with [tool]."))
	if(affected.hatch_state == HATCH_UNSCREWED)
		affected.hatch_state = HATCH_OPENED
	else
		affected.hatch_state = HATCH_UNSCREWED
	..()

/datum/surgery_step/robotics/open_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s [tool.name] slips, failing to [affected.hatch_state == HATCH_UNSCREWED ? "open" : "close"] the hatch on [target]'s [affected.name]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

//////////////////////////////////////////////////////////////////
//	robotic limb brute damage repair surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/repair_brute
	name = "Repair damage to prosthetic"
	allowed_tools = list(
		TOOL_WELDER = 100,
		/obj/item/gun/energy/plasmacutter = 50,
	)

	min_duration = 3 SECONDS
	max_duration = 6 SECONDS

	success_sound = 'sound/items/welder.ogg'

/datum/surgery_step/robotics/repair_brute/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(affected)
		if(!affected.brute_dam)
			to_chat(user, span_warning("There is no damage to repair."))
			return FALSE
		if(!tool.tool_use_check(user, 1))
			return FALSE
		return TRUE
	return FALSE

/datum/surgery_step/robotics/repair_brute/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.hatch_state == HATCH_OPENED && (affected.brute_dam > 0))
		return affected

/datum/surgery_step/robotics/repair_brute/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] begins to patch damage to [target]'s [affected.plaintext_zone]'s support structure with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/robotics/repair_brute/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] finishes patching damage to [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/robotics/repair_brute/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s [tool.name] slips, damaging the internal structure of [target]'s [affected.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(0, rand(5, 10))
	..()

//////////////////////////////////////////////////////////////////
//	robotic limb burn damage repair surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/repair_burn
	name = "Repair burns on prosthetic"
	allowed_tools = list(
		/obj/item/stack/cable_coil = 100
	)
	min_duration = 3 SECONDS
	max_duration = 6 SECONDS

/datum/surgery_step/robotics/repair_burn/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(affected)
		if(!affected.burn_dam)
			to_chat(user, span_warning("There is no damage to repair."))
			return FALSE
		else
			var/obj/item/stack/cable_coil/C = tool
			if(istype(C))
				if(!C.tool_use_check(3))
					to_chat(user, span_warning("You need three or more cable pieces to repair this damage."))
				else
					return TRUE
	return FALSE

/datum/surgery_step/robotics/repair_burn/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.hatch_state == HATCH_OPENED && (affected.burn_dam > 0))
		return affected

/datum/surgery_step/robotics/repair_burn/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] begins to splice new cabling into [target]'s [affected.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/robotics/repair_burn/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] finishes splicing cable into [target]'s [affected.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.heal_damage(0, rand(30,50), BODYTYPE_ROBOTIC)
	tool.use(2) // We need 3 cable coil, and `handle_post_surgery()` removes 1.
	..()

/datum/surgery_step/robotics/repair_burn/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user] causes a short circuit in [target]'s [affected.plaintext_zone]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(0, rand(5,10))
	..()

//////////////////////////////////////////////////////////////////
//	 artificial organ repair surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/fix_organ_robotic //For artificial organs
	name = "Repair prosthetic organ"
	allowed_tools = list(
		TOOL_SCREWDRIVER = 70,
		/obj/item/stack/medical/bone_gel = 30,
	)
	min_duration = 4 SECONDS
	max_duration = 6 SECONDS
	surgery_flags = SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT

/datum/surgery_step/robotics/fix_organ_robotic/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(!affected)
		return
	for(var/obj/item/organ/I in affected.contained_organs)
		if((I.organ_flags & ORGAN_SYNTHETIC) && I.damage > 0)
			return TRUE
	..()

/datum/surgery_step/robotics/fix_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(!affected)
		return FALSE

	var/list/organs = list()
	for(var/obj/item/organ/I in affected.contained_organs)
		if((I.organ_flags & ORGAN_SYNTHETIC) && I.damage > 0)
			organs[I.name] = I.slot

	if(!length(organs))
		to_chat(span_warning("[target.p_they(TRUE)] has no robotic organs there."))
		return FALSE

	var/organ = input(user, "Which organ do you want to prepare for surgery?", "Repair Organ", "Surgery") as null|anything in organs
	if(organ)
		return list(organ, organs[organ])

/datum/surgery_step/robotics/fix_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] starts mending the damage to [target]'s [(LAZYACCESS(target.surgeries_in_progress, target_zone))[1]] mechanisms."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/robotics/fix_organ_robotic/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/I = target.getorganslot((LAZYACCESS(target.surgeries_in_progress, target_zone))?[2])
	if(!I || !I.owner == target)
		return

	user.visible_message(span_notice("[user] repairs [target]'s [I.name] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	I.damage = 0
	..()

/datum/surgery_step/robotics/fix_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, gumming up the mechanisms inside of [target]'s [affected.plaintext_zone] with [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.create_wound(WOUND_CUT, 5)
	for(var/obj/item/organ/I in affected.contained_organs)
		I.applyOrganDamage(rand(3,5))
	..()

//////////////////////////////////////////////////////////////////
//	robotic organ detachment surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/detach_organ_robotic
	name = "Decouple prosthetic organ"
	allowed_tools = list(
		TOOL_MULTITOOL = 100
	)
	min_duration = 9 SECONDS
	max_duration = 11 SECONDS
	surgery_flags = SURGERY_NO_STUMP | SURGERY_NO_FLESH | SURGERY_NEEDS_DEENCASEMENT

/datum/surgery_step/robotics/detach_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/list/attached_organs = list()

	for(var/obj/item/organ/I in affected.contained_organs)
		attached_organs[I.name] = I.slot

	if(!length(attached_organs))
		to_chat(user, span_warning("There are no appropriate internal components to decouple."))
		return FALSE

	var/organ_to_remove = input(user, "Which organ do you want to prepare for removal?") as null|anything in attached_organs
	if(organ_to_remove)
		return list(organ_to_remove,attached_organs[organ_to_remove])

/datum/surgery_step/robotics/detach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] starts to decouple [target]'s [(LAZYACCESS(target.surgeries_in_progress, target_zone))[1]] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/robotics/detach_organ_robotic/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] has decoupled [target]'s [(LAZYACCESS(target.surgeries_in_progress, target_zone))[1]] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	var/obj/item/organ/I = target.getorganslot((LAZYACCESS(target.surgeries_in_progress, target_zone))[2])
	if(istype(I))
		I.cut_away()
	..()

/datum/surgery_step/robotics/detach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_warning("[user]'s hand slips, disconnecting [tool]."))
	..()


//////////////////////////////////////////////////////////////////
//	robotic organ transplant finalization surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/attach_organ_robotic
	name = "Reattach prosthetic organ"
	allowed_tools = list(
		TOOL_SCREWDRIVER = 100,
	)
	min_duration = 10 SECONDS
	max_duration = 12 SECONDS
	surgery_flags = SURGERY_NO_STUMP | SURGERY_NO_FLESH | SURGERY_NEEDS_DEENCASEMENT

/datum/surgery_step/robotics/attach_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/removable_organs = list()
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	for(var/obj/item/organ/I in affected.cavity_items)
		if ((deprecise_zone(I.zone) == affected.body_zone))
			removable_organs[I.name] = REF(I)

	if(!length(removable_organs))
		to_chat(user, span_warning("You cannot find any organs to attach."))
		return

	var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
	if(organ_to_replace)
		return list(organ_to_replace, removable_organs[organ_to_replace])

/datum/surgery_step/robotics/attach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins reattaching [target]'s [(LAZYACCESS(target.surgeries_in_progress, target_zone))[1]] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/robotics/attach_organ_robotic/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/obj/item/organ/O = locate((LAZYACCESS(target.surgeries_in_progress, target_zone))[2]) in affected.cavity_items
	if(!O)
		return

	user.visible_message(span_notice("[user] has reattached [target]'s [O.name] with \the [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)

	O.organ_flags &= ~ORGAN_CUT_AWAY
	affected.remove_cavity_item(O)
	O.Insert(target)
	..()

/datum/surgery_step/robotics/attach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_warning("[user]'s hand slips, disconnecting [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()
