// Relays don't handle any actual communication. Global NTNet datum does that, relays only tell the datum if it should or shouldn't work.
/obj/machinery/ntnet_relay
	name = "NTNet Quantum Relay"
	desc = "A very complex router and transmitter capable of connecting electronic devices together. Looks fragile."
	use_power = ACTIVE_POWER_USE
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 10 //10kW, apropriate for machine that keeps massive cross-Zlevel wireless network operational. Used to be 20 but that actually drained the smes one round
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "bus"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/ntnet_relay

	var/datum/ntnet/NTNet = null // This is mostly for backwards reference and to allow varedit modifications from ingame.
	///On / off status for the relay machine, toggleable by the user.
	var/relay_enabled = TRUE
	///(D)DoS-attack-related failure causing it not to be operational any longer.
	var/dos_failure = FALSE
	var/list/dos_sources = list() // Backwards reference for qdel() stuff
	var/uid
	var/static/gl_uid = 1

	// Denial of Service attack variables
	var/dos_overload = 0 // Amount of DoS "packets" in this relay's buffer
	var/dos_capacity = 500 // Amount of DoS "packets" in buffer required to crash the relay
	var/dos_dissipate = 0.5 // Amount of DoS "packets" dissipated over time.

/obj/machinery/ntnet_relay/examine(mob/user)
	. = ..()
	. += span_notice("The front panel ID display reads: [uid]")

///Proc called to change the value of the `relay_enabled` variable and append behavior related to its change.
/obj/machinery/ntnet_relay/proc/set_relay_enabled(new_value)
	if(new_value == relay_enabled)
		return
	. = relay_enabled
	relay_enabled = new_value
	if(.) //Turned off
		set_is_operational(FALSE)
	else if(!dos_failure && !(machine_stat & (NOPOWER|BROKEN|MAINT))) //Turned on
		set_is_operational(TRUE)


///Proc called to change the value of the `dos_failure` variable and append behavior related to its change.
/obj/machinery/ntnet_relay/proc/set_dos_failure(new_value)
	if(new_value == dos_failure)
		return
	. = dos_failure
	dos_failure = new_value
	if(.) //Failure ended
		if(relay_enabled && !(machine_stat & (NOPOWER|BROKEN|MAINT)))
			set_is_operational(TRUE)
	else //Failure started
		set_is_operational(FALSE)


/obj/machinery/ntnet_relay/on_set_machine_stat(old_value)
	if(old_value & (NOPOWER|BROKEN|MAINT))
		if(relay_enabled && !dos_failure && !(machine_stat & (NOPOWER|BROKEN|MAINT))) //From off to on.
			set_is_operational(TRUE)
	else if(machine_stat & (NOPOWER|BROKEN|MAINT)) //From on to off.
		set_is_operational(FALSE)


/obj/machinery/ntnet_relay/update_icon_state()
	icon_state = "bus[is_operational ? null : "_off"]"
	return ..()

/obj/machinery/ntnet_relay/process(delta_time)
	update_use_power(is_operational ? ACTIVE_POWER_USE : IDLE_POWER_USE)

	update_appearance()

	if(dos_overload > 0)
		dos_overload = max(0, dos_overload - dos_dissipate * delta_time)

	// If DoS traffic exceeded capacity, crash.
	if((dos_overload > dos_capacity) && !dos_failure)
		set_dos_failure(TRUE)
		update_appearance()
		SSnetworks.add_log("Relay [uid]: Health check failed, 503 Unavailable. ")
	// If the DoS buffer reaches 0 again, restart.
	if((dos_overload == 0) && dos_failure)
		set_dos_failure(FALSE)
		update_appearance()
		SSnetworks.add_log("Relay [uid]: Health check normal, Servicing requests.")
	..()

/obj/machinery/ntnet_relay/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NtnetRelay")
		ui.open()

/obj/machinery/ntnet_relay/ui_data(mob/user)
	var/list/data = list()
	data["enabled"] = relay_enabled
	data["dos_capacity"] = dos_capacity
	data["dos_overload"] = dos_overload
	data["dos_crashed"] = dos_failure
	return data

/obj/machinery/ntnet_relay/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("restart")
			dos_overload = 0
			set_dos_failure(FALSE)
			update_appearance()
			SSnetworks.add_log("Relay [uid]: Unit restarted, [relay_enabled ? "Relay [uid] added to pool" : "Unit was not added to pool"].")
			return TRUE
		if("toggle")
			set_relay_enabled(!relay_enabled)
			SSnetworks.add_log("Relay [uid]: [relay_enabled ? "Unit added to pool" : "Unit removed from pool"].")
			update_appearance()
			return TRUE

/obj/machinery/ntnet_relay/Initialize(mapload)
	uid = gl_uid++
	component_parts = list()

	if(SSnetworks.station_network)
		SSnetworks.relays.Add(src)
		SSnetworks.add_log("Relay [uid]: Registered, Available nodes:[SSnetworks.relays.len]")
	. = ..()

/obj/machinery/ntnet_relay/Destroy()
	if(SSnetworks.station_network)
		SSnetworks.relays.Remove(src)
		SSnetworks.add_log("Relay [uid]: Device unavailable, Removed from network, Available nodes: [SSnetworks.relays.len]")

	for(var/datum/computer_file/program/ntnet_dos/D in dos_sources)
		D.target = null
		D.error = "Connection to quantum relay severed"

	return ..()
