/datum/component/add_screen_object_on_login
	dupe_mode = COMPONENT_DUPE_ALLOWED

	var/arguments

/datum/component/add_screen_object_on_login/Initialize(...)
	arguments = args.Copy()
	RegisterSignal(parent, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))

/datum/component/add_screen_object_on_login/proc/on_hud_created(datum/source)
	SIGNAL_HANDLER

	var/mob/mob_parent = parent

	mob_parent.hud_used.add_screen_object(arglist(arguments))
	qdel(src)
