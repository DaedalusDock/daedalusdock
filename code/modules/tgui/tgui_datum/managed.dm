/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

//Note to self, Hire a lawyer and figure out the legality of my changes here -Francinum, 4/11/24

/*
 * TGUI Compiled UI Holder. Impliments the UI Holder Interface, with support for Compiled (Inferno/React/Etc.) TGUI Interfaces.
 */

/**
 * Compiled tgui datum (represents a UI).
 */
/datum/tgui/managed

	allow_suspend = TRUE
	/// The interface (template) to be used for this UI.
	var/interface
	/// Key that is used for remembering the window geometry.
	var/window_key
	/// Deprecated: Window size.
	var/window_size

/* Moved to base type, Refactor out later.
	/// The mob who opened/is using the UI.
	// var/mob/user
	/// The object which owns the UI.
	// var/datum/src_object
	/// The title of te UI.
	// var/title
	/// The window_id for browse() and onclose().
	// var/datum/tgui_window/window


	/// Update the UI every MC tick.
	// var/autoupdate = TRUE
	/// If the UI has been initialized yet.
	// var/initialized = FALSE
	/// Time of opening the window.
	// var/opened_at
	/// Stops further updates when close() was called.
	// var/closing = FALSE
	// /// The status/visibility of the UI.
	// var/status = UI_INTERACTIVE
	/// Timed refreshing state
	// var/refreshing = FALSE

	/// Rate limit client refreshes to prevent DoS.
	// COOLDOWN_DECLARE(refresh_cooldown)
*/

/**
 * public
 *
 * Create a new UI.
 *
 * required user mob The mob who opened/is using the UI.
 * required src_object datum The object or datum which owns the UI.
 * required interface string The interface used to render the UI.
 * optional title string The title of the UI.
 * optional ui_x int Deprecated: Window width.
 * optional ui_y int Deprecated: Window height.
 *
 * return datum/tgui The requested UI.
 */
/datum/tgui/managed/New(mob/user, datum/src_object, interface, title, ui_x, ui_y)
	log_tgui(user,
		"new [interface] fancy [user?.client?.prefs.read_preference(/datum/preference/toggle/tgui_fancy)]",
		src_object = src_object)
	src.user = user
	src.src_object = src_object
	src.window_key = "[REF(src_object)]-main"
	src.interface = interface
	if(title)
		src.title = title
	src.state = src_object.ui_state(user)
	// Deprecated
	if(ui_x && ui_y)
		src.window_size = list(ui_x, ui_y)

/datum/tgui/managed/Destroy()
	user = null
	src_object = null
	return ..()

/**
 * public
 *
 * Open this UI (and initialize it with data).
 *
 * return bool - TRUE if a new pooled window is opened, FALSE in all other situations including if a new pooled window didn't open because one already exists.
 */
/datum/tgui/managed/open()
	if(!user.client)
		return FALSE
	if(window)
		return FALSE
	process_status()
	if(status < UI_UPDATE)
		return FALSE
	window = SStgui.request_pooled_window(user)
	if(!window)
		return FALSE
	opened_at = world.time
	window.acquire_lock(src)
	if(!window.is_ready())
		window.initialize(
			strict_mode = TRUE,
			fancy = user.client.prefs.read_preference(/datum/preference/toggle/tgui_fancy),
			assets = list(
				get_asset_datum(/datum/asset/simple/tgui),
			))
	else
		window.send_message("ping")

	var/flush_queue = window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/fontawesome))
	flush_queue |= window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/tgfont))

	for(var/datum/asset/asset in src_object.ui_assets(user))
		flush_queue |= window.send_asset(asset)

	if (flush_queue)
		user.client.browse_queue_flush()

	window.send_message("update", get_payload(
		with_data = TRUE,
		with_static_data = TRUE))
	SStgui.on_open(src)

	return TRUE

// /datum/tgui/managed/close() uses base implimentation.
// /datum/tgui/managed/send_asset() uses base implimentation.
// /datum/tgui/managed/set_autoupdate() uses base implimentation.
// /datum/tgui/managed/set_state() uses base implimentation.
// /datum/tgui/managed/send_full_update() uses base implimentation.
// /datum/tgui/managed/send_update() uses base implimentation.
// /datum/tgui/managed/process() uses base implimentation.

/**
 * private
 *
 * Package the data to send to the UI, as JSON.
 *
 * return list
 */
/datum/tgui/managed/get_payload(custom_data, with_data, with_static_data)
	var/list/json_data = list()
	json_data["config"] = list(
		"title" = title,
		"status" = status,
		"interface" = interface,
		"refreshing" = refreshing,
		"window" = list(
			"key" = window_key,
			"size" = window_size,
			"fancy" = user.client.prefs.read_preference(/datum/preference/toggle/tgui_fancy),
			"locked" = user.client.prefs.read_preference(/datum/preference/toggle/tgui_lock),
		),
		"client" = list(
			"ckey" = user.client.ckey,
			"address" = user.client.address,
			"computer_id" = user.client.computer_id,
		),
		"user" = list(
			"name" = "[user]",
			"observer" = isobserver(user),
		),
	)
	var/data = custom_data || with_data && src_object.ui_data(user)
	if(data)
		json_data["data"] = data
	var/static_data = with_static_data && src_object.ui_static_data(user)
	if(static_data)
		json_data["static_data"] = static_data
	if(src_object.tgui_shared_states)
		json_data["shared"] = src_object.tgui_shared_states
	return json_data



/**
 * private
 *
 * Callback for handling incoming tgui messages.
 *
 * ..() == TRUE means that a ui_act message has been passed to the source object.
 *
 */
/datum/tgui/managed/on_message(type, list/payload, list/href_list)
	if(!..())
		return
	switch(type)
		if("ready")
			// Send a full update when the user manually refreshes the UI
			if(initialized)
				send_full_update()
			initialized = TRUE
		if("ping/reply")
			initialized = TRUE
		if("suspend")
			close(can_be_suspended = TRUE)
		if("close")
			close(can_be_suspended = FALSE)
		if("log")
			if(href_list["fatal"])
				close(can_be_suspended = FALSE)
		if("setSharedState")
			if(status != UI_INTERACTIVE)
				return
			LAZYINITLIST(src_object.tgui_shared_states)
			src_object.tgui_shared_states[href_list["key"]] = href_list["value"]
			SStgui.update_uis(src_object)
