/obj/item/mcobject/messaging/hand_scanner
	name = "hand scanner component"
	base_icon_state = "comp_hscan"
	icon_state = "comp_hscan"

/obj/item/mcobject/messaging/hand_scanner/Initialize(mapload)
	. = ..()
	configs -= MC_CFG_OUTPUT_MESSAGE

/obj/item/mcobject/messaging/hand_scanner/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(!anchored)
		return
	if(!ishuman(user))
		to_chat(user, span_warning("The hand scanner may only be used by humanoids."))
		return

	var/mob/living/carbon/human/H = user
	add_fingerprint(H)
	//playsoundhere
	z_flick("comp_hscan1", src)
	fire(H.get_fingerprints(hand = H.get_active_hand()))
	log_message("scanned [key_name(user)]", LOG_MECHCOMP)
	return TRUE

/obj/item/mcobject/messaging/hand_scanner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/atom/target = interacting_with // Yes i am supremely lazy

	if(!isclosedturf(target))
		return NONE

	if(!user.dropItemToGround(src, silent = TRUE))
		return NONE

	forceMove(target)
	return ITEM_INTERACT_SUCCESS
