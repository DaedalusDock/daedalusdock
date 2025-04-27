/obj/machinery/computer4
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"

	network_flags = NETWORK_FLAG_USE_DATATERMINAL // Does not get a net ID

	#warn TODO: move all but operating_system into the operating system itself. No reason a computer needs to control these.
	/// The current focused program.
	var/tmp/datum/c4_file/terminal_program/active_program
	/// The operating system.
	var/tmp/datum/c4_file/terminal_program/operating_system/thinkdos/operating_system
	/// All programs currently running on the machine.
	var/tmp/list/datum/c4_file/terminal_program/processing_programs = list()

	/// k:v list of peripherals where key is the peripheral type and v is a reference.
	var/tmp/list/obj/item/peripheral/peripherals = list()

	/// Screen text buffer.
	var/text_buffer = ""

	// Read-only vars for making the computer
	var/screen_bg_color = "#1B1E1B"
	var/screen_font_color = "#19A319"

	/// k:v list of ckey to a list of past inputs.
	var/list/tgui_input_history = list()
	/// k:v list of ckey to a number that indexes into the input history, used to update tgui_last_accessed.
	var/list/tgui_input_index = list()
	/// k:v list of ckey to the last used command.
	var/list/tgui_last_accessed = list()

	/// List of program typepaths to install by default
	var/list/default_programs = list(
		/datum/c4_file/terminal_program/notepad,
		/datum/c4_file/terminal_program/probe,
	)
	/// The directory to install them in
	var/default_program_dir = "/programs"

/obj/machinery/computer4/Initialize(mapload)
	#warn debug
	. = ..()
	set_internal_disk(new /obj/item/disk/data)

	internal_disk.root.try_add_file(new /datum/c4_file/terminal_program/operating_system/thinkdos)

	if(length(default_programs))
		var/datum/c4_file/folder/program_dir = internal_disk.root.parse_directory(default_program_dir, internal_disk.root, create_if_missing = TRUE)
		for(var/program_path in default_programs)
			program_dir.try_add_file(new program_path)

	add_peripheral(new /obj/item/peripheral/network_card/wireless)
	add_peripheral(new /obj/item/peripheral/card_reader)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer4/LateInitialize()
	. = ..()
	if(is_operational)
		post_system()

/obj/machinery/computer4/on_set_is_operational(old_value)
	if(is_operational)
		post_system()
	else
		unload_program(active_program)
		set_operating_system(null)
		text_buffer = ""

/obj/machinery/computer4/set_internal_disk(obj/item/disk/data/disk)
	if(internal_disk)
		internal_disk.computer = null

	. = ..()

	if(internal_disk)
		internal_disk.computer = src

/obj/machinery/computer4/set_inserted_disk(obj/item/disk/data/disk)
	if(inserted_disk)
		inserted_disk.computer = null

	. = ..()

	if(inserted_disk)
		inserted_disk.computer = src

/// Getter for retrieving peripherals in program code.
/obj/machinery/computer4/proc/get_peripheral(peripheral_type)
	return peripherals[peripheral_type]

/// Adds a peripheral to the peripherals list. Does not handle physical location.
/obj/machinery/computer4/proc/add_peripheral(obj/item/peripheral/new_peri)
	new_peri.forceMove(src)

	peripherals[new_peri.peripheral_type] = new_peri
	RegisterSignal(new_peri, COMSIG_MOVABLE_MOVED, PROC_REF(peripheral_gone))

	new_peri.on_attach(src)

/// Removes a peripheral from the peripherals list. Does not handle physical location.
/obj/machinery/computer4/proc/remove_peripheral(obj/item/peripheral/to_remove)
	peripherals -= to_remove.peripheral_type
	UnregisterSignal(to_remove, COMSIG_MOVABLE_MOVED)

	to_remove.on_detach(src)

/obj/machinery/computer4/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(.)
		return

	if(istype(weapon, /obj/item/peripheral))
		var/obj/item/peripheral/peripheral = weapon
		if(peripherals[peripheral])
			to_chat(user, span_warning("There is already a peripheral in that slot."))
			return TRUE

		if(!user.transferItemToLoc(peripheral, src))
			return TRUE

		add_peripheral(peripheral)
		user.visible_message(span_notice("[user] inserts [peripheral] into [src]."))
		return TRUE

/// Called by peripherals to interface with the computer
/obj/machinery/computer4/proc/peripheral_input(obj/item/peripheral/invoker, command, datum/signal/packet)
	if(!is_operational)
		return

	for(var/datum/c4_file/terminal_program/program as anything in processing_programs)
		program.peripheral_input(invoker, command, packet)

/obj/machinery/computer4/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src)
	if(!ui)
		ui = new(user, src, "Terminal")
		ui.open()

/obj/machinery/computer4/ui_data(mob/user)
	tgui_last_accessed[user.ckey] ||= ""
	var/list/data = list(
		"displayHTML" = text_buffer,
		"terminalActive" = !!active_program,
		"floppy" = inserted_disk,
		"windowName" = name,
		"user" = user,
		"fontColor" = screen_font_color,
		"bgColor" = screen_bg_color,
		"inputValue" = tgui_last_accessed[user.ckey],
		"peripherals" = list(),
	)
	return data

/obj/machinery/computer4/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("text")
			if(!active_program || !params["value"])
				return

			operating_system.try_std_in(params["value"])
			add_history(usr.ckey, params["value"])
			playsound(loc, SFX_KEYBOARD, 50, 1, -15)
			return TRUE

		if("history")
			if (params["direction"] == "prev")
				return traverse_history(usr.ckey, -1)

			if (params["direction"] == "next")
				return traverse_history(usr.ckey,  1)

/// Get the history entry at a certain index. Returns null if the index is out of bounds or the ckey is null. Will return an empty string for length+1
/obj/machinery/computer4/proc/get_history(ckey, index)
	if (isnull(ckey))
		return ""

	// Allow length+1 to simulate hitting the 'end' of the history and ending up on an empty line
	if (index == length(tgui_input_history[ckey]) + 1)
		return ""

	// Ensure index with key exists
	if(!islist(tgui_input_history[ckey]))
		return ""

	// Ensure we can return a value
	if (index < 1 || length(tgui_input_history[ckey]) < index)
		return ""

	return tgui_input_history[ckey][index]

/obj/machinery/computer4/proc/add_history(ckey, new_history)
	LAZYADD(tgui_input_history[ckey], new_history)

	// Ensure not over limit after adding new entry
	if (length(tgui_input_history) > 10)
		tgui_input_history[ckey] -= tgui_input_history[ckey][1]

	// After typing something else in the console, history is always most recent entry
	tgui_input_index[ckey] = length(tgui_input_history[ckey])

/// Traverse the current history by some amount. Returns true if different history was accessed, false otherwise (usually if new index OOB)
/obj/machinery/computer4/proc/traverse_history(ckey, amount)
	// Most recent entry in history if first time accessing
	tgui_input_index[ckey] ||= length(tgui_input_history[ckey])

	// Ensure previous history exists
	var/result = get_history(ckey, tgui_input_index[ckey] + amount)
	if (isnull(result))
		return FALSE

	tgui_input_index[ckey] = tgui_input_index[ckey] + amount
	tgui_last_accessed[ckey] = result
	return TRUE

/obj/machinery/computer4/proc/post_system()
	text_buffer = ""

	text_buffer += "Initializing system...<br>"

	if(!internal_disk)
		text_buffer = "<font color=red>1701 - NO FIXED DISK</font><br>"

	// Os already known.
	if(operating_system)
		var/existing_active_program = active_program
		execute_program(operating_system)
		execute_program(existing_active_program)

	// Okay let's try the foreign disk.
	if(!operating_system && inserted_disk)
		var/datum/c4_file/terminal_program/operating_system/new_os = locate() in inserted_disk?.root.contents

		if(new_os)
			text_buffer += "Booting from inserted drive...<br>"
			execute_program(new_os)
		else
			text_buffer += "<font color=red>Non-system disk or disk error.</font><br>"

	// Okay how about the internal drive?
	if(!operating_system && internal_disk)
		var/datum/c4_file/terminal_program/operating_system/new_os = locate() in internal_disk?.root.contents

		if(new_os)
			text_buffer += "Booting from fixed drive...<br>"
			execute_program(new_os)
		else
			text_buffer += "<font color=red>Unable to boot from fixed drive.</font><br>"


	// Fuck.
	if(!operating_system)
		text_buffer += "<font color=red>ERR - BOOT FAILURE</font><br>"

	SStgui.update_uis(src)

/// Run a program.
/obj/machinery/computer4/proc/execute_program(datum/c4_file/terminal_program/program)
	if(!program)
		return FALSE

	if(!(program in processing_programs))
		add_processing_program(program)

	if(!operating_system && istype(program, /datum/c4_file/terminal_program/operating_system))
		set_operating_system(program)


	set_active_program(program)
	program.execute()
	return TRUE

/// Close a program.
/obj/machinery/computer4/proc/unload_program(datum/c4_file/terminal_program/program)
	if(!program)
		return FALSE

	if(!(program in processing_programs))
		CRASH("Tried tried to remove a program we aren't even running.")

	remove_processing_program(program)

	if(active_program == program)
		set_active_program(operating_system)

	return TRUE

/// Move a program to background
/obj/machinery/computer4/proc/try_background_program(datum/c4_file/terminal_program/program)
	if(length(processing_programs) > 6) // Sane limit IMO
		return FALSE

	if(active_program == program)
		set_active_program(operating_system)

	return TRUE

/// Setter for the processing programs list. Use execute_program() instead!
/obj/machinery/computer4/proc/add_processing_program(datum/c4_file/terminal_program/program)
	PRIVATE_PROC(TRUE)

	processing_programs += program
	RegisterSignal(program, list(COMSIG_PARENT_QDELETING, COMSIG_COMPUTER4_FILE_MOVED), PROC_REF(processing_program_moved))

/// Setter for the processing programs list. Use unload_program() instead!
/obj/machinery/computer4/proc/remove_processing_program(datum/c4_file/terminal_program/program)
	processing_programs -= program
	UnregisterSignal(program, list(COMSIG_PARENT_QDELETING, COMSIG_COMPUTER4_FILE_MOVED))

/// Setter for active program. Use execute_program() or unload_program() instead!
/obj/machinery/computer4/proc/set_active_program(datum/c4_file/terminal_program/program)
	PRIVATE_PROC(TRUE)

	active_program = program

/// Setter for operating system.
/obj/machinery/computer4/proc/set_operating_system(datum/c4_file/terminal_program/operating_system/os)
	PRIVATE_PROC(TRUE)

	var/datum/c4_file/terminal_program/operating_system/old_os = operating_system
	operating_system = os

	if(!operating_system)
		for(var/datum/c4_file/terminal_program/program as anything in processing_programs)
			unload_program(program)

		unload_program(old_os)
		text_buffer = ""

/// Handles any running programs being moved in the filesystem.
/obj/machinery/computer4/proc/processing_program_moved(datum/source)
	SIGNAL_HANDLER

	if(source == operating_system)
		if(QDELING(source))
			set_operating_system(null)
			return

		// Check if it's still in the root of either disk, this is fine :)
		if(operating_system in internal_disk?.root.contents)
			return

		if(operating_system in inserted_disk?.root.contents)
			return

		// OS is not in a root folder, KILL!!!
		set_operating_system(null)
		return


	unload_program(active_program)

/// Handles a peripheral moving.
/obj/machinery/computer4/proc/peripheral_gone(obj/item/peripheral/source)
	SIGNAL_HANDLER

	remove_peripheral(source)
