/obj/structure/low_wall
	name = "low wall"
	desc = "A low wall, with space to mount windows or grilles on top of it."
	icon = 'icons/obj/smooth_structures/low_wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	color = "#57575c" //To display in mapping softwares
	greyscale_colors = "#57575c"
	density = TRUE
	anchored = TRUE
	pass_flags_self = PASSTABLE | LETPASSTHROW
	can_atmos_pass = CANPASS_ALWAYS
	layer = LOW_WALL_LAYER
	max_integrity = 150
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_LOW_WALL)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_LOW_WALL, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTERS_BLASTDOORS)
	armor = list(MELEE = 20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 25, BIO = 100, FIRE = 80, ACID = 100)
	greyscale_config = /datum/greyscale_config/low_wall
	/// Material used in construction
	var/plating_material = /datum/material/iron
	/// Paint color of our wall
	var/wall_paint
	/// Paint colour of our stripe
	var/stripe_paint
	/// Typecache of airlocks to apply a neighboring stripe overlay to
	var/static/list/airlock_typecache

/obj/structure/low_wall/Initialize(mapload)
	. = ..()
	if(!mapload)
		var/turf/T = get_turf(src)
		if(T)
			T.regenerate_ao()

/obj/structure/low_wall/update_greyscale()
	greyscale_colors = get_wall_color()
	return ..()

/obj/structure/low_wall/proc/get_wall_color()
	var/wall_color = wall_paint
	if(!wall_color)
		var/datum/material/plating_mat_ref = GET_MATERIAL_REF(plating_material)
		wall_color = plating_mat_ref.wall_color
	return wall_color

/obj/structure/low_wall/proc/get_stripe_color()
	var/stripe_color = stripe_paint
	if(!stripe_color)
		stripe_color = get_wall_color()
	return stripe_color

/obj/structure/low_wall/ex_act(severity)
	// Obstructed low walls cant be deleted through explosions
	if(is_top_obstructed())
		return
	return ..()

/obj/structure/low_wall/examine(mob/user)
	. = ..()
	. += span_notice("You could <b>weld</b> it down.")
	if(wall_paint)
		. += span_notice("It's coated with a <font color=[wall_paint]>layer of paint</font>.")
	if(stripe_paint)
		. += span_notice("It has a <font color=[stripe_paint]>painted stripe</font> around its base.")

/obj/structure/low_wall/Initialize(mapload)
	. = ..()
	color = null //To remove the mapping preview color
	AddElement(/datum/element/climbable)
	set_material(plating_material)
	if(wall_paint)
		set_wall_paint(wall_paint)
	if(stripe_paint)
		set_stripe_paint(stripe_paint)
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/structure/low_wall/update_overlays()
	overlays.Cut()
	var/datum/material/plating_mat_ref = GET_MATERIAL_REF(plating_material)

	var/icon/stripe_icon = SSgreyscale.GetColoredIconByType(plating_mat_ref.wall_stripe_greyscale_config, get_stripe_color())
	var/mutable_appearance/smoothed_stripe = mutable_appearance(stripe_icon, icon_state, layer = LOW_WALL_STRIPE_LAYER)
	overlays += smoothed_stripe

	if(!airlock_typecache)
		airlock_typecache = typecacheof(list(/obj/machinery/door/airlock, /obj/machinery/door/poddoor))
	var/neighbor_stripe = NONE
	for(var/cardinal in GLOB.cardinals)
		var/turf/step_turf = get_step(src, cardinal)
		var/obj/structure/low_wall/neighbor = locate() in step_turf
		if(neighbor)
			continue
		if(!can_area_smooth(step_turf))
			continue
		for(var/atom/movable/movable_thing as anything in step_turf)
			if(airlock_typecache[movable_thing.type])
				neighbor_stripe ^= cardinal
				break
	if(neighbor_stripe)
		var/icon/neighbor_icon = SSgreyscale.GetColoredIconByType(/datum/greyscale_config/wall_neighbor_stripe, get_stripe_color())
		var/mutable_appearance/neighb_stripe_appearace = mutable_appearance(neighbor_icon, "stripe-[neighbor_stripe]", layer = LOW_WALL_STRIPE_LAYER)
		overlays += neighb_stripe_appearace
	return ..()

/obj/structure/low_wall/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return
	if(mover.throwing)
		return TRUE
	if(locate(/obj/structure/low_wall) in get_turf(mover))
		return TRUE

