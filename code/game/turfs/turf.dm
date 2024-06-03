GLOBAL_LIST_EMPTY(station_turfs)

/// Any floor or wall. What makes up the station and the rest of the map.
/turf
	icon = 'icons/turf/floors.dmi'
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_PLANE// Important for interaction with and visualization of openspace.
	explosion_block = 1

	// baseturfs can be either a list or a single turf type.
	// In class definition like here it should always be a single type.
	// A list will be created in initialization that figures out the baseturf's baseturf etc.
	// In the case of a list it is sorted from bottom layer to top.
	// This shouldn't be modified directly, use the helper procs.
	var/tmp/list/baseturfs = /turf/baseturf_bottom
	/// Is this turf in the process of running ChangeTurf()?
	var/tmp/changing_turf = FALSE

	///Lumcount added by sources other than lighting datum objects, such as the overlay lighting component.
	var/tmp/dynamic_lumcount = 0
	var/tmp/lighting_corners_initialised = FALSE
	///Our lighting object.
	var/tmp/datum/lighting_object/lighting_object
	///Lighting Corner datums.
	var/tmp/datum/lighting_corner/lighting_corner_NE
	var/tmp/datum/lighting_corner/lighting_corner_SE
	var/tmp/datum/lighting_corner/lighting_corner_SW
	var/tmp/datum/lighting_corner/lighting_corner_NW

	/// If there's a tile over a basic floor that can be ripped out
	var/tmp/overfloor_placed = FALSE

	/// The max temperature of the fire which it was subjected to
	var/tmp/max_fire_temperature_sustained = 0

	/// For the station blueprints, images of objects eg: pipes
	var/tmp/list/image/blueprint_data
	/// Contains the throw range for explosions. You won't need this, stop looking at it.
	var/tmp/explosion_throw_details

	///Lazylist of movable atoms providing opacity sources.
	var/tmp/list/atom/movable/opacity_sources

	//* END TMP VARS *//


	/// Turf bitflags, see code/__DEFINES/flags.dm
	var/turf_flags = NONE

	/// How accessible underfloor pieces such as wires, pipes, etc are on this turf. Can be HIDDEN, VISIBLE, or INTERACTABLE.
	var/underfloor_accessibility = UNDERFLOOR_HIDDEN

	///Used for fire, if a melting temperature was reached, it will be destroyed
	var/to_be_destroyed = 0

	/// Determines how air interacts with this turf.
	var/blocks_air = AIR_ALLOWED

	var/bullet_bounce_sound = 'sound/weapons/gun/general/mag_bullet_remove.ogg' //sound played when a shell casing is ejected ontop of the turf.
	var/bullet_sizzle = FALSE //used by ammo_casing/bounce_away() to determine if the shell casing should make a sizzle sound when it's ejected over the turf
							//IE if the turf is supposed to be water, set TRUE.

	var/tiled_dirt = FALSE // use smooth tiled dirt decal

	///Bool, whether this turf will always be illuminated no matter what area it is in
	var/always_lit = FALSE

	/// Set to TRUE for pseudo 3/4ths walls, otherwise, leave alone.
	var/lighting_uses_jen = FALSE

	///Which directions does this turf block the vision of, taking into account both the turf's opacity and the movable opacity_sources.
	var/directional_opacity = NONE

	///the holodeck can load onto this turf if TRUE
	var/holodeck_compatible = FALSE

	/// If this turf contained an RCD'able object (or IS one, for walls)
	/// but is now destroyed, this will preserve the value.
	/// See __DEFINES/construction.dm for RCD_MEMORY_*.
	var/rcd_memory
	///whether or not this turf forces movables on it to have no gravity (unless they themselves have forced gravity)
	var/force_no_gravity = FALSE

	/// How pathing algorithm will check if this turf is passable by itself (not including content checks). By default it's just density check.
	/// WARNING: Currently to use a density shortcircuiting this does not support dense turfs with special allow through function
	var/pathing_pass_method = TURF_PATHING_PASS_DENSITY

