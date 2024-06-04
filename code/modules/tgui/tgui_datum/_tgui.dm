/**
 * TGUI Abstract-Class UI Holder. Defines the interface required for both flavors of UI.
 *
 * Directly creating this type is illegal.
 */
/datum/tgui
	abstract_type = /datum/tgui

	/// The mob who opened/is using the UI.
	var/mob/user
	/// The object which owns the UI.
	var/datum/src_object
	/// The title of te UI.
	var/title
	/// The window_id for browse() and onclose().
	var/datum/tgui_window/window

	/// The status/visibility of the UI.
	var/status = UI_INTERACTIVE
	/// Topic state used to determine status/interactability.
	var/datum/ui_state/state = null
	/// Time of opening the window.
	var/opened_at
	/// Stops further updates when close() was called.
	var/closing = FALSE
	/// Update the UI every MC tick.
	var/autoupdate = TRUE
	/// If the UI has been initialized yet.
	var/initialized = FALSE
	/// Timed refreshing state
	var/refreshing = FALSE

	/// Allows window suspension (Required by Managed TGUI Pooling)
	var/allow_suspend = FALSE

	/// Rate limit client refreshes to prevent DoS.
	COOLDOWN_DECLARE(refresh_cooldown)

/**
 * public
 *
 * Open this UI (and initialize it with data).
 *
 * This should create and assign a tgui_window datum.
 *
 *
 */
/datum/tgui/proc/open()
	CRASH("TGUI Handler of type [type] does not impliment open()")

/**
 * public
 *
 * Close the UI.
 *
 */
/datum/tgui/proc/close(can_be_suspended = TRUE)
	if(closing)
		return
	if(!allow_suspend) //If we disallow suspension, always hard close.
		can_be_suspended = FALSE
	closing = TRUE
	// If we don't have window, open proc did not have the opportunity
	// to finish, therefore it's safe to skip this whole block.
	if(window)
		// Windows you want to keep are usually blue screens of death
		// and we want to keep them around, to allow user to read
		// the error message properly.
		window.release_lock()
		window.close(can_be_suspended)
		src_object.ui_close(user)
		SStgui.on_close(src)
	state = null
	qdel(src)

/**
 * private
 *
 * Package the data to send to the UI, as JSON.
 *
 * return list
 */
/datum/tgui/proc/get_payload(custom_data, with_data, with_static_data)
	CRASH("TGUI Handler of type [type] does not impliment get_payload()")

/**
 * public
 *
 * Send a full update to the client (includes static data).
 *
 * optional custom_data list Custom data to send instead of ui_data.
 * optional force bool Send an update even if UI is not interactive.
 */
/datum/tgui/proc/send_full_update(custom_data, force)
	if(!user.client || !initialized || closing)
		return
	if(!COOLDOWN_FINISHED(src, refresh_cooldown))
		refreshing = TRUE
		addtimer(CALLBACK(src, PROC_REF(send_full_update)), TGUI_REFRESH_FULL_UPDATE_COOLDOWN, TIMER_UNIQUE)
		return
	refreshing = FALSE
	var/should_update_data = force || status >= UI_UPDATE
	window.send_message("update", get_payload(
		custom_data,
		with_data = should_update_data,
		with_static_data = TRUE))
	COOLDOWN_START(src, refresh_cooldown, TGUI_REFRESH_FULL_UPDATE_COOLDOWN)

/**
 * public
 *
 * Send a partial update to the client (excludes static data).
 *
 * optional custom_data list Custom data to send instead of ui_data.
 * optional force bool Send an update even if UI is not interactive.
 */
/datum/tgui/proc/send_update(custom_data, force)
	if(!user.client || !initialized || closing)
		return
	var/should_update_data = force || status >= UI_UPDATE
	window.send_message("update", get_payload(
		custom_data,
		with_data = should_update_data))

/**
 * public
 *
 * Makes an asset available to use in tgui.
 *
 * required asset datum/asset
 *
 * return bool - true if an asset was actually sent
 */
/datum/tgui/proc/send_asset(datum/asset/asset)
	if(!window)
		CRASH("send_asset() was called either without calling open() first or when open() did not return TRUE.")
	return window.send_asset(asset)

/**
 * private
 *
 * Callback for handling incoming tgui messages.
 *
 * Call parent first.
 * ..() == TRUE means that a ui_act message has been passed to the source object.
 *
 */
/datum/tgui/proc/on_message(type, list/payload, list/href_list)
	SHOULD_CALL_PARENT(TRUE)
	// Pass act type messages to ui_act
	if(type && copytext(type, 1, 5) == "act/")
		var/act_type = copytext(type, 5)
		log_tgui(user, "Action: [act_type] [href_list["payload"]]",
			window = window,
			src_object = src_object)
		process_status()
		DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(on_act_message), act_type, payload, state))
		return FALSE
	return TRUE // Not an `act/`, must be handled by the specific UI handler.

/**
 * private
 *
 * Updates the status, and returns TRUE if status has changed.
 */
/datum/tgui/proc/process_status()
	var/prev_status = status
	status = src_object.ui_status(user, state)
	return prev_status != status

/**
 * private
 *
 * Run an update cycle for this UI. Called internally by SStgui
 * every second or so.
 */
/datum/tgui/process(delta_time, force = FALSE)
	if(closing)
		return
	var/datum/host = src_object.ui_host(user)
	// If the object or user died (or something else), abort.
	if(QDELETED(src_object) || QDELETED(host) || QDELETED(user) || QDELETED(window))
		close(can_be_suspended = FALSE)
		return
	// Validate ping
	if(!initialized && world.time - opened_at > TGUI_PING_TIMEOUT)
		log_tgui(user, "Error: Zombie window detected, closing.",
			window = window,
			src_object = src_object)
		close(can_be_suspended = FALSE)
		return
	// Update through a normal call to ui_interact
	if(status != UI_DISABLED && (autoupdate || force))
		src_object.ui_interact(user, src)
		return
	// Update status only
	var/needs_update = process_status()
	if(status <= UI_CLOSE)
		close()
		return
	if(needs_update)
		window.send_message("update", get_payload())

/**
 * public
 *
 * Enable/disable auto-updating of the UI.
 *
 * required value bool Enable/disable auto-updating.
 */
/datum/tgui/proc/set_autoupdate(autoupdate)
	src.autoupdate = autoupdate

/**
 * public
 *
 * Replace current ui.state with a new one.
 *
 * required state datum/ui_state/state Next state
 */
/datum/tgui/proc/set_state(datum/ui_state/state)
	src.state = state

/// Wrapper for behavior to potentially wait until the next tick if the server is overloaded
/datum/tgui/proc/on_act_message(act_type, payload, state)
	if(QDELETED(src) || QDELETED(src_object))
		return
	if(src_object.ui_act(act_type, payload, src, state))
		SStgui.update_uis(src_object)
