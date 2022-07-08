/// Wires for the fax machine
/datum/wires/fax
	holder_type = /obj/machinery/fax_machine
	proper_name = "Fax Machine"

/datum/wires/fax/New(atom/holder)
	wires = list(
		WIRE_SEND_FAXES,
		WIRE_RECEIVE_FAXES,
		WIRE_PAPERWORK,
	)
	add_duds(1)
	return ..()

/datum/wires/fax/get_status()
	var/obj/machinery/fax_machine/machine = holder
	var/list/status = list()
	var/service_light_intensity
	switch((machine.sending_enabled + machine.receiving_enabled))
		if(0)
			service_light_intensity = "off"
		if(1)
			service_light_intensity = "blinking"
		if(2)
			service_light_intensity = "on"
	status += "The service light is [service_light_intensity]."
	status += "The bluespace transceiver is glowing [machine.can_receive_paperwork ? "blue" : "red"]."
	return status

/datum/wires/fax/on_pulse(wire, user)
	var/obj/machinery/fax_machine/machine = holder
	switch(wire)
		if(WIRE_SEND_FAXES)
			machine.send_stored_paper(user)
		if(WIRE_PAPERWORK)
			machine.can_receive_paperwork = !machine.can_receive_paperwork
		if(WIRE_RECEIVE_FAXES)
			if(machine.receiving_enabled)
				machine.receiving_enabled = FALSE
				addtimer(VARSET_CALLBACK(machine, receiving_enabled, TRUE), 30 SECONDS)

/datum/wires/fax/on_cut(wire, mend)
	var/obj/machinery/fax_machine/machine = holder
	switch(wire)
		if(WIRE_SEND_FAXES)
			machine.sending_enabled = mend
		if(WIRE_PAPERWORK)
			machine.can_receive_paperwork = mend
		if(WIRE_RECEIVE_FAXES)
			machine.receiving_enabled = mend
