/datum/interaction_mode/intents3
	shift_to_open_context_menu = TRUE
	var/intent = INTENT_HELP

/datum/interaction_mode/intents3/update_istate(mob/M, modifiers)
	M.istate.reset()
	M.istate.secondary = LAZYACCESS(modifiers, RIGHT_CLICK)
	if (intent == INTENT_HELP)
		UI.icon_state = "[intent]"
		return
	M.istate.blocking = TRUE
	switch (intent)
		if (INTENT_GRAB)
			M.istate.control = TRUE
		if (INTENT_HARM)
			M.istate.harm = TRUE
	UI.icon_state = "[intent]"

/datum/interaction_mode/intents3/procure_hud(mob/M, datum/hud/H)
	if (!M.hud_used.has_interaction_ui)
		return
	var/atom/movable/screen/act_intent3/AI = new
	AI.hud = H
	AI.intents = src
	UI = AI
	return AI

/datum/interaction_mode/intents3/state_changed(datum/interaction_state/state)
	if (state.harm)
		intent = INTENT_HARM
	else if (state.control)
		intent = INTENT_GRAB
	else
		intent = INTENT_HELP
	update_istate(owner.mob, null)

/datum/interaction_mode/intents3/keybind(type)
	var/static/next_intent = list(
		INTENT_HELP = INTENT_GRAB,
		INTENT_GRAB = INTENT_HARM,
		INTENT_HARM = INTENT_HELP)
	switch (type)
		if (0)
			intent = INTENT_HELP
		if (1)
			intent = INTENT_GRAB
		if (2)
			intent = INTENT_HARM
		if (3)
			intent = next_intent[intent]
	update_istate(owner.mob, null)

/datum/interaction_mode/intents3/status()
	return "Intent: [intent]"

/datum/interaction_mode/set_combat_mode(new_state, silent)
	. = ..()
	if(intent = INTENT_HARM)
		return
	intent = INTENT_HARM
	update_istate(owner.mob)
