#define IMPORTANT_ACTION_COOLDOWN (60 SECONDS)
#define MAX_STATUS_LINE_LENGTH 40

#define STATE_BUYING_SHUTTLE "buying_shuttle"
#define STATE_CHANGING_STATUS "changing_status"
#define STATE_MAIN "main"
#define STATE_MESSAGES "messages"

// The communications computer
/obj/machinery/computer/communications
	name = "announcements console"
	desc = "A console used for announcements."
	icon_screen = "comm"
	icon_keyboard = "tech_key"
	req_access = list(ACCESS_FEDERATION)
	circuit = /obj/item/circuitboard/computer/communications
	light_color = LIGHT_COLOR_BLUE

	network_flags = NETWORK_FLAG_GEN_ID

	/// If the battlecruiser has been called
	var/static/battlecruiser_called = FALSE

	/// Cooldown for important actions, such as messaging CentCom or other sectors
	COOLDOWN_DECLARE(static/important_action_cooldown)

	/// Whether syndicate mode is enabled or not.
	var/syndicate = FALSE

	/// The current state of the UI
	var/state = STATE_MAIN

	/// The current state of the UI for AIs
	var/cyborg_state = STATE_MAIN

	/// The name of the user who logged in
	var/authorize_name
	/// The name of the job of the user who logged in
	var/authorize_job
	/// The access that the card had on login
	var/list/authorize_access

	/// The messages this console has been sent
	var/list/datum/comm_message/messages

	/// The timer ID for sending the next cross-comms message
	var/send_cross_comms_message_timer

/obj/machinery/computer/communications/syndicate
	icon_screen = "commsyndie"
	circuit = /obj/item/circuitboard/computer/communications/syndicate
	req_access = list(ACCESS_SYNDICATE_LEADER)
	light_color = LIGHT_COLOR_BLOOD_MAGIC

	syndicate = TRUE

/obj/machinery/computer/communications/syndicate/emag_act(mob/user, obj/item/card/emag/emag_card)
	return

/obj/machinery/computer/communications/syndicate/can_send_messages_to_other_sectors(mob/user)
	return FALSE

/obj/machinery/computer/communications/syndicate/authenticated_as_silicon_or_captain(mob/user)
	return FALSE

/obj/machinery/computer/communications/syndicate/get_communication_players()
	var/list/targets = list()
	for(var/mob/target in GLOB.player_list)
		if(target.stat == DEAD || target.z == z)
			targets += target
	return targets

/obj/machinery/computer/communications/Initialize(mapload)
	. = ..()
	SET_TRACKING(__TYPE__)
	AddComponent(/datum/component/gps, "Secured Communications Signal")

/// Are we NOT a silicon, AND we're logged in as the captain?
/obj/machinery/computer/communications/proc/authenticated_as_non_silicon_captain(mob/user)
	if (issilicon(user))
		return FALSE
	return ACCESS_CAPTAIN in authorize_access

/// Are we a silicon, OR we're logged in as the captain?
/obj/machinery/computer/communications/proc/authenticated_as_silicon_or_captain(mob/user)
	if (issilicon(user) || user.has_unlimited_silicon_privilege)
		return TRUE
	return ACCESS_CAPTAIN in authorize_access

/// Are we a silicon, OR logged in?
/obj/machinery/computer/communications/proc/authenticated(mob/user)
	if (issilicon(user) || user.has_unlimited_silicon_privilege)
		return TRUE
	return authenticated

/obj/machinery/computer/communications/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		attack_hand(user)
	else
		return ..()

/obj/machinery/computer/communications/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return

	obj_flags |= EMAGGED

	if (authenticated)
		authorize_access = SSid_access.get_access_for_group(list(/datum/access_group/station/all))

	to_chat(user, span_danger("You scramble the communication routing circuits!"))
	playsound(src, 'sound/machines/terminal_alert.ogg', 50, FALSE)

