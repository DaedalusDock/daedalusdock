// So much of this is shamelessly stolen from SMES units.

/obj/machinery/netbridge
	name = "netbridge"
	network_flags = NETWORK_FLAGS_STANDARD_CONNECTION
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"
	base_icon_state = "RD-server"
	density = TRUE

	var/obj/machinery/power/terminal/terminal
	/// Are we shut down due to a loop detection?
	var/loop_alarm = FALSE

/obj/machinery/netbridge/Initialize(mapload)
	. = ..()
	SET_TRACKING(__TYPE__)
	find_and_set_terminal()

	if(!terminal)
		atom_break()
		return
	terminal.master = src
	update_appearance()

/obj/machinery/netbridge/proc/find_and_set_terminal()
	for(var/direction in GLOB.cardinals)
		var/turf/T = get_step(src, direction)
		for(var/obj/machinery/power/terminal/term in T)
			if(term.dir == turn(direction, 180))
				terminal = term
				return TRUE
	return FALSE

/obj/machinery/netbridge/examine(mob/user)
	. = ..()
	. += span_info("There are 4 lights.")
	if(machine_stat & NOPOWER)
		. += span_alert("None of them are on, and the machine is eerily quiet.")
		return
	. += span_info("Port 1 - <span style='color:[netjack ? "green" : "red"]'>•</span>")
	. += span_info("Port 2 - <span style='color:[terminal ? "green" : "red"]'>•</span>")
	. += span_info("Alarm - <span style='color:[!loop_alarm ? "green" : "red"]'>•</span>")
	. += span_info("System - <span style='color:[is_operational ? "green" : "red"]'>•</span>")
	return

/obj/machinery/netbridge/screwdriver_act(mob/living/user, obj/item/tool)
	if(default_deconstruction_screwdriver(user, null, null, tool))
		update_appearance()
		return TRUE

/obj/machinery/netbridge/wrench_act(mob/living/user, obj/item/tool)
	if(default_change_direction_wrench(user, tool))
		terminal?.master = null
		terminal = null
		var/turf/T = get_step(src, dir)
		for(var/obj/machinery/power/terminal/term in T)
			if(term.dir == turn(dir, 180))
				terminal = term
				terminal.master = src
				to_chat(user, span_notice("Terminal found."))
				break
		if(!terminal)
			to_chat(user, span_alert("No power terminal found."))
			return TRUE
		set_machine_stat(machine_stat & ~BROKEN)
		update_appearance()
		return TRUE

/obj/machinery/netbridge/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	//building and linking a terminal
	if(!istype(tool, /obj/item/stack/cable_coil))
		return NONE

	if(ISDIAGONALDIR(get_dir(user,src)))//we don't want diagonal click
		return NONE //Continue the rest of the chain if diagonal.

	if(terminal) //is there already a terminal ?
		to_chat(user, span_warning("[src] already has a power terminal!"))
		return ITEM_INTERACT_BLOCKING

	if(!panel_open) //is the panel open ?
		to_chat(user, span_warning("You must open the maintenance panel first!"))
		return ITEM_INTERACT_BLOCKING

	var/turf/T = get_turf(user)
	if (T.underfloor_accessibility < UNDERFLOOR_INTERACTABLE) //can we get to the underfloor?
		to_chat(user, span_warning("You must first remove the floor plating!"))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/stack/cable_coil/C = tool
	if(C.get_amount() < 10)
		to_chat(user, span_warning("You need more wires!"))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice("You start attaching the terminal..."))
	playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)

	if(do_after(user, src, 2 SECONDS, DO_PUBLIC, display = C))
		if(C?.get_amount() < 10)
			//Amount changed mid do-after, or cable vanished.
			return ITEM_INTERACT_BLOCKING
		var/obj/structure/cable/N = T.get_cable_node() //get the connecting node cable, if there's one
		if (prob(50) && electrocute_mob(usr, N, N, 1, TRUE)) //animate the electrocution if uncautious and unlucky
			do_sparks(5, TRUE, src)
			return ITEM_INTERACT_BLOCKING
		if(!terminal)
			C.use(10)
			user.visible_message(span_notice("[user.name] builds a power terminal."))

			//build the terminal and link it to the network
			make_terminal(T)
			terminal.connect_to_network()
			return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING


/obj/machinery/netbridge/multitool_act(mob/living/user, obj/item/tool)
	. = TRUE
	visible_message(span_notice("[user] begins resetting [src]."), blind_message = span_hear("You hear cheap plastic creaking."), vision_distance = COMBAT_MESSAGE_RANGE)
	if(!tool.use_tool(src, user, 2 SECOND, INFINITY, 50))
		return
	visible_message(span_notice("[src] whirrs like a jet engine, before settling down..."), blind_message = span_hear("You hear a jet engine."))

	loop_alarm = FALSE
	if(!link_to_jack()) //success is falsy. kapu why did you let me do that.
		visible_message(span_notice("[src]'s 'Port 1' lamp blinks green."), vision_distance = COMBAT_MESSAGE_RANGE)
	else
		visible_message(span_warning("[src]'s 'Port 1' lamp blinks red."), vision_distance = COMBAT_MESSAGE_RANGE)
	return

/obj/machinery/netbridge/proc/make_terminal(turf/T)
	terminal = new/obj/machinery/power/terminal(T)
	terminal.setDir(get_dir(T,src))
	terminal.master = src
	set_machine_stat(machine_stat & ~BROKEN)

/obj/machinery/netbridge/update_icon_state()
	. = ..()
	//This looks like shit because the icon states are named like shit and I don't want to bother touching them.
	var/suffix = "on"
	if(loop_alarm || !netjack || !terminal || (machine_stat & BROKEN))
		suffix = "halt"
	if(machine_stat & NOPOWER)
		suffix = "off"
	if(panel_open) //Overrides the icon state.
		suffix = "on_t"
	icon_state = "[base_icon_state]-[suffix]"

/obj/machinery/netbridge/proc/loop_alarm()
	loop_alarm = TRUE
	playsound(src, 'sound/machines/twobeep.ogg', 50, FALSE)
	visible_message(span_warning("[src] aggressively flashes."))
	update_icon()

// On receipt, clone the signal and send it out the other port.
/obj/machinery/netbridge/receive_wireline_signal(datum/signal/signal, obj/machinery/power/packet_source)
	if(!terminal || !netjack || loop_alarm || !is_operational)
		return //No point, or we've tripped the safety.
	if(signal.check_bridge(src)) //Have we already seen this signal?
		loop_alarm()
		return
	// Clone and rewrite the signal author.
	var/datum/signal/signal_to_forward = signal.Copy()
	signal_to_forward.author = WEAKREF(src)

	// Signal come in, signal go out.
	if(packet_source == netjack)
		terminal.post_signal(signal_to_forward)
	else
		netjack.post_signal(signal_to_forward)
