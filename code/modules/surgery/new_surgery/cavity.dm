//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	 generic implant surgery step datum
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity
	shock_level = 40
	delicate = 1
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT
	abstract_type = /datum/surgery_step/cavity

/datum/surgery_step/cavity/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_warning("[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"), \
	span_warning("Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"))
	affected.receive_damage(20, sharpness = SHARP_EDGED|SHARP_POINTY)

//////////////////////////////////////////////////////////////////
//	 create implant space surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/make_space
	name = "Hollow out cavity"
	allowed_tools = list(
		TOOL_DRILL = 100,
		/obj/item/pen = 75,
		/obj/item/stack/rods = 50,
	)
	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/make_space/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.cavity_name && !affected.cavity)
		return affected

/datum/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts making some space inside [target]'s [affected.cavity_name] cavity with [tool]."))

	affected.cavity = TRUE
	..()

/datum/surgery_step/cavity/make_space/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] makes some space inside [target]'s [affected.cavity_name] cavity with [tool]."))

//////////////////////////////////////////////////////////////////
//	 implant cavity sealing surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/close_space
	name = "Close cavity"
	allowed_tools = list(
		TOOL_CAUTERY = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		TOOL_WELDER = 25
	)
	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/close_space/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.cavity)
		return affected

/datum/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts mending [target]'s [affected.cavity_name] cavity wall with [tool]."))

	..()

/datum/surgery_step/cavity/close_space/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] mends [target]'s [affected.cavity_name] cavity walls with [tool]."))
	affected.cavity = FALSE

//////////////////////////////////////////////////////////////////
//	 implanting surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/place_item
	name = "Place item in cavity"
	allowed_tools = list(/obj/item = 100)
	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/place_item/can_operate(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(istype(user,/mob/living/silicon/robot))
		return FALSE
	. = ..()

/datum/surgery_step/cavity/place_item/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && affected.cavity)
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
	user.visible_message("[user] starts putting [tool] inside [target]'s [affected.cavity_name] cavity.")

	playsound(target.loc, 'sound/effects/squelch1.ogg', 25, 1)
	..()

/datum/surgery_step/cavity/place_item/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(!user.temporarilyRemoveItemFromInventory(tool, affected))
		return
	user.visible_message(span_notice("[user] puts \the [tool] inside [target]'s [affected.cavity_name] cavity."))

	if (tool.w_class == affected.atom_storage.max_specific_storage && prob(50) && IS_ORGANIC_LIMB(affected) && affected.sever_artery())
		to_chat(user, span_warning("You tear some blood vessels trying to fit such a big object in this cavity."))


	user.transferItemToLoc(tool, affected)
	affected.add_cavity_item(tool)

//////////////////////////////////////////////////////////////////
//	 implant removal surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/cavity/implant_removal
	name = "Remove foreign body"
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTER = 75,
		/obj/item/kitchen/fork = 20
	)
	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/implant_removal/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	return affected && length(affected.cavity_items)

/datum/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message("[user] starts poking around inside [target]'s [affected.plaintext_zone] with [tool].")
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
			user.visible_message(span_notice("[user] takes something out of incision on [target]'s [affected.plaintext_zone] with [tool]."))
			if(!user.put_in_hands(obj))
				obj.forceMove(get_turf(target))

			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)

		else
			user.visible_message(
				span_notice("[user] removes [tool] from [target]'s [affected.plaintext_zone]."),
				span_notice("There's something inside [target]'s [affected.plaintext_zone], but you just missed it this time.")
			)

	else
		user.visible_message(
			span_notice("[user] could not find anything inside [target]'s [affected.name], and pulls [tool] out."),
			span_notice("You could not find anything inside [target]'s [affected.name].")
		)

/datum/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	for(var/obj/item/implant/imp in affected.cavity_items)
		var/fail_prob = 10
		fail_prob += 100 - tool_potency(tool)
		if (prob(fail_prob))
			user.visible_message(span_warning("Something beeps inside [target]'s [affected.name]!"))
			playsound(imp.loc, 'sound/items/countdown.ogg', 75, 1, -3)
			spawn(25)
				imp.activate()