/obj/machinery/computer/communications/ui_act(action, list/params)
	var/static/list/approved_states = list(STATE_MAIN, STATE_MESSAGES)

	. = ..()
	if (.)
		return

	if (!has_communication())
		return

	. = TRUE

	switch (action)
		if ("answerMessage")
			if (!authenticated(usr))
				return

			var/answer_index = params["answer"]
			var/message_index = params["message"]

			// If either of these aren't numbers, then bad voodoo.
			if(!isnum(answer_index) || !isnum(message_index))
				message_admins("[ADMIN_LOOKUPFLW(usr)] provided an invalid index type when replying to a message on [src] [ADMIN_JMP(src)]. This should not happen. Please check with a maintainer and/or consult tgui logs.")
				CRASH("Non-numeric index provided when answering comms console message.")

			if (!answer_index || !message_index || answer_index < 1 || message_index < 1)
				return
			var/datum/comm_message/message = messages[message_index]
			if (message.answered)
				return
			message.answered = answer_index
			message.answer_callback.InvokeAsync()

		if ("deleteMessage")
			if (!authenticated(usr))
				return

			var/message_index = text2num(params["message"])
			if (!message_index)
				return

			LAZYREMOVE(messages, LAZYACCESS(messages, message_index))

		if ("makePriorityAnnouncement")
			if (!authenticated_as_silicon_or_captain(usr) && !syndicate)
				return

			make_announcement(usr)

		if ("messageAssociates")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return

			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			var/message = trim(html_encode(params["message"]), MAX_MESSAGE_LEN)

			var/emagged = obj_flags & EMAGGED
			if (emagged)
				message_syndicate(message, usr)
				to_chat(usr, span_danger("SYSERR @l(19833)of(transmit.dm): !@$ MESSAGE TRANSMITTED TO SYNDICATE COMMAND."))
			else if(syndicate)
				message_syndicate(message, usr)
				to_chat(usr, span_danger("Message transmitted to Syndicate Command."))
			else
				message_centcom(message, usr)
				to_chat(usr, span_notice("Message transmitted to Central Command."))

			var/associates = (emagged || syndicate) ? "the Syndicate": "CentCom"
			usr.log_talk(message, LOG_SAY, tag = "message to [associates]")
			deadchat_broadcast(" has messaged [associates], \"[message]\" at [span_name("[get_area_name(usr, TRUE)]")].", span_name("[usr.real_name]"), usr, message_type = DEADCHAT_ANNOUNCEMENT)
			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)

		if ("requestNukeCodes")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return
			var/reason = trim(html_encode(params["reason"]), MAX_MESSAGE_LEN)
			nuke_request(reason, usr)
			to_chat(usr, span_notice("Request sent."))
			usr.log_message("has requested the nuclear codes from CentCom with reason \"[reason]\"", LOG_SAY)
			priority_announce("The codes for the on-station nuclear self-destruct have been requested by [usr]. Confirmation or denial of this request will be sent shortly.", sub_title = "Nuclear Self-Destruct Codes Requested", sound_type = ANNOUNCER_CENTCOM)
			playsound(src, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)

		if ("restoreBackupRoutingData")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!(obj_flags & EMAGGED))
				return
			to_chat(usr, span_notice("Backup routing data restored."))
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			obj_flags &= ~EMAGGED

		if ("sendToOtherSector")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!can_send_messages_to_other_sectors(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return

			var/message = trim(params["message"], MAX_MESSAGE_LEN)
			if (!message)
				return

			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)

			var/destination = params["destination"]

			log_game("[key_name(usr)] is about to send the following message to [destination]: [message]")
			to_chat(
				GLOB.admins,
				span_adminnotice( \
					"<b color='orange'>CROSS-SECTOR MESSAGE (OUTGOING):</b> [ADMIN_LOOKUPFLW(usr)] is about to send \
					the following message to <b>[destination]</b> (will autoapprove in [DisplayTimeText(CROSS_SECTOR_CANCEL_TIME)]): \
					<b><a href='?src=[REF(src)];reject_cross_comms_message=1'>REJECT</a></b><br> \
					[html_encode(message)]" \
				)
			)

			send_cross_comms_message_timer = addtimer(CALLBACK(src, PROC_REF(send_cross_comms_message), usr, destination, message), CROSS_SECTOR_CANCEL_TIME, TIMER_STOPPABLE)

			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)
		if ("setState")
			if (!authenticated(usr))
				return
			if (!(params["state"] in approved_states))
				return
			set_state(usr, params["state"])
			playsound(src, SFX_TERMINAL_TYPE, 50, FALSE)

		if ("toggleAuthentication")
			// Log out if we're logged in
			if (authorize_name)
				authenticated = FALSE
				authorize_access = null
				authorize_name = null
				authorize_job = null
				playsound(src, 'sound/machines/terminal_off.ogg', 50, FALSE)
				return

			if (obj_flags & EMAGGED)
				authenticated = TRUE
				authorize_access = SSid_access.get_access_for_group(list(/datum/access_group/station/all))
				authorize_name = "Unknown"
				authorize_job = null
				to_chat(usr, span_warning("[src] lets out a quiet alarm as its login is overridden."))
				playsound(src, 'sound/machines/terminal_alert.ogg', 25, FALSE)
			else if(isliving(usr))
				var/mob/living/L = usr
				var/obj/item/card/id/id_card = L.get_idcard(hand_first = TRUE)
				if (check_access(id_card))
					authenticated = TRUE
					authorize_access = id_card.access.Copy()
					authorize_name = id_card.registered_name
					authorize_job = id_card.assignment

			state = STATE_MAIN
			playsound(src, 'sound/machines/terminal_on.ogg', 50, FALSE)

		// Request codes for the Captain's Spare ID safe.
		if("requestSafeCodes")
			if(SSjob.assigned_captain)
				to_chat(usr, span_warning("There is already an assigned Captain or Acting Captain on deck!"))
				return

			if(SSjob.safe_code_timer_id)
				to_chat(usr, span_warning("The safe code has already been requested and is being delivered to your station!"))
				return

			if(SSjob.safe_code_requested)
				to_chat(usr, span_warning("The safe code has already been requested and delivered to your station!"))
				return

			var/turf/pod_location = get_turf(src)

			SSjob.safe_code_request_loc = pod_location
			SSjob.safe_code_requested = TRUE
			SSjob.safe_code_timer_id = addtimer(CALLBACK(SSjob, TYPE_PROC_REF(/datum/controller/subsystem/job, send_spare_id_safe_code), pod_location), 120 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)
			priority_announce(
				"Due to staff shortages, your station has been approved for delivery of access codes to secure the Captain's Spare ID. Delivery via drop pod at [get_area(pod_location)]. ETA 120 seconds.")

