/obj/structure/flock/tealprint
	name = "weird lookin ghost building"
	desc = "It's some weird looking ghost building. Seems like its under construction, You can see faint strands of material floating in it."

	density = FALSE

	var/materials_required = 0
	var/current_materials = 0

	var/obj/structure/flock/building_type = null

/obj/structure/flock/tealprint/Initialize(mapload, datum/flock/join_flock, desired_type)
	. = ..()
	var/turf/T = loc
	if(!T.can_flock_occupy(src))
		return INITIALIZE_HINT_QDEL

	SET_TRACKING(type)

	building_type = desired_type
	icon = initial(building_type.icon)
	icon_state = initial(building_type.icon_state)
	alpha = 104

/obj/structure/flock/tealprint/Destroy()
	UNSET_TRACKING(type)
	return ..()

/obj/structure/flock/tealprint/deconstruct(disassembled)
	if(!initial(building_type.cancellable))
		return

	flock_talk(src, "Tealprint dematerializing", flock)
	playsound(src, 'goon/sounds/flockmind/flockdrone_door_deny.ogg', 30, TRUE, extrarange = -10)
	return ..()
