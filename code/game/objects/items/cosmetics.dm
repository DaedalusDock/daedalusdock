/obj/item/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "lipstick"
	w_class = WEIGHT_CLASS_TINY
	var/colour = "red"
	var/open = FALSE
	/// A trait that's applied while someone has this lipstick applied, and is removed when the lipstick is removed
	var/lipstick_trait

/obj/item/lipstick/purple
	name = "purple lipstick"
	colour = "purple"

/obj/item/lipstick/jade
	//It's still called Jade, but theres no HTML color for jade, so we use lime.
	name = "jade lipstick"
	colour = "lime"

/obj/item/lipstick/black
	name = "black lipstick"
	colour = "black"

/obj/item/lipstick/black/death
	name = "\improper Kiss of Death"
	desc = "An incredibly potent tube of lipstick made from the venom of the dreaded Yellow Spotted Space Lizard, as deadly as it is chic. Try not to smear it!"
	lipstick_trait = TRAIT_KISS_OF_DEATH

/obj/item/lipstick/random
	name = "lipstick"
	icon_state = "random_lipstick"

/obj/item/lipstick/random/Initialize(mapload)
	. = ..()
	icon_state = "lipstick"
	colour = pick("red","purple","lime","black","green","blue","white")
	name = "[colour] lipstick"

/obj/item/lipstick/attack_self(mob/user)
	cut_overlays()
	to_chat(user, span_notice("You twist \the [src] [open ? "closed" : "open"]."))
	open = !open
	if(open)
		var/mutable_appearance/colored_overlay = mutable_appearance(icon, "lipstick_uncap_color")
		colored_overlay.color = colour
		icon_state = "lipstick_uncap"
		add_overlay(colored_overlay)
	else
		icon_state = "lipstick"

/obj/item/lipstick/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!open || !ismob(interacting_with) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH)
		return NONE

	var/mob/living/carbon/human/target = interacting_with
	if(!ishuman(target) || !target.has_mouth())
		to_chat(user, span_warning("Where are the lips on that?"))
		return ITEM_INTERACT_BLOCKING

	if(target.is_mouth_covered())
		to_chat(user, span_warning("Remove [ target == user ? "your" : "[target.p_their()]" ] mask first."))
		return ITEM_INTERACT_BLOCKING

	if(target.lip_style) //if they already have lipstick on
		to_chat(user, span_warning("You need to wipe off the old lipstick first."))
		return ITEM_INTERACT_BLOCKING

	if(target == user)
		user.visible_message(
			span_notice("[user] does [user.p_their()] lips with \the [src]."),
			span_notice("You take a moment to apply \the [src]. Perfect!")
		)
		target.update_lips("lipstick", colour, lipstick_trait)
		return ITEM_INTERACT_SUCCESS

	user.visible_message(
		span_warning("[user] begins to do [target]'s lips with \the [src]."),
		span_notice("You begin to apply \the [src] on [target]'s lips...")

)
	if(!do_after(user, target, 2 SECONDS, DO_PUBLIC))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(
		span_notice("[user] does [target]'s lips with \the [src]."),
		span_notice("You apply \the [src] on [target]'s lips.")
	)
	target.update_lips("lipstick", colour, lipstick_trait)
	return ITEM_INTERACT_SUCCESS

//you can wipe off lipstick with paper!
/obj/item/paper/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.zone_selected != BODY_ZONE_PRECISE_MOUTH || !ishuman(interacting_with))
		return NONE

	var/mob/living/carbon/human/target = interacting_with
	if(target.lip_color == null)
		return NONE

	if(target == user)
		to_chat(user, span_notice("You wipe off the lipstick with [src]."))
		target.update_lips(null)
		return ITEM_INTERACT_SUCCESS

	user.visible_message(
		span_warning("[user] begins to wipe [target]'s lipstick off with \the [src]."),
		span_notice("You begin to wipe off [target]'s lipstick...")
	)

	if(!do_after(user, target, 1 SECONDS, DO_PUBLIC))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(
		span_notice("[user] wipes [target]'s lipstick off with \the [src]."),
		span_notice("You wipe off [target]'s lipstick.")
	)
	target.update_lips(null)
	return ITEM_INTERACT_SUCCESS


