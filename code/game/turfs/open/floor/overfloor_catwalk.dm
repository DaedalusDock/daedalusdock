/**
 * ## catwalk flooring
 *
 * They show what's underneath their catwalk flooring (pipes and the like)
 * you can screwdriver it to interact with the underneath stuff without destroying the tile...
 * unless you want to!
 */
/obj/structure/overfloor_catwalk
	name = "catwalk floor"
	desc = "Flooring that shows its contents underneath. Engineers love it!"

	icon = 'icons/turf/floors/catwalk_plating.dmi'
	icon_state = "maint"
	base_icon_state = "maint"
	layer = CATWALK_LAYER
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_OPAQUE

	smoothing_groups = null
	smoothing_flags = NONE
	canSmoothWith = null

	anchored = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP | BLOCK_Z_FALL

	var/covered = TRUE
	var/tile_type = /obj/item/stack/overfloor_catwalk

#ifdef SIMPLE_MAPHELPERS
// Set these back to the turf layer so that they don't block underfloor equipment
/obj/structure/overfloor_catwalk
	layer = TURF_LAYER
#endif

/obj/structure/overfloor_catwalk/Initialize(mapload)
	. = ..()
	if(!isturf(loc))
		return INITIALIZE_HINT_QDEL

	for(var/obj/structure/overfloor_catwalk/cat in loc)
		if(cat == src)
			continue
		stack_trace("multiple lattices found in ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL

	var/turf/T = loc
	T.update_underfloor_accessibility()

	AddElement(/datum/element/footstep_override, clawfootstep = FOOTSTEP_CATWALK, heavyfootstep = FOOTSTEP_CATWALK, footstep = FOOTSTEP_CATWALK)

	var/static/list/loc_connections = list(
		COMSIG_TURF_CHANGE = PROC_REF(pre_turf_change)
	)

	AddElement(/datum/element/connect_loc, loc_connections)

	update_appearance(UPDATE_OVERLAYS)

/obj/structure/overfloor_catwalk/proc/pre_turf_change(datum/source, path, new_baseturfs, flags, post_change_callbacks)
	SIGNAL_HANDLER
	if(ispath(path, /turf/open/floor/plating))
		return

	post_change_callbacks += CALLBACK(src, PROC_REF(deconstruct), FALSE)

/obj/structure/overfloor_catwalk/examine(mob/user)
	. = ..()
	. += span_notice("The mesh comes out with a few simple <b>screws</b>.")
	. += span_notice("The frame can be popped out with some <b>leverage</b>.")

/obj/structure/overfloor_catwalk/update_overlays()
	. = ..()
	if(!covered)
		return

	. += image(icon, null, "lattice", CATWALK_LATTICE_LAYER)

/obj/structure/overfloor_catwalk/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(isturf(old_loc))
		var/turf/old_turf = old_loc
		old_turf.update_underfloor_accessibility()

	if(isturf(loc))
		var/turf/turf_loc = loc
		turf_loc.update_underfloor_accessibility()

/obj/structure/overfloor_catwalk/deconstruct(disassembled = TRUE)
	if(disassembled && loc)
		new tile_type(drop_location())
	qdel(src)

/obj/structure/overfloor_catwalk/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	covered = !covered
	if(!covered)
		obj_flags &= ~(BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP | BLOCK_Z_FALL)
		mouse_opacity = MOUSE_OPACITY_ICON
	else
		obj_flags |= (BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP | BLOCK_Z_FALL)
		mouse_opacity = MOUSE_OPACITY_OPAQUE

	tool.play_tool_sound(src)
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/structure/overfloor_catwalk/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(tool.use_tool(src, user, volume=80))
		deconstruct(TRUE)
		return TRUE

/obj/structure/overfloor_catwalk/singularity_pull(S, current_size)
	if(current_size >= STAGE_FOUR)
		deconstruct(TRUE)

/obj/structure/overfloor_catwalk/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_FLOORWALL)
		return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 2)

//Reskins! More fitting with most of our tiles, and appear as a radial on the base type
/obj/structure/overfloor_catwalk/iron
	name = "iron plated catwalk floor cover"
	icon_state = "iron"
	base_icon_state = "iron"
	tile_type = /obj/item/stack/overfloor_catwalk/iron

/obj/structure/overfloor_catwalk/iron_white
	name = "white plated catwalk floor cover"
	icon_state = "whiteiron"
	base_icon_state = "whiteiron"
	tile_type = /obj/item/stack/overfloor_catwalk/iron_white

/obj/structure/overfloor_catwalk/iron_dark
	name = "dark plated catwalk floor cover"
	icon_state = "darkiron"
	base_icon_state = "darkiron"
	tile_type = /obj/item/stack/overfloor_catwalk/iron_dark

/obj/structure/overfloor_catwalk/flat_white
	name = "white large plated catwalk floor cover"
	icon_state = "flatwhite"
	base_icon_state = "flatwhite"
	tile_type = /obj/item/stack/overfloor_catwalk/flat_white

/obj/structure/overfloor_catwalk/iron_smooth //the original green type
	name = "smooth plated catwalk floor cover"
	icon_state = "smoothiron"
	base_icon_state = "smoothiron"
	tile_type = /obj/item/stack/overfloor_catwalk/iron_smooth

/obj/structure/overfloor_catwalk/titanium
	name = "titanium plated catwalk floor cover"
	icon_state = "smoothiron"
	base_icon_state = "smoothiron"
	tile_type = /obj/item/stack/overfloor_catwalk/titanium
