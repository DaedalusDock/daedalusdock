/*
It's like a regular ol' straight pipe, but you can turn it on and off.
*/
#define MANUAL_VALVE "m"
#define DIGITAL_VALVE "d"

/obj/machinery/atmospherics/components/binary/valve
	icon_state = "mvalve_map-3"
	name = "manual valve"
	desc = "A pipe with a valve that can be used to disable flow of gas through it."
	can_unwrench = TRUE
	shift_underlay_only = FALSE
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_OPEN //Intentionally no allow_silicon flag
	pipe_flags = PIPING_CARDINAL_AUTONORMALIZE | PIPING_BRIDGE
	construction_type = /obj/item/pipe/binary
	pipe_state = "mvalve"
	custom_reconcilation = TRUE
	use_power = NO_POWER_USE
	///Type of valve (manual or digital), used to set the icon of the component in update_icon_nopipes()
	var/valve_type = MANUAL_VALVE
	///Bool to stop interactions while the opening/closing animation is going
	var/switching = FALSE
	var/on_sound = 'sound/machines/valveopen.ogg'
	var/off_sound = 'sound/machines/valveclose.ogg'

/obj/machinery/atmospherics/components/binary/valve/update_icon_nopipes(animation = FALSE)
	normalize_cardinal_directions()
	if(animation)
		flick("[valve_type]valve_[on][!on]-[set_overlay_offset(piping_layer)]", src)
	icon_state = "[valve_type]valve_[on ? "on" : "off"]-[set_overlay_offset(piping_layer)]"

/**
 * Called by finish_interact(), switch between open and closed, reconcile the air between two pipelines
 */
/obj/machinery/atmospherics/components/binary/valve/proc/set_open(to_open)
	if(on == to_open)
		return
	SEND_SIGNAL(src, COMSIG_VALVE_SET_OPEN, to_open)
	. = on
	on = to_open
	if(on)
		update_icon_nopipes()
		update_parents()
		var/datum/pipeline/parent1 = parents[1]
		parent1.reconcile_air()
		investigate_log("was opened by [usr ? key_name(usr) : "a remote signal"]", INVESTIGATE_ATMOS)
		vent_movement |= VENTCRAWL_ALLOWED
	else
		update_icon_nopipes()
		investigate_log("was closed by [usr ? key_name(usr) : "a remote signal"]", INVESTIGATE_ATMOS)
		vent_movement &= ~VENTCRAWL_ALLOWED


// This is what handles the actual functionality of combining 2 pipenets when the valve is open
// Basically when a pipenet updates it will consider both sides to be the same for the purpose of the gas update
/obj/machinery/atmospherics/components/binary/valve/return_pipenets_for_reconcilation(datum/pipeline/requester)
	. = ..()
	if(!on)
		return
	. |= parents[1]
	. |= parents[2]

/obj/machinery/atmospherics/components/binary/valve/interact(mob/user)
	add_fingerprint(usr)
	if(switching)
		return
	update_icon_nopipes(TRUE)
	switching = TRUE
	playsound(src, (on ? on_sound : off_sound), 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(finish_interact)), 1 SECONDS)

/**
 * Called by iteract() after a 1 second timer, calls toggle(), allows another interaction with the component.
 */
/obj/machinery/atmospherics/components/binary/valve/proc/finish_interact()
	set_open(!on)
	switching = FALSE

/obj/machinery/atmospherics/components/binary/valve/digital // can be controlled by AI
	icon_state = "dvalve_map-3"

	name = "digital valve"
	desc = "A digitally controlled valve."
	valve_type = DIGITAL_VALVE
	pipe_state = "dvalve"
	on_sound = 'sound/machines/creak.ogg'
	off_sound = 'sound/machines/creak.ogg'

	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_OPEN | INTERACT_MACHINE_OPEN_SILICON

/obj/machinery/atmospherics/components/binary/valve/digital/update_icon_nopipes(animation)
	if(!is_operational)
		normalize_cardinal_directions()
		icon_state = "dvalve_nopower-[set_overlay_offset(piping_layer)]"
		return
	return..()

/obj/machinery/atmospherics/components/binary/valve/layer2
	piping_layer = 2
	icon_state = "mvalve_map-2"

/obj/machinery/atmospherics/components/binary/valve/layer4
	piping_layer = 4
	icon_state = "mvalve_map-4"

/obj/machinery/atmospherics/components/binary/valve/on
	on = TRUE

/obj/machinery/atmospherics/components/binary/valve/on/layer2
	piping_layer = 2
	icon_state = "mvalve_map-2"

/obj/machinery/atmospherics/components/binary/valve/on/layer4
	piping_layer = 4
	icon_state = "mvalve_map-4"

/obj/machinery/atmospherics/components/binary/valve/digital/layer2
	piping_layer = 2
	icon_state = "dvalve_map-2"

/obj/machinery/atmospherics/components/binary/valve/digital/layer4
	piping_layer = 4
	icon_state = "dvalve_map-4"

/obj/machinery/atmospherics/components/binary/valve/digital/on
	on = TRUE

/obj/machinery/atmospherics/components/binary/valve/digital/on/layer2
	piping_layer = 2
	icon_state = "dvalve_map-2"

/obj/machinery/atmospherics/components/binary/valve/digital/on/layer4
	piping_layer = 4
	icon_state = "dvalve_map-4"

#undef MANUAL_VALVE
#undef DIGITAL_VALVE
