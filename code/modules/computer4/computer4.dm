/obj/machinery/computer4
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"

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
	internal_disk = new /obj/item/disk/data
	internal_disk.root.computer = src
	internal_disk.root.try_add_file(new /datum/c4_file/terminal_program/operating_system/thinkdos)

	. = ..()
	post_system()

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
	var/list/new_text_buffer = list()
	text_buffer = ""

	new_text_buffer += "Initializing system..."

	if(!internal_disk)
		new_text_buffer = "<font color=red>1701 - NO FIXED DISK</font>"

	// Os already known.
	if(operating_system)
		var/existing_active_program = active_program
		execute_program(operating_system)
		execute_program(existing_active_program)

	// Okay let's try the foreign disk.
	if(!operating_system && inserted_disk)
		var/datum/c4_file/terminal_program/operating_system/new_os = locate() in inserted_disk?.root.contents

		if(new_os)
			new_text_buffer += "Booting from inserted drive..."
			execute_program(new_os)
		else
			new_text_buffer += "<font color=red>Non-system disk or disk error.</font>"

	// Okay how about the internal drive?
	if(!operating_system && internal_disk)
		var/datum/c4_file/terminal_program/operating_system/new_os = locate() in internal_disk?.root.contents

		if(new_os)
			new_text_buffer += "Booting from fixed drive..."
			execute_program(new_os)
		else
			new_text_buffer += "<font color=red>Unable to boot from fixed drive.</font>"


	// Fuck.
	if(!operating_system)
		new_text_buffer += "<font color=red>ERR - BOOT FAILURE</font>"

	text_buffer = jointext(new_text_buffer, "<br>") + "<br>"
	SStgui.update_uis(src)

/obj/machinery/computer4/proc/execute_program(datum/c4_file/terminal_program/program)
	if(!program)
		return FALSE

	if(!operating_system && istype(program, /datum/c4_file/terminal_program/operating_system))
		operating_system = program // Hard dels are avoided by os Destroy

	active_program = program
	program.execute()
	return TRUE
