GLOBAL_LIST_INIT(available_interaction_modes, list(
	"Combat Mode" = /datum/interaction_mode/combat_mode,
	"Three Intents" = /datum/interaction_mode/intents3
))

/datum/interaction_mode
	var/shift_to_open_context_menu = FALSE
	var/client/owner
	var/atom/movable/screen/UI

/datum/interaction_mode/New(client/C)
	owner = C
	owner.set_right_click_menu_mode(shift_to_open_context_menu)
	if (owner?.mob?.hud_used.has_interaction_ui)
		owner.mob.hud_used.static_inventory += procure_hud(owner.mob, owner.mob.hud_used)

/datum/interaction_mode/Destroy(force, ...)
	. = ..()
	owner = null
	if (UI)
		UI?.hud.static_inventory -= UI
		QDEL_NULL(UI)

/datum/interaction_mode/proc/reload_hud(mob/M)
	if (UI)
		owner.mob.hud_used.static_inventory -= UI
	if (M.hud_used.has_interaction_ui)
		M.hud_used.static_inventory += procure_hud(owner.mob, owner.mob.hud_used)

/datum/interaction_mode/proc/replace(datum/interaction_mode/IM)
	IM = new IM (owner)
	if (UI)
		UI?.hud.static_inventory -= UI
	owner.imode = IM
	qdel(src)

/datum/interaction_mode/proc/update_istate(mob/M, modifiers)

/datum/interaction_mode/proc/procure_hud(mob/M, datum/hud/H)
	return list()

/datum/interaction_mode/proc/state_changed(datum/interaction_state/state)

/datum/interaction_mode/proc/keybind(type)

/datum/interaction_mode/proc/status()
