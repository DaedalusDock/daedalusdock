/obj/item/computer_hardware/card_slot
	name = "primary RFID card module" // \improper breaks the find_hardware_by_name proc
	desc = "A module allowing this computer to read or write data on ID cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	icon_state = "card_mini"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_CARD

	var/obj/item/card/id/stored_card
	var/current_identification = null
	var/current_job = null

/obj/item/computer_hardware/card_slot/Destroy()
	if(stored_card) //If you didn't expect this behavior for some dumb reason, do something different instead of directly destroying the slot
		QDEL_NULL(stored_card)
	return ..()

///What happens when the ID card is removed (or deleted) from the module, through try_eject() or not.
/obj/item/computer_hardware/card_slot/Exited(atom/movable/gone, direction)
	if(stored_card == gone)
		stored_card = null
		if(holder)
			holder.notify_id_removed(device_type)

			holder.update_slot_icon()

			if(ishuman(holder.loc))
				var/mob/living/carbon/human/human_wearer = holder.loc
				if(human_wearer.wear_id == holder)
					human_wearer.sec_hud_set_ID()
	return ..()

/obj/item/computer_hardware/card_slot/GetAccess()
	var/list/total_access = list()
	if(stored_card)
		total_access = stored_card.GetAccess()

	var/obj/item/computer_hardware/card_slot/card_slot2 = holder?.all_components[MC_CARD2] //Best of both worlds
	if(card_slot2?.stored_card)
		total_access |= card_slot2.stored_card.GetAccess()
	return total_access

/obj/item/computer_hardware/card_slot/GetID(bypass_wallet)
	if(stored_card)
		return stored_card
	return ..()

/obj/item/computer_hardware/card_slot/RemoveID()
	if(stored_card)
		. = stored_card
		if(!try_eject())
			return null
		return

/obj/item/computer_hardware/card_slot/try_insert(obj/item/I, mob/living/user = null)
	if(!holder)
		return FALSE

	if(!istype(I, /obj/item/card/id))
		return FALSE

	if(stored_card)
		return FALSE

	// item instead of player is checked so telekinesis will still work if the item itself is close
	if(!in_range(src, I))
		return FALSE

	if(user)
		if(!user.transferItemToLoc(I, src))
			return FALSE
	else
		I.forceMove(src)

	stored_card = I
	to_chat(user, span_notice("You insert \the [I] into \the [expansion_hw ? "secondary":"primary"] [src]."))
	playsound(src, 'sound/machines/cardreader_insert.ogg', 50, FALSE)
	holder.update_appearance()

	current_identification = stored_card.registered_name
	current_job = stored_card.assignment

	var/holder_loc = holder.loc
	if(ishuman(holder_loc))
		var/mob/living/carbon/human/human_wearer = holder_loc
		if(human_wearer.wear_id == holder)
			human_wearer.sec_hud_set_ID()
	holder.update_slot_icon()

	holder.notify_id_inserted(device_type)
	return TRUE

/obj/item/computer_hardware/card_slot/try_eject(mob/living/user = null, forced = FALSE)
	if(!stored_card)
		to_chat(user, span_warning("There are no cards in \the [src]."))
		return FALSE

	if(user && !issilicon(user) && in_range(src, user))
		user.put_in_hands(stored_card)
	else
		stored_card.forceMove(drop_location())

	to_chat(user, span_notice("You remove the card from \the [src]."))
	playsound(src, 'sound/machines/cardreader_desert.ogg', 50, FALSE)
	holder?.update_appearance()

	stored_card = null
	current_identification = null
	current_job = null

	//holder.notify_id_removed(device_type) This is here as a reference, this is actually done in Exitted()
	return TRUE

/obj/item/computer_hardware/card_slot/screwdriver_act(mob/living/user, obj/item/tool)
	if(stored_card)
		to_chat(user, span_notice("You press down on the manual eject button with [tool]."))
		try_eject(user)
		return ITEM_INTERACT_SUCCESS
	swap_slot()
	to_chat(user, span_notice("You adjust the connecter to fit into [expansion_hw ? "an expansion bay" : "the primary ID bay"]."))
	return ITEM_INTERACT_SUCCESS

/**
 *Swaps the card_slot hardware between using the dedicated card slot bay on a computer, and using an expansion bay.
*/
/obj/item/computer_hardware/card_slot/proc/swap_slot()
	expansion_hw = !expansion_hw
	if(expansion_hw)
		device_type = MC_CARD2
		name = "secondary RFID card module"
	else
		device_type = MC_CARD
		name = "primary RFID card module"

/obj/item/computer_hardware/card_slot/examine(mob/user)
	. = ..()
	. += "The connector is set to fit into [expansion_hw ? "an expansion bay" : "a computer's primary ID bay"], but can be adjusted with a screwdriver."
	if(stored_card)
		. += "There appears to be something loaded in the card slots."

/obj/item/computer_hardware/card_slot/secondary
	name = "secondary RFID card module"
	device_type = MC_CARD2
	expansion_hw = TRUE
