//Procedures in this file: internal organ surgery, removal, transplants
//////////////////////////////////////////////////////////////////
//						INTERNAL ORGANS							//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal
	can_infect = 1
	pain_given = 40
	delicate = 1
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT | SURGERY_BLOODY_GLOVES
	abstract_type = /datum/surgery_step/internal

//////////////////////////////////////////////////////////////////
//	Organ mending surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/fix_organ
	name = "Repair internal organ"
	desc = "Repairs damage to a patient's internal organ."
	allowed_tools = list(
		/obj/item/stack/medical/suture = 100,
		/obj/item/stack/medical/bruise_pack = 100,
		/obj/item/stack/sticky_tape = 20
	)
	min_duration = 3 SECONDS
	max_duration = 5 SECONDS

/datum/surgery_step/internal/fix_organ/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(!affected)
		return

	for(var/obj/item/organ/I in affected.contained_organs)
		if(istype(I, /obj/item/organ/brain))
			continue
		if(!(I.organ_flags & (ORGAN_SYNTHETIC)) && I.damage > 0)
			return TRUE

/datum/surgery_step/internal/fix_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/organs = list()
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	for(var/obj/item/organ/I in affected.contained_organs)
		if(istype(I, /obj/item/organ/brain))
			continue
		if(!(I.organ_flags & (ORGAN_SYNTHETIC)) && I.damage > 0)
			organs[I.name] = I.slot

	var/obj/item/organ/O
	var/organ_to_replace = -1
	while(organ_to_replace == -1)
		organ_to_replace = input(user, "Which organ do you want to repair?") as null|anything in organs
		if(!organ_to_replace)
			break
		O = organs[organ_to_replace]
		if(!O.can_recover())
			to_chat(user, span_warning("[O] is too far gone, it cannot be salvaged."))
			organ_to_replace = -1
			continue
		// You need to treat the necrotization, bro
		if(O.organ_flags & ORGAN_DEAD)
			to_chat(user, span_warning("[O] is decayed, you must replace it or perform <b>Treat Necrosis</b>."))
			continue

		return list(organ_to_replace, O)

