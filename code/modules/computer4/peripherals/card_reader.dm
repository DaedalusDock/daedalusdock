/obj/item/peripheral/card_reader
	name = "card reader"
	desc = "A peripheral board for scanning ID cards."
	peripheral_type = PERIPHERAL_TYPE_CARD_READER

	var/obj/item/card/id/inserted_card

/obj/item/peripheral/card_reader/on_attach(obj/machinery/computer4/computer)
	. = ..()
	RegisterSignal(computer, COMSIG_PARENT_ATTACKBY, PROC_REF(on_computer_attackby))

/obj/item/peripheral/card_reader/on_detach(obj/machinery/computer4/computer)
	. = ..()
	UnregisterSignal(computer, COMSIG_PARENT_ATTACKBY)

/// Handles behavior for inserting the card
/obj/item/peripheral/card_reader/proc/on_computer_attackby(datum/source, obj/item/I, mob/living/user)
	SIGNAL_HANDLER

	if(!isidcard(I))
		return

	if(try_insert_card(user, I))
		playsound(loc, 'sound/machines/cardreader_insert.ogg', 50)
		user.visible_message(span_notice("[user] inserts [I] into [loc]."))
	return COMPONENT_NO_AFTERATTACK

/obj/item/peripheral/card_reader/proc/try_insert_card(mob/user, obj/item/card/id/new_card)
	if(user)
		if(!user.transferItemToLoc(new_card, src))
			return FALSE
	else
		new_card.forceMove(src)

	inserted_card = new_card
	return TRUE

/obj/item/peripheral/card_reader/proc/try_eject_card(mob/user)
	if(!inserted_card)
		return FALSE

	if(!user?.put_in_hands(inserted_card))
		inserted_card.forceMove(drop_location())

	inserted_card = null
	return TRUE

/obj/item/peripheral/card_reader/proc/scan_card()
	if(!inserted_card)
		return "nocard"

	var/list/data = list(
		"name" = inserted_card.registered_name,
		"job" = inserted_card.assignment,
		"access" = access2text(inserted_card.GetAccess())
	)
	var/datum/signal/packet = new(src, data, TRANSMISSION_WIRE)
	deferred_peripheral_input(PERIPHERAL_CMD_SCAN_CARD, packet, 0.4 SECONDS)
	return packet