/obj/machinery/computer/communications/proc/send_cross_comms_message(mob/user, destination, message)
	send_cross_comms_message_timer = null

	var/list/payload = list()

	var/network_name = CONFIG_GET(string/cross_comms_network)
	if (network_name)
		payload["network"] = network_name
	payload["sender_ckey"] = usr.ckey

	send2otherserver(html_decode(station_name()), message, "Comms_Console", destination == "all" ? null : list(destination), additional_data = payload)
	priority_announce(message, sub_title = "Outbound message to nearby station")
	usr.log_talk(message, LOG_SAY, tag = "message to the other server")
	message_admins("[ADMIN_LOOKUPFLW(usr)] has sent a message to the other server\[s].")
	deadchat_broadcast(" has sent an outgoing message to the other station(s).</span>", "<span class='bold'>[usr.real_name]", usr, message_type = DEADCHAT_ANNOUNCEMENT)

/obj/machinery/computer/communications/ui_data(mob/user)
	var/list/data = list(
		"authenticated" = FALSE,
		"emagged" = FALSE,
		"syndicate" = syndicate,
	)

	var/ui_state = (issilicon(user) || user.has_unlimited_silicon_privilege) ? cyborg_state : state

	var/has_connection = has_communication()
	data["hasConnection"] = has_connection

	if(!SSjob.assigned_captain && !SSjob.safe_code_requested && has_connection)
		data["canRequestSafeCode"] = TRUE
		data["safeCodeDeliveryWait"] = 0
	else
		data["canRequestSafeCode"] = FALSE
		if(SSjob.safe_code_timer_id && has_connection)
			data["safeCodeDeliveryWait"] = timeleft(SSjob.safe_code_timer_id)
			data["safeCodeDeliveryArea"] = get_area(SSjob.safe_code_request_loc)
		else
			data["safeCodeDeliveryWait"] = 0
			data["safeCodeDeliveryArea"] = null

	if (authenticated || (issilicon(user) || user.has_unlimited_silicon_privilege))
		data["authenticated"] = TRUE
		data["canLogOut"] = !(issilicon(user) || user.has_unlimited_silicon_privilege)
		data["page"] = ui_state

		if ((obj_flags & EMAGGED) || syndicate)
			data["emagged"] = TRUE

		switch (ui_state)
			if (STATE_MAIN)
				data["canMakeAnnouncement"] = FALSE
				data["canMessageAssociates"] = FALSE
				data["canRequestNuke"] = FALSE
				data["canSendToSectors"] = FALSE
				data["importantActionReady"] = COOLDOWN_FINISHED(src, important_action_cooldown)
				data["alertLevel"] = get_security_level()
				data["authorizeName"] = authorize_name
				data["canLogOut"] = !(issilicon(user) || user.has_unlimited_silicon_privilege)

				if (authenticated_as_non_silicon_captain(user))
					data["canMessageAssociates"] = TRUE
					data["canRequestNuke"] = TRUE

				if (can_send_messages_to_other_sectors(user))
					data["canSendToSectors"] = TRUE

					var/list/sectors = list()
					var/our_id = CONFIG_GET(string/cross_comms_name)

					for (var/server in CONFIG_GET(keyed_list/cross_server))
						if (server == our_id)
							continue
						sectors += server

					data["sectors"] = sectors

				if (authenticated_as_silicon_or_captain(user))
					data["canMakeAnnouncement"] = TRUE

				else if(syndicate)
					data["canMakeAnnouncement"] = TRUE

			if (STATE_MESSAGES)
				data["messages"] = list()

				if (messages)
					for (var/_message in messages)
						var/datum/comm_message/message = _message
						data["messages"] += list(list(
							"answered" = message.answered,
							"content" = message.content,
							"title" = message.title,
							"possibleAnswers" = message.possible_answers,
						))

	return data

