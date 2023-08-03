#ifdef MACRO_TEST
#warn !!UNSAFE!!: MacroTest Verbs Enabled, Do Not Merge.
/client
	var/x_mt_watchingfocus = FALSE


/client/verb/dump_macroset_ids()
	set name = "Dump Macroset IDs"
	set category = "_MACRO_TEST"
	to_chat(usr, winget(src, "", "macros"))

/client/verb/dump_set()
	set name = "Dump Default Macroset Contents"
	set category = "_MACRO_TEST"
	to_chat(usr, winget(src, "default.*" , null))

/client/verb/arbitrary_winget(cmd as message)
	set name = "awin"
	set desc = "Run an arbitrary Winset call, Space-separated arguments."
	set category = "_MACRO_TEST"
	var/list/parts = splittext(cmd, " ")
	to_chat(usr, winget(src, parts[1], parts[2]))

/client/verb/focuswatch()
	set name = "toggle focus watch"
	set category = "_MACRO_TEST"
	if(x_mt_watchingfocus)
		x_mt_watchingfocus = FALSE
		return
	else
		x_mt_watchingfocus = TRUE
		while(x_mt_watchingfocus)
			// Live-report the element with focus.
			to_chat(usr, (winget(src, "", "focus") || "NULL (Entire game defocused?)"))
			sleep(0.5 SECONDS) //Every 5 seconds
#endif
