/datum/surgery_step/remove_embedded_item
	name = "Remove embedded item"
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
	if(.)
		var/obj/item/bodypart/affected = .
		if(length(affected.embedded_objects))
			return TRUE

/datum/surgery_step/remove_embedded_item/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	var/obj/item/embedded = input(user, "Remove embedded item", "Surgery") as null|anything in affected.embedded_objects
	if(!embedded)
		return

	for(var/datum/component/embedded/E as anything in affected.GetComponents(/datum/component/embedded))
		if(E.weapon == embedded)
			if(!user.put_in_hands(E))
				E.forceMove(user.drop_location())
			break

	user.visible_message(
		span_notice("[user] pulls [embedded] from [target]'s [affected.plaintext_zone].")
	)
