/obj/machinery/computer/holomap


/obj/machinery/computer/holomap/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Holomap", name)
		ui.open()

/obj/machinery/computer/holomap/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/holomaps)
