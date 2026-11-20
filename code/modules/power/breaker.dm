TYPEINFO_DEF(/obj/machinery/power/breaker)
	default_armor = list(BLUNT = 20, PUNCTURE = 20, SLASH = 0, LASER = 10, ENERGY = 100, BOMB = 30, BIO = 100, FIRE = 90, ACID = 50)

/obj/machinery/power/breaker
	name = "breaker box"
	desc = "A machine to bridge multiple cable networks."
	icon = 'icons/obj/breakerbox.dmi'
	icon_state = "bbox"

	density = TRUE
	anchored = TRUE

	var/obj/machinery/power/terminal/terminal = null
	/// When active, it is merging the two powernets.
	var/active = TRUE

	COOLDOWN_DECLARE(toggle_cd)

/obj/machinery/power/breaker/Initialize(mapload)
	. = ..()

	var/static/list/loc_connections = list(
		COMSIG_TURF_GET_CABLE_CONNECTIONS = PROC_REF(loc_get_cable_connections),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

	SET_TRACKING(__TYPE__)
	dir_loop:
		for(var/d in GLOB.cardinals)
			var/turf/T = get_step(src, d)
			for(var/obj/machinery/power/terminal/term in T)
				if(term && term.dir == turn(d, 180))
					terminal = term
					break dir_loop

	if(terminal)
		connect_terminal(terminal)
	connect_to_network()
	update_appearance()

/obj/machinery/power/breaker/Destroy()
	UNSET_TRACKING(__TYPE__)

	active = FALSE
	regenerate_networks()

	if(SSticker.IsRoundInProgress())
		var/turf/T = get_turf(src)
		message_admins("[src] deleted at [ADMIN_VERBOSEJMP(T)]")
		log_game("[src] deleted at [AREACOORD(T)]")
		investigate_log("deleted at [AREACOORD(T)]", INVESTIGATE_ENGINE)

	if(terminal)
		disconnect_terminal()
	return ..()

/obj/machinery/power/breaker/examine(mob/user)
	. = ..()
	if(!get_step(src, 0).get_cable_node())
		. += span_alert("It is not connected to a power network.")

	if(!terminal)
		. += span_alert("It is not connected to a terminal.")

	else if(get_step(terminal, 0).get_cable_node())
		. += span_alert("The terminal is not connected to a power network.")

	if(panel_open)
		. += span_info("The maintenance panel is open.")

	. += span_info("It is turned [active ? "on" : "off"].")

/obj/machinery/power/breaker/update_overlays()
	. = ..()

	if(active && get_step(src, 0).get_cable_node() && get_step(terminal, 0)?.get_cable_node())
		. += image(icon, "bbox_lights")
		. += emissive_appearance(icon, "bbox_lights")
	else
		. += image(icon, "bbox_lights_fault")
		. += emissive_appearance(icon, "bbox_lights_fault")

	if(panel_open)
		. += image(icon, "bbox_panel_overlay")

/obj/machinery/power/breaker/proc/make_terminal(turf/T)
	terminal = new/obj/machinery/power/terminal(T)
	terminal.setDir(get_dir(T,src))

	connect_terminal(terminal)
	update_appearance()

/obj/machinery/power/breaker/disconnect_terminal()
	var/obj/structure/cable/terminal_node = get_step(terminal, 0)?.get_cable_node()
	if(terminal)
		terminal.master = null
		UnregisterSignal(terminal, COMSIG_PARENT_QDELETING)
		UnregisterSignal(terminal.loc, COMSIG_TURF_GET_CABLE_CONNECTIONS)

	terminal?.master = null
	terminal = null
	update_appearance()

	if(terminal_node)
		terminal_node.cut_cable_from_powernet(remove = FALSE)
		terminal_node.auto_propagate_cut_cable()

	// Only generates the network belonging to the breaker, since terminal is now null.
	regenerate_networks()

/obj/machinery/power/breaker/proc/connect_terminal(obj/machinery/power/terminal/new_terminal)
	if(terminal)
		disconnect_terminal()

	terminal = new_terminal
	new_terminal.master = src

	RegisterSignal(new_terminal, COMSIG_PARENT_QDELETING, PROC_REF(on_terminal_delete))
	RegisterSignal(terminal.loc, COMSIG_TURF_GET_CABLE_CONNECTIONS, PROC_REF(terminal_get_cable_connections))

	regenerate_networks()

/// Rebuild the network across the line, or don't, if the breaker isn't on.
/obj/machinery/power/breaker/proc/regenerate_networks()
	var/obj/structure/cable/our_cable = get_step(src, 0).get_cable_node()
	our_cable?.cut_cable_from_powernet(remove = FALSE, propagate_network = FALSE)

	var/obj/structure/cable/terminal_cable = get_step(terminal, 0)?.get_cable_node()
	terminal_cable?.cut_cable_from_powernet(remove = FALSE, propagate_network = FALSE)

	// Due to ordering, priority is handed to the network on the breaker turf.
	our_cable?.merge_new_connections()
	terminal_cable?.merge_new_connections()

/obj/machinery/power/breaker/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(!panel_open)
		try_toggle(user)
		return TRUE

/obj/machinery/power/breaker/attack_ai(mob/user)
	. = ..()
	try_toggle(user, FALSE)

/// Toggle the breaker.
/obj/machinery/power/breaker/proc/try_toggle(mob/user, visible_message = TRUE)
	if(!COOLDOWN_FINISHED(src, toggle_cd))
		to_chat(user, span_warning("[src] is cooling down."))
		return FALSE

	COOLDOWN_START(src, toggle_cd, 10 SECONDS)
	playsound(src, 'goon/sounds/button.ogg', 50)

	if(user && visible_message)
		visible_message(span_notice("[user] [active ? "enables" : "disables"] [src]."))

	active = !active
	regenerate_networks()
	update_appearance()

	log_game("Breaker at [AREACOORD(src)] toggled [active ? "on" : "off"][user && "by [key_name(user)]"].")
	return TRUE

/obj/machinery/power/breaker/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	//opening using screwdriver
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	//changing direction using wrench
	if(default_change_direction_wrench(user, tool))
		disconnect_terminal()
		var/turf/T = get_step(src, dir)
		for(var/obj/machinery/power/terminal/term in T)
			if(term && term.dir == turn(dir, 180))
				terminal = term
				terminal.master = src
				break

		if(!terminal)
			to_chat(user, span_alert("No power terminal found."))
			return ITEM_INTERACT_BLOCKING

		connect_terminal(terminal)
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	//building and linking a terminal
	if(istype(tool, /obj/item/stack/cable_coil))
		var/dir = get_dir(user,src)
		if(ISDIAGONALDIR(dir))//we don't want diagonal click
			return NONE

		if(terminal) //is there already a terminal ?
			to_chat(user, span_warning("[src] already has a power terminal."))
			return ITEM_INTERACT_BLOCKING

		if(!panel_open) //is the panel open ?
			to_chat(user, span_warning("The maintenance panel must be open."))
			return ITEM_INTERACT_BLOCKING

		var/turf/T = get_turf(user)
		if (T.underfloor_accessibility < UNDERFLOOR_INTERACTABLE) //can we get to the underfloor?
			to_chat(user, span_warning("Something is blocking the plating."))
			return ITEM_INTERACT_BLOCKING


		var/obj/item/stack/cable_coil/C = tool
		if(C.get_amount() < 10)
			to_chat(user, span_warning("You need [10 - C.get_amount()] more wires."))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice("You start building the power terminal..."))
		playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)

		if(do_after(user, src, 20))
			if(C?.get_amount() < 10)
				return ITEM_INTERACT_BLOCKING

			var/obj/structure/cable/N = T.get_cable_node() //get the connecting node cable, if there's one
			if (prob(50) && electrocute_mob(user, N, N, 1, TRUE)) //animate the electrocution if uncautious and unlucky
				do_sparks(5, TRUE, src)
				return ITEM_INTERACT_BLOCKING

			if(!terminal)
				C.use(10)
				user.visible_message(
					span_notice("[user.name] builds a power terminal."),
				)

				make_terminal(T)
		return ITEM_INTERACT_SUCCESS

	//crowbarring it !
	var/turf/T = get_turf(src)
	if(default_deconstruction_crowbar(tool))
		message_admins("[src] has been deconstructed by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("[src] has been deconstructed by [key_name(user)] at [AREACOORD(src)]")
		investigate_log("deconstructed by [key_name(user)] at [AREACOORD(src)]", INVESTIGATE_ENGINE)
		return ITEM_INTERACT_SUCCESS

/obj/machinery/power/breaker/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(terminal && panel_open)
		terminal.dismantle(user, I)
		return TRUE

/obj/machinery/power/breaker/default_deconstruction_crowbar(obj/item/crowbar/C)
	if(C.tool_behaviour == TOOL_CROWBAR && terminal)
		to_chat(usr, span_warning("You must first remove the power terminal."))
		return FALSE

	return ..()

/// Called when a cable on the breaker's turf is looking for connections.
/obj/machinery/power/breaker/proc/loc_get_cable_connections(datum/source, obj/structure/cable/cable, list/connections, powernetless_only)
	SIGNAL_HANDLER

	if(!active || !terminal)
		return

	if(!cable.is_knotted())
		return


	var/obj/structure/cable/terminal_cable = get_step(terminal, 0).get_cable_node()
	if(terminal_cable)
		connections += terminal_cable

/// Called when a cable on the terminal's turf is looking for connections.
/obj/machinery/power/breaker/proc/terminal_get_cable_connections(datum/source, obj/structure/cable/cable, list/connections, powernetless_only)
	SIGNAL_HANDLER

	if(!active)
		return

	if(!cable.is_knotted())
		return


	var/obj/structure/cable/breaker_cable = get_step(src, 0).get_cable_node()
	if(breaker_cable)
		connections += breaker_cable

/// Called when the terminal is deleted.
/obj/machinery/power/breaker/proc/on_terminal_delete(datum/source)
	SIGNAL_HANDLER
	disconnect_terminal()
