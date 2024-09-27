/*
 * False Walls
 */
/obj/structure/falsewall
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms."
	anchored = TRUE
	icon = 'icons/turf/walls/solid_wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	color = "#57575c" //To display in mapping softwares
	layer = LOW_OBJ_LAYER
	density = TRUE
	opacity = TRUE
	max_integrity = 100
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS
	can_be_unanchored = FALSE
	can_atmos_pass = CANPASS_PROC
	rad_insulation = RAD_MEDIUM_INSULATION
	material_flags = MATERIAL_EFFECTS
	/// Material type of the plating
	var/plating_material = /datum/material/iron
	/// Material type of the reinforcement
	var/reinf_material
	/// Paint of the wall
	var/wall_paint
	/// Stripe paint of the wall
	var/stripe_paint
	var/opening = FALSE
	/// Material Set Name
	var/matset_name

	//These are set by the material, do not touch!!!
	var/material_color
	var/stripe_icon
	//Ok you can touch vars again :)

	/// Typecache of the neighboring objects that we want to neighbor stripe overlay with
	var/static/list/neighbor_typecache

/obj/structure/falsewall/Initialize()
	color = null //Clear the mapaid color. This should hopefully not cause problems.
	//This has to be stripped before the supercall so it doesn't end up in atom_colours.
	. = ..()
	zas_update_loc()
	set_materials(plating_material, reinf_material)

/obj/structure/falsewall/proc/get_wall_color()
	return wall_paint || material_color

/obj/structure/falsewall/proc/get_stripe_color()
	return stripe_paint || material_color

/obj/structure/falsewall/update_name()
	. = ..()
	name = matset_name

/obj/structure/falsewall/attack_hand(mob/user, list/modifiers)
	if(opening)
		return
	. = ..()
	if(.)
		return

	opening = TRUE
	update_appearance()
	if(!density)
		var/srcturf = get_turf(src)
		for(var/mob/living/obstacle in srcturf) //Stop people from using this as a shield
			opening = FALSE
			return
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/falsewall, toggle_open)), 5)

/obj/structure/falsewall/proc/toggle_open()
	if(!QDELETED(src))
		set_density(!density)
		set_opacity(density)
		opening = FALSE
		update_appearance()
		zas_update_loc()

/obj/structure/falsewall/zas_canpass(turf/other)
	if(QDELETED(src))
		return AIR_ALLOWED
	return ZONE_BLOCKED

/obj/structure/falsewall/update_icon(updates=ALL)//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	. = ..()
	if(!density || !(updates & UPDATE_SMOOTHING))
		return

	if(opening)
		smoothing_flags = NONE
		clear_smooth_overlays()
	else
		smoothing_flags = SMOOTH_BITMASK
		QUEUE_SMOOTH(src)

/obj/structure/falsewall/update_icon_state()
	if(opening)
		icon_state = "fwall_[density ? "opening" : "closing"]"
		return ..()
	icon_state = density ? "[base_icon_state]-[smoothing_junction]" : "fwall_open"
	return ..()

/// Partially copypasted from /turf/closed/wall
/obj/structure/falsewall/update_overlays()
	//Updating the unmanaged wall overlays (unmanaged for optimisations)
	overlays.len = 0
	var/list/new_overlays = list()
	if(density && !opening)
		color = wall_paint || material_color

		var/image/smoothed_stripe = image(stripe_icon, icon_state)
		smoothed_stripe.appearance_flags = RESET_COLOR
		smoothed_stripe.color = stripe_paint || material_color
		new_overlays += smoothed_stripe

		var/neighbor_stripe = NONE
		if(!neighbor_typecache)
			neighbor_typecache = typecacheof(list(/obj/machinery/door/airlock, /obj/structure/window/reinforced/fulltile, /obj/structure/window/fulltile, /obj/structure/window/reinforced/shuttle, /obj/machinery/door/poddoor))

		for(var/cardinal in GLOB.cardinals)
			var/turf/step_turf = get_step(src, cardinal)
			var/can_area_smooth
			CAN_AREAS_SMOOTH(src, step_turf, can_area_smooth)
			if(isnull(can_area_smooth))
				continue
			for(var/atom/movable/movable_thing as anything in step_turf)
				if(neighbor_typecache[movable_thing.type])
					neighbor_stripe ^= cardinal
					break

		if(neighbor_stripe)
			var/image/neighb_stripe_overlay = image('icons/turf/walls/neighbor_stripe.dmi', "stripe-[neighbor_stripe]")
			neighb_stripe_overlay.appearance_flags = RESET_COLOR
			neighb_stripe_overlay.color = stripe_paint || material_color
			new_overlays += neighb_stripe_overlay

		overlays = new_overlays
		//And letting anything else that may want to render on the wall to work (ie components)
	return ..()

