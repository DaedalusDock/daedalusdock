/obj/machinery/computer/atmos_alert
	name = "atmospheric alert console"
	desc = "Used to monitor the station's air alarms."
	circuit = /obj/item/circuitboard/computer/atmos_alert
	icon_screen = "alert:0"
	icon_keyboard = "atmos_key"
	light_color = LIGHT_COLOR_CYAN

	network_flags = NETWORK_FLAG_GEN_ID | NETWORK_FLAG_JOIN_FREQUENCY

	var/list/priority_alarms = list()
	var/list/minor_alarms = list()

	connection_frequency = FREQ_ATMOS_ALARMS
	default_connection_frequency_inbound_filter = RADIO_ATMOSIA

/obj/machinery/computer/atmos_alert/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosAlertConsole", name)
		ui.open()

/obj/machinery/computer/atmos_alert/ui_data(mob/user)
	var/list/data = list()

	data["priority"] = list()
	for(var/zone in priority_alarms)
		data["priority"] += zone
	data["minor"] = list()
	for(var/zone in minor_alarms)
		data["minor"] += zone

	return data

/obj/machinery/computer/atmos_alert/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("clear")
			var/zone = params["zone"]
			if(zone in priority_alarms)
				to_chat(usr, span_notice("Priority alarm for [zone] cleared."))
				priority_alarms -= zone
				. = TRUE
			if(zone in minor_alarms)
				to_chat(usr, span_notice("Minor alarm for [zone] cleared."))
				minor_alarms -= zone
				. = TRUE
	update_appearance()

/obj/machinery/computer/atmos_alert/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(FALSE) //TODO: RECONCILE TAGS AND NETIDS
	if(!signal)
		return

	var/list/payload = signal.data[PKT_PAYLOAD]
	var/zone = payload["zone"]
	var/severity = payload["alert"]

	if(!zone || !severity)
		return

	minor_alarms -= zone
	priority_alarms -= zone
	if(severity == "severe")
		priority_alarms += zone
	else if (severity == "minor")
		minor_alarms += zone
	update_appearance()
	return

/obj/machinery/computer/atmos_alert/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(priority_alarms.len)
		. += "alert:2"
		return
	if(minor_alarms.len)
		. += "alert:1"
