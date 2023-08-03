// Set a client's focus to an object and override these procs on that object to let it handle keypresses

/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	return
/datum/proc/key_up(key, client/user) // Called when a key is released
	return
/datum/proc/keyLoop(client/user) // Called once every frame
	set waitfor = FALSE
	return

// removes all the existing macros
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/macro_set = params2list(winget(src, "default.*", "command")) // The third arg doesnt matter here as we're just removing them all
	for(var/k in 1 to length(macro_set))
		var/list/split_name = splittext(macro_set[k], ".")
		var/macro_name = "[split_name[1]].[split_name[2]]" // [3] is "command"
		erase_output = "[erase_output];[macro_name].parent=null"
	winset(src, null, erase_output)

/client/proc/set_macros()
	set waitfor = FALSE //We're going to sleep here even more than TG.

	//Reset the buffer
	reset_held_keys()

	erase_all_macros()

	var/list/personal_macro_set = prefs?.key_bindings_by_key
	if(!personal_macro_set)
		to_chat(span_big(span_alertwarning("Something has gone horribly wrong setting up your input system, Please call a coder.")))
		CRASH("Player missing keybinds but we've been asked to set them up??")

	//Set up the stuff we don't let them override.
	var/list/macro_set = SSinput.macro_set
	for(var/k in 1 to length(macro_set))
		var/key = macro_set[k]
		var/command = macro_set[key]
		winset(src, "shared-[REF(key)]", "parent=default;name=[key];command=[command]")


	var/list/printables = list()
	//Now the stuff we do.
	for(var/keycode in personal_macro_set) //We don't care about the bound key, just the key itself
		if(!hotkeys && !SSinput.unprintables_cache[keycode]) //Track printable hotkeys and skip them.
			printables += keycode
			continue
		winset(src, "personal-[REF(keycode)]", "parent=default;name=[keycode];command=\"KeyDown [keycode]\"")
		winset(src, "personal-[REF("[keycode]")]-UP", "parent=default;name=[keycode]+UP;command=\"KeyUp [keycode]\"")


	if(hotkeys)
		winset(src, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED]")
	else
		winset(src, null, "input.focus=true input.background-color=[COLOR_INPUT_DISABLED]")

	if(printables.len)
		to_chat(src, "[span_boldnotice("Hey, you might have some bad keybinds!")]\n\
		[span_notice("The following keys are bound despite Classic Controls being enabled. These binds are not applied.\nThis warning may be in error.")]\n\
		Keys: [jointext(printables, ", ")]\
		")
	update_special_keybinds()
