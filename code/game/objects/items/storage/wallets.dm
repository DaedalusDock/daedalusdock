/obj/item/storage/wallet
	name = "wallet"
	desc = "An old leather wallet with RFID blocking potential."
	icon_state = "wallet"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_ID

	/// Is the wallet open?
	var/is_open = FALSE
	/// The ID that is visible and functional if the wallet is open.
	var/obj/item/card/id/front_id = null

	var/cached_flat_icon

/obj/item/storage/wallet/Initialize()
	. = ..()
	atom_storage.animated = FALSE
	atom_storage.rustle_sound = null
	atom_storage.open_sound = null
	atom_storage.close_sound = null
	atom_storage.max_slots = 4
	atom_storage.max_specific_storage = WEIGHT_CLASS_TINY
	atom_storage.max_total_storage = WEIGHT_CLASS_TINY * 4

	RegisterSignal(atom_storage, COMSIG_STORAGE_CAN_INSERT, PROC_REF(can_insert_item))
	RegisterSignal(atom_storage, COMSIG_STORAGE_ATTEMPT_OPEN, PROC_REF(on_attempt_open_storage))
	register_context()
	update_appearance()

/obj/item/storage/wallet/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_RMB] = is_open ? "Close" : "Open"
	context[SCREENTIP_CONTEXT_ALT_LMB] = is_open ? "Close" : "Open"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/storage/wallet/Exited(atom/movable/gone, direction)
	. = ..()
	if(istype(gone, /obj/item/card/id))
		refreshID()

/obj/item/storage/wallet/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(istype(arrived, /obj/item/card/id))
		refreshID()

/obj/item/storage/wallet/update_overlays()
	. = ..()
	cached_flat_icon = null
	if(!is_open)
		return

	. += image(icon, "wallet_underlay")
	if(front_id)
		. += image(front_id.icon, front_id.icon_state)
		. += front_id.overlays
	. += image(icon, "wallet_overlay")

/obj/item/storage/wallet/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	if(is_open)
		close()
	else
		open()

/obj/item/storage/wallet/attack_hand_secondary(mob/user, list/modifiers)
	if(is_open)
		close()
	else
		open()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/wallet/AltClick(mob/user)
	. = ..()
	if(!.)
		return

	if(is_open)
		close()
	else
		open()

/obj/item/storage/wallet/get_id_examine_strings(mob/user)
	. = ..()
	if(front_id && is_open)
		. += front_id.get_id_examine_strings(user)

/obj/item/storage/wallet/GetID(bypass_wallet)
	if(is_open || bypass_wallet)
		return front_id

/obj/item/storage/wallet/RemoveID()
	if(!front_id)
		return
	. = front_id
	front_id.forceMove(get_turf(src))

/obj/item/storage/wallet/InsertID(obj/item/inserting_item, force)
	var/obj/item/card/inserting_id = inserting_item.RemoveID()
	if(!inserting_id)
		return FALSE
	return atom_storage.attempt_insert(inserting_item, force = force)

/obj/item/storage/wallet/GetAccess()
	if(is_open && front_id)
		return front_id.GetAccess()
	else
		return ..()

/obj/item/storage/wallet/get_examine_string(mob/user, thats = FALSE)
	if(front_id && is_open)
		var/that_string = gender == PLURAL ? "Those are " : "That is "
		return "[icon2html(get_cached_flat_icon(), user)] [thats? that_string : ""][get_examine_name(user)]" //displays all overlays in chat
	return ..()

/obj/item/storage/wallet/proc/open()
	SIGNAL_HANDLER
	if(is_open)
		return

	is_open = TRUE
	update_appearance()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.sec_hud_set_ID()

/obj/item/storage/wallet/proc/close()
	if(!is_open)
		return

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.sec_hud_set_ID()

	is_open = FALSE
	atom_storage.close_all()
	update_appearance()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.sec_hud_set_ID()

/obj/item/storage/wallet/proc/get_cached_flat_icon()
	if(!cached_flat_icon)
		cached_flat_icon = getFlatIcon(src)
	return cached_flat_icon

/obj/item/storage/wallet/update_name()
	. = ..()
	if(front_id && is_open)
		name = "wallet displaying \a [front_id.name]"
	else
		name = "wallet"

/obj/item/storage/wallet/proc/on_attempt_open_storage(datum/storage/source, mob/user)
	SIGNAL_HANDLER
	if(!is_open)
		return STORAGE_INTERRUPT_OPEN

/obj/item/storage/wallet/proc/can_insert_item(datum/storage/source, obj/item/I, mob/user, messages, force)
	SIGNAL_HANDLER
	if(!is_open && user)
		return STORAGE_NO_INSERT

/obj/item/storage/wallet/proc/id_icon_updated(datum/source)
	SIGNAL_HANDLER
	update_appearance()

/**
 * Calculates the new front ID.
 *
 * Picks the ID card that has the most combined command or higher tier accesses.
 */
/obj/item/storage/wallet/proc/refreshID()
	if(front_id)
		UnregisterSignal(front_id, COMSIG_ATOM_UPDATED_ICON)

	front_id = null
	for(var/obj/item/card/id/id_card in contents)
		// Certain IDs can forcibly jump to the front so they can disguise other cards in wallets. Chameleon/Agent ID cards are an example of this.
		if(HAS_TRAIT(id_card, TRAIT_MAGNETIC_ID_CARD))
			front_id = id_card
			break

	if(!front_id)
		front_id = locate(/obj/item/card/id) in contents

	if(front_id)
		RegisterSignal(front_id, COMSIG_ATOM_UPDATED_ICON, PROC_REF(id_icon_updated))

	if(ishuman(loc))
		var/mob/living/carbon/human/wearing_human = loc
		if(wearing_human.wear_id == src)
			wearing_human.sec_hud_set_ID()

	update_appearance()
	update_slot_icon()

/obj/item/storage/wallet/random
	icon_state = "random_wallet" // for mapping purposes

/obj/item/storage/wallet/random/Initialize(mapload)
	. = ..()
	icon_state = "wallet"

/obj/item/storage/wallet/random/PopulateContents()
	SSeconomy.spawn_ones_for_amount(rand(5, 30), src)
	new /obj/effect/spawner/random/entertainment/wallet_storage(src)

/obj/item/storage/wallet/open
	is_open = TRUE
