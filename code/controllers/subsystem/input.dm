VERB_MANAGER_SUBSYSTEM_DEF(input)
	name = "Input"
	init_order = INIT_ORDER_INPUT
	init_stage = INITSTAGE_EARLY
	flags = SS_TICKER
	priority = FIRE_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	use_default_stats = FALSE

	/// Standard macroset *ALL* players get
	var/list/macro_set
	/// Macros applied only to hotkey users
	var/list/hotkey_only_set
	/// Macros applied onlt to classic users
	var/list/classic_only_set
	/// Typecache of all unprintable keys that are safe for classic to bind
	var/list/unprintables_cache
	/// Macro IDs we shouldn't clear during client.clear_macros()
	var/list/protected_macro_ids

	///running average of how many clicks inputted by a player the server processes every second. used for the subsystem stat entry
	var/clicks_per_second = 0
	///count of how many clicks onto atoms have elapsed before being cleared by fire(). used to average with clicks_per_second.
	var/current_clicks = 0
	///acts like clicks_per_second but only counts the clicks actually processed by SSinput itself while clicks_per_second counts all clicks
	var/delayed_clicks_per_second = 0
	///running average of how many movement iterations from player input the server processes every second. used for the subsystem stat entry
	var/movements_per_second = 0
	///running average of the amount of real time clicks take to truly execute after the command is originally sent to the server.
	///if a click isnt delayed at all then it counts as 0 deciseconds.
	var/average_click_delay = 0

/datum/controller/subsystem/verb_manager/input/Initialize()
	setup_default_macro_sets()

	initialized = TRUE

	refresh_client_macro_sets()

	return ..()

// This is for when macro sets are eventualy datumized
/datum/controller/subsystem/verb_manager/input/proc/setup_default_macro_sets()
	macro_set = list(
		// These could probably just be put in the skin. I actually don't 	understand WHY they aren't just in the skin. Besides the use of defines for Tab.
		"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
		"Tab" = "\".winset \\\"input.focus=true?map.focus=true input.background-color=[COLOR_INPUT_DISABLED]:input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
		"Escape" = "Reset-Held-Keys",
	)
	hotkey_only_set = list(
		"Any" = "\"KeyDown \[\[*\]\]\"",
		"Any+UP" = "\"KeyUp \[\[*\]\]\"",
	)
	classic_only_set = list(
		//We need to force these to capture them for macro modifiers.
		//Did I mention I fucking despise the way this system works at a base, almost reptilian-barely-understands-consciousness level?
		//Because I do.
		"Alt" = "\"KeyDown Alt\"",
		"Alt+UP" = "\"KeyUp Alt\"",
		"Ctrl" = "\"KeyDown Ctrl\"",
		"Ctrl+UP" = "\"KeyUp Ctrl\"",
	)
	// This list may be out of date, and may include keys not actually legal to bind? The only full list is from 2008. http://www.byond.com/docs/notes/macro.html
	unprintables_cache = list(
		// Arrow Keys
		"North" = TRUE,
		"West" = TRUE,
		"East" = TRUE,
		"South" = TRUE,
		// Numpad-Lock Disabled
		"Northwest" = TRUE, // KP_Home
		"Northeast" = TRUE, // KP_PgUp
		"Center" = TRUE,
		"Southwest" = TRUE, // KP_End
		"Southeast" = TRUE, // KP_PgDn
		// Keys you really shouldn't touch, but are technically unprintable
		"Return" = TRUE,
		"Escape" = TRUE,
		"Delete" = TRUE,
		// Things I'm not sure BYOND actually supports anymore.
		"Select" = TRUE,
		"Execute" = TRUE,
		"Snapshot" = TRUE,
		"Attn" = TRUE,
		"CrSel" = TRUE,
		"ExSel" = TRUE,
		"ErEOF" = TRUE,
		"Zoom" = TRUE,
		"PA1" = TRUE,
		"OEMClear" = TRUE,
		// Things the modern ref says is okay
		"Pause" = TRUE,
		"Play" = TRUE,
		"Insert" = TRUE,
		"Help" = TRUE,
		"LWin" = TRUE,
		"RWin" = TRUE,
		"Apps" = TRUE,
		"Numpad0" = TRUE,
		"Numpad1" = TRUE,
		"Numpad2" = TRUE,
		"Numpad3" = TRUE,
		"Numpad4" = TRUE,
		"Numpad5" = TRUE,
		"Numpad6" = TRUE,
		"Numpad7" = TRUE,
		"Numpad8" = TRUE,
		"Numpad9" = TRUE,
		"Multiply" = TRUE,
		"Add" = TRUE,
		"Separator" = TRUE,
		"Subtract" = TRUE,
		"Decimal" = TRUE,
		"Divide" = TRUE,
		"F1" = TRUE,
		"F2" = TRUE,
		"F3" = TRUE,
		"F4" = TRUE,
		"F5" = TRUE,
		"F6" = TRUE,
		"F7" = TRUE,
		"F8" = TRUE,
		"F9" = TRUE,
		"F10" = TRUE,
		"F11" = TRUE,
		"F12" = TRUE,
		"F13" = TRUE,
		"F14" = TRUE,
		"F15" = TRUE,
		"F16" = TRUE,
		"F17" = TRUE,
		"F18" = TRUE,
		"F19" = TRUE,
		"F20" = TRUE,
		"F21" = TRUE,
		"F22" = TRUE,
		"F23" = TRUE,
		"F24" = TRUE,
	)
	// Macro IDs we don't delete on wipe, Usually stuff baked into the skin, or that we have to be more careful with.
	protected_macro_ids = list(
		"PROTECTED-Shift",
		"PROTECTED-ShiftUp"
	)

