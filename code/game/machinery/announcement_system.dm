GLOBAL_LIST_EMPTY(announcement_systems)

/obj/machinery/announcement_system
	density = TRUE
	name = "\improper Automated Announcement System"
	desc = "An automated announcement system that handles minor announcements over the radio."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "AAS_On"
	base_icon_state = "AAS"

	verb_say = "coldly states"
	verb_ask = "queries"
	verb_exclaim = "alarms"

	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.05

	circuit = /obj/item/circuitboard/machine/announcement_system

	network_flags = NETWORK_FLAG_GEN_ID // Generate an ID so we can send PDA messages with a valid source.

	var/datum/radio_frequency/common_freq

	var/obj/item/radio/headset/radio
	var/arrival = "%PERSON, %RANK has boarded the station."
	var/arrivalToggle = 1
	var/newhead = "%PERSON, %RANK, is the department head."
	var/newheadToggle = 1

	var/greenlight = "Light_Green"
	var/pinklight = "Light_Pink"
	var/errorlight = "Error_Red"

/obj/machinery/announcement_system/Initialize(mapload)
	. = ..()
	GLOB.announcement_systems |= src
	// Voice Radio makes me cry.
	radio = new /obj/item/radio/headset/silicon/ai(src)
	// We don't need to be *present* on the frequency, just be able to send packets on it.
	common_freq = SSpackets.return_frequency(FREQ_COMMON)
	update_appearance()

/obj/machinery/announcement_system/update_icon_state()
	icon_state = "[base_icon_state]_[is_operational ? "On" : "Off"][panel_open ? "_Open" : null]"
	return ..()

/obj/machinery/announcement_system/update_overlays()
	. = ..()
	if(arrivalToggle)
		. += greenlight

	if(newheadToggle)
		. += pinklight

	if(machine_stat & BROKEN)
		. += errorlight

/obj/machinery/announcement_system/Destroy()
	QDEL_NULL(radio)
	GLOB.announcement_systems -= src //"OH GOD WHY ARE THERE 100,000 LISTED ANNOUNCEMENT SYSTEMS?!!"
	return ..()

/obj/machinery/announcement_system/on_set_is_operational(old_value)
	if(is_operational)
		GLOB.announcement_systems |= src
	else
		GLOB.announcement_systems -= src

/obj/machinery/announcement_system/screwdriver_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	panel_open = !panel_open
	to_chat(user, span_notice("You [panel_open ? "open" : "close"] the maintenance hatch of [src]."))
	update_appearance()
	return TRUE

/obj/machinery/announcement_system/crowbar_act(mob/living/user, obj/item/tool)
	if(default_deconstruction_crowbar(tool))
		return TRUE

/obj/machinery/announcement_system/multitool_act(mob/living/user, obj/item/tool)
	if(!panel_open || !(machine_stat & BROKEN))
		return FALSE
	to_chat(user, span_notice("You reset [src]'s firmware."))
	set_machine_stat(machine_stat & ~BROKEN)
	update_appearance()

/obj/machinery/announcement_system/proc/CompileText(str, user, rank) //replaces user-given variables with actual thingies.
	str = replacetext(str, "%PERSON", "[user]")
	str = replacetext(str, "%RANK", "[rank]")
	return str

/obj/machinery/announcement_system/proc/announce(message_type, user, rank, list/channels)
	if(!is_operational)
		return

	var/message

	if(message_type == "ARRIVAL" && arrivalToggle)
		message = CompileText(arrival, user, rank)
	else if(message_type == "NEWHEAD" && newheadToggle)
		message = CompileText(newhead, user, rank)
	else if(message_type == "ARRIVALS_BROKEN")
		message = "The arrivals shuttle has been damaged. Docking for repairs..."
	//PARIAH EDIT
	else if(message_type == "CRYOSTORAGE")
		message = "[user][rank ? ", [rank]" : ""] has been moved to cryo storage."
	//PARIAH EDIT END
	broadcast(message, channels)