/obj/machinery/computer/communications/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CommunicationsConsole")
		ui.open()

/obj/machinery/computer/communications/ui_static_data(mob/user)
	return list(
		"maxMessageLength" = MAX_MESSAGE_LEN,
	)

/obj/machinery/computer/communications/Topic(href, href_list)
	if (href_list["reject_cross_comms_message"])
		if (!usr.client?.holder)
			log_game("[key_name(usr)] tried to reject a cross-comms message without being an admin.")
			message_admins("[key_name(usr)] tried to reject a cross-comms message without being an admin.")
			return

		if (isnull(send_cross_comms_message_timer))
			to_chat(usr, span_warning("It's too late!"))
			return

		deltimer(send_cross_comms_message_timer)
		send_cross_comms_message_timer = null

		log_admin("[key_name(usr)] has cancelled the outgoing cross-comms message.")
		message_admins("[key_name(usr)] has cancelled the outgoing cross-comms message.")

		return TRUE

	return ..()

/// Returns whether or not the communications console can communicate with the station
/obj/machinery/computer/communications/proc/has_communication()
	var/turf/current_turf = get_turf(src)
	var/z_level = current_turf.z
	if(syndicate)
		return TRUE
	return is_station_level(z_level) || is_centcom_level(z_level)

/obj/machinery/computer/communications/proc/set_state(mob/user, new_state)
	if ((issilicon(user) || user.has_unlimited_silicon_privilege))
		cyborg_state = new_state
	else
		state = new_state

