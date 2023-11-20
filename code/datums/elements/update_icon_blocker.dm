//Prevents calling anything in update_icon() like update_icon_state() or update_overlays()

/datum/element/update_icon_blocker
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	/// Set of COMSIG_ATOM_UPDATE_ICON to return. See [signals_atom_main.dm]
	var/blocking_flags

/datum/element/update_icon_blocker/Attach(datum/target, blocking_flags = COMSIG_ATOM_NO_UPDATE_ICON_STATE | COMSIG_ATOM_NO_UPDATE_OVERLAYS)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	if(!blocking_flags)
		CRASH("Attempted to block icon updates with a null blocking_flags argument. Why?")
	src.blocking_flags = blocking_flags
	RegisterSignal(target, COMSIG_ATOM_UPDATE_ICON, PROC_REF(block_update_icon))

/datum/element/update_icon_blocker/proc/block_update_icon()
	SIGNAL_HANDLER

	return blocking_flags
