#ifdef MACRO_TEST
#warn !!UNSAFE!!: MacroTest Verbs Enabled, Do Not Merge.
/client
	var/x_mt_watchingfocus = FALSE

/// Dumps the list of all macros. This should almost always be just default
/client/verb/dump_macroset_ids()
	set name = "mt Dump Macroset IDs"
	set category = "_MACRO_TEST"
	to_chat(usr, (winget(src, "", "macros") || "NULL (Bad. Incredibly. Incredibly bad.)"))

/// List all children of default. Name for macros is their bound key.
/client/verb/dump_set()
	set name = "mt Dump bindings"
	set category = "_MACRO_TEST"
	to_chat(usr, (winget(src, "default.*" , "name")|| "NULL (Bad. Real bad.)"))

/// A slightly more pleasant way to execute free winsets.
/client/verb/arbitrary_winget(cmd as message)
	set name = "awing"
	set desc = "Run an arbitrary Winset call, Space-separated arguments."
	set category = "_MACRO_TEST"
	var/list/parts = splittext(cmd, " ")
	to_chat(usr, (winget(src, parts[1], parts[2]) || "NULL (Bad Call?)"))


/// Will dump the currently focused skin element to chat. Used for tracking down focus juggling issues.
/client/verb/focuswatch()
	set name = "mt toggle focus watch"
	set category = "_MACRO_TEST"
	if(x_mt_watchingfocus)
		x_mt_watchingfocus = FALSE
		return
	else
		x_mt_watchingfocus = TRUE
		while(x_mt_watchingfocus)
			// Live-report the element with focus.
			to_chat(usr, (winget(src, "", "focus") || "NULL (Entire game defocused?)"))
			sleep(0.5 SECONDS) //Every half second
#endif