/obj/item/razor
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "razor"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_TINY

/obj/item/razor/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/razor/add_item_context(obj/item/source, list/context, atom/target, mob/living/user)
	. = ..()
	if(!isliving(target))
		return

	if(user.zone_selected == BODY_ZONE_HEAD)
		context[SCREENTIP_CONTEXT_LMB] = "Restyle hair"
		context[SCREENTIP_CONTEXT_RMB] = "Shave hair"
	else if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		context[SCREENTIP_CONTEXT_LMB] = "Restyle facial hair"
		context[SCREENTIP_CONTEXT_RMB] = "Shave face"
	else
		return

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/razor/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins shaving [user.p_them()]self without the razor guard! It looks like [user.p_theyre()] trying to commit suicide!"))
	shave(user, BODY_ZONE_PRECISE_MOUTH)
	shave(user, BODY_ZONE_HEAD)//doesnt need to be BODY_ZONE_HEAD specifically, but whatever
	return BRUTELOSS

/obj/item/razor/proc/shave(mob/living/carbon/human/H, location = BODY_ZONE_PRECISE_MOUTH)
	if(location == BODY_ZONE_PRECISE_MOUTH)
		H.facial_hairstyle = "Shaved"
	else
		H.hairstyle = "Skinhead"

	H.update_body_parts()
	playsound(loc, 'sound/items/welder2.ogg', 20, TRUE)


