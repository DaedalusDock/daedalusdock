GLOBAL_LIST_EMPTY(bodyscanscreens)

DEFINE_INTERACTABLE(/obj/machinery/body_scan_display)
/obj/machinery/body_scan_display
	name = "body scan display"
	desc = "A wall-mounted display linked to a body scanner."
	icon = 'icons/obj/machines/bodyscan_displays.dmi'
	icon_state = "telescreen"

	var/current_content = ""

/obj/machinery/body_scan_display/Initialize(mapload)
	. = ..()
	GLOB.bodyscanscreens += src
	setDir(dir)

/obj/machinery/body_scan_display/Destroy()
	GLOB.bodyscanscreens -= src
	return ..()

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/body_scan_display, 32)

/obj/machinery/body_scan_display/setDir(ndir)
	. = ..()
	switch(dir)
		if(NORTH)
			pixel_y = 32
			base_pixel_y = 32
			pixel_x = 0
			base_pixel_x = 0
		if(SOUTH)
			pixel_y = -32
			base_pixel_y = -32
			pixel_x = 0
			base_pixel_x = 0
		if(EAST)
			pixel_y = 0
			base_pixel_y = 0
			pixel_x = 32
			base_pixel_x = 32
		if(WEST)
			pixel_y = 0
			base_pixel_y = 0
			pixel_x = -32
			base_pixel_x = -32

/obj/machinery/body_scan_display/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	. += image(icon, "operating")
	. += emissive_appearance(icon, "operating", alpha = 90)

/obj/machinery/body_scan_display/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["erase"])
		current_content = null
		updateUsrDialog()
		return TRUE

/obj/machinery/body_scan_display/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/datum/browser/popup = new(user, "bodyscanner", "Body Scanner", 600, 800)
	popup.set_content(get_content())
	popup.open()

/obj/machinery/body_scan_display/proc/push_content(content)
	current_content = content
	updateUsrDialog()
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/body_scan_display/proc/get_content()
	. += {"
		<fieldset class='computerPaneSimple' style='margin: 10px auto;text-align:center'>
				[button_element(src, "Erase Scan", "erase=1")]
		</fieldset>
	"}

	. += current_content
