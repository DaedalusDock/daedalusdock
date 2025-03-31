// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/update_appearance(updates=check_updates())
	icon_update_needed = FALSE
	if(!updates)
		return

	. = ..()
	// And now, separately for cleanness, the lighting changing
	if(!update_state)
		switch(charging)
			if(APC_NOT_CHARGING)
				set_light_color(COLOR_SOFT_RED)
			if(APC_CHARGING)
				set_light_color(LIGHT_COLOR_BLUE)
			if(APC_FULLY_CHARGED)
				set_light_color(LIGHT_COLOR_GREEN)
		set_light(l_outer_range = light_on_outer_range, l_inner_range = light_on_inner_range, l_power = light_on_power)
		return

	if(update_state & UPSTATE_BLUESCREEN)
		set_light_color(LIGHT_COLOR_BLUE)
		set_light(l_outer_range = light_on_outer_range, l_inner_range = light_on_inner_range, l_power = light_on_power)
		return

	set_light(0)

/obj/machinery/power/apc/update_icon_state()
	if(!update_state)
		icon_state = "apc0"
		return ..()
	if(update_state & (UPSTATE_OPENED1|UPSTATE_OPENED2))
		var/basestate = "apc[cell ? 2 : 1]"
		if(update_state & UPSTATE_OPENED1)
			icon_state = (update_state & (UPSTATE_MAINT|UPSTATE_BROKE)) ? "apcmaint" : basestate
		else if(update_state & UPSTATE_OPENED2)
			icon_state = "[basestate][((update_state & UPSTATE_BROKE) || malfhack) ? "-b" : null]-nocover"
		return ..()
	if(update_state & UPSTATE_BROKE)
		icon_state = "apc-b"
		return ..()
	if(update_state & UPSTATE_BLUESCREEN)
		icon_state = "apcemag"
		return ..()
	if(update_state & UPSTATE_WIREEXP)
		icon_state = "apcewires"
		return ..()
	if(update_state & UPSTATE_MAINT)
		icon_state = "apc0"
	return ..()

/obj/machinery/power/apc/update_overlays()
	. = ..()
	if((machine_stat & (BROKEN|MAINT)) || update_state)
		return

	. += mutable_appearance(icon, "apcox-[locked]")
	. += emissive_appearance(icon, "apcox-[locked]", alpha = 90)
	. += mutable_appearance(icon, "apco3-[charging]")
	. += emissive_appearance(icon, "apco3-[charging]", alpha = 90)
	if(!operating)
		return

//Heehoo stole this pattern from bay along with their APC sprite -fran
	var/static/list/map_apc_statcode_to_color = list(
		COLOR_RED, //APC_CHANNEL_OFF
		COLOR_ORANGE, //APC_CHANNEL_AUTO_OFF
		COLOR_LIME, //APC_CHANNEL_ON
		COLOR_BLUE //APC_CHANNEL_AUTO_ON
	)
	var/mutable_appearance/colorbuffer

	colorbuffer = mutable_appearance(icon, "apco0")
	colorbuffer.color = map_apc_statcode_to_color[equipment+1]
	. += colorbuffer
	. += emissive_appearance(icon, "apco0", alpha = 90)

	colorbuffer = mutable_appearance(icon, "apco1")
	colorbuffer.color = map_apc_statcode_to_color[lighting+1]
	. += colorbuffer
	. += emissive_appearance(icon, "apco1")

	colorbuffer = mutable_appearance(icon, "apco2", alpha = 90)
	colorbuffer.color = map_apc_statcode_to_color[environ+1]
	. += colorbuffer
	. += emissive_appearance(icon, "apco2", alpha = 90)

/// Checks for what icon updates we will need to handle
/obj/machinery/power/apc/proc/check_updates()
	SIGNAL_HANDLER
	. = NONE

	// Handle icon status:
	var/new_update_state = NONE
	if(machine_stat & BROKEN)
		new_update_state |= UPSTATE_BROKE
	if(machine_stat & MAINT)
		new_update_state |= UPSTATE_MAINT

	if(opened)
		new_update_state |= (opened << UPSTATE_COVER_SHIFT)
		if(cell)
			new_update_state |= UPSTATE_CELL_IN

	else if((obj_flags & EMAGGED) || malfai)
		new_update_state |= UPSTATE_BLUESCREEN
	else if(panel_open)
		new_update_state |= UPSTATE_WIREEXP

	if(new_update_state != update_state)
		update_state = new_update_state
		. |= UPDATE_ICON_STATE

	// Handle overlay status:
	var/new_update_overlay = NONE
	if(operating)
		new_update_overlay |= UPOVERLAY_OPERATING

	if(!update_state)
		if(locked)
			new_update_overlay |= UPOVERLAY_LOCKED

		new_update_overlay |= (charging << UPOVERLAY_CHARGING_SHIFT)
		new_update_overlay |= (equipment << UPOVERLAY_EQUIPMENT_SHIFT)
		new_update_overlay |= (lighting << UPOVERLAY_LIGHTING_SHIFT)
		new_update_overlay |= (environ << UPOVERLAY_ENVIRON_SHIFT)

	if(new_update_overlay != update_overlay)
		update_overlay = new_update_overlay
		. |= UPDATE_OVERLAYS


// Used in process so it doesn't update the icon too much
/obj/machinery/power/apc/proc/queue_icon_update()
	icon_update_needed = TRUE
