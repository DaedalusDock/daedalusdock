/datum/component/spook_factor
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/spook_contribution = 0
	var/area/affecting_area

/datum/component/spook_factor/Initialize(spook_contribution)
	. = ..()
	if(!ismovable(parent))
		return INITIALIZE_HINT_QDEL

	src.spook_contribution = spook_contribution
	var/area/A = get_area(parent)
	if(!A)
		return

	affect_area(A)

/datum/component/spook_factor/Destroy(force, silent)
	affect_area(null)
	return ..()

/datum/component/spook_factor/RegisterWithParent()
	var/atom/movable/movable_parent = parent
	movable_parent.become_area_sensitive(REF(src))
	RegisterSignal(movable_parent, COMSIG_ENTER_AREA, PROC_REF(enter_area))
	RegisterSignal(movable_parent, COMSIG_EXIT_AREA, PROC_REF(exit_area))

/datum/component/spook_factor/UnregisterFromParent()
	var/atom/movable/movable_parent = parent
	UnregisterSignal(movable_parent, list(COMSIG_EXIT_AREA, COMSIG_ENTER_AREA))
	movable_parent.lose_area_sensitivity(REF(src))

/datum/component/spook_factor/InheritComponent(datum/component/C, i_am_original, spook_contribution)
	var/area/A = affecting_area
	affect_area(null)
	src.spook_contribution = spook_contribution
	affect_area(A)

/datum/component/spook_factor/proc/affect_area(area/A)
	if(affecting_area == A)
		return

	affecting_area?.adjust_spook_level(-spook_contribution)
	affecting_area = A
	affecting_area?.adjust_spook_level(spook_contribution)

/datum/component/spook_factor/proc/enter_area(atom/movable/source, area/A)
	SIGNAL_HANDLER
	affect_area(A)

/datum/component/spook_factor/proc/exit_area(atom/movable/source, area/A)
	SIGNAL_HANDLER
	affect_area(null)
