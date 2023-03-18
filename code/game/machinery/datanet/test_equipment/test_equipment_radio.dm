/obj/machinery/test_equipment/radio
	name = "Radio Test Equipment"
	desc = "Test equipment for radio packet transmission. You should not see this on prod."
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator"
	anchored = FALSE
	var/datum/radio_frequency/radio_connection
	var/current_frequency = 0
	var/list/current_data
	var/send_range = 0

/obj/machinery/test_equipment/radio/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/datum/browser/popup = new(usr, "dte_radio", "Radio Test Equipment", 400, 600)
	var/dat = {"
		<A href='?src=[REF(src)];set_freq=1'>[format_frequency(current_frequency)]</a>
		<A href='?src=[REF(src)];set_range=1'>Range:[format_range(send_range)]</a>
		<A href='?src=[REF(src)];set_packet=1'>Set Packet Data</a>
		<A href='?src=[REF(src)];send_packet=1'>Send Packet</a><br>
		<hr>
		<code>[json_encode(current_data)]</code>
	"}
	popup.set_content(dat)
	popup.open()

/obj/machinery/test_equipment/radio/proc/format_range(rangeint)
	switch(rangeint)
		if(0)
			return "GLOBAL"
		if(-1)
			return "Z-LOCK"
		else
			return rangeint

/obj/machinery/test_equipment/radio/Topic(href, href_list)
	. = ..()
	if(href_list["set_freq"])
		var/new_freq = sanitize_frequency(input(usr, "Input 4 digit frequency (No dot)", "Frequency", current_frequency) as num, TRUE)
		if(new_freq == current_frequency)
			return
		if(current_frequency)//We start with a bad freq and no membership so just skip it.
			SSpackets.remove_object(src, current_frequency)
		current_frequency = new_freq
		radio_connection = SSpackets.add_object(src, current_frequency)
		updateDialog()
		if(current_frequency == FREQ_ATMOS_CONTROL)
			icon_state = "dominator-Blue"
			//You have special behaviour, you get a special color.
			return
		var/color_index = (current_frequency % 4)+1
		var/static/color_map = list(
			"dominator-Red",
			"dominator-Orange",
			"dominator-Yellow",
			"dominator-Green",
			"dominator-Purple",
		)
		icon_state = color_map[color_index] //Just make telling them apart easier for me.
		return
	if(href_list["set_range"])
		var/new_range = input(usr, "New Range (Z-Lock:-1, Global:0)", "Range", 0) as num|null
		if(isnull(new_range))
			return
		send_range = new_range
		updateDialog()
		return
	if(href_list["set_packet"])
		var/new_packet = input(usr, "Input json blob", "JSON Packet Blob") as message
		current_data = json_decode(new_packet)
		updateDialog()
		return
	if(href_list["send_packet"])
		if(!current_frequency)
			say("BAD FREQUENCY!")
			return
		if(!current_data)
			say("NO DATA TO SEND!")
			return
		var/datum/signal/packsig = new(src, current_data.Copy(), TRANSMISSION_RADIO)
		radio_connection.post_signal(packsig, range=send_range)
		return

/obj/machinery/test_equipment/radio/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(FALSE) //This is a dev tool go fuck yourself
	var/signal_data = signal.data //If you are looking at this code do not ever fuck with signal.range directly or I will kill you.
	say("F:[signal.frequency]|R:[signal.range]|D:[json_encode(signal_data)]")

