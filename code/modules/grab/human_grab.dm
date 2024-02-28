/mob/living/carbon/human/add_grab(obj/item/hand_item/grab/grab, use_offhand = FALSE)
	if(use_offhand)
		. = put_in_inactive_hand(grab)
	else
		. = put_in_active_hand(grab)

/mob/living/carbon/human/can_be_grabbed(mob/living/grabber, target_zone, use_offhand)
	. = ..()
	if(!.)
		return

	var/obj/item/bodypart/BP = get_bodypart(deprecise_zone(target_zone))
	if(!istype(BP))
		to_chat(grabber, span_warning("\The [src] is missing that body part!"))
		return FALSE

	if(grabber == src)
		var/using_slot = use_offhand ? get_inactive_hand() : get_active_hand()
		if(!using_slot)
			to_chat(src, span_warning("You cannot grab yourself without a usable hand!"))
			return FALSE

		if(using_slot == BP)
			to_chat(src, span_warning("You can't grab your own [BP.plaintext_zone] with itself!"))
			return FALSE
	/*
	if(pull_damage())
		to_chat(grabber, span_warning("Pulling \the [src] in their current condition would probably be a bad idea."))
	*/

	var/obj/item/clothing/C = get_item_covering_zone(target_zone)
	if(istype(C))
		C.add_fingerprint(grabber)
	else
		add_fingerprint(grabber)