/// Sends a message to the appropriate channels.
/obj/machinery/announcement_system/proc/broadcast(message, list/channels)
	use_power(active_power_usage)
	if(!length(channels))
		radio.talk_into(src, message, null)
	else
		for(var/channel in channels)
			radio.talk_into(src, message, channel)
	return TRUE

/obj/machinery/announcement_system/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AutomatedAnnouncement")
		ui.open()

/obj/machinery/announcement_system/ui_data()
	var/list/data = list()
	data["arrival"] = arrival
	data["arrivalToggle"] = arrivalToggle
	data["newhead"] = newhead
	data["newheadToggle"] = newheadToggle
	return data

/obj/machinery/announcement_system/ui_act(action, param)
	. = ..()
	if(.)
		return
	if(!usr.canUseTopic(src, USE_CLOSE|USE_SILICON_REACH))
		return
	if(machine_stat & BROKEN)
		visible_message(span_warning("[src] buzzes."), span_hear("You hear a faint buzz."))
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, TRUE)
		return
	switch(action)
		if("ArrivalText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.canUseTopic(src, USE_CLOSE|USE_SILICON_REACH))
				return
			if(NewMessage)
				arrival = NewMessage
				log_game("The arrivals announcement was updated: [NewMessage] by:[key_name(usr)]")
		if("NewheadText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.canUseTopic(src, USE_CLOSE|USE_SILICON_REACH))
				return
			if(NewMessage)
				newhead = NewMessage
				log_game("The head announcement was updated: [NewMessage] by:[key_name(usr)]")
		if("NewheadToggle")
			newheadToggle = !newheadToggle
			update_appearance()
		if("ArrivalToggle")
			arrivalToggle = !arrivalToggle
			update_appearance()
	add_fingerprint(usr)

/obj/machinery/announcement_system/attack_robot(mob/living/silicon/user)
	. = attack_ai(user)

/obj/machinery/announcement_system/attack_ai(mob/user)
	if(!user.canUseTopic(src, USE_CLOSE|USE_SILICON_REACH))
		return
	if(machine_stat & BROKEN)
		to_chat(user, span_warning("[src]'s firmware appears to be malfunctioning!"))
		return
	interact(user)

/obj/machinery/announcement_system/proc/act_up() //does funny breakage stuff
	if(!atom_break()) // if badmins flag this unbreakable or its already broken
		return

	arrival = pick("#!@%ERR-34%2 CANNOT LOCAT@# JO# F*LE!", "CRITICAL ERROR 99.", "ERR)#: DA#AB@#E NOT F(*ND!")
	newhead = pick("OV#RL()D: \[UNKNOWN??\] DET*#CT)D!", "ER)#R - B*@ TEXT F*O(ND!", "AAS.exe is not responding. NanoOS is searching for a solution to the problem.")

/obj/machinery/announcement_system/emp_act(severity)
	. = ..()
	if(!(machine_stat & (NOPOWER|BROKEN)) && !(. & EMP_PROTECT_SELF))
		act_up()

/obj/machinery/announcement_system/emag_act()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	act_up()

/obj/machinery/announcement_system/proc/announce_secoff_latejoin(
	mob/officer,
	department,
	distribution)

	if (!is_operational)
		return

	broadcast("Officer [officer.real_name] has been assigned to [department].", list(RADIO_CHANNEL_SECURITY))

	var/list/targets = list()

	var/list/partners = list()
	for (var/officer_ref in distribution)
		var/mob/partner = locate(officer_ref)
		if (!istype(partner) || distribution[officer_ref] != department)
			continue
		partners += partner.real_name

	if (partners.len)
		for (var/obj/item/modular_computer/pda as anything in GLOB.TabletMessengers)
			if (pda.saved_identification in partners)
				var/obj/item/computer_hardware/network_card/packetnet/rfcard = pda.all_components[MC_NET]
				if(!istype(rfcard))
					break //No RF card to send to.
				targets += rfcard.hardware_id

	if (!targets.len)
		return

	for(var/next_addr in targets)
		var/datum/signal/outgoing = create_signal(next_addr, list(
			PACKET_CMD = NETCMD_PDAMESSAGE,
			"name" = "Automated Announcement System",
			"job" = "Security Department Update",
			"message" = "Officer [officer.real_name] has been assigned to your department, [department].",
			"automated" = TRUE,
		))
		outgoing.transmission_method = TRANSMISSION_RADIO
		common_freq.post_signal(outgoing, RADIO_PDAMESSAGE)

/obj/machinery/announcement_system/proc/notify_citation(cited_name, cite_message, fine_amount)
	if (!is_operational)
		return

	for (var/obj/item/modular_computer/tablet in GLOB.TabletMessengers)
		if(tablet.saved_identification == cited_name)
			var/obj/item/computer_hardware/network_card/packetnet/rfcard = tablet.all_components[MC_NET]
			if(!istype(rfcard))
				break //No RF card to send to.
			var/message = "You have been fined [fine_amount] marks for '[cite_message]'. Fines may be paid at security."
			var/datum/signal/outgoing = create_signal(rfcard.hardware_id, list(
				PACKET_CMD = NETCMD_PDAMESSAGE,
				"name" = "Automated Announcement System",
				"job" = "Security Citation",
				"message" = message,
				"automated" = TRUE,
			))
			outgoing.transmission_method = TRANSMISSION_RADIO
			common_freq.post_signal(outgoing, RADIO_PDAMESSAGE)

/// A helper proc for sending an announcement to PDAs. Takes a list of hardware IDs as targets
/obj/machinery/announcement_system/proc/mass_pda_message(list/recipients, message, reason)
	for(var/next_addr in recipients)
		var/datum/signal/outgoing = create_signal(next_addr, list(
			PACKET_CMD = NETCMD_PDAMESSAGE,
			"name" = "Automated Announcement System",
			"job" = reason,
			"message" = message,
			"automated" = TRUE,
		))
		outgoing.transmission_method = TRANSMISSION_RADIO
		common_freq.post_signal(outgoing, RADIO_PDAMESSAGE)
	return TRUE

/// A helper proc for sending an announcement to a single PDA.
/obj/machinery/announcement_system/proc/pda_message(recipient, message, reason)
	var/datum/signal/outgoing = create_signal(recipient, list(
		PACKET_CMD = NETCMD_PDAMESSAGE,
		"name" = "Automated Announcement System",
		"job" = reason,
		"message" = message,
		"automated" = TRUE,
	))
	outgoing.transmission_method = TRANSMISSION_RADIO
	common_freq.post_signal(outgoing, RADIO_PDAMESSAGE)
	return TRUE

/// Get an announcement system and call pda_message()
/proc/aas_pda_message(recipient, message, reason)
	var/obj/machinery/announcement_system/AAS = pick(GLOB.announcement_systems)
	if(!AAS)
		return FALSE

	return AAS.pda_message(arglist(args))

/// Get an announcement system and call mass_pda_message()
/proc/aas_mass_pda_message(recipients, message, reason)
	var/obj/machinery/announcement_system/AAS = pick(GLOB.announcement_systems)
	if(!AAS)
		return FALSE

	return AAS.mass_pda_message(arglist(args))

/// Send an ASS pda message to a given name
/proc/aas_pda_message_name(name, record_type, message, reason)
	var/datum/data/record/R = SSdatacore.get_record_by_name(name, record_type)
	if(!R || !R.fields[DATACORE_PDA_ID])
		return FALSE

	return aas_pda_message(R.fields[DATACORE_PDA_ID], message)

/// Send an ASS pda message to an entire department
/proc/aas_pda_message_department(department, message, reason)
	. = list()
	for(var/datum/data/record/R as anything in SSdatacore.get_records(department))
		var/id = R.fields[DATACORE_PDA_ID]
		if(id)
			. += id

	return aas_mass_pda_message(., message, reason)

/proc/aas_radio_message(message, list/channels)
	var/obj/machinery/announcement_system/AAS = pick(GLOB.announcement_systems)
	if(!AAS)
		return FALSE

	return AAS.broadcast(message, channels)
