/obj/machinery/computer4

	/// The current running/focused program.
	var/tmp/datum/c4_file/terminal_program/active_program

	/// Screen text buffer.
	var/text_buffer = ""

	// Read-only vars for making the computer
	var/screen_bg_color = "#1B1E1B"
	var/screen_font_color = "#19A319"

/obj/machinery/computer4/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src)
	if(!ui)
		ui = new(user, src, "Terminal")
		ui.open()

/obj/machinery/computer4/ui_data(mob/user)
	var/list/data = list(
		"displayHTML" = text_buffer,
		"terminalActive" = !!active_program,
		"floppy" = inserted_disk,
		"windowName" = name,
		"user" = user,
		"fontColor" = screen_font_color,
		"bgColor" = screen_bg_color,
		"inputValue" = "" // Fix this
	)
	return data

