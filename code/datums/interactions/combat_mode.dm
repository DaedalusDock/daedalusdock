/datum/interaction_mode/combat_mode
	shift_to_open_context_menu = TRUE
	var/combat_mode = FALSE

/datum/interaction_mode/combat_mode/update_istate(mob/M, modifiers)
	M.istate.harm = combat_mode
	M.istate.blocking = combat_mode
	M.istate.secondary = LAZYACCESS(modifiers, RIGHT_CLICK)
	M.istate.alternate = LAZYACCESS(modifiers, SHIFT_CLICK)
	M.istate.control = LAZYACCESS(modifiers, CTRL_CLICK)

/datum/interaction_mode/combat_mode/procure_hud(mob/M, datum/hud/H)
	if (!M.hud_used.has_interaction_ui)
		return
	var/atom/movable/screen/combattoggle/flashy/CT = new
	CT.hud = H
	CT.icon = H.ui_style
	CT.combat_mode = src
	UI = CT
	return CT

/datum/interaction_mode/combat_mode/state_changed(datum/interaction_state/state)
	if (state.harm)
		combat_mode = TRUE
	else
		combat_mode = FALSE
	update_istate(owner.mob, null)
	UI.update_icon_state()

/datum/interaction_mode/combat_mode/keybind(type)
	switch (type)
		if (0)
			combat_mode = TRUE
		if (2)
			combat_mode = FALSE
		if (3)
			combat_mode = !combat_mode
	update_istate(owner.mob, null)
	UI.update_icon_state()

/datum/interaction_mode/combat_mode/status()
	return "Combat Mode: [combat_mode ? "On" : "Off"]"

/datum/interaction_mode/combat_mode/set_combat_mode(new_state, silent)
	. = ..()
	if(combat_mode == new_state)
		return

	keybind(3)
	if(silent || !(owner?.prefs.toggles & SOUND_COMBATMODE))
		return

	if(combat_mode)
		SEND_SOUND(src, sound('sound/misc/ui_togglecombat.ogg', volume = 25)) //Sound from interbay!
	else
		SEND_SOUND(src, sound('sound/misc/ui_toggleoffcombat.ogg', volume = 25)) //Slightly modified version of the above
