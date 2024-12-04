/obj/item/stack/splint
	name = "medical splints"
	singular_name = "splint"
	stack_name = "pair"
	icon_state = "splint"
	novariants = TRUE
	w_class = WEIGHT_CLASS_SMALL
	full_w_class = WEIGHT_CLASS_NORMAL
	item_flags = NOBLUDGEON
	merge_type = /obj/item/stack/splint
	amount = 1
	max_amount = 2

	splint_slowdown = 1

/obj/item/stack/splint/two
	amount = 2

/obj/item/stack/proc/try_splint(mob/living/carbon/human/H, mob/living/user)
	if(!istype(H))
		return

	var/zone = deprecise_zone(user.zone_selected)
	var/obj/item/bodypart/BP = H.get_bodypart(zone)
	if(!BP)
		to_chat(user, span_warning("[H] does not have a limb there."))
		return

	if(!(BP.body_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)))
		to_chat(user, span_warning("You cannot use [src] to apply a splint there."))
		return

	if(BP.splint)
		to_chat(user, span_warning("There is already a splint there."))
		return

	if(H != user)
		user.visible_message(span_notice("[user] starts to apply [src] to [H]'s [BP.plaintext_zone]."), blind_message = span_hear("You hear something being wrapped."))
	else
		switch(user.get_active_hand())
			if(BODY_ZONE_PRECISE_R_HAND)
				if(zone == BODY_ZONE_R_ARM)
					to_chat(user, span_warning("You cannot apply a splint to the arm you are using!"))
					return
			if(BODY_ZONE_PRECISE_L_HAND)
				if(zone == BODY_ZONE_L_ARM)
					to_chat(user, span_warning("You cannot apply a splint to the arm you are using!"))
					return

		user.visible_message(span_notice("[user] starts to apply [src] to [user.p_their()] [BP.plaintext_zone]."), blind_message = span_hear("You hear something being wrapped."))

	if(!do_after(user, H, 5 SECONDS, DO_PUBLIC, interaction_key = "splint", display = src))
		return

	if(H == user && prob(25))
		user.visible_message(span_warning("[user] fumbles [src]."))
		return

	var/obj/item/stack/splint = split_stack(null, 1, null)
	if(!BP.apply_splint(splint))
		splint.merge(src)
		to_chat(user, span_warning("You fail to apply [src]."))
		return

	if(H != user)
		user.visible_message(span_notice("[user] finishes applying [src] to [H]'s [BP.plaintext_zone]."))
	else
		user.visible_message(span_notice("[user] finishes applying [src] to [user.p_their()] [BP.plaintext_zone]."))

	return TRUE

