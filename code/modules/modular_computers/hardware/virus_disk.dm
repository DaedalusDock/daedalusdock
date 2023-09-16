
/// Completely give up sending the virus. Returns immediately.
#define VIRUS_MODE_ABORT -1
/// 'Generic' mode. Assumes no more than the magic packet is required, and simply adds some bogus registers to cover up the real fields.
#define VIRUS_MODE_GENERIC 0
/// Throw out the old signal and provide an entirely unique one. Use this if you need to mark a packet inviolable.
#define VIRUS_MODE_RAW_SIGNAL 1
/// Add a list of extra fields to the packet.
#define VIRUS_MODE_EXTRA_STAPLE 2

/obj/item/computer_hardware/hard_drive/role/virus
	name = "\improper generic virus disk"
	icon_state = "virusdisk"
	var/magic_packet = "HONK!" //Set this in user_input()
	var/charges = 5

// Due to the GPRSification of PDAs, theses now share quite a lot of code.
// All viruses work in roughly the same way, sending a magic packet with a bogus command
// Some viruses may have additional data as a payload.
/obj/item/computer_hardware/hard_drive/role/virus/proc/send_virus(target_addr, mob/living/user)
	if(!target_addr)
		return
	if(charges <= 0)
		to_chat(user, span_notice("ERROR: Out of charges."))
		return
	var/obj/item/computer_hardware/network_card/packetnet/pnetcard = holder.all_components[MC_NET]
	if(!istype(pnetcard))//Very unlikely, but this path isn't too hot to make me worry.
		to_chat(user, span_warning("ERROR: NON-GPRS NETWORK CARD."))
		return
	var/list/user_input_tuple = user_input(target_addr, user)
	var/datum/signal/outgoing = new(src, list(
		SSpackets.pda_exploitable_register = magic_packet,
		PACKET_DESTINATION_ADDRESS = target_addr
		))
	var/signal_data = outgoing.data
	switch(user_input_tuple[1])
		if(VIRUS_MODE_ABORT)
			return
		if(VIRUS_MODE_GENERIC)
			//Add some fluffy bogus data.
			var/itermax = rand(1,3)
			for(var/iter = 0, iter<itermax, iter++)
				var/reg_name = pick_list(PACKET_STRING_FILE, "packet_field_names")
				if(reg_name == SSpackets.pda_exploitable_register)
					continue //Just skip one.
				signal_data[reg_name] = random_string(rand(16,32), GLOB.hex_characters)

		if(VIRUS_MODE_RAW_SIGNAL)
			outgoing = user_input_tuple[2]
		if(VIRUS_MODE_EXTRA_STAPLE)
			outgoing.data.Add(user_input_tuple[2])
	//We need to scromble the fields to make it not perfectly obvious which one is which
	shuffle_inplace(outgoing.data)
	pnetcard.post_signal(outgoing)
	to_chat(user, span_notice("Virus sent."))
	return

/*
 * Your chance to get input from the user/set custom data for your virus.
 * Return value is a list of 1/2 values:
 * list(VIRUS_MODE_ABORT) - Abort the send attempt
 *
 * list(VIRUS_MODE_GENERIC) - Sets the value of the SSpackets.exploitable_pda_register field on the packet to it's magic_packet.
 * This mode also adds some bogus garbage to the packet to disguise exactly which field is the vulnerable one.
 *
 * list(VIRUS_MODE_RAW_SIGNAL, ref/datum/signal) - Signal packet will be sent as is, If you need to mark a packet inviolable, use this one.
 *
 * list(VIRUS_MODE_EXTRA_STAPLE, list(signal_data)) - List will be appended to the standard values
 */
/obj/item/computer_hardware/hard_drive/role/virus/proc/user_input(target_addr, mob/living/user)
	return list(VIRUS_MODE_ABORT)

/obj/item/computer_hardware/hard_drive/role/virus/clown
	name = "\improper H.O.N.K. disk"

/obj/item/computer_hardware/hard_drive/role/virus/clown/user_input(target_addr, mob/living/user)
	magic_packet = SSpackets.clownvirus_magic_packet
	return list(VIRUS_MODE_GENERIC)

