/*
 * Rawkeys are magic keybindings that are bound directly to a key instead of having an associated action, like "move up"
 * Rawkeys are NOT in GLOB.keybindings_by_name
 * NOTE: Legacy mode users will NOT fire rawkeys for printable keys. Do remember this if you are for some reason making
 * a rawkey associated with a printable key.
 */
/datum/keybinding/rawkey/ctrl
	hotkey_keys = list("Ctrl")
	name = "CTRL"
	keybind_signal = COMSIG_KB_RAW_CTRL

/datum/keybinding/rawkey/ctrl/up(client/user)
	. = ..()
	if(.)
		return

	if(isliving(user.mob))
		var/mob/living/user_mob = user.mob
		user_mob.hud_used?.action_intent?.update_appearance()

/datum/keybinding/rawkey/ctrl/down(client/user)
	. = ..()
	if(.)
		return

	if(isliving(user.mob))
		var/mob/living/user_mob = user.mob
		user_mob.hud_used?.action_intent?.update_appearance()

/datum/keybinding/rawkey/shift
	hotkey_keys = list("Shift")
	name = "Shift"
	keybind_signal = COMSIG_KB_RAW_CTRL

/datum/keybinding/rawkey/shift/up(client/user)
	. = ..()
	if(.)
		return

	user.mob.update_mouse_pointer()

/datum/keybinding/rawkey/shift/down(client/user)
	. = ..()
	if(.)
		return

	user.mob.update_mouse_pointer()

