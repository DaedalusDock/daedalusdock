MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/holomap, 32)

/obj/machinery/holomap
	name = "station map"
	desc = "A monitor containing a map of the station."
	icon = 'icons/obj/machines/station_map.dmi'
	icon_state = "station_map"

	var/datum/holomap_holder/station/holomap

	/// Is TRUE if this was built on a z level that doesn't have a map.
	var/bogus = FALSE
	/// The original Z of this map. Aka, what map were going to display.
	var/initial_z = null

/obj/machinery/holomap/Initialize(mapload)
	. = ..()
	initial_z = z

	if(SSholomap.initialized)
		setup_holomap()
	else
		RegisterSignal(SSdcs, COMSIG_GLOB_HOLOMAPS_READY, PROC_REF(setup_holomap))

/obj/machinery/holomap/Destroy()
	QDEL_NULL(holomap)
	return ..()

/obj/machinery/holomap/setDir(ndir)
	. = ..()
	switch(dir)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/holomap/update_overlays()
	. = ..()

	var/image/floor_image = image(icon, "station_map_floor")
	floor_image.plane = FLOOR_PLANE
	floor_image.layer = TURF_DECAL_HIGH_LAYER
	switch(dir)
		if(NORTH)
			floor_image.pixel_y = -32
		if(SOUTH)
			floor_image.pixel_y = 32
		if(EAST)
			floor_image.pixel_x = -32
		if(WEST)
			floor_image.pixel_x = 32
	. += floor_image

	if(!bogus && is_operational && SSholomap.initialized && (initial_z <= length(SSholomap.minimaps)))
		. += SSholomap.minimaps[initial_z]["[dir]"]
		. += emissive_appearance(SSholomap.minimap_icons[initial_z]["[dir]"], alpha = 90)

/obj/machinery/holomap/update_icon_state()
	if(is_operational)
		if(length(holomap?.viewer_map))
			icon_state = "station_map_activate"
		else
			icon_state = "station_map"
	else
		icon_state = "station_map0"
	return ..()

/obj/machinery/holomap/set_is_operational(new_value)
	. = ..()

	if(!is_operational)
		holomap.remove_all_viewers()

/obj/machinery/holomap/ui_interact(mob/user, special_state)
	if(holomap.viewer_map[user])
		holomap.remove_viewer(user)
		return

	holomap.show_to(user)

/// Sets up the actual holomap datum.
/obj/machinery/holomap/proc/setup_holomap(datum/source)
	SIGNAL_HANDLER

	var/icon/I = SSholomap.get_holomap(initial_z)
	if(isnull(I))
		bogus = TRUE
		holomap = new /datum/holomap_holder/invalid(src, null)

	else
		holomap = new(src, I)

	update_appearance(UPDATE_OVERLAYS)

	RegisterSignal(holomap, COMSIG_HOLOMAP_VIEWER_REMOVED, PROC_REF(holomap_viewer_gone))
	RegisterSignal(holomap, COMSIG_HOLOMAP_VIEWER_GAINED, PROC_REF(holomap_viewer_gain))

/obj/machinery/holomap/proc/holomap_viewer_gain(datum/source, mob/viewer)
	SIGNAL_HANDLER
	update_appearance(UPDATE_ICON_STATE)
	RegisterSignal(viewer, COMSIG_MOVABLE_MOVED, PROC_REF(viewer_moved))

/obj/machinery/holomap/proc/holomap_viewer_gone(datum/source, mob/viewer)
	SIGNAL_HANDLER
	update_appearance(UPDATE_ICON_STATE)

	UnregisterSignal(viewer, COMSIG_MOVABLE_MOVED)

/obj/machinery/holomap/proc/viewer_moved(mob/source)
	SIGNAL_HANDLER

	if(source.z && source.Adjacent(src))
		return

	holomap.remove_viewer(source)