// Badmins just wanna have fun ♪
/datum/controller/subsystem/verb_manager/input/proc/refresh_client_macro_sets()
	var/list/clients = GLOB.clients
	for(var/i in 1 to clients.len)
		var/client/user = clients[i]
		user.set_macros()

/datum/controller/subsystem/verb_manager/input/can_queue_verb(datum/callback/verb_callback/incoming_callback, control)
	//make sure the incoming verb is actually something we specifically want to handle
	if(control != "mapwindow.map")
		return FALSE

	if((average_click_delay > MAXIMUM_CLICK_LATENCY || !..()) && !always_queue)
		current_clicks++
		average_click_delay = MC_AVG_FAST_UP_SLOW_DOWN(average_click_delay, 0)
		return FALSE

	return TRUE

///stupid workaround for byond not recognizing the /atom/Click typepath for the queued click callbacks
/atom/proc/_Click(location, control, params)
	if(usr)
		Click(location, control, params)

/datum/controller/subsystem/verb_manager/input/fire()
	..()

	var/moves_this_run = 0
	for(var/mob/user in GLOB.keyloop_list)
		moves_this_run += user.focus?.keyLoop(user.client)//only increments if a player moves due to their own input

	movements_per_second = MC_AVG_SECONDS(movements_per_second, moves_this_run, wait TICKS)

/datum/controller/subsystem/verb_manager/input/run_verb_queue()
	var/deferred_clicks_this_run = 0 //acts like current_clicks but doesnt count clicks that dont get processed by SSinput

	for(var/datum/callback/verb_callback/queued_click as anything in verb_queue)
		if(!istype(queued_click))
			stack_trace("non /datum/callback/verb_callback instance inside SSinput's verb_queue!")
			continue

		average_click_delay = MC_AVG_FAST_UP_SLOW_DOWN(average_click_delay, TICKS2DS((DS2TICKS(world.time) - queued_click.creation_time)))
		queued_click.InvokeAsync()

		current_clicks++
		deferred_clicks_this_run++

	verb_queue.Cut() //is ran all the way through every run, no exceptions

	clicks_per_second = MC_AVG_SECONDS(clicks_per_second, current_clicks, wait SECONDS)
	delayed_clicks_per_second = MC_AVG_SECONDS(delayed_clicks_per_second, deferred_clicks_this_run, wait SECONDS)
	current_clicks = 0

/datum/controller/subsystem/verb_manager/input/stat_entry(msg)
	. = ..()
	. += "M/S:[round(movements_per_second,0.01)] | C/S:[round(clicks_per_second,0.01)] ([round(delayed_clicks_per_second,0.01)] | CD: [round(average_click_delay / (1 SECONDS),0.01)])"