/turf/vv_edit_var(var_name, new_value)
	var/static/list/banned_edits = list(
		NAMEOF_STATIC(src, x),
		NAMEOF_STATIC(src, y),
		NAMEOF_STATIC(src, z)
		)
	if(var_name in banned_edits)
		return FALSE
	. = ..()

/**
 * Turf Initialize
 *
 * Doesn't call parent, see [/atom/proc/Initialize]
 * Please note, space tiles do not run this code.
 * This is done because it's called so often that any extra code just slows things down too much
 * If you add something relevant here add it there too
 * [/turf/open/space/Initialize]
 * [/turf/closed/mineral/Initialize]
 */
/turf/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)

	if(initialized)
		stack_trace("Warning: [src]([type]) initialized multiple times!")

	initialized = TRUE

	if(permit_ao && mapload)
		queue_ao()

	// by default, vis_contents is inherited from the turf that was here before
	if(length(vis_contents))
		vis_contents.len = 0

	assemble_baseturfs()

	if(length(contents))
		levelupdate()

	#ifdef UNIT_TESTS
	ASSERT_SORTED_SMOOTHING_GROUPS(smoothing_groups)
	ASSERT_SORTED_SMOOTHING_GROUPS(canSmoothWith)
	#endif

	SETUP_SMOOTHING()

	QUEUE_SMOOTH(src)

	if (!mapload && length(contents))
		for(var/atom/movable/AM as anything in src)
			Entered(AM, null)

	var/area/our_area = loc
	if(!our_area.luminosity && always_lit) //Only provide your own lighting if the area doesn't for you
		add_overlay(global.fullbright_overlay)

	if (z_flags & Z_MIMIC_BELOW)
		setup_zmimic(mapload)

	if (light_power && light_outer_range)
		update_light()

	if (opacity)
		directional_opacity = ALL_CARDINALS

	// apply materials properly from the default custom_materials value
	if (length(custom_materials))
		set_custom_materials(custom_materials)

	#ifdef SPATIAL_GRID_ZLEVEL_STATS
	if((istype(src, /turf/open/floor) || istype(src, /turf/closed/wall)) && isstationlevel(z))
		GLOB.station_turfs |= src
	#endif
	return INITIALIZE_HINT_NORMAL

/turf/Destroy(force)
	. = QDEL_HINT_IWILLGC
	if(!changing_turf)
		stack_trace("Incorrect turf deletion")
	changing_turf = FALSE

	if (z_flags & Z_MIMIC_BELOW)
		cleanup_zmimic()

	if(force)
		..()
		//this will completely wipe turf state
		var/turf/B = new world.turf(src)
		for(var/A in B.contents)
			qdel(A)
		return

	if(blueprint_data)
		QDEL_LIST(blueprint_data)
	initialized = FALSE

	///ZAS THINGS
	if(connections)
		connections.erase_all()

	if(simulated && zone)
		zone.remove_turf(src)
	///NO MORE ZAS THINGS

	..()
	#ifdef SPATIAL_GRID_ZLEVEL_STATS
	if(isstationlevel(z))
		GLOB.station_turfs += src
	#endif

	vis_contents.len = 0

/// WARNING WARNING
/// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
/// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
/// We do it because moving signals over was needlessly expensive, and bloated a very commonly used bit of code
/turf/clear_signal_refs()
	return

/turf/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!isliving(user))
		return
	user.move_grabbed_atoms_towards(src)

/turf/attack_grab(mob/living/user, atom/movable/victim, obj/item/hand_item/grab/grab, list/params)
	. = ..()
	if(.)
		return
	if(!isliving(user))
		return
	if(user == victim)
		return
	if(grab.current_grab.same_tile)
		return

	grab.move_victim_towards(src)