/obj/item/razor/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with))
		return NONE

	var/mob/living/carbon/human/H = interacting_with
	var/location = user.zone_selected
	if(!(location in list(BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_HEAD)))
		return NONE

	if(!H.get_bodypart(BODY_ZONE_HEAD))
		to_chat(user, span_warning("[H] does not have a head."))
		return ITEM_INTERACT_BLOCKING

	switch(location)
		if(BODY_ZONE_PRECISE_MOUTH)
			if(H.gender != MALE)
				return ITEM_INTERACT_BLOCKING

			if (H == user)
				to_chat(user, span_warning("What kind of maniac would shave without a mirror?"))
				return ITEM_INTERACT_BLOCKING

			var/new_style = tgui_input_list(user, "Select a facial hairstyle", "Grooming", GLOB.facial_hairstyles_list)
			if(isnull(new_style) || !user.canUseTopic(USE_CLOSE | USE_IGNORE_TK))
				return ITEM_INTERACT_BLOCKING

			if(!get_location_accessible(H, location))
				to_chat(user, span_warning("Something is blocking [H.p_their()] face."))
				return ITEM_INTERACT_BLOCKING

			user.visible_message(span_notice("[user] tries to change [H]'s facial hairstyle using [src]."), span_notice("You try to change [H]'s facial hairstyle using [src]."))
			if(new_style && do_after(user, H, 6 SECONDS, DO_PUBLIC, display = src))
				user.visible_message(span_notice("[user] successfully changes [H]'s facial hairstyle using [src]."), span_notice("You successfully change [H]'s facial hairstyle using [src]."))
				H.facial_hairstyle = new_style
				H.update_body_parts()
				return ITEM_INTERACT_SUCCESS

		if(BODY_ZONE_HEAD)
			if(!user.combat_mode)
				if (H == user)
					to_chat(user, span_warning("What kind of maniac would cut their hair without a mirror?"))
					return ITEM_INTERACT_BLOCKING

				var/new_style = tgui_input_list(user, "Select a hairstyle", "Grooming", GLOB.hairstyles_list)
				if(isnull(new_style) || !user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
					return ITEM_INTERACT_BLOCKING

				if(!get_location_accessible(H, location))
					to_chat(user, span_warning("Something is blocking [H.p_their()] head."))
					return ITEM_INTERACT_BLOCKING

				if(HAS_TRAIT(H, TRAIT_BALD))
					to_chat(H, span_warning("[H] is just way too bald. Like, really really bald."))
					return ITEM_INTERACT_BLOCKING

				user.visible_message(span_notice("[user] tries to change [H]'s hairstyle using [src]."), span_notice("You try to change [H]'s hairstyle using [src]."))
				if(new_style && do_after(user, H, 6 SECONDS, DO_PUBLIC, display = src))
					user.visible_message(span_notice("[user] successfully changes [H]'s hairstyle using [src]."), span_notice("You successfully change [H]'s hairstyle using [src]."))
					H.hairstyle = new_style
					H.update_body_parts()
					return ITEM_INTERACT_SUCCESS
				return ITEM_INTERACT_BLOCKING

/obj/item/razor/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with))
		return NONE

	var/mob/living/carbon/human/H = interacting_with
	var/location = user.zone_selected
	if(!(location in list(BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_HEAD)))
		return NONE

	if(!H.get_bodypart(BODY_ZONE_HEAD))
		to_chat(user, span_warning("[H] does not have a head."))
		return ITEM_INTERACT_BLOCKING

	switch(location)
		if(BODY_ZONE_PRECISE_MOUTH)
			if(!(FACEHAIR in H.dna.species.species_traits))
				to_chat(user, span_warning("[H.p_they(TRUE)] have no facial hair to shave."))
				return ITEM_INTERACT_BLOCKING

			if(!get_location_accessible(H, location))
				to_chat(user, span_warning("Something is blocking [H.p_their()] face."))
				return ITEM_INTERACT_BLOCKING

			if(H.facial_hairstyle == "Shaved")
				return ITEM_INTERACT_BLOCKING

			if(H == user) //shaving yourself
				user.visible_message(
					span_notice("[user] starts to shave [user.p_their()] facial hair with [src]."),
					span_notice("You take a moment to shave your facial hair with [src]...")
				)

				if(do_after(user, H, 5 SECONDS, DO_PUBLIC, display = src))
					user.visible_message(
						span_notice("[user] shaves [user.p_their()] facial hair clean with [src]."),
						span_notice("You finish shaving with [src]. Fast and clean!")
					)
					shave(H, location)
					return ITEM_INTERACT_SUCCESS
				return ITEM_INTERACT_BLOCKING
			else
				user.visible_message(
					span_warning("[user] tries to shave [H]'s facial hair with [src]."),
					span_notice("You start shaving [H]'s facial hair...")
				)
				if(do_after(user, H, 5 SECONDS, DO_PUBLIC, display = src))
					user.visible_message(span_warning("[user] shaves off [H]'s facial hair with [src]."), \
						span_notice("You shave [H]'s facial hair clean off."))
					shave(H, location)
					return ITEM_INTERACT_SUCCESS
				return ITEM_INTERACT_BLOCKING

		if(BODY_ZONE_HEAD)
			if(!H.has_hair(TRUE))
				to_chat(user, span_warning("[H.p_they()] have no hair to shave."))
				return ITEM_INTERACT_BLOCKING
			if(!get_location_accessible(H, location))
				to_chat(user, span_warning("Something is blocking [H.p_their()] head."))
				return ITEM_INTERACT_BLOCKING

			if(H == user) //shaving yourself
				user.visible_message(
					span_notice("[user] starts to shave [user.p_their()] head with [src]."),
					span_notice("You start to shave your head with [src]...")
				)
				if(do_after(user, H, 5 SECONDS, DO_PUBLIC, display = src))
					user.visible_message(
						span_notice("[user] shaves [user.p_their()] head with [src]."),
						span_notice("You finish shaving with [src].")
					)
					shave(H, location)
					return ITEM_INTERACT_SUCCESS
				return ITEM_INTERACT_BLOCKING
			else
				user.visible_message(
					span_warning("[user] tries to shave [H]'s head with [src]!"), \
					span_notice("You start shaving [H]'s head...")
				)
				if(do_after(user, H, 5 SECONDS, DO_PUBLIC, display = src))
					user.visible_message(span_warning("[user] shaves [H]'s head bald with [src]!"), \
						span_notice("You shave [H]'s head bald."))
					shave(H, location)
					return ITEM_INTERACT_SUCCESS
				return ITEM_INTERACT_BLOCKING

		else
			return NONE
