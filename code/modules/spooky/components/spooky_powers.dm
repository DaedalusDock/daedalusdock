/// Grants powers to the parent mob based on the spookiness of their area.
/datum/component/spooky_powers
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/list/powers = list()
	var/area/current_area

/datum/component/spooky_powers/Initialize(power_list)
	. = ..()
	if(!ismob(parent))
		return INITIALIZE_HINT_QDEL

	for(var/action_type in power_list)
		var/datum/action/new_action = new action_type
		powers[new_action] = power_list[action_type]

/datum/component/spooky_powers/Destroy(force, silent)
	powers = null
	return ..()

/datum/component/spooky_powers/RegisterWithParent()
	. = ..()
	var/atom/movable/movable_parent = parent
	if(isobserver(movable_parent))
		RegisterSignal(movable_parent, COMSIG_MOVABLE_MOVED, PROC_REF(observer_moved))
	else
		movable_parent.become_area_sensitive(REF(src))
		RegisterSignal(movable_parent, COMSIG_ENTER_AREA, PROC_REF(enter_area))

	update_area(get_area(parent))

/datum/component/spooky_powers/UnregisterFromParent()
	. = ..()
	var/atom/movable/movable_parent = parent
	if(isobserver(movable_parent))
		UnregisterSignal(movable_parent, COMSIG_MOVABLE_MOVED)
	else
		UnregisterSignal(movable_parent, list(COMSIG_ENTER_AREA))
		movable_parent.lose_area_sensitivity(REF(src))

	update_area(null)

/datum/component/spooky_powers/proc/update_powers()
	if(QDELETED(parent))
		return

	var/spook = current_area?.spook_level || 0
	for(var/datum/action/power in powers)
		if((powers[power] > spook) && (power.owner == parent))
			power.Remove(parent)
			continue

		if((powers[power] <= spook) && (power.owner != parent))
			power.Grant(parent)

/datum/component/spooky_powers/proc/update_area(area/A)
	if(A == current_area)
		return

	if(current_area)
		UnregisterSignal(current_area, AREA_SPOOK_LEVEL_CHANGED)

	current_area = A

	if(current_area)
		RegisterSignal(current_area, AREA_SPOOK_LEVEL_CHANGED, PROC_REF(area_spook_changed))

	update_powers()

/datum/component/spooky_powers/proc/area_spook_changed(area/source, old_spook_level)
	SIGNAL_HANDLER
	update_powers()

/datum/component/spooky_powers/proc/enter_area(atom/movable/source, area/A)
	SIGNAL_HANDLER
	update_area(A)

/datum/component/spooky_powers/proc/observer_moved(atom/movable/source, old_loc, movement_dir, forced, old_locs, momentum_change)
	SIGNAL_HANDLER
	var/area/A = get_area(source)
	if(A == current_area)
		return

	update_area(A)
