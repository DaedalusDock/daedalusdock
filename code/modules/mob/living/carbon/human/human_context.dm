/mob/living/carbon/human/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if (!ishuman(user))
		return .

	if (user == src)
		return .

	context[SCREENTIP_CONTEXT_CTRL_LMB] = "Grab"

	var/obj/item/hand_item/grab/G = user.is_grabbing(src)
	if (G)
		G.current_grab.add_context(context, held_item, user, src)

	return CONTEXTUAL_SCREENTIP_SET
