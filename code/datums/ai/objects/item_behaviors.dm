
///This behavior is for obj/items, it is used to free themselves out of the hands of whoever is holding them
/datum/ai_behavior/item_escape_grasp

/datum/ai_behavior/item_escape_grasp/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/obj/item/item_pawn = controller.pawn
	var/mob/item_holder = item_pawn.loc
	if(!istype(item_holder))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE
	item_pawn.visible_message(span_warning("[item_pawn] slips out of the hands of [item_holder]!"))
	item_holder.dropItemToGround(item_pawn, TRUE)
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS
