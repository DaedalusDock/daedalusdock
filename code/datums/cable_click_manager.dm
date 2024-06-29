/datum/cable_click_manager
	var/obj/item/stack/cable_coil/parent
	var/mob/user

	/// Mouse catcher
	var/atom/movable/screen/fullscreen/cursor_catcher/catcher
	var/image/phantom_wire
	var/image/phantom_knot

	var/turf/tracked_turf
	var/position_1
	var/position_2

/datum/cable_click_manager/New(new_parent)
	parent = new_parent

	phantom_knot = image('icons/obj/power_cond/cable.dmi', "0")
	phantom_knot.appearance_flags = APPEARANCE_UI
	phantom_knot.plane = ABOVE_LIGHTING_PLANE
	phantom_knot.color = parent.color
	phantom_knot.alpha = 128
	phantom_knot.filters += outline_filter(1, COLOR_RED)

	phantom_wire = image('icons/obj/power_cond/cable.dmi')
	phantom_wire.appearance_flags = APPEARANCE_UI
	phantom_wire.plane = GAME_PLANE
	phantom_wire.layer = FLY_LAYER
	phantom_wire.color = parent.color
	phantom_wire.alpha = 128
	phantom_wire.filters += outline_filter(1, COLOR_RED)

/datum/cable_click_manager/Destroy(force, ...)
	set_user(null)
	parent = null
	STOP_PROCESSING(SSkinesis, src)
	return ..()

// WIRE_LAYER
/datum/cable_click_manager/proc/set_user(mob/new_user)
	if(user == new_user)
		return

	if(catcher)
		QDEL_NULL(catcher)

	if(user)
		UnregisterSignal(user, list(COMSIG_MOB_LOGIN, COMSIG_MOB_LOGOUT, COMSIG_MOB_SWAP_HANDS, COMSIG_MOB_CLICKON))
		user.clear_fullscreen("cable_laying", FALSE)
		user.client?.images -= phantom_wire
		user.client?.images -= phantom_knot

	position_1 = null
	position_2 = null
	STOP_PROCESSING(SSkinesis, src)

	user = new_user
	if(!user)
		return

	RegisterSignal(user, COMSIG_MOB_LOGIN, PROC_REF(on_login))
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	RegisterSignal(user, COMSIG_MOB_SWAP_HANDS, PROC_REF(on_swap_hands))
	RegisterSignal(user, COMSIG_MOB_CLICKON, PROC_REF(intercept_click))

	if(user.client)
		create_catcher()
		disable_catcher()

/datum/cable_click_manager/proc/create_catcher()
	user.client.images |= phantom_wire
	user.client.images |= phantom_knot

	catcher = user.overlay_fullscreen("cable_laying", /atom/movable/screen/fullscreen/cursor_catcher/cable, 0)
	catcher.assign_to_mob(user)

	if(user.get_active_held_item() != parent)
		catcher.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	else
		START_PROCESSING(SSkinesis, src)

	RegisterSignal(catcher, COMSIG_CLICK, PROC_REF(on_catcher_click))

/// Turn on the catcher.
/datum/cable_click_manager/proc/enable_catcher()
	catcher.mouse_opacity = MOUSE_OPACITY_OPAQUE
	START_PROCESSING(SSkinesis, src)

/// Turn off the catcher and clear all state.
/datum/cable_click_manager/proc/disable_catcher()
	catcher.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	clear_state()
	STOP_PROCESSING(SSkinesis, src)

/datum/cable_click_manager/proc/on_catcher_click(atom/source, location, control, params)
	SIGNAL_HANDLER

	if(user.incapacitated())
		return

	params = params2list(params)
	if(!length(params))
		return

	if(params[RIGHT_CLICK])
		if(position_1)
			clear_state()
			return

		disable_catcher()
		to_chat(usr, span_obviousnotice("Advanced wire placement disabled."))
		return

	var/turf/T = parse_caught_click_modifiers(params, get_turf(user.client.eye), user.client)
	if(!T || (tracked_turf && T != tracked_turf))
		return

	if(!T.Adjacent(user))
		return

	var/list/screen_split = splittext(params[SCREEN_LOC], ",")
	var/list/x_split = splittext(screen_split[1], ":")
	var/list/y_split = splittext(screen_split[2], ":")

	var/grid_cell = get_nonant_from_pixels(text2num(x_split[2]), text2num(y_split[2]))

	if(T.underfloor_accessibility < UNDERFLOOR_INTERACTABLE || !T.can_have_cabling())
		to_chat(user, span_warning("[T] can not have cables."))
		clear_state()
		return

	if(user.canface())
		user.face_atom(T)

	if(!tracked_turf)
		position_1 = grid_cell
		phantom_knot.loc = T
		offset_image_to_nonant_cell(position_1, phantom_knot)
		tracked_turf = T
		return

	if(try_place_wire(T, (position_1 | grid_cell)))
		clear_state()

