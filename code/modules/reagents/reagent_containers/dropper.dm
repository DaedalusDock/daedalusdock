/obj/item/reagent_containers/dropper
	name = "dropper"
	desc = "A dropper. Holds up to 5 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dropper0"
	worn_icon_state = "pen"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1, 2, 3, 4, 5)
	volume = 5
	reagent_flags = TRANSPARENT
	custom_price = PAYCHECK_MEDIUM

/obj/item/reagent_containers/dropper/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!interacting_with.reagents)
		return NONE

	return interact_with_reagent_container(interacting_with, user, modifiers)

/obj/item/reagent_containers/dropper/proc/interact_with_reagent_container(atom/interacting_with, mob/living/user, list/modifiers)
	if(reagents.total_volume > 0)
		if(interacting_with.reagents.total_volume >= interacting_with.reagents.maximum_volume)
			to_chat(user, span_notice("[interacting_with] is full."))
			return ITEM_INTERACT_BLOCKING

		if(!interacting_with.is_injectable(user))
			to_chat(user, span_warning("You cannot transfer reagents to [interacting_with]."))
			return ITEM_INTERACT_BLOCKING

		var/trans = 0

		if(ismob(interacting_with))
			if(ishuman(interacting_with))
				var/mob/living/carbon/human/victim = interacting_with

				var/obj/item/safe_thing = victim.is_eyes_covered()

				if(safe_thing)
					if(!safe_thing.reagents)
						safe_thing.create_reagents(100)

					trans = reagents.trans_to(safe_thing, amount_per_transfer_from_this, transfered_by = user, methods = TOUCH)

					interacting_with.visible_message(span_danger("[user] tries to squirt something into [interacting_with]'s eyes, but fails!"), \
											span_userdanger("[user] tries to squirt something into your eyes, but fails!"))

					to_chat(user, span_notice("You transfer [trans] unit\s of the solution."))
					update_appearance()
					return ITEM_INTERACT_SUCCESS

			else if(isalien(interacting_with)) //hiss-hiss has no eyes!
				to_chat(interacting_with, span_danger("[interacting_with] does not seem to have any eyes."))
				return ITEM_INTERACT_BLOCKING

			interacting_with.visible_message(span_danger("[user] squirts something into [interacting_with]'s eyes!"), \
									span_userdanger("[user] squirts something into your eyes!"))

			var/mob/M = interacting_with
			var/R
			if(reagents)
				for(var/datum/reagent/A in src.reagents.reagent_list)
					R += "[A] ([num2text(A.volume)]),"

			log_combat(user, M, "squirted", R)

		trans = src.reagents.trans_to(interacting_with, amount_per_transfer_from_this, transfered_by = user, methods = TOUCH)
		to_chat(user, span_notice("You transfer [trans] unit\s of the solution."))
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	else

		if(!interacting_with.is_drawable(user, FALSE)) //No drawing from mobs here
			to_chat(user, span_warning("You cannot directly remove reagents from [interacting_with]."))
			return ITEM_INTERACT_BLOCKING

		if(!interacting_with.reagents.total_volume)
			to_chat(user, span_warning("[interacting_with] is empty."))
			return ITEM_INTERACT_BLOCKING

		var/trans = interacting_with.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)

		to_chat(user, span_notice("You fill [src] with [trans] unit\s of the solution."))

		update_appearance()
		return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/dropper/update_overlays()
	. = ..()
	if(!reagents.total_volume)
		return
	var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "dropper")
	filling.color = mix_color_from_reagents(reagents.reagent_list)
	. += filling
