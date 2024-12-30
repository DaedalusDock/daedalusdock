/datum/surgery_step/remove_embedded_item
	name = "Remove embedded item"
	desc = "Removes an object embedded at the surface of a patient's flesh."
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTER = 50,
		TOOL_CROWBAR = 30,
		/obj/item/kitchen/fork = 20
	)
	min_duration = 0
	max_duration = 0

/datum/surgery_step/remove_embedded_item/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(!.)
		return
	var/obj/item/bodypart/affected = .
	if(!length(affected.embedded_objects))
		return FALSE

/datum/surgery_step/remove_embedded_item/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/obj/item/embedded = input(user, "Remove embedded item", "Surgery") as null|anything in affected.embedded_objects
	if(!embedded)
		return

	if(!user.put_in_hands(embedded))
		embedded.forceMove(user.drop_location())

	user.visible_message(
		span_notice("[user] pulls [embedded] from [target]'s [affected.plaintext_zone]."),
		vision_distance = COMBAT_MESSAGE_RANGE
	)
	..()
