//Simple door control, more of an example than anything else.

/*
 *  | > AIRLOCK CONTROL <
 *  | * - >LOCKED< - UNLOCKED
 *  | # - [CLOSED] X OPEN
 */

/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control
	name = "sairctl"

	// Target airlock ID Tag
	var/id_tag

	var/doorbolt_state
	var/dooropen_state

/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control/populate_memory(datum/c4_file/record/conf_record)
	var/datum/data/record/record = conf_record.stored_record

	id_tag = record.fields[RTOS_CONFIG_ID_TAG_GENERIC]

	if(!id_tag)
		halt(RTOS_HALT_BAD_CONFIG, "BAD_CONFIG")
		return TRUE

/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control/peripheral_input(obj/item/peripheral/invoker, command, datum/signal/packet)
	. = ..()
	if(command == PERIPHERAL_CMD_RECEIVE_PACKET)
		update_netstate(packet)

	// if(command == PERIPHERAL_CMD_SCAN_CARD)
	// 	on_cardscan(packet)

/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control/finish_startup()


	var/obj/item/peripheral/network_card/wireless/wcard = get_computer()?.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	wcard.listen_mode = WIRELESS_FILTER_ID_TAGS
	wcard.id_tags = list(id_tag)

	print_history = new /list(RTOS_OUTPUT_ROWS)
	print_history[1] = "  > DOOR CONTROL <  "

	redraw_status()

/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control/proc/redraw_status()
	var/static/list/char_mirror = list(
		">" = "<",
		"#" = "#",
	)

	var/statchar = ">"
	switch(doorbolt_state)
		if("locked")
			print_history[2] = "* - >LOCK< |  UNLCK "
			statchar = "#"
		if("unlocked")
			print_history[2] = "* -  LOCK  | >UNLCK<"
		else
			print_history[2] = "* - ? CHECK   DOOR ?"

	switch(dooropen_state)
		if("closed")
			print_history[3] = "# -  OPEN  | [statchar]CLOSE[char_mirror[statchar]]"
		if("open")
			print_history[3] = "# - [statchar]OPEN[char_mirror[statchar]] |  CLOSE "
		else
			print_history[3] = "# - ? CHECK   DOOR ?"

	redraw_screen(TRUE)


/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control/proc/update_netstate(datum/signal/packet)
	//make sure it's updating it's status.
	// I should probably modify the protocol but it's 5am. suck me.
	if((packet.data["tag"] != id_tag) && (packet.data["timestamp"]))
		return

	// We're gonna blindly trust this, We'll validate it someday. Maybe.
	doorbolt_state = packet.data["lock_status"]
	dooropen_state = packet.data["door_status"]

	redraw_status()

/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control/proc/probe_airlock_status()
	var/datum/signal/signal = new(
		src,
		list(
			"tag" = id_tag,
			PACKET_CMD = "update" //Doesn't matter.
		)
	)
	post_signal(signal, RADIO_AIRLOCK)

/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control/std_in(text)
	. = ..()
	var/datum/signal/signal
	switch(text)
		if("*") //Toggle Lock
			signal = new(
				src,
				list(
					"tag" = id_tag,
					PACKET_CMD = (doorbolt_state == "locked") ? "unlock" : "lock"
				)
			)
		if("#") //Toggle Open
			signal = new(
				src,
				list(
					"tag" = id_tag,
					PACKET_CMD = (dooropen_state == "closed") ? "open" : "close"
				)
			)
		else //Just probe the airlock to update state.
			probe_airlock_status()

	if(signal)
		post_signal(signal, RADIO_AIRLOCK)

// /datum/c4_file/terminal_program/operating_system/rtos/simple_door_control/proc/on_cardscan(datum/signal/packet)