/datum/surgery_step/internal/fix_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"

	user.visible_message(span_notice("[user] starts treating damage to [target]'s [(LAZYACCESS(target.surgeries_in_progress, target_zone))[1]] with [tool_name]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/internal/fix_organ/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"

	var/obj/item/organ/O = target.getorganslot((LAZYACCESS(target.surgeries_in_progress, target_zone))[2])
	if(!O)
		return
	if(!O.can_recover())
		to_chat(user, span_warning("[O] is too far gone, it cannot be salvaged."))
		return ..()

	O.surgically_fix(user)
	user.visible_message(span_notice("[user] finishes treating damage to [target]'s [(LAZYACCESS(target.surgeries_in_progress, target_zone))[1]] with [tool_name]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/internal/fix_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	var/dam_amt = 2

	dam_amt = 5
	target.adjustToxLoss(10, cause_of_death = "A bad surgeon")
	affected.receive_damage(dam_amt, sharpness = SHARP_EDGED|SHARP_POINTY)

	for(var/obj/item/organ/I in affected.contained_organs)
		if(I.damage > 0 && !(I.organ_flags & ORGAN_SYNTHETIC) && (affected.how_open() >= (affected.encased ? SURGERY_DEENCASED : SURGERY_RETRACTED)))
			I.applyOrganDamage(dam_amt)
	..()

//////////////////////////////////////////////////////////////////
//	 Organ detatchment surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/detach_organ
	name = "Detach organ"
	desc = "Detaches a patient's organ from their body, leaving it stranded in their chest cavity for removal."
	allowed_tools = list(
		TOOL_SCALPEL = 100,
		/obj/item/shard = 50
	)
	min_duration = 90
	max_duration = 110
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT

/datum/surgery_step/internal/detach_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/list/attached_organs = list()

	for(var/obj/item/organ/I in affected.contained_organs)
		if(I.organ_flags & ORGAN_UNREMOVABLE)
			continue
		attached_organs[I.name] = I.slot

	if(!length(attached_organs))
		to_chat(user, span_warning("There are no appropriate internal components to decouple."))
		return FALSE

	var/organ_to_remove = input(user, "Which organ do you want to prepare for removal?") as null|anything in attached_organs
	if(organ_to_remove)
		return list(organ_to_remove,attached_organs[organ_to_remove])

/datum/surgery_step/internal/detach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] starts to separate [target]'s [(LAZYACCESS(target.surgeries_in_progress, target_zone))[1]] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/internal/detach_organ/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] has separated [target]'s [(LAZYACCESS(target.surgeries_in_progress, target_zone))[1]] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)

	var/obj/item/organ/I = target.getorganslot((LAZYACCESS(target.surgeries_in_progress, target_zone))[2])
	if(istype(I))
		I.cut_away()
	..()

/datum/surgery_step/internal/detach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(affected.check_artery() & CHECKARTERY_OK)
		user.visible_message(span_warning("[user]'s hand slips, slicing an artery inside [target]'s [affected.plaintext_zone] with \the [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
		affected.set_sever_artery(TRUE)
		affected.receive_damage(rand(10,15), sharpness = SHARP_EDGED|SHARP_POINTY)
	else
		user.visible_message(span_warning("[user]'s hand slips, slicing up inside [target]'s [affected.plaintext_zone] with \the [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
		affected.receive_damage(rand(15, 25), sharpness = SHARP_EDGED|SHARP_POINTY)
	..()

//////////////////////////////////////////////////////////////////
//	 Organ removal surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/remove_organ
	name = "Remove internal organ"
	desc = "Retrieves an organ from a patient's cavity."
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		/obj/item/wirecutters = 75,
		/obj/item/knife = 75,
		/obj/item/kitchen/fork = 20
	)
	min_duration = 60
	max_duration = 80

/datum/surgery_step/internal/remove_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/removable_organs = list()
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	for(var/obj/item/organ/I in affected.cavity_items)
		if (I.organ_flags & ORGAN_CUT_AWAY)
			removable_organs[I.name] = REF(I)

	if(!length(removable_organs))
		to_chat(user, span_warning("You cannot find any organs to remove."))
		return

	var/organ_to_remove= input(user, "Which organ do you want to remove?") as null|anything in removable_organs
	if(organ_to_remove)
		return list(organ_to_remove, removable_organs[organ_to_remove])

/datum/surgery_step/internal/remove_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("\The [user] starts removing [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)[1]] with \the [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/internal/remove_organ/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/obj/item/organ/O = locate((LAZYACCESS(target.surgeries_in_progress, target_zone))[2]) in affected.cavity_items
	if(!O)
		return

	user.visible_message(span_notice("[user] has removed [target]'s [O.name] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)

	if(istype(O) && istype(affected))
		affected.remove_cavity_item(O)
		if(!user.put_in_hands(O))
			O.forceMove(target.drop_location())

	..()

/datum/surgery_step/internal/remove_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, damaging [target]'s [affected.plaintext_zone] with [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.receive_damage(20, sharpness = tool.sharpness)
	..()

//////////////////////////////////////////////////////////////////
//	 Organ inserting surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/replace_organ
	name = "Replace internal organ"
	desc = "Places an organ into the patient's cavity, where it is able to be attached to them."
	allowed_tools = list(
		/obj/item/organ = 100
	)
	min_duration = 60
	max_duration = 80
	var/robotic_surgery = FALSE

/datum/surgery_step/internal/replace_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/O = tool
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)

	if(istype(O) && istype(affected))
		var/o_is = (O.gender == PLURAL) ? "are" : "is"
		var/o_a =  (O.gender == PLURAL) ? "" : "a "
		if(O.w_class > affected.cavity_storage_max_weight)
			to_chat(user, span_warning("\The [O.name] [o_is] too big for [affected.cavity_name] cavity!"))
		else
			var/obj/item/organ/I = target.getorganslot(O.slot)
			if(I)
				to_chat(user, span_warning("\The [target] already has [o_a][O.name]."))
			else
				. = TRUE

/datum/surgery_step/internal/replace_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts [robotic_surgery ? "reinstalling" : "transplanting"] [tool] into [target]'s [affected.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/internal/replace_organ/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("\The [user] has [robotic_surgery ? "reinstalled" : "transplanted"] [tool] into [target]'s [affected.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)

	var/obj/item/organ/O = tool
	if(istype(O) && user.transferItemToLoc(O, target))
		affected.add_cavity_item(O) //move the organ into the patient. The organ is properly reattached in the next step

		if(!(O.organ_flags & ORGAN_CUT_AWAY))
			stack_trace("[user] ([user.ckey]) replaced organ [O.type], which didn't have ORGAN_CUT_AWAY set, in [target] ([target.ckey])")
			O.organ_flags |= ORGAN_CUT_AWAY
	..()

/datum/surgery_step/internal/replace_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_warning("[user]'s hand slips, damaging \the [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	var/obj/item/organ/I = tool
	if(istype(I))
		I.applyOrganDamage(rand(3,5))
	..()

//////////////////////////////////////////////////////////////////
//	 Organ attachment surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/attach_organ
	name = "Attach internal organ"
	desc = "Connects an organ to the patient's body, allowing them to utilize it."
	allowed_tools = list(
		/obj/item/fixovein = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/stack/sticky_tape = 50
	)
	min_duration = 100
	max_duration = 120
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT

/datum/surgery_step/internal/attach_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	var/list/attachable_organs = list()
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/obj/item/organ/O
	for(var/obj/item/organ/I in affected.cavity_items)
		if((I.organ_flags & ORGAN_CUT_AWAY))
			attachable_organs[I.name] = REF(I)

	if(!length(attachable_organs))
		return FALSE

	var/obj/item/organ/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in attachable_organs
	if(!organ_to_replace)
		return FALSE

	organ_to_replace = locate(attachable_organs[organ_to_replace]) in affected.cavity_items

	if((deprecise_zone(organ_to_replace.zone) != affected.body_zone))
		to_chat(user, span_warning("You can't find anywhere to attach \the [organ_to_replace] to!"))
		return FALSE

	O = locate(attachable_organs[organ_to_replace]) in affected.cavity_items
	if(O)
		to_chat(user, span_warning("\The [target] already has \a [O]."))
		return FALSE

	return list(organ_to_replace, attachable_organs[organ_to_replace.name])

/datum/surgery_step/internal/attach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_warning("[user] begins reattaching [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)[1]] with \the [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/internal/attach_organ/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/obj/item/organ/I = locate(LAZYACCESS(target.surgeries_in_progress, target_zone)[2]) in affected.cavity_items
	if(!I)
		return

	user.visible_message(span_notice("[user] has reattached [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)[1]] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)

	if(istype(I) && affected && deprecise_zone(I.zone) == affected.body_zone && (I in affected.cavity_items))
		affected.remove_cavity_item(I)
		I.Insert(target)
	..()

/datum/surgery_step/internal/attach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, damaging the flesh in [target]'s [affected.plaintext_zone] with [tool]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/internal/brain_revival
	name = "Brain revival"
	desc = "Utilizes the incredible power of Alkysine to restore the spark of life."

	min_duration = 100
	max_duration = 150

	surgery_flags = SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT | SURGERY_CANNOT_FAIL

/datum/surgery_step/internal/brain_revival/tool_potency(obj/item/tool)
	if(!tool.reagents)
		return 0

	if(!(tool.reagents.flags & (OPENCONTAINER)))
		return 0

	return 100

/datum/surgery_step/internal/brain_revival/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/BP = ..()
	if(!BP)
		return
	if(target_zone != BODY_ZONE_HEAD)
		return
	var/obj/item/organ/brain/B = locate() in BP.contained_organs
	if(!(B?.organ_flags & ORGAN_DEAD))
		return

	return TRUE

/datum/surgery_step/internal/brain_revival/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE

	var/obj/item/reagent_containers/glass/S = tool
	if(!S.reagents.has_reagent(/datum/reagent/medicine/alkysine, 5))
		to_chat(user, span_warning("\The [S] doesn't contain enough alkysine!"))
		return

	var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
	if(!locate(/obj/item/organ/brain) in head)
		to_chat(user, span_warning("\The [S] doesn't contain a brain to repair!"))
		return

	return TRUE

/datum/surgery_step/internal/brain_revival/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user] begins pouring [tool] into [target]'s [affected]..."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/internal/brain_revival/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!tool.reagents.has_reagent(/datum/reagent/medicine/alkysine, 5))
		return

	var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
	var/obj/item/organ/brain/brain = locate() in head?.contained_organs
	if(!head || !brain)
		return

	tool.reagents.remove_reagent(/datum/reagent/medicine/alkysine, 5)
	brain.setOrganDamage(0)
	..()

//////////////////////////////////////////////////////////////////
//	 Peridaxon necrosis treatment surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/treat_necrosis
	name = "Treat necrosis"
	desc = "Utilizes the restorative power of even the slightest amount of Peridaxon to restore functionality to an organ."

	surgery_flags = parent_type::surgery_flags & ~SURGERY_BLOODY_GLOVES

	can_infect = FALSE

	min_duration = 5 SECONDS
	max_duration = 6 SECONDS

/datum/surgery_step/internal/treat_necrosis/tool_potency(obj/item/tool)
	if(!tool.reagents)
		return 0

	if(!(tool.reagents.flags & OPENCONTAINER))
		return 0

	return 100

/datum/surgery_step/internal/treat_necrosis/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(!affected)
		return

	for(var/obj/item/organ/O as anything in affected.contained_organs)
		if((O.organ_flags & ORGAN_DEAD) && !(O.organ_flags & ORGAN_SYNTHETIC))
			return affected

/datum/surgery_step/internal/treat_necrosis/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	if(!tool.reagents.has_reagent(/datum/reagent/medicine/peridaxon))
		to_chat(user, span_warning("[tool] does not contain any peridaxon."))
		return FALSE

	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/list/obj/item/organ/dead_organs = list()

	for(var/obj/item/organ/I in affected.contained_organs)
		if(!(I.organ_flags & (ORGAN_CUT_AWAY|ORGAN_SYNTHETIC)) && (I.organ_flags & ORGAN_DEAD))
			dead_organs[I.name] = I

	if(!length(dead_organs))
		to_chat(user, span_warning("[target.name] does not have any dead organs."))
		return FALSE

	var/obj/item/organ/O
	var/organ_to_fix = -1
	while(organ_to_fix == -1)
		organ_to_fix = input(user, "Which organ do you want to repair?") as null|anything in dead_organs
		if(!organ_to_fix)
			break
		O = dead_organs[organ_to_fix]

		if(!O.can_recover())
			to_chat(user, span_warning("The [organ_to_fix] is necrotic and can't be saved, it will need to be replaced."))
			organ_to_fix = -1
			continue

		if(O.damage >= O.maxHealth)
			to_chat(user, span_warning("The [organ_to_fix] needs to be repaired before it is regenerated."))
			organ_to_fix = -1
			continue

	if(organ_to_fix)
		return list(organ_to_fix, dead_organs[organ_to_fix])

/datum/surgery_step/internal/treat_necrosis/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		span_notice("[user] starts applying medication to the affected tissue in [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)[1]] with \the [tool]."),
		span_notice("You start applying medication to the affected tissue in [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)[1]] with \the [tool]."),
		vision_distance = COMBAT_MESSAGE_RANGE
	)
	target.apply_pain(50, target_zone)
	..()

/datum/surgery_step/internal/treat_necrosis/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/affected = LAZYACCESS(target.surgeries_in_progress, target_zone)[2]

	var/transfer_amount
	if(is_reagent_container(tool))
		var/obj/item/reagent_containers/container = tool
		transfer_amount = container.amount_per_transfer_from_this
	else
		transfer_amount = tool.reagents.total_volume

	var/rejuvenate = tool.reagents.has_reagent(/datum/reagent/medicine/peridaxon)
	var/transered_amount = tool.reagents.trans_to(target, transfer_amount, methods = INJECT)
	if(transered_amount > 0)
		if(rejuvenate)
			affected.set_organ_dead(FALSE)

		user.visible_message(
			span_notice("[user] applies [transered_amount] unit\s of the solution to affected tissue in [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)[1]]."),
			span_notice("You apply [transered_amount] unit\s of the solution to affected tissue in [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)[1]] with \the [tool]."),
			vision_distance = COMBAT_MESSAGE_RANGE
		)
	..()

/datum/surgery_step/internal/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)

	var/transfer_amount
	if(is_reagent_container(tool))
		var/obj/item/reagent_containers/container = tool
		transfer_amount = container.amount_per_transfer_from_this
	else
		transfer_amount = tool.reagents.total_volume

	var/trans = tool.reagents.trans_to(target, transfer_amount, methods = INJECT)

	user.visible_message(
		span_warning("[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"),
		span_warning("Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"),
		vision_distance = COMBAT_MESSAGE_RANGE
	)
	..()
