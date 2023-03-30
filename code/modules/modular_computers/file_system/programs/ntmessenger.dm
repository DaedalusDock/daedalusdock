/datum/computer_file/program/messenger
	filename = "nt_messenger"
	filedesc = "Messenger"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "command"
	program_state = PROGRAM_STATE_BACKGROUND
	extended_desc = "This program allows old-school communication with other modular devices."
	size = 8
	usage_flags = PROGRAM_TABLET
	ui_header = "ntnrc_idle.gif"
	available_on_ntnet = TRUE
	tgui_id = "NtosMessenger"
	program_icon = "comment-alt"
	alert_able = TRUE

	/// The current ringtone (displayed in the chat when a message is received).
	var/ringtone = "beep"
	/// Whether or not the ringtone is currently on.
	var/ringer_status = TRUE
	/// Whether or not we're sending and receiving messages.
	var/sending_and_receiving = TRUE
	/// The messages currently saved in the app.
	var/messages = list()
	/// great wisdom from PDA.dm - "no spamming" (prevents people from spamming the same message over and over)
	var/last_text
	/// even more wisdom from PDA.dm - "no everyone spamming" (prevents people from spamming the same message over and over)
	var/last_text_everyone
	/// Whether or not we allow emojis to be sent by the user.
	var/allow_emojis = FALSE
	/// Whether or not we're currently looking at the message list.
	var/viewing_messages = FALSE
	// Whether or not we're sorting by job.
	var/sort_by_job = TRUE
	// Whether or not we're sending (or trying to send) a virus.
	var/sending_virus = FALSE


	/// Whether or not this app is loaded on a silicon's tablet.
	var/is_silicon = FALSE
	/// Whether or not we're in a mime PDA.
	var/mime_mode = FALSE

	var/obj/item/computer_hardware/network_card/packetnet/netcard_cache

/datum/computer_file/program/messenger/ui_state(mob/user)
	if(istype(user, /mob/living/silicon))
		return GLOB.reverse_contained_state
	return GLOB.default_state

/datum/computer_file/program/messenger/can_run(mob/user, loud, access_to_check, transfer, list/access)
	. = ..()
	if(!.) //Already declined for other reason.
		return .
	var/obj/item/computer_hardware/network_card/packetnet/pnetcard = computer.all_components[MC_NET]
	if(!istype(pnetcard))
		if(loud)
			to_chat(user, span_danger("\The [computer] flashes a \"GPRS Error - Incompatible Network card\" warning."))
		return FALSE

/datum/computer_file/program/messenger/event_hardware_changed(background)
	. = ..()
	if(netcard_cache != computer.all_components[MC_NET])
		if(background)
			computer.visible_message(span_danger("\The [computer]'s screen displays a \"Process [filename].[filetype] (PID [rand(100,999)]) terminated - GPRS hardware error\" error"))
		else
			computer.visible_message(span_danger("\The [computer]'s screen briefly freezes and then shows \"NETWORK ERROR - GPRS hardware error. Verify hardware presence or contact a certified technician.\" error."))
		kill_program(TRUE)

/datum/computer_file/program/messenger/run_program(mob/living/user)
	. = ..()
	if(!.)
		return
	//If we got here, it's safe to assume this, probably.
	netcard_cache = computer.all_components[MC_NET]

/datum/computer_file/program/messenger/process_tick(delta_time)
	. = ..()
	while(netcard_cache.check_queue())
		process_signal(netcard_cache.pop_signal())
	sending_and_receiving = netcard_cache.radio_state

/datum/computer_file/program/messenger/kill_program(forced)
	. = ..()
	netcard_cache = null

