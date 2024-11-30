//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	 generic implant surgery step datum
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity
	pain_given =40
	delicate = 1
	surgery_flags = SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT
	abstract_type = /datum/surgery_step/cavity

/datum/surgery_step/cavity/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(
		span_warning("[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"),
		span_warning("Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"),
		vision_distance = COMBAT_MESSAGE_RANGE
	)
	affected.receive_damage(20, sharpness = SHARP_EDGED|SHARP_POINTY)
	..()

//////////////////////////////////////////////////////////////////
//	 create implant space surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/make_space
	name = "Hollow out cavity"
	desc = "Grants access to an internal cavity. Often used to gain access to a patient's internal organs."
	allowed_tools = list(
		TOOL_DRILL = 100,
		/obj/item/pen = 75,
		/obj/item/stack/rods = 50,
	)
	min_duration = 3 SECONDS
	max_duration = 4 SECONDS

/datum/surgery_step/cavity/make_space/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.cavity_name && !affected.cavity)
		return affected

/datum/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts making some space inside [target]'s [affected.cavity_name] cavity with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/cavity/make_space/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] makes some space inside [target]'s [affected.cavity_name] cavity with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.cavity = TRUE
	..()

//////////////////////////////////////////////////////////////////
//	 implant cavity sealing surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/close_space
	name = "Close cavity"
	desc = "Seals a patient's internal cavity, preventing access."
	allowed_tools = list(
		TOOL_CAUTERY = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		TOOL_WELDER = 25
	)
	min_duration = 3 SECONDS
	max_duration = 4 SECONDS

	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/cavity/close_space/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.cavity)
		return affected

/datum/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts mending [target]'s [affected.cavity_name] cavity wall with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)

	..()

/datum/surgery_step/cavity/close_space/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] mends [target]'s [affected.cavity_name] cavity walls with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	affected.cavity = FALSE
	..()

//////////////////////////////////////////////////////////////////
//	 implanting surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/place_item
	name = "Place item in cavity"
	desc = "Inserts an object into a patient's cavity."
	allowed_tools = list(/obj/item = 100)
	min_duration = 4 SECONDS
	max_duration = 6 SECONDS

	preop_sound = 'sound/surgery/organ1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/cavity/place_item/can_operate(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(istype(user,/mob/living/silicon/robot))
		return FALSE
	. = ..()

/datum/surgery_step/cavity/place_item/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.cavity && !isorgan(tool))
		return affected

/datum/surgery_step/cavity/place_item/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(affected && affected.cavity)
		var/max_volume = 7 * (affected.cavity_storage_max_weight -1)
		if(tool.w_class > affected.cavity_storage_max_weight)
			to_chat(user, span_warning("\The [tool] is too big for [affected.cavity_name] cavity."))
			return FALSE

		var/total_volume = (tool.w_class - 1) ** 2

		for(var/obj/item/I in affected.cavity_items)
			if(istype(I,/obj/item/implant))
				continue
			total_volume += (tool.w_class - 1) ** 2

		if(total_volume > max_volume)
			to_chat(user, span_warning("There isn't enough space left in [affected.cavity_name] cavity for [tool]."))
			return FALSE
		return TRUE

/datum/surgery_step/cavity/place_item/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts putting [tool] inside [target]'s [affected.cavity_name] cavity."), vision_distance = COMBAT_MESSAGE_RANGE)

	playsound(target.loc, 'sound/effects/squelch1.ogg', 25, 1)
	..()

/datum/surgery_step/cavity/place_item/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(!user.transferItemToLoc(tool, affected))
		return
	affected.add_cavity_item(tool)

	user.visible_message(span_notice("[user] puts \the [tool] inside [target]'s [affected.cavity_name] cavity."), vision_distance = COMBAT_MESSAGE_RANGE)

	if (tool.w_class == affected.cavity_storage_max_weight && prob(50) && IS_ORGANIC_LIMB(affected) && affected.set_sever_artery(TRUE))
		to_chat(user, span_warning("You tear some blood vessels trying to fit such a big object in this cavity."))
		target.bleed(15)
	..()

//////////////////////////////////////////////////////////////////
//	 implant removal surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/implant_removal
	name = "Remove foreign body"
	desc = "Removes an object from the patient's cavity."
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTER = 75,
		/obj/item/kitchen/fork = 20
	)
	min_duration = 4 SECONDS
	max_duration = 6 SECONDS

	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/cavity/implant_removal/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(!affected)
		return FALSE
	for(var/obj/item/I in affected.cavity_items)
		if(!isorgan(I))
			return affected

/datum/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts poking around inside [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/cavity/implant_removal/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/exposed = 0
	if(affected.how_open() >= (affected.encased ? SURGERY_DEENCASED : SURGERY_RETRACTED))
		exposed = 1

	if(!IS_ORGANIC_LIMB(affected) && affected.how_open() == SURGERY_DEENCASED)
		exposed = 1

	var/find_prob = 0
	var/list/loot = list()

	if(exposed)
		loot = affected.cavity_items
	else
		for(var/datum/wound/wound in affected.wounds)
			if(LAZYLEN(wound.embedded_objects))
				loot |= wound.embedded_objects
			find_prob += 50

		for(var/datum/component/embedded/E as anything in affected.GetComponents(/datum/component/embedded))
			if(E.harmful)
				continue // handled by the above loop
			find_prob += 10
			loot |= E.weapon

	if (length(loot))

		var/obj/item/obj = pick(loot)

		if(istype(obj,/obj/item/implant))
			find_prob +=40
		else
			find_prob +=50

		if (prob(find_prob))
			user.visible_message(span_notice("[user] takes something out of incision on [target]'s [affected.plaintext_zone] with [tool]."), vision_distance = COMBAT_MESSAGE_RANGE)
			if(istype(obj, /obj/item/implant))
				var/obj/item/implant/I = obj
				I.removed(target)

			if(!user.put_in_hands(obj))
				obj.forceMove(get_turf(target))

			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)

		else
			user.visible_message(
				span_notice("[user] removes [tool] from [target]'s [affected.plaintext_zone]."),
				span_notice("There's something inside [target]'s [affected.plaintext_zone], but you just missed it this time."),
				vision_distance = COMBAT_MESSAGE_RANGE
			)

	else
		user.visible_message(
			span_notice("[user] could not find anything inside [target]'s [affected.name], and pulls [tool] out."),
			span_notice("You could not find anything inside [target]'s [affected.name]."),
			vision_distance = COMBAT_MESSAGE_RANGE
		)
	..()

/datum/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	for(var/obj/item/implant/imp in affected.cavity_items)
		var/fail_prob = 10
		fail_prob += 100 - tool_potency(tool)
		if (prob(fail_prob))
			user.visible_message(span_warning("Something beeps inside [target]'s [affected.name]!"), vision_distance = COMBAT_MESSAGE_RANGE)
			playsound(imp.loc, 'sound/items/countdown.ogg', 75, 1, -3)
			spawn(25)
				imp.activate()
