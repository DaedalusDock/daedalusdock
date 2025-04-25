/obj/machinery/computer4
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"

	network_flags = NETWORK_FLAGS_STANDARD_CONNECTION

	/// The current running/focused program.
	var/tmp/datum/c4_file/terminal_program/active_program
	/// The operating system.
	var/tmp/datum/c4_file/terminal_program/operating_system/thinkdos/operating_system

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

/obj/machinery/computer4/Initialize(mapload)
	#warn debug
	. = ..()
	set_internal_disk(new /obj/item/disk/data)
	internal_disk.root.try_add_file(new /datum/c4_file/terminal_program/operating_system/thinkdos)
	internal_disk.root.try_add_file(new /datum/c4_file/terminal_program/notepad)
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

	if(!operating_system && istype(program, /datum/c4_file/terminal_program/operating_system))
		set_operating_system(program) // Hard dels are avoided by os Destroy

	set_active_program(program)
	program.execute()
	return TRUE

/// Close a program.
/obj/machinery/computer4/proc/unload_program(datum/c4_file/terminal_program/program)
	if(!program)
		return FALSE

	if(active_program == program)
		set_active_program(operating_system)

	return TRUE

/// Setter for active program. Use execute_program() or unload_program() instead!
/obj/machinery/computer4/proc/set_active_program(datum/c4_file/terminal_program/program)
	PRIVATE_PROC(TRUE)

	if(active_program)
		UnregisterSignal(active_program, list(COMSIG_PARENT_QDELETING, COMSIG_COMPUTER4_FILE_MOVED))

	active_program = program

	if(active_program && active_program != operating_system) // set_operating_system already does all of this.
		RegisterSignal(active_program, list(COMSIG_PARENT_QDELETING, COMSIG_COMPUTER4_FILE_MOVED), PROC_REF(active_program_moved))

/obj/machinery/computer4/proc/set_operating_system(datum/c4_file/terminal_program/operating_system/os)
	PRIVATE_PROC(TRUE)

	if(os)
		UnregisterSignal(os, list(COMSIG_PARENT_QDELETING, COMSIG_COMPUTER4_FILE_MOVED))

	operating_system = os

	if(os)
		RegisterSignal(operating_system, list(COMSIG_PARENT_QDELETING, COMSIG_COMPUTER4_FILE_MOVED), PROC_REF(operating_system_moved))
	else
		text_buffer = ""

/obj/machinery/computer4/proc/active_program_moved(datum/source)
	SIGNAL_HANDLER

	unload_program(active_program)

/obj/machinery/computer4/proc/operating_system_moved(datum/source)
	SIGNAL_HANDLER

	if(QDELING(operating_system))
		set_operating_system(null)
		return

	// Check if it's still in the root of either disk, this is fine :)
	if(operating_system in internal_disk?.root.contents)
		return

	if(operating_system in inserted_disk?.root.contents)
		return

	// OS is not in a root folder, KILL!!!
	if(operating_system == active_program)
		set_active_program(null)

	set_operating_system(null)
