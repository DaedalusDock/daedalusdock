/datum/interaction_mode/combat_mode/cyborg

/datum/interaction_mode/combat_mode/cyborg/procure_hud(mob/M, datum/hud/H)
	if (!M.hud_used.has_interaction_ui)
		return
	var/atom/movable/screen/combattoggle/robot/CT = new
	CT.hud = H
	CT.icon = H.ui_style
	CT.combat_mode = src
	UI = CT
	return CT

/datum/interaction_mode/combat_mode/cyborg/keybind(type)
	switch (type)
		if (3)
			combat_mode = !combat_mode
	update_istate(owner.mob, null)
	UI.update_icon_state()