/datum/cable_click_manager/process(delta_time)
	if(tracked_turf && !tracked_turf.Adjacent(user))
		clear_state()
		return

	var/list/params = params2list(catcher.mouse_params)
	if(!length(params) || !params[SCREEN_LOC])
		return

	var/turf/T = parse_caught_click_modifiers(params, get_turf(user.client.eye), user.client)
	if(!T)
		return

	if(!T.Adjacent(user))
		phantom_wire.loc = null
		return

	if(tracked_turf && (T != tracked_turf))
		return

	var/list/screen_split = splittext(params[SCREEN_LOC], ",")
	var/list/x_split = splittext(screen_split[1], ":")
	var/list/y_split = splittext(screen_split[2], ":")

	var/grid_cell = get_nonant_from_pixels(text2num(x_split[2]), text2num(y_split[2]))

	if(isnull(position_1))
		phantom_wire.icon_state = "0"
		phantom_wire.loc = T
		offset_image_to_nonant_cell(grid_cell, phantom_wire)
		return

	position_2 = grid_cell
	phantom_wire.loc = T
	phantom_wire.pixel_x = 0
	phantom_wire.pixel_y = 0
	phantom_wire.icon_state = "[position_1 | position_2]"

/datum/cable_click_manager/proc/try_place_wire(turf/T, cable_direction = NONE)
	return parent.place_turf(T, user, cable_direction)

/datum/cable_click_manager/proc/clear_state()
	tracked_turf = null
	phantom_knot.loc = null
	phantom_wire.loc = null
	position_1 = null
	position_2 = null

// Nonant grid
// 1 2 3
// 4 5 6
// 7 8 9
/// Returns the nonant cell the mouse is in based on the pixel offsets.
/datum/cable_click_manager/proc/get_nonant_from_pixels(pixel_x = 0, pixel_y = 0)
	var/nonant_row
	var/nonant_column
	switch(pixel_x)
		if(0 to 10)
			nonant_row = 1
		if(11 to 22)
			nonant_row = 2
		else
			nonant_row = 3

	switch(pixel_y)
		if(0 to 10)
			nonant_column = 6
		if(11 to 22)
			nonant_column = 3
		else
			nonant_column = 0

	var/static/list/lookup = list(
		CABLE_NORTHWEST, CABLE_NORTH, CABLE_NORTHEAST,
		CABLE_WEST,      0          , CABLE_EAST,
		CABLE_SOUTHWEST, CABLE_SOUTH, CABLE_SOUTHEAST
	)

	return lookup[nonant_row + nonant_column]

/datum/cable_click_manager/proc/offset_image_to_nonant_cell(cell, image/I)
	switch(cell)
		if(CABLE_NORTHWEST)
			I.pixel_x = 0
			I.pixel_y = 32
		if(CABLE_NORTH)
			I.pixel_x = 16
			I.pixel_y = 32
		if(CABLE_NORTHEAST)
			I.pixel_x = 32
			I.pixel_y = 32
		if(CABLE_WEST)
			I.pixel_x = 0
			I.pixel_y = 16
		if(0)
			I.pixel_x = 16
			I.pixel_y = 16
		if(CABLE_EAST)
			I.pixel_x = 32
			I.pixel_y = 16
		if(CABLE_SOUTHWEST)
			I.pixel_x = 0
			I.pixel_y = 0
		if(CABLE_SOUTH)
			I.pixel_x = 16
			I.pixel_y = 0
		if(CABLE_SOUTHEAST)
			I.pixel_x = 32
			I.pixel_y = 0

	I.pixel_x -= 16
	I.pixel_y -= 16

/datum/cable_click_manager/proc/on_login()
	SIGNAL_HANDLER
	if(!user.client)
		return

	if(!catcher)
		create_catcher()
		disable_catcher()
	else
		START_PROCESSING(SSkinesis, src)

/datum/cable_click_manager/proc/on_logout()
	SIGNAL_HANDLER
	STOP_PROCESSING(SSkinesis, src)

/datum/cable_click_manager/proc/on_swap_hands()
	SIGNAL_HANDLER
	if(!catcher)
		return

	spawn(0) // There is no signal for AFTER you swap hands
		if(!user)
			return

		if(user.get_active_held_item() == parent)
			catcher.mouse_opacity = MOUSE_OPACITY_OPAQUE
			START_PROCESSING(SSkinesis, src)
		else
			disable_catcher()

/datum/cable_click_manager/proc/intercept_click(datum/source, atom/A, params)
	SIGNAL_HANDLER

	if(!catcher)
		return

	if(!params[RIGHT_CLICK])
		return

	if(catcher.mouse_opacity != MOUSE_OPACITY_OPAQUE)
		enable_catcher()
		to_chat(usr, span_obviousnotice("Advanced wire placement enabled."))
		return COMSIG_MOB_CANCEL_CLICKON

/atom/movable/screen/fullscreen/cursor_catcher/cable
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_OPAQUE
