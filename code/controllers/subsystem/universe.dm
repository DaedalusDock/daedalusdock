SUBSYSTEM_DEF(universe)
	name = "Universe"
	flags = SS_NO_FIRE|SS_NO_INIT

	var/datum/universal_state/current_state


/datum/controller/subsystem/universe/proc/SetUniversalState(newstate, list/ztraits, on_exit = TRUE, on_enter = TRUE)
	if(istype(current_state, newstate))
		return

	if(on_exit)
		current_state?.OnExit()

	if(ztraits)
		current_state = new newstate(ztraits)
	else
		current_state = new newstate

	if(on_enter)
		current_state.OnEnter()

/datum/controller/subsystem/universe/proc/ClearUniversalState()
	current_state?.OnExit()
	current_state = null
