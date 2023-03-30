#define VIRUS_MODE_ABORT -1
#define VIRUS_MODE_NO_INPUT 0
#define VIRUS_MODE_RAW_SIGNAL 1
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
	var/datum/signal/outgoing = new(src, list("command" = magic_packet))
	var/signal_data = outgoing.data
	switch(user_input_tuple[1])
		if(VIRUS_MODE_ABORT)
			return
		if(VIRUS_MODE_NO_INPUT)
			//Add some fluffy bogus data.
			var/signal_data = outgoing.data
			var/itermax = rand(2,5)
			for(var/iter = 0, iter<itermax, iter++)
				signal_data[random_string(5, GLOB.hex_characters)] = random_string(16, GLOB.hex_characters)

		if(VIRUS_MODE_RAW_SIGNAL)
			outgoing = user_input_tuple[2]
		if(VIRUS_MODE_EXTRA_STAPLE)
			outgoing.data.Add(user_input_tuple[2])
	pnetcard.post_signal(outgoing)
	to_chat(user, span_notice("Virus sent."))
	return

/// Your chance to get input from the user/set custom data for your virus.
/// Return value is a list of 1/2 values:
/// list(VIRUS_MODE_ABORT) - Abort the send attempt
///
/// list(VIRUS_MODE_NO_INPUT) - No input taken,
///
/// list(VIRUS_MODE_RAW_SIGNAL, ref/datum/signal) - Signal packet will be sent as is.
///
/// list(VIRUS_MODE_EXTRA_STAPLE, list(signal_data)) - List will be appended to the standard values
/obj/item/computer_hardware/hard_drive/role/virus/proc/user_input(target_addr, mob/living/user)
	return list(VIRUS_MODE_ABORT)

/obj/item/computer_hardware/hard_drive/role/virus/clown
	name = "\improper H.O.N.K. disk"

/obj/item/computer_hardware/hard_drive/role/virus/clown/user_input(target_addr, mob/living/user)
	magic_packet = SSpackets.clownvirus_magic_packet
	return list(VIRUS_MODE_NO_INPUT)

/obj/item/computer_hardware/hard_drive/role/virus/mime
	name = "\improper sound of silence disk"

/obj/item/computer_hardware/hard_drive/role/virus/mime/user_input(target_addr, mob/living/user)
	magic_packet = SSpackets.mimevirus_magic_packet
	return list(VIRUS_MODE_NO_INPUT)



/obj/item/computer_hardware/hard_drive/role/virus/deto
	name = "\improper D.E.T.O.M.A.T.I.X. disk"
	charges = 6

/obj/item/computer_hardware/hard_drive/role/virus/deto/user_input(target_addr, mob/living/user)
	magic_packet = SSpackets.detomatix_magic_packet
	return list(VIRUS_MODE_NO_INPUT)

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
	outgoing.has_magic_data = MAGIC_DATA_MUST_OBFUSCATE //touch this and you lose your spine, legs, AND eyes. Three for one.
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
#undef VIRUS_MODE_NO_INPUT
#undef VIRUS_MODE_RAW_SIGNAL
#undef VIRUS_MODE_EXTRA_STAPLE