/// Returns whether we are authorized to buy this specific shuttle.
/// Does not handle prerequisite checks, as those should still *show*.
/obj/machinery/computer/communications/proc/can_purchase_this_shuttle(datum/map_template/shuttle/shuttle_template)
	if (isnull(shuttle_template.who_can_purchase))
		return FALSE

	if (shuttle_template.emag_only)
		return !!(obj_flags & EMAGGED)

	for (var/access in authorize_access)
		if (access in shuttle_template.who_can_purchase)
			return TRUE

	return FALSE

/obj/machinery/computer/communications/proc/can_send_messages_to_other_sectors(mob/user)
	if (!authenticated_as_non_silicon_captain(user))
		return

	return length(CONFIG_GET(keyed_list/cross_server)) > 0

/obj/machinery/computer/communications/proc/make_announcement(mob/living/user)
	var/is_ai = (issilicon(user) || user.has_unlimited_silicon_privilege)
	if(!SScommunications.can_announce(user, is_ai))
		to_chat(user, span_alert("Intercomms recharging. Please stand by."))
		return

	var/input = tgui_input_text(user, "Message to announce to the station crew", "Announcement")
	if(!input || !user.canUseTopic(src, USE_CLOSE|USE_SILICON_REACH))
		return

	var/can_speak = user.can_speak()
	if(isliving(user) && can_speak)
		can_speak = !istype(user.get_selected_language(), /datum/language/visual)

	if(!can_speak) //No more cheating, mime/random mute guy!
		to_chat(user, span_warning("You find yourself unable to speak."))
		return

	if(isliving(user)) // adminghosts
		input = user.treat_message(input) //Adds slurs and so on. Someone should make this use languages too.

	var/sender = authorize_name
	if(authorize_job)
		sender = "[sender] ([authorize_job])"

	var/list/players = get_communication_players()
	SScommunications.make_announcement(user, is_ai, input, syndicate || (obj_flags & EMAGGED), players, sender)
	deadchat_broadcast(" made a priority announcement from [span_name("[get_area_name(usr, TRUE)]")].", span_name("[user.real_name]"), user, message_type=DEADCHAT_ANNOUNCEMENT)

/obj/machinery/computer/communications/proc/get_communication_players()
	return GLOB.player_list

/obj/machinery/computer/communications/proc/post_status(command, data1, data2)

	var/datum/radio_frequency/frequency = SSpackets.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = create_signal(
		payload = list(
			PKT_ARG_CMD = NET_COMMAND_STATDISPLAY_SET,
			PKT_ARG_STATDISPLAY_MODE = command
		),
		transmission_method = TRANSMISSION_RADIO
	)

	switch(command)
		if("message")
			status_signal.data[PKT_PAYLOAD]["msg1"] = data1
			status_signal.data[PKT_PAYLOAD]["msg2"] = data2
		if("alert")
			status_signal.data[PKT_PAYLOAD]["picture_state"] = data1

	frequency.post_signal(status_signal)

/obj/machinery/computer/communications/Destroy()
	UNSET_TRACKING(__TYPE__)
	return ..()

/// Override the cooldown for special actions
/// Used in places such as CentCom messaging back so that the crew can answer right away
/obj/machinery/computer/communications/proc/override_cooldown()
	COOLDOWN_RESET(src, important_action_cooldown)

/obj/machinery/computer/communications/proc/add_message(datum/comm_message/new_message)
	LAZYADD(messages, new_message)


/datum/comm_message
	var/title
	var/content
	var/list/possible_answers = list()
	var/answered
	var/datum/callback/answer_callback

/datum/comm_message/New(new_title,new_content,new_possible_answers)
	..()
	if(new_title)
		title = new_title
	if(new_content)
		content = new_content
	if(new_possible_answers)
		possible_answers = new_possible_answers

#undef IMPORTANT_ACTION_COOLDOWN
#undef STATE_BUYING_SHUTTLE
#undef STATE_CHANGING_STATUS
#undef STATE_MAIN
#undef STATE_MESSAGES