/**
 * Check whether the specified turf is blocked by something dense inside it with respect to a specific atom.
 *
 * Returns truthy value TURF_BLOCKED_TURF_DENSE if the turf is blocked because the turf itself is dense.
 * Returns truthy value TURF_BLOCKED_CONTENT_DENSE if one of the turf's contents is dense and would block
 * a source atom's movement.
 * Returns falsey value TURF_NOT_BLOCKED if the turf is not blocked.
 *
 * Arguments:
 * * exclude_mobs - If TRUE, ignores dense mobs on the turf.
 * * source_atom - If this is not null, will check whether any contents on the turf can block this atom specifically. Also ignores itself on the turf.
 * * ignore_atoms - Check will ignore any atoms in this list. Useful to prevent an atom from blocking itself on the turf.
 */
/turf/proc/is_blocked_turf(exclude_mobs = FALSE, source_atom = null, list/ignore_atoms)
	if(density)
		return TRUE

	for(var/atom/movable/movable_content as anything in contents)
		// We don't want to block ourselves or consider any ignored atoms.
		if((movable_content == source_atom) || (movable_content in ignore_atoms))
			continue
		// If the thing is dense AND we're including mobs or the thing isn't a mob AND if there's a source atom and
		// it cannot pass through the thing on the turf,  we consider the turf blocked.
		if(movable_content.density && (!exclude_mobs || !ismob(movable_content)))
			if(source_atom && movable_content.CanPass(source_atom, get_dir(src, source_atom)))
				continue
			return TRUE
	return FALSE

/**
 * Checks whether the specified turf is blocked by something dense inside it, but ignores anything with the climbable trait
 *
 * Works similar to is_blocked_turf(), but ignores climbables and has less options. Primarily added for jaunting checks
 */
/turf/proc/is_blocked_turf_ignore_climbable()
	if(density)
		return TRUE

	for(var/atom/movable/atom_content as anything in contents)
		if(atom_content.density && !(atom_content.flags_1 & ON_BORDER_1) && !HAS_TRAIT(atom_content, TRAIT_CLIMBABLE))
			return TRUE
	return FALSE