/obj/item/computer_hardware/hard_drive/role/virus/mime
	name = "\improper sound of silence disk"

/obj/item/computer_hardware/hard_drive/role/virus/mime/user_input(target_addr, mob/living/user)
	magic_packet = SSpackets.mimevirus_magic_packet
	return list(VIRUS_MODE_GENERIC)



/obj/item/computer_hardware/hard_drive/role/virus/deto
	name = "\improper D.E.T.O.M.A.T.I.X. disk"
	charges = 6

/obj/item/computer_hardware/hard_drive/role/virus/deto/user_input(target_addr, mob/living/user)
	if(!holder) //What?
		stack_trace("Attempted to send a detomatix virus without a holder computer?? | loc.type:[loc.type]")
		return list(VIRUS_MODE_ABORT)
	magic_packet = SSpackets.detomatix_magic_packet
	//Shamelessly stolen from msg_input
	var/text_message = null


	text_message = tgui_input_text(user, "Enter a message", "NT Messaging")

	if(!user.canUseTopic(holder, USE_CLOSE))
		return

	text_message = sanitize(text_message)
	if(!text_message)
		return list(VIRUS_MODE_ABORT)
	var/sender_name = sanitize(tgui_input_text(user, "Enter the sending name", "NT Messaging"))
	if(!sender_name)
		return list(VIRUS_MODE_ABORT)
	var/sender_job = sanitize(tgui_input_text(user, "Enter the sending job", "NT Messaging"))
	if(!sender_name)
		return list(VIRUS_MODE_ABORT)

	if(!user.canUseTopic(holder, USE_CLOSE))
		return list(VIRUS_MODE_ABORT)

	var/list/pda_data_staple = list(
		// We already have the target address
		// GPRS Card handles the source address
		PACKET_CMD = NETCMD_PDAMESSAGE,
		"name" = sender_name,
		"job" = sender_job,
		"message" = text_message
	)
	//Add some fluffy bogus data.
	var/itermax = rand(1,3)
	for(var/iter = 0, iter<itermax, iter++)
		var/reg_name = pick_list(PACKET_STRING_FILE, "packet_field_names")
		if(reg_name == SSpackets.pda_exploitable_register)
			continue //Just skip one.
		pda_data_staple[reg_name] = random_string(rand(16,32), GLOB.hex_characters)
	return list(VIRUS_MODE_EXTRA_STAPLE, pda_data_staple)

/obj/item/computer_hardware/hard_drive/role/virus/frame
	name = "\improper F.R.A.M.E. disk"

	var/telecrystals = 0
	var/current_progression = 0

/obj/item/computer_hardware/hard_drive/role/virus/frame/user_input(target_addr, mob/living/user)
	var/lock_code = "[rand(100,999)] [pick(GLOB.phonetic_alphabet)]"
	var/datum/signal/outgoing = new(
		src,
		list(
			"command" = SSpackets.framevirus_magic_packet,
			"telecrystals" = telecrystals,
			"current_progression" = current_progression,
			"lock_code" = lock_code,
			"fallback_mind" = user.mind // yeah?
		)
	)
	to_chat(user, "Sending... Attempting to install uplink with Code: [span_robot(lock_code)]")
	telecrystals = 0 // Burn the crystals regardless.
	outgoing.has_magic_data = MAGIC_DATA_INVIOLABLE //touch this and you lose your spine, legs, AND eyes. Three for one.
	return list(VIRUS_MODE_RAW_SIGNAL, outgoing)

/obj/item/computer_hardware/hard_drive/role/virus/frame/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/stack/telecrystal))
		if(!charges)
			to_chat(user, span_notice("[src] is out of charges, it's refusing to accept [I]."))
			return
		var/obj/item/stack/telecrystal/telecrystalStack = I
		telecrystals += telecrystalStack.amount
		to_chat(user, span_notice("You slot [telecrystalStack] into [src]. The next time it's used, it will also give [telecrystals] telecrystal\s."))
		telecrystalStack.use(telecrystalStack.amount)

#undef VIRUS_MODE_ABORT
#undef VIRUS_MODE_GENERIC
#undef VIRUS_MODE_RAW_SIGNAL
#undef VIRUS_MODE_EXTRA_STAPLE
