/*
 * 'Slaved' pinpad that mirrors another pad.
 */

/datum/c4_file/terminal_program/operating_system/rtos/slave
	name = "slavepad"

	/// Slave ID tag
	var/id_tag


/datum/c4_file/terminal_program/operating_system/rtos/slave/populate_memory(datum/c4_file/record/conf_record)
	var/list/fields = conf_record.stored_record.fields
	id_tag = fields[RTOS_CONFIG_ID_TAG_GENERIC]

	if(!id_tag)
		halt(RTOS_HALT_NO_CONFIG, "NO_IDTAG")

/datum/c4_file/terminal_program/operating_system/rtos/slave/finish_startup()
	var/obj/item/peripheral/network_card/wireless/wcard = get_computer()?.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	wcard.listen_mode = WIRELESS_FILTER_ID_TAGS
	wcard.id_tags = list(id_tag)

	var/datum/signal/signal = new(
		src,
		list(
			"tag" = id_tag,
			PACKET_CMD = NETCMD_UPDATE_REQUEST,
		)
	)
	post_signal(signal)

/datum/c4_file/terminal_program/operating_system/rtos/slave/peripheral_input(obj/item/peripheral/invoker, command, datum/signal/packet)
	. = ..()
	if(command == PERIPHERAL_CMD_RECEIVE_PACKET)
		handle_packet(packet)
	if(command == PERIPHERAL_CMD_SCAN_CARD)
		handle_cardscan(packet)

/datum/c4_file/terminal_program/operating_system/rtos/slave/proc/handle_packet(datum/signal/packet)
	var/list/fields = packet.data

	if(fields[PACKET_CMD] != NETCMD_UPDATE_DATA)
		return

	var/redraw_screen = FALSE
	var/update_visuals = FALSE

	if(fields[PACKET_ARG_TEXTBUFFER])
		var/list/tmp_history
		tmp_history = params2list(fields[PACKET_ARG_TEXTBUFFER])
		tmp_history.Cut(4)
		print_history = list()
		for(var/row in tmp_history)
			print_history += html_encode(row)
		redraw_screen = TRUE

	var/new_leds = fields[PACKET_ARG_LEDS]
	if(!isnull(new_leds) && text2num(new_leds))
		display_indicators = new_leds
		update_visuals = TRUE

	var/new_display = fields[PACKET_ARG_DISPLAY]
	if(istext(new_display))
		display_icon = new_display
		update_visuals = TRUE

	if(redraw_screen)
		redraw_screen(TRUE)
	if(update_visuals)
		update_visuals()

// Forward the data to the host machine
/datum/c4_file/terminal_program/operating_system/rtos/slave/proc/handle_cardscan(datum/signal/packet)
	var/datum/signal/signal = new(
		src,
		list(
			"tag" = id_tag,
			PACKET_CMD = NETCMD_ECSLAVE_ACCESS,
			"packet" = list2params(packet.data)
		)
	)
	post_signal(signal)

/datum/c4_file/terminal_program/operating_system/rtos/slave/std_in(text)
	var/datum/signal/signal = new(
		src,
		list(
			"tag" = id_tag,
			PACKET_CMD = "key",
			"key" = text
		)
	)
	post_signal(signal)
