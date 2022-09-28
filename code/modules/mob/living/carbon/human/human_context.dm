/mob/living/carbon/human/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if (!ishuman(user))
		return .

	if (user == src)
		return .

	if (grabbedby?.owner == user)
		switch (grabbedby.current_state)
			if (GRAB_LEVEL_PULL)
				context[SCREENTIP_CONTEXT_CTRL_LMB] = "Grip"
			if (GRAB_LEVEL_AGGRESSIVE)
				context[SCREENTIP_CONTEXT_CTRL_LMB] = "Strangle"
			else
				return .
	else
		context[SCREENTIP_CONTEXT_CTRL_LMB] = "Pull"

	return CONTEXTUAL_SCREENTIP_SET