/datum/computer_file/program/messenger/proc/process_signal(datum/signal/signal)
	if(!signal)
		CRASH("Messenger program attempted to process null signal??")
	var/list/signal_data = signal.data
	if(!signal_data)
		return
	var/signal_command = signal_data["command"]
	//Network ID verification is "hardware accelerated" (AKA: Done for us by the card)

	var/rigged = FALSE//are we going to explode?
	// "Exploiting a bug" my ass this shit is going to suck to write.
	// ESPECIALLY THIS FUCKER RIGHT HERE vvvv
	if(signal_command == SSpackets.detomatix_magic_packet)
		//This one falls through to standard PDA behaviour, so we need to be checked first.
		signal_command = NETCMD_PDAMESSAGE //Lie about it.
		if(signal_data["s_addr"] == netcard_cache.hardware_id)//No broadcast bombings, fuck off.
			//Calculate our "difficulty"
			var/difficulty
			var/obj/item/computer_hardware/hard_drive/role/our_jobdisk = computer.all_components[MC_HDD_JOB]
			if(our_jobdisk)
				difficulty += bit_count(our_jobdisk & (DISK_MED | DISK_SEC | DISK_POWER | DISK_MANIFEST))
				if(our_jobdisk.disk_flags & DISK_MANIFEST)
					difficulty++ //if cartridge has manifest access it has extra snowflake difficulty
			if(!(SEND_SIGNAL(computer, COMSIG_TABLET_CHECK_DETONATE) & COMPONENT_TABLET_NO_DETONATE || prob(difficulty * 15)))
				rigged = TRUE //Cool, we're allowed to blow up. Really glad this whole check wasn't for nothing.
				var/trait_timer_key = signal_data["s_addr"]
				ADD_TRAIT(computer, TRAIT_PDA_CAN_EXPLODE, trait_timer_key)
				ADD_TRAIT(computer, TRAIT_PDA_MESSAGE_MENU_RIGGED, trait_timer_key)
				addtimer(TRAIT_CALLBACK_REMOVE(computer, TRAIT_PDA_MESSAGE_MENU_RIGGED, trait_timer_key), 10 SECONDS)
			//Intentional fallthrough.

	if(signal_command == NETCMD_PDAMESSAGE)
		var/list/message_data = list(
			"name" = signal_data["name"] || "#UNK",
			"job" = signal_data["job"] || "#UNK",
			"contents" = html_decode("\"[signal_data["message"]]\"") || "#ERROR_MISSING_FIELD",
			"outgoing" = FALSE,
			"automated" = signal_data["automated"] || FALSE,
			"target_addr" = signal_data["s_addr"] || null
		)
		if(computer.hardware_flag == PROGRAM_TABLET) //We need to render the extraneous bullshit to chat.
			show_in_chat(signal_data, rigged)
		if(ringer_status)
			computer.ring(ringtone)
		messages += message_data
		return

	if(signal_command == SSpackets.clownvirus_magic_packet)
		computer.honkamnt = rand(15, 25)
		return
	if(signal_command == SSpackets.mimevirus_magic_packet)
		ringer_status = FALSE
		ringtone = ""
		return
	if(signal_command == SSpackets.framevirus_magic_packet)
		if(computer.hardware_flag != PROGRAM_TABLET)
			return //If it's not a PDA, too bad!
		if(!(signal.has_magic_data & MAGIC_DATA_MUST_OBFUSCATE))
			return //Must be obfuscated, due to the ability to create PDAs.
		var/datum/component/uplink/hidden_uplink = computer.GetComponent(/datum/component/uplink)
		if(!hidden_uplink)
			var/datum/mind/target_mind
			var/list/backup_players = list()
			for(var/datum/mind/player as anything in get_crewmember_minds())
				if(player.assigned_role?.title == computer.saved_job)
					backup_players += player
				if(player.name == computer.saved_identification)
					target_mind = player
					break
			if(!target_mind)
				if(!length(backup_players))
					target_mind = signal_data["fallback_mind"] //yea...
				else
					target_mind = pick(backup_players)
			hidden_uplink = computer.AddComponent(/datum/component/uplink, target_mind, enabled = TRUE, starting_tc = signal_data["telecrystals"], has_progression = TRUE)
			hidden_uplink.uplink_handler.has_objectives = TRUE
			hidden_uplink.uplink_handler.owner = target_mind
			hidden_uplink.uplink_handler.can_take_objectives = FALSE
			hidden_uplink.uplink_handler.progression_points = min(SStraitor.current_global_progression, signal_data["current_progression"])
			hidden_uplink.uplink_handler.generate_objectives()
			SStraitor.register_uplink_handler(hidden_uplink.uplink_handler)
		else
			hidden_uplink.add_telecrystals(signal_data["telecrystals"])
		//Unlock it regardless of if we created it or not.
		hidden_uplink.locked = FALSE
		hidden_uplink.active = TRUE

/datum/computer_file/program/messenger/proc/show_in_chat(list/signal_data, rigged)
	var/mob/living/L = null
	if(holder.holder.loc && isliving(holder.holder.loc))
		L = holder.holder.loc
	//Maybe they are a pAI!
	else
		L = get(holder.holder, /mob/living/silicon)

	if(L && (L.stat == CONSCIOUS || L.stat == SOFT_CRIT))
		var/reply = "(<a href='byond://?src=[REF(src)];choice=[rigged ? "Mess_us_up" : "Message"];skiprefresh=1;target=[signal_data["s_addr"]]'>Reply</a>)"
		var/hrefstart
		var/hrefend
		if (isAI(L))
			hrefstart = "<a href='?src=[REF(L)];track=[html_encode(signal_data["name"])]'>"
			hrefend = "</a>"

		if(signal_data["s_addr"] == null)
			reply = "\[#ERRNOADDR\]"

		if(signal_data["automated"])
			reply = "\[Automated Message\]"


		var/inbound_message = "\"[signal_data["message"]]\""
		if(signal_data["emojis"] == TRUE)//so will not parse emojis as such from pdas that don't send emojis
			inbound_message = emoji_parse(inbound_message)

		if(ringer_status)
			to_chat(L, "<span class='infoplain'>[icon2html(src)] <b>PDA message from [hrefstart][signal_data["name"]] ([signal_data["job"]])[hrefend], </b>[inbound_message] [reply]</span>")

/datum/computer_file/program/messenger/Topic(href, href_list)
	..()

	if(!href_list["close"] && usr.canUseTopic(computer, BE_CLOSE, FALSE, NO_TK))
		switch(href_list["choice"])
			if("Message")
				send_message(usr, href_list["s_addr"])
			if("Mess_us_up")
				if(!HAS_TRAIT(src, TRAIT_PDA_CAN_EXPLODE))
					var/obj/item/modular_computer/tablet/comp = computer
					comp.explode(usr, from_message_menu = TRUE)
					return

/datum/computer_file/program/messenger/proc/msg_input(mob/living/U = usr, rigged = FALSE)
	var/text_message = null

	if(mime_mode)
		text_message = emoji_sanitize(tgui_input_text(U, "Enter emojis", "NT Messaging"))
	else
		text_message = tgui_input_text(U, "Enter a message", "NT Messaging")

	if (!text_message || !netcard_cache.radio_state)
		return
	if(!U.canUseTopic(computer, BE_CLOSE))
		return
	return sanitize(text_message)

/datum/computer_file/program/messenger/proc/send_message(mob/living/user, target_address, everyone = FALSE, rigged = FALSE, fake_name = null, fake_job = null)