/obj/structure/low_wall/IsObscured()
	return FALSE //We handle this ourselves. Please dont break <3.

/obj/structure/low_wall/attackby(obj/item/weapon, mob/living/user, params)
	if(istype(weapon, /obj/item/paint) || istype(weapon, /obj/item/paint_remover))
		return ..()

	if(is_top_obstructed())
		return TRUE
	var/list/modifiers = params2list(params)
	if(!(flags_1 & NODECONSTRUCT_1) && LAZYACCESS(modifiers, RIGHT_CLICK))
		if(weapon.tool_behaviour == TOOL_WELDER)
			if(weapon.tool_start_check(user, amount = 0))
				to_chat(user, span_notice("You start cutting \the [src]..."))
				if (weapon.use_tool(src, user, 50, volume = 50))
					to_chat(user, span_notice("You cut \the [src] down."))
					deconstruct(TRUE)
			return TRUE
	if(istype(weapon, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/my_sheet = weapon
		if(my_sheet.try_install_window(user, src.loc, src))
			return TRUE
	if(!user.combat_mode && !(weapon.item_flags & ABSTRACT))
		if(user.transferItemToLoc(weapon, loc, silent = FALSE, user_click_modifiers = modifiers))
			return TRUE
	return ..()

/obj/structure/low_wall/deconstruct(disassembled = TRUE, wrench_disassembly = 0)
	var/datum/material/plating_mat_ref = GET_MATERIAL_REF(plating_material)
	new plating_mat_ref.sheet_type(loc, 2)
	qdel(src)

/obj/structure/low_wall/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(is_top_obstructed())
		return FALSE
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 5)
		if(RCD_WINDOWGRILLE)
			/// Slight copypasta from grilles
			var/cost = 8
			var/delay = 2 SECONDS

			if(the_rcd.window_glass == RCD_WINDOW_REINFORCED)
				delay = 4 SECONDS
				cost = 12

			return rcd_result_with_memory(
				list("mode" = RCD_WINDOWGRILLE, "delay" = delay, "cost" = cost),
				get_turf(src), RCD_MEMORY_WINDOWGRILLE,
			)
	return FALSE

/obj/structure/low_wall/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(is_top_obstructed())
		return FALSE
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct \the [src]."))
			qdel(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			/// Slight copypasta from grilles
			var/turf/my_turf = loc
			if(!ispath(the_rcd.window_type, /obj/structure/window))
				CRASH("Invalid window path type in RCD: [the_rcd.window_type]")
			var/obj/structure/window/window_path = the_rcd.window_type
			if(!valid_window_location(my_turf, user.dir, is_fulltile = initial(window_path.fulltile)))
				return FALSE
			to_chat(user, span_notice("You construct the window."))
			var/obj/structure/window/WD = new the_rcd.window_type(my_turf, user.dir)
			WD.set_anchored(TRUE)
			return TRUE
	return FALSE

/obj/structure/low_wall/proc/set_wall_paint(new_paint)
	wall_paint = new_paint
	update_greyscale()
	update_appearance()

/obj/structure/low_wall/proc/set_stripe_paint(new_paint)
	stripe_paint = new_paint
	update_appearance()

/obj/structure/low_wall/proc/set_material(new_material_type)
	plating_material = new_material_type
	update_greyscale()
	update_appearance()

/// Whether the top of the low wall is obstructed by an installed grille or a window
/obj/structure/low_wall/proc/is_top_obstructed()
	var/obj/structure/window/window = locate() in loc
	if(window && window.anchored)
		return TRUE
	var/obj/structure/grille/grille = locate() in loc
	if(grille && grille.anchored)
		return TRUE
	return FALSE

/obj/structure/low_wall/titanium
	plating_material = /datum/material/titanium
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_LOW_WALL, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTERS_BLASTDOORS, SMOOTH_GROUP_SHUTTLE_PARTS)

/obj/structure/low_wall/plastitanium
	plating_material = /datum/material/alloy/plastitanium

/obj/structure/low_wall/wood
	plating_material = /datum/material/wood

//Dummy type for prepainted walls
/obj/structure/low_wall/prepainted

/obj/structure/low_wall/prepainted/daedalus
	wall_paint = PAINT_WALL_DAEDALUS
	stripe_paint = PAINT_STRIPE_DAEDALUS
