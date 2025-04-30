/// Board and drive are not in place and screwed in yet.
#define STATE_COMPONENT_MANIPULATION 0
/// Board and drive screwed in.
#define STATE_COMPONENTS_INSTALLED 2
/// Wires placed.
#define STATE_WIRED 3
/// Victor Pride?
#define STATE_GLASSED 4

// TODO: rewrite this entire goddamn thing post item_interaction https://github.com/tgstation/tgstation/pull/81477

/obj/structure/frame/computer
	name = "computer frame"
	icon_state = "0"
	state = STATE_COMPONENT_MANIPULATION

	var/circuit_screwed = FALSE
	var/drive_screwed = FALSE

	/// The hard drive used in construction.
	var/obj/item/disk/data/hard_drive

/obj/structure/frame/computer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/// Attempt to advance to the next state
/obj/structure/frame/computer/proc/try_change_state(new_state)
	switch(new_state)
		if(STATE_COMPONENTS_INSTALLED)
			if(!circuit_screwed || !drive_screwed)
				return FALSE

	state = new_state
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/structure/frame/computer/update_icon_state()
	. = ..()
	if(!circuit)
		icon_state = 0
		return

	if(state == STATE_COMPONENT_MANIPULATION)
		icon_state = "1"
		return

	icon_state = "[state]"

/obj/structure/frame/computer/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(.)
		return

	if(default_unfasten_wrench(user, tool, 4 SECONDS))
		return TRUE

/obj/structure/frame/computer/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(.)
		return

	if(state == STATE_GLASSED)
		finish_construction(user, tool)
		return TRUE

	if(!(state in list(STATE_COMPONENT_MANIPULATION, STATE_COMPONENTS_INSTALLED)))
		return

	if(!circuit && !hard_drive)
		return

	var/obj/item/target
	if(circuit && hard_drive)
		target = tgui_input_list(user, "Select a part to modify", "Machine Frame", list(circuit, hard_drive))
		if(!target || !user.canUseTopic(src))
			return TRUE

	target ||= circuit || hard_drive

	if(target == circuit)
		tool.play_tool_sound(src)
		circuit_screwed = !circuit_screwed
		to_chat(user, span_notice("You [circuit_screwed ? "screw in" : "unscrew"] the circuit."))
		if(circuit_screwed)
			try_change_state(STATE_COMPONENTS_INSTALLED)
		else
			try_change_state(STATE_COMPONENT_MANIPULATION)
		return TRUE

	if(target == hard_drive)
		tool.play_tool_sound(src)
		drive_screwed = !drive_screwed
		to_chat(user, span_notice("You [drive_screwed ? "screw in" : "unscrew"] the drive."))
		if(drive_screwed)
			try_change_state(STATE_COMPONENTS_INSTALLED)
		else
			try_change_state(STATE_COMPONENT_MANIPULATION)
		return TRUE

/obj/structure/frame/computer/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(.)
		return

	// Remove glass panel
	if(state == STATE_GLASSED)
		tool.play_tool_sound(src)
		to_chat(user, span_notice("You remove the glass panel."))
		try_change_state(STATE_WIRED)
		var/obj/item/stack/sheet/glass/G = new(drop_location(), 2)
		if (!QDELETED(G))
			G.add_fingerprint(user)
		return TRUE

	if((state == STATE_COMPONENT_MANIPULATION) && !circuit_screwed && !drive_screwed)
		var/obj/item/target
		if((circuit && !circuit_screwed) && (hard_drive && !drive_screwed))
			target = tgui_input_list(user, "Select a part to remove", "Machine Frame", list(circuit, hard_drive))
			if(!target || !user.canUseTopic(src))
				return TRUE

		target ||= (!circuit_screwed && circuit) || hard_drive

		tool.play_tool_sound(src)
		to_chat(user, span_notice("You remove [target]."))

		target.forceMove(drop_location())
		target.add_fingerprint(user)

		if(target == circuit)
			circuit = null
		else
			hard_drive = null
		return TRUE

/obj/structure/frame/computer/wirecutter_act(mob/living/user, obj/item/tool)
	. = ..()
	if(.)
		return

	if(state != STATE_WIRED)
		return

	tool.play_tool_sound(src)
	to_chat(user, span_notice("You remove the cables."))
	try_change_state(STATE_COMPONENTS_INSTALLED)

	var/obj/item/stack/cable_coil/A = new (drop_location(), 5)
	if (!QDELETED(A))
		A.add_fingerprint(user)

	return TRUE

/obj/structure/frame/computer/welder_act(mob/living/user, obj/item/tool)
	. = ..()
	if(.)
		return

	if(state != STATE_COMPONENT_MANIPULATION)
		return

	if(circuit)
		to_chat(user, span_warning("You must remove the circuit before deconstructing."))
		return TRUE

	if(hard_drive)
		to_chat(user, span_warning("You must remove the hard drive before deconstructing."))
		return TRUE

	if(!tool.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, span_notice("You start deconstructing the frame..."))
	if(tool.use_tool(src, user, 2 SECONDS, volume=50))
		to_chat(user, span_notice("You deconstruct the frame."))
		var/obj/item/stack/sheet/iron/M = new (drop_location(), 5)
		if (!QDELETED(M))
			M.add_fingerprint(user)

		deconstruct(TRUE)
	return TRUE