/turf/proc/CanZPass(atom/movable/A, direction, z_move_flags)
	if(z == A.z) //moving FROM this turf
		//Check contents
		for(var/obj/O in contents)
			if(direction == UP)
				if(O.obj_flags & BLOCK_Z_OUT_UP)
					return FALSE
			else if(O.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE

		return direction & UP //can't go below
	else
		if(density) //No fuck off
			return FALSE

		if(direction == UP) //on a turf below, trying to enter
			return 0

		if(direction == DOWN) //on a turf above, trying to enter
			for(var/obj/O in contents)
				if(O.obj_flags & BLOCK_Z_IN_DOWN)
					return FALSE
			return TRUE

///Called each time the target falls down a z level possibly making their trajectory come to a halt. see __DEFINES/movement.dm.
/turf/proc/zImpact(atom/movable/falling, levels = 1, turf/prev_turf)
	var/flags = FALL_RETAIN_PULL
	var/list/falling_movables = falling.get_move_group()
	var/list/falling_mob_names

	for(var/atom/movable/falling_mob as anything in falling_movables)
		if(ishuman(falling_mob))
			var/mob/living/carbon/human/H = falling_mob
			falling_mob_names += H.get_face_name()
			continue
		falling_mob_names += falling_mob.name

	for(var/i in contents)
		var/atom/thing = i
		flags |= thing.intercept_zImpact(falling_movables, levels)
		if(flags & FALL_STOP_INTERCEPTING)
			break

	if(prev_turf && !(flags & FALL_NO_MESSAGE))
		for(var/mov_name in falling_mob_names)
			prev_turf.visible_message(
				span_warning("<b>[name]</b> falls through [prev_turf]!"),,
				span_hear("You hear a whoosh of displaced air.")
			)

	if(!(flags & FALL_INTERCEPTED) && falling.zFall(levels + 1))
		return FALSE

	for(var/atom/movable/falling_movable as anything in falling_movables)
		var/mob/living/L = falling_movable
		if(!isliving(L))
			L = null
		if(!(flags & FALL_RETAIN_PULL))
			L?.release_all_grabs()

		if(!(flags & FALL_INTERCEPTED))
			falling_movable.onZImpact(src, levels)

			#ifndef ZMIMIC_MULTIZ_SPEECH //Multiz speech handles this otherwise
			if(!(flags & FALL_NO_MESSAGE))
				prev_turf.audible_message(span_hear("You hear something slam into the deck below."))
			#endif

		if(L)
			if(LAZYLEN(L.grabbed_by))
				for(var/obj/item/hand_item/grab/G in L.grabbed_by)
					if(L.z != G.assailant.z || get_dist(L, G.assailant) > 1)
						qdel(G)
	return TRUE

/turf/attackby(obj/item/C, mob/user, params)
	if(..() || C.attack_turf(src, user, params))
		return TRUE

	if(can_lay_cable() && istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.place_turf(src, user)
		return TRUE

	return FALSE

/turf/attackby_secondary(obj/item/weapon, mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(weapon.sharpness && try_graffiti(user, weapon))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN


//There's a lot of QDELETED() calls here if someone can figure out how to optimize this but not runtime when something gets deleted by a Bump/CanPass/Cross call, lemme know or go ahead and fix this mess - kevinz000
/// Test if a movable can enter this turf. Send no_side_effects = TRUE to prevent bumping.
/turf/Enter(atom/movable/mover, no_side_effects = FALSE)
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	var/atom/firstbump
	var/canPassSelf = CanPass(mover, get_dir(src, mover))
	if(canPassSelf || (mover.movement_type & PHASING))
		for(var/atom/movable/thing as anything in contents)
			if(thing == mover || thing == mover.loc) // Multi tile objects and moving out of other objects
				continue
			if(!thing.Cross(mover))
				if(no_side_effects)
					return FALSE
				if(QDELETED(mover)) //deleted from Cross() (CanPass is pure so it cant delete, Cross shouldnt be doing this either though, but it can happen)
					return FALSE
				if((mover.movement_type & PHASING))
					mover.Bump(thing)
					if(QDELETED(mover)) //deleted from Bump()
						return FALSE
					continue
				else
					if(!firstbump || ((thing.layer < firstbump.layer || (thing.flags_1 & ON_BORDER_1|BUMP_PRIORITY_1)) && !(firstbump.flags_1 & ON_BORDER_1)))
						firstbump = thing

	if(QDELETED(mover)) //Mover deleted from Cross/CanPass/Bump, do not proceed.
		return FALSE

	if(!canPassSelf) //Even if mover is unstoppable they need to bump us.
		firstbump = src

	if(firstbump)
		mover.Bump(firstbump)
		return (mover.movement_type & PHASING)

	return TRUE

/turf/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)

	if(arrived.flags_2 & ATMOS_SENSITIVE_2)
		LAZYDISTINCTADD(atmos_sensitive_contents, arrived)
		if(TURF_HAS_VALID_ZONE(src))
			if(isnull(zone.atmos_sensitive_contents))
				SSzas.zones_with_sensitive_contents += zone
			LAZYDISTINCTADD(zone.atmos_sensitive_contents, arrived)
	// Spatial grid tracking needs to happen before the signal is sent
	. = ..()

	if (!arrived.bound_overlay && !(arrived.zmm_flags & ZMM_IGNORE) && arrived.invisibility != INVISIBILITY_ABSTRACT && TURF_IS_MIMICKING(above))
		above.update_mimic()


/turf/Exited(atom/movable/gone, direction)
	if(gone.flags_2 & ATMOS_SENSITIVE_2)
		if(!isnull(atmos_sensitive_contents))
			LAZYREMOVE(atmos_sensitive_contents, gone)
		if(TURF_HAS_VALID_ZONE(src))
			LAZYREMOVE(zone.atmos_sensitive_contents, gone)
			if(isnull(zone.atmos_sensitive_contents))
				SSzas.zones_with_sensitive_contents -= zone

	// Spatial grid tracking needs to happen before the signal is sent
	. = ..()

// A proc in case it needs to be recreated or badmins want to change the baseturfs
/turf/proc/assemble_baseturfs(turf/fake_baseturf_type)
	var/static/list/created_baseturf_lists = list()
	var/turf/current_target
	if(fake_baseturf_type)
		if(length(fake_baseturf_type)) // We were given a list, just apply it and move on
			baseturfs = baseturfs_string_list(fake_baseturf_type, src)
			return
		current_target = fake_baseturf_type
	else
		if(length(baseturfs))
			return // No replacement baseturf has been given and the current baseturfs value is already a list/assembled
		if(!baseturfs)
			current_target = initial(baseturfs) || type // This should never happen but just in case...
			stack_trace("baseturfs var was null for [type]. Failsafe activated and it has been given a new baseturfs value of [current_target].")
		else
			current_target = baseturfs

	// If we've made the output before we don't need to regenerate it
	if(created_baseturf_lists[current_target])
		var/list/premade_baseturfs = created_baseturf_lists[current_target]
		if(length(premade_baseturfs))
			baseturfs = baseturfs_string_list(premade_baseturfs.Copy(), src)
		else
			baseturfs = baseturfs_string_list(premade_baseturfs, src)
		return baseturfs

	var/turf/next_target = initial(current_target.baseturfs)
	//Most things only have 1 baseturf so this loop won't run in most cases
	if(current_target == next_target)
		baseturfs = current_target
		created_baseturf_lists[current_target] = current_target
		return current_target
	var/list/new_baseturfs = list(current_target)
	for(var/i=0;current_target != next_target;i++)
		if(i > 100)
			// A baseturfs list over 100 members long is silly
			// Because of how this is all structured it will only runtime/message once per type
			stack_trace("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			message_admins("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			break
		new_baseturfs.Insert(1, next_target)
		current_target = next_target
		next_target = initial(current_target.baseturfs)

	baseturfs = baseturfs_string_list(new_baseturfs, src)
	created_baseturf_lists[new_baseturfs[new_baseturfs.len]] = new_baseturfs.Copy()
	return new_baseturfs

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.initialized)
			SEND_SIGNAL(O, COMSIG_OBJ_HIDE, underfloor_accessibility < UNDERFLOOR_VISIBLE)

// override for space turfs, since they should never hide anything
/turf/open/space/levelupdate()
	return

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L && L.initialized)
		qdel(L)

/turf/proc/Bless()
	new /obj/effect/blessing(src)

//////////////////////////////
//Distance procs
//////////////////////////////

//Distance associates with all directions movement
/turf/proc/Distance(turf/T)
	return get_dist(src,T)

//  This Distance proc assumes that only cardinal movement is
//  possible. It results in more efficient (CPU-wise) pathing
//  for bots and anything else that only moves in cardinal dirs.
/turf/proc/Distance_cardinal(turf/T)
	if(!src || !T)
		return FALSE
	return abs(x - T.x) + abs(y - T.y)

////////////////////////////////////////////////////

/turf/singularity_act()
	if(underfloor_accessibility < UNDERFLOOR_INTERACTABLE)
		for(var/obj/O in contents) //this is for deleting things like wires contained in the turf
			if(HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
				O.singularity_act()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	SSblackbox.record_feedback("amount", "turfs_singulod", 1)
	return(2)

/turf/proc/can_have_cabling()
	return TRUE

/turf/proc/can_lay_cable()
	return can_have_cabling() && underfloor_accessibility >= UNDERFLOOR_INTERACTABLE

/turf/proc/visibilityChanged()
	GLOB.cameranet.updateVisibility(src)

/turf/proc/burn_tile()
	return

/turf/proc/break_tile()
	return

/turf/proc/is_shielded()
	return

/turf/narsie_act(force, ignore_mobs, probability = 20)
	. = (prob(probability) || force)
	for(var/I in src)
		var/atom/A = I
		if(ignore_mobs && ismob(A))
			continue
		if(ismob(A) || .)
			A.narsie_act()

/turf/proc/add_blueprints(atom/movable/AM)
	var/image/I = new
	I.plane = GAME_PLANE
	I.layer = OBJ_LAYER
	I.appearance = AM.appearance
	I.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM
	I.loc = src
	I.setDir(AM.dir)
	I.alpha = 128
	LAZYADD(blueprint_data, I)

/turf/proc/add_blueprints_preround(atom/movable/AM)
	if(!SSicon_smooth.initialized)
		if(AM.layer == WIRE_LAYER) //wires connect to adjacent positions after its parent init, meaning we need to wait (in this case, until smoothing) to take its image
			SSicon_smooth.blueprint_queue += AM
		else
			add_blueprints(AM)

/turf/proc/is_transition_turf()
	return

/turf/acid_act(acidpwr, acid_volume)
	. = ..()
	if((acidpwr <= 0) || (acid_volume <= 0))
		return FALSE

	AddComponent(/datum/component/acid, acidpwr, acid_volume)
	for(var/obj/O in src)
		if(underfloor_accessibility < UNDERFLOOR_INTERACTABLE && HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
			continue

		O.acid_act(acidpwr, acid_volume)

	return . || TRUE

/turf/proc/acid_melt()
	return

/turf/rust_heretic_act()
	if(turf_flags & NO_RUST)
		return
	if(HAS_TRAIT(src, TRAIT_RUSTY))
		return

	AddElement(/datum/element/rust)

/turf/handle_fall(mob/faller)
	if(has_gravity(src))
		playsound(src, SFX_BODYFALL, 50, TRUE)
	faller.drop_all_held_items()

/turf/proc/photograph(limit=20)
	var/image/I = new()
	I.add_overlay(src)
	for(var/V in contents)
		var/atom/A = V
		if(A.invisibility)
			continue
		I.add_overlay(A)
		if(limit)
			limit--
		else
			return I
	return I

/turf/AllowDrop()
	return TRUE

/turf/proc/add_vomit_floor(mob/living/M, toxvomit = NONE, purge_ratio = 0.1)

	var/obj/effect/decal/cleanable/vomit/V = new /obj/effect/decal/cleanable/vomit(src, M.get_static_viruses())

	//if the vomit combined, apply toxicity and reagents to the old vomit
	if (QDELETED(V))
		V = locate() in src
	if(!V)
		return
	// Apply the proper icon set based on vomit type
	if(toxvomit == VOMIT_PURPLE)
		V.icon_state = "vomitpurp_[pick(1,4)]"
	else if (toxvomit == VOMIT_TOXIC)
		V.icon_state = "vomittox_[pick(1,4)]"
	if (purge_ratio && iscarbon(M))
		clear_reagents_to_vomit_pool(M, V, purge_ratio)

/proc/clear_reagents_to_vomit_pool(mob/living/carbon/M, obj/effect/decal/cleanable/vomit/V, purge_ratio = 0.1)
	var/obj/item/organ/stomach/belly = M.getorganslot(ORGAN_SLOT_STOMACH)
	if(!belly?.reagents.total_volume)
		return
	var/chemicals_lost = belly.reagents.total_volume * purge_ratio
	belly.reagents.trans_to(V, chemicals_lost, transfered_by = M)
	//clear the stomach of anything even not food
	for(var/bile in belly.reagents.reagent_list)
		var/datum/reagent/reagent = bile
		if(!belly.food_reagents[reagent.type])
			belly.reagents.remove_reagent(reagent.type, min(reagent.volume, 10))
		else
			var/bit_vol = reagent.volume - belly.food_reagents[reagent.type]
			if(bit_vol > 0)
				belly.reagents.remove_reagent(reagent.type, min(bit_vol, 10))

//Whatever happens after high temperature fire dies out or thermite reaction works.
//Should return new turf
/turf/proc/Melt()
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/// Handles exposing a turf to reagents.
/turf/expose_reagents(list/reagents, datum/reagents/source, methods=TOUCH, volume_modifier=1, show_message=TRUE, exposed_temperature)
	. = ..()
	if(. & COMPONENT_NO_EXPOSE_REAGENTS)
		return

	SEND_SIGNAL(source, COMSIG_REAGENTS_EXPOSE_TURF, src, reagents, methods, volume_modifier, show_message, exposed_temperature)
	for(var/reagent in reagents)
		var/datum/reagent/R = reagent
		. |= R.expose_turf(src, reagents[R], exposed_temperature)

/**
 * Called when this turf is being washed. Washing a turf will also wash any mopable floor decals
 */
/turf/wash(clean_types)
	. = ..()

	for(var/am in src)
		if(am == src)
			continue
		var/atom/movable/movable_content = am
		if(!ismopable(movable_content))
			continue
		movable_content.wash(clean_types)

/**
 * Returns adjacent turfs to this turf that are reachable, in all cardinal directions
 *
 * Arguments:
 * * caller: The movable, if one exists, being used for mobility checks to see what tiles it can reach
 * * ID: An ID card that decides if we can gain access to doors that would otherwise block a turf
 * * simulated_only: Do we only worry about turfs with simulated atmos, most notably things that aren't space?
 * * no_id: When true, doors with public access will count as impassible
*/
/turf/proc/reachableAdjacentTurfs(atom/movable/caller, ID, simulated_only, no_id = FALSE)
	. = list()

	for(var/iter_dir in GLOB.cardinals)
		var/turf/turf_to_check = get_step(src,iter_dir)
		if(!turf_to_check || (simulated_only && isspaceturf(turf_to_check)))
			continue
		if(turf_to_check.density || LinkBlockedWithAccess(turf_to_check, caller, ID, no_id = no_id))
			continue
		. += turf_to_check

/turf/proc/GetHeatCapacity()
	. = heat_capacity

/turf/proc/GetTemperature()
	. = temperature

/turf/proc/TakeTemperature(temp)
	temperature += temp

/turf/proc/is_below_sound_pressure()
	var/datum/gas_mixture/GM = unsafe_return_air()
	if(isnull(GM) || GM.returnPressure() < SOUND_MINIMUM_PRESSURE)
		return TRUE

/// Call to move a turf from its current area to a new one
/turf/proc/change_area(area/old_area, area/new_area)
	//dont waste our time
	if(old_area == new_area)
		return

	//move the turf
	old_area.turfs_to_uncontain += src
	new_area.contents += src
	new_area.contained_turfs += src

	//changes to make after turf has moved
	on_change_area(old_area, new_area)

/// Allows for reactions to an area change without inherently requiring change_area() be called (I hate maploading)
/turf/proc/on_change_area(area/old_area, area/new_area)
	transfer_area_lighting(old_area, new_area)

//A check to see if graffiti should happen
/turf/proc/try_graffiti(mob/vandal, obj/item/tool)

	if(!tool.sharpness)
		return FALSE

	if(!vandal.canUseTopic(src, USE_CLOSE) || !vandal.is_holding(tool))
		return FALSE

	if(HAS_TRAIT_FROM(src, TRAIT_NOT_ENGRAVABLE, INNATE_TRAIT))
		to_chat(vandal, span_warning("[src] cannot be engraved!"))
		return FALSE

	if(HAS_TRAIT_FROM(src, TRAIT_NOT_ENGRAVABLE, TRAIT_GENERIC))
		to_chat(vandal, span_warning("[src] already has an engraving."))
		return FALSE

	var/message = stripped_input(vandal, "Enter a message to engrave.", "Engraving", null ,64, TRUE)
	if(!message)
		return FALSE
	if(is_ic_filtered_for_pdas(message))
		REPORT_CHAT_FILTER_TO_USER(vandal, message)

	if(!vandal.canUseTopic(src, USE_CLOSE) || !vandal.is_holding(tool))
		return TRUE

	vandal.visible_message(span_warning("\The [vandal] begins carving something into \the [src]."))

	if(!do_after(vandal, src, max(2 SECONDS, length(message)), DO_PUBLIC, display = tool))
		return TRUE

	if(!vandal.canUseTopic(src, USE_CLOSE) || !vandal.is_holding(tool))
		return TRUE
	vandal.visible_message(span_obviousnotice("[vandal] carves some graffiti into [src]."))
	log_graffiti(message, vandal)
	AddComponent(/datum/component/engraved, message, TRUE)


	return TRUE
