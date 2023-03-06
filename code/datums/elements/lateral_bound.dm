/datum/element/lateral_bound
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2
	///Do we only delete the parent if they're being thrown? (Mass Driver, Etc.)
	var/throw_only

/datum/element/lateral_bound/Attach(datum/target, throw_only = FALSE)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	src.throw_only = throw_only
	RegisterSignal(target, COMSIG_MOVABLE_LATERAL_Z_MOVE, .proc/handle_lateral_movement)

/datum/element/lateral_bound/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, COMSIG_MOVABLE_LATERAL_Z_MOVE)

/datum/element/lateral_bound/proc/handle_lateral_movement(atom/movable/source)
	if(throw_only && !source.throwing) //Do we only care about throwing, and are we NOT being thrown?
		return
	qdel(source)
	return COMPONENT_BLOCK_MOVEMENT
