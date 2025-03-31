GLOBAL_REAL_VAR(starlight_color) = pick(COLOR_TEAL, COLOR_GREEN, COLOR_SILVER, COLOR_CYAN, COLOR_ORANGE, COLOR_PURPLE)
GLOBAL_REAL_VAR(space_appearances) = make_space_appearances()

/turf/open/space
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	name = "\proper space"
	overfloor_placed = FALSE
	underfloor_accessibility = UNDERFLOOR_INTERACTABLE
	z_flags = Z_ATMOS_IN_DOWN|Z_ATMOS_IN_UP|Z_ATMOS_OUT_DOWN|Z_ATMOS_OUT_UP
	z_eventually_space = TRUE
	temperature = TCMB
	simulated = FALSE
	explosion_block = 0.5
	initial_gas = null

	var/destination_z
	var/destination_x
	var/destination_y

	plane = PLANE_SPACE
	layer = SPACE_LAYER
	light_power = 0.25
	light_inner_range = 0.1
	light_outer_range = 10
	light_falloff_curve = 5
	always_lit = TRUE
	bullet_bounce_sound = null
	vis_flags = VIS_INHERIT_ID //when this be added to vis_contents of something it be associated with something on clicking, important for visualisation of turf in openspace and interraction with openspace that show you turf.

	force_no_gravity = TRUE

/turf/open/space/basic/New() //Do not convert to Initialize
	//This is used to optimize the map loader
	return

/**
 * Space Initialize
 *
 * Doesn't call parent, see [/atom/proc/Initialize].
 * When adding new stuff to /atom/Initialize, /turf/Initialize, etc
 * don't just add it here unless space actually needs it.
 *
 * There is a lot of work that is intentionally not done because it is not currently used.
 * This includes stuff like smoothing, blocking camera visibility, etc.
 * If you are facing some odd bug with specifically space, check if it's something that was
 * intentionally ommitted from this implementation.
 */
/turf/open/space/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)

	appearance = global.space_appearances[(((x + y) ^ ~(x * y) + z) % 25) + 1]

	if(initialized)
		stack_trace("Warning: [src]([type]) initialized multiple times!")

	initialized = TRUE

	if(!loc:area_has_base_lighting) //Only provide your own lighting if the area doesn't for you
		// Intentionally not add_overlay for performance reasons.
		// add_overlay does a bunch of generic stuff, like creating a new list for overlays,
		// queueing compile, cloning appearance, etc etc etc that is not necessary here.
		overlays += global.fullbright_overlay
		luminosity = TRUE

	return INITIALIZE_HINT_NORMAL

/proc/make_space_appearances()
	. = new /list(26)
	for (var/i in 0 to 25)
		var/image/I = new()
		I.appearance = /turf/open/space
		I.icon_state = "[i]"
		I.plane = PLANE_SPACE
		I.layer = SPACE_LAYER
		.[i+1] = I

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/turf/open/space/attack_ghost(mob/dead/observer/user)
	if(destination_z)
		var/turf/T = locate(destination_x, destination_y, destination_z)
		user.forceMove(T)

/turf/open/space/TakeTemperature(temp)

/turf/open/space/RemoveLattice()
	return

//IT SHOULD RETURN NULL YOU MONKEY, WHY IN TARNATION WHAT THE FUCKING FUCK
/turf/open/space/remove_air(amount)
	return null

/turf/open/space/proc/update_starlight()
	for(var/t in RANGE_TURFS(1,src)) //RANGE_TURFS is in code\__HELPERS\game.dm
		if(isspaceturf(t))
			//let's NOT update this that much pls
			continue
		set_light(l_color = global.starlight_color, l_on = TRUE)
		return
	set_light(l_on = FALSE)

/turf/open/space/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/turf/open/space/proc/CanBuildHere()
	return TRUE

/turf/open/space/handle_slip()
	return

/turf/open/space/attackby(obj/item/C, mob/user, params)
	..()
	if(!CanBuildHere())
		return
	if(istype(C, /obj/item/stack/rods))
		build_with_rods(C, user)
	else if(istype(C, /obj/item/stack/tile/iron))
		build_with_floor_tiles(C, user)


/turf/open/space/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(!arrived || src != arrived.loc)
		return

	if(destination_z && destination_x && destination_y && !LAZYLEN(arrived.grabbed_by) && !arrived.currently_z_moving)
		var/tx = destination_x
		var/ty = destination_y
		var/turf/DT = locate(tx, ty, destination_z)
		var/itercount = 0
		while(DT.density || istype(DT.loc,/area/shuttle)) // Extend towards the center of the map, trying to look for a better place to arrive
			if (itercount++ >= 100)
				log_game("SPACE Z-TRANSIT ERROR: Could not find a safe place to land [arrived] within 100 iterations.")
				break
			if (tx < 128)
				tx++
			else
				tx--
			if (ty < 128)
				ty++
			else
				ty--
			DT = locate(tx, ty, destination_z)

		if(SEND_SIGNAL(arrived, COMSIG_MOVABLE_LATERAL_Z_MOVE) & COMPONENT_BLOCK_MOVEMENT)
			return

		arrived.forceMoveWithGroup(DT, ZMOVING_LATERAL)
		if(isliving(arrived))
			var/mob/living/L = arrived
			for(var/obj/item/hand_item/grab/G as anything in L.recursively_get_conga_line())
				var/turf/pulled_dest = get_step(G.assailant.loc, REVERSE_DIR(G.assailant.dir)) || G.assailant.loc
				G.affecting.forceMoveWithGroup(pulled_dest, ZMOVING_LATERAL)


/turf/open/space/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/space/singularity_act()
	return

/turf/open/space/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk, src))
		return TRUE
	return FALSE

/turf/open/space/is_transition_turf()
	if(destination_x || destination_y || destination_z)
		return TRUE


/turf/open/space/acid_act(acidpwr, acid_volume)
	return FALSE

/turf/open/space/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!CanBuildHere())
		return FALSE

	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 1)
			else
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 3)
	return FALSE

/turf/open/space/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span_notice("You build a floor."))
			PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			return TRUE
	return FALSE

/turf/open/space/rust_heretic_act()
	return FALSE

/turf/open/space/TryScrapeToLattice()
	var/dest_x = destination_x
	var/dest_y = destination_y
	var/dest_z = destination_z
	..()
	destination_x = dest_x
	destination_y = dest_y
	destination_z = dest_z

/turf/open/space/openspace
	icon = 'icons/turf/floors.dmi'
	icon_state = "invisible"
	z_flags = Z_ATMOS_IN_DOWN | Z_ATMOS_IN_UP | Z_ATMOS_OUT_DOWN | Z_ATMOS_OUT_UP | Z_MIMIC_BELOW | Z_MIMIC_OVERWRITE | Z_MIMIC_NO_AO


/turf/open/space/CanZPass(atom/movable/A, direction, z_move_flags)
	if(z == A.z) //moving FROM this turf
		//Check contents
		for(var/obj/O in contents)
			if(direction == UP)
				if(O.obj_flags & BLOCK_Z_OUT_UP)
					return FALSE
			else if(O.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE

	else
		for(var/obj/O in contents)
			if(direction == UP)
				if(O.obj_flags & BLOCK_Z_IN_DOWN)
					return FALSE
			else if(O.obj_flags & BLOCK_Z_IN_UP)
				return FALSE

	return TRUE