/obj/structure/falsewall/proc/ChangeToWall(delete = 1)
	var/datum/material/plating_mat_ref = GET_MATERIAL_REF(plating_material)
	var/turf/T = get_turf(src)
	T.PlaceOnTop(plating_mat_ref.wall_type)
	var/turf/closed/wall/placed_wall = T
	placed_wall.set_wall_information(plating_material, reinf_material, wall_paint, stripe_paint)
	if(delete)
		qdel(src)
	return T

/obj/structure/falsewall/tool_act(mob/living/user, obj/item/tool)
	if(!opening)
		return ..()
	to_chat(user, span_warning("You must wait until the door has stopped moving!"))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/falsewall/screwdriver_act(mob/living/user, obj/item/tool)
	if(!density)
		to_chat(user, span_warning("You can't reach, close it first!"))
		return
	var/turf/loc_turf = get_turf(src)
	if(loc_turf.density)
		to_chat(user, span_warning("[src] is blocked!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if(!isfloorturf(loc_turf))
		to_chat(user, span_warning("[src] bolts must be tightened on the floor!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	user.visible_message(span_notice("[user] tightens some bolts on the wall."), span_notice("You tighten the bolts on the wall."))
	ChangeToWall()
	return TOOL_ACT_TOOLTYPE_SUCCESS


/obj/structure/falsewall/welder_act(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, 0 SECONDS, volume=50))
		dismantle(user, TRUE)
		return TOOL_ACT_TOOLTYPE_SUCCESS
	return

/// Painfully copypasted from /turf/closed/wall
/obj/structure/falsewall/proc/paint_wall(new_paint)
	wall_paint = new_paint
	update_appearance()

/// Painfully copypasted from /turf/closed/wall
/obj/structure/falsewall/proc/paint_stripe(new_paint)
	stripe_paint = new_paint
	update_appearance()

/// Painfully copypasted from /turf/closed/wall
/obj/structure/falsewall/proc/set_wall_information(plating_mat, reinf_mat, new_paint, new_stripe_paint)
	wall_paint = new_paint
	stripe_paint = new_stripe_paint
	set_materials(plating_mat, reinf_mat)

/// Painfully copypasted from /turf/closed/wall (Twice!)
/obj/structure/falsewall/proc/set_materials(plating_mat, reinf_mat, update_appearance = TRUE)
	var/datum/material/plating_mat_ref = GET_MATERIAL_REF(plating_mat)
	var/datum/material/reinf_mat_ref
	if(reinf_mat)
		reinf_mat_ref = GET_MATERIAL_REF(reinf_mat)

	if(reinf_mat_ref)
		icon = plating_mat_ref.reinforced_wall_icon
		material_color = plating_mat_ref.wall_color
	else
		icon = plating_mat_ref.wall_icon
		material_color = plating_mat_ref.wall_color

	if(reinf_mat_ref)
		stripe_icon = plating_mat_ref.reinforced_wall_stripe_icon
	else
		stripe_icon = plating_mat_ref.wall_stripe_icon

	plating_material = plating_mat
	reinf_material = reinf_mat

	if(reinf_material)
		name = "reinforced [plating_mat_ref.name] [plating_mat_ref.wall_name]"
		desc = "It seems to be a section of hull reinforced with [reinf_mat_ref.name] and plated with [plating_mat_ref.name]."
		explosion_block = initial(explosion_block) * 2
	else
		name = "[plating_mat_ref.name] [plating_mat_ref.wall_name]"
		desc = "It seems to be a section of hull plated with [plating_mat_ref.name]."
		explosion_block = initial(explosion_block)

	matset_name = name

	if(update_appearance)
		update_appearance()

/obj/structure/falsewall/attackby(obj/item/W, mob/user, params)
	if(opening)
		to_chat(user, span_warning("You must wait until the door has stopped moving!"))
		return
	return ..()

/obj/structure/falsewall/proc/dismantle(mob/user, disassembled=TRUE, obj/item/tool = null)
	user.visible_message(span_notice("[user] dismantles the false wall."), span_notice("You dismantle the false wall."))
	if(tool)
		tool.play_tool_sound(src, 100)
	else
		playsound(src, 'sound/items/welder.ogg', 100, TRUE)
	deconstruct(disassembled)

/obj/structure/falsewall/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			new /obj/structure/girder(src.loc, reinf_material, wall_paint, stripe_paint, TRUE)
		var/datum/material/plating_mat_ref = GET_MATERIAL_REF(plating_material)
		new plating_mat_ref.sheet_type(src.loc, 2)
	qdel(src)

/obj/structure/falsewall/get_dumping_location()
	return null

/obj/structure/falsewall/examine_status(mob/user) //So you can't detect falsewalls by examine.
	to_chat(user, span_notice("The outer plating is <b>welded</b> firmly in place."))
	return null

/*
 * False R-Walls
 */

/obj/structure/falsewall/reinforced
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon = 'icons/turf/walls/solid_wall_reinforced.dmi'
	reinf_material = /datum/material/alloy/plasteel

/obj/structure/falsewall/reinforced/examine_status(mob/user)
	to_chat(user, span_notice("The outer <b>grille</b> is fully intact."))
	return null

/obj/structure/falsewall/reinforced/attackby(obj/item/tool, mob/user)
	..()
	if(tool.tool_behaviour == TOOL_WIRECUTTER)
		dismantle(user, TRUE, tool)

/*
 * Uranium Falsewalls
 */

/obj/structure/falsewall/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	plating_material = /datum/material/uranium
	var/active = null
	var/last_event = 0

/obj/structure/falsewall/uranium/attackby(obj/item/W, mob/user, params)
	radiate()
	return ..()

/obj/structure/falsewall/uranium/attack_hand(mob/user, list/modifiers)
	radiate()
	. = ..()

/obj/structure/falsewall/uranium/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			radiation_pulse(
				src,
				max_range = 2,
				threshold = RAD_LIGHT_INSULATION,
				chance = URANIUM_IRRADIATION_CHANCE,
				minimum_exposure_time = URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME,
			)
			for(var/turf/closed/wall/mineral/uranium/T in orange(1,src))
				T.radiate()
			last_event = world.time
			active = null
			return
	return
/*
 * Other misc falsewall types
 */

/obj/structure/falsewall/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	plating_material = /datum/material/gold

/obj/structure/falsewall/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny."
	plating_material = /datum/material/silver

/obj/structure/falsewall/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	plating_material = /datum/material/diamond
	max_integrity = 800

/obj/structure/falsewall/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definitely a bad idea."
	plating_material = /datum/material/plasma

/obj/structure/falsewall/bananium
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	plating_material = /datum/material/bananium


/obj/structure/falsewall/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating. Rough."
	icon = 'icons/turf/walls/stone_wall.dmi'
	plating_material = /datum/material/sandstone

/obj/structure/falsewall/wood
	name = "wooden wall"
	desc = "A wall with wooden plating. Stiff."
	icon = 'icons/turf/walls/wood_wall.dmi'
	icon_state = "wood_wall-0"
	base_icon_state = "wood_wall"
	plating_material = /datum/material/wood

/obj/structure/falsewall/iron
	name = "rough iron wall"
	desc = "A wall with rough metal plating."
	base_icon_state = "iron_wall"

/obj/structure/falsewall/abductor
	name = "alien wall"
	desc = "A wall with alien alloy plating."
	plating_material = /datum/material/alloy/alien

/obj/structure/falsewall/titanium
	name = "wall"
	desc = "A light-weight titanium wall used in shuttles."
	icon = 'icons/turf/walls/metal_wall.dmi'
	plating_material = /datum/material/titanium
	smoothing_groups = SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_LOW_WALL + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/obj/structure/falsewall/plastitanium
	name = "wall"
	desc = "An evil wall of plasma and titanium."
	icon = 'icons/turf/walls/metal_wall.dmi'
	plating_material = /datum/material/alloy/plastitanium
	smoothing_groups = SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS
