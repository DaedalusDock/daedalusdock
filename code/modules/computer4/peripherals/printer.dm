/obj/item/peripheral/printer
	name = "printer module"
	desc = "A small printer designed for voidcomputers."
	icon_state = "card_mod"

	peripheral_type = PERIPHERAL_TYPE_PRINTER

	/// Set to TRUE while printing.
	var/busy = FALSE

/// Begin printing paper with the given text.
/obj/item/peripheral/printer/proc/print(text, title)
	if(busy)
		return FALSE

	busy = TRUE
	addtimer(CALLBACK(src, PROC_REF(finish_print), text), 5 SECONDS)
	return TRUE

/// Finish printing.
/obj/item/peripheral/printer/proc/finish_print(text, title)
	busy = FALSE

	if(!master_pc?.is_operational)
		return

	playsound(src, 'goon/sounds/printer.ogg', 50)

	var/obj/item/paper/thermal/sheet = new(drop_location())
	sheet.setText("<tt>[text]</tt>")
	if(title)
		sheet.name = "paper - [title]"

	master_pc.visible_message(span_notice("[master_pc] prints out [sheet]."))