/obj/structure/frame/computer/proc/try_place_circuit(obj/item/I, mob/living/user, params)
	if(!istype(I, /obj/item/circuitboard/computer))
		to_chat(user, span_warning("That frame does not accept circuit boards of this type."))
		return TRUE

	if(circuit)
		to_chat(user, span_warning("There is already a board installed."))
		return TRUE

	if(!user.transferItemToLoc(I, src))
		return TRUE

	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	to_chat(user, span_notice("You place [I] inside the frame."))
	circuit = I
	circuit.add_fingerprint(user)
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/structure/frame/computer/proc/try_place_drive(obj/item/I, mob/living/user, params)
	var/obj/item/disk/data/data_disk = I
	if(!data_disk.is_hard_drive)
		to_chat(user, span_warning("A floppy disk is not a suitable hard drive."))
		return TRUE

	if(hard_drive)
		to_chat(user, span_warning("There is already a board installed."))
		return TRUE

	if(!user.transferItemToLoc(I, src))
		return TRUE

	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	to_chat(user, span_notice("You place [I] inside the frame."))
	hard_drive = I
	hard_drive.add_fingerprint(user)
	return TRUE

/obj/structure/frame/computer/proc/try_place_cable(obj/item/I, mob/living/user, params)
	if(!I.tool_start_check(user, amount=5))
		return

	to_chat(user, span_notice("You start adding cables to the frame..."))
	if(I.use_tool(src, user, 2 SECONDS, volume=50, amount=5))
		if(state != 2)
			return TRUE

		to_chat(user, span_notice("You add cables to the frame."))
		try_change_state(STATE_WIRED)
		return TRUE

/obj/structure/frame/computer/proc/try_place_glass(obj/item/I, mob/living/user, params)
	if(!I.tool_start_check(user, amount=2))
		return TRUE

	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	to_chat(user, span_notice("You start to put in the glass panel..."))

	if(I.use_tool(src, user, 2 SECONDS, amount=2))
		if(state != STATE_WIRED)
			return TRUE

		to_chat(user, span_notice("You put in the glass panel."))
		try_change_state(STATE_GLASSED)
	return TRUE

/obj/structure/frame/computer/attackby(obj/item/P, mob/living/user, params)
	switch(state)
		if(STATE_COMPONENT_MANIPULATION)
			if(istype(P, /obj/item/circuitboard/computer) && try_place_circuit(P, user, params))
				return TRUE

			if(istype(P, /obj/item/disk/data) && try_place_drive(P, user, params))
				return TRUE

		if(STATE_COMPONENTS_INSTALLED)
			if(istype(P, /obj/item/stack/cable_coil) && try_place_cable(P, user, params))
				return TRUE

		if(STATE_WIRED)
			if(istype(P, /obj/item/stack/sheet/glass) && try_place_glass(P, user, params))
				return TRUE

	return ..()

/obj/structure/frame/computer/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/structure/frame/computer/deconstruct(disassembled = TRUE)
	if((flags_1 & NODECONSTRUCT_1))
		return ..()

	if(state == STATE_GLASSED)
		if(disassembled)
			new /obj/item/stack/sheet/glass(drop_location(), 2)
		else
			new /obj/item/shard(drop_location())
			new /obj/item/shard(drop_location())

	if(state >= STATE_WIRED)
		new /obj/item/stack/cable_coil(drop_location(), 5)


/// Screwing in the glass panel
/obj/structure/frame/computer/proc/finish_construction(mob/living/user, obj/item/I, params)
	I.play_tool_sound(src)
	to_chat(user, span_notice("You connect the monitor."))

	var/obj/machinery/new_machine = new circuit.build_path(loc)
	new_machine.setDir(dir)
	transfer_fingerprints_to(new_machine)

	if(!istype(new_machine, /obj/machinery/computer) && !istype(new_machine, /obj/machinery/computer4))
		qdel(src)
		return

	var/obj/machinery/computer/new_computer = new_machine
	new_machine.clear_components()

	// Set anchor state and move the frame's parts over to the new machine.
	// Then refresh parts and call on_construction().
	new_computer.set_anchored(anchored)
	new_computer.component_parts = list()

	circuit.forceMove(new_computer)
	new_computer.component_parts += circuit
	new_computer.circuit = circuit

	hard_drive.forceMove(new_computer)
	new_computer.component_parts += hard_drive

	for(var/atom/movable/movable_part in src)
		movable_part.forceMove(new_computer)
		new_computer.component_parts += movable_part

	new_computer.RefreshParts()
	new_computer.on_construction()

	qdel(src)
