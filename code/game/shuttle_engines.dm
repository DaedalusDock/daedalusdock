#define ENGINE_UNWRENCHED 0
#define ENGINE_WRENCHED 1
#define ENGINE_WELDED 2
#define ENGINE_WELDTIME 200

TYPEINFO_DEF(/obj/structure/shuttle)
	default_armor = list(BLUNT = 100, PUNCTURE = 40, SLASH = 100, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 70)

/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	smoothing_groups = SMOOTH_GROUP_SHUTTLE_PARTS
	max_integrity = 500
	can_atmos_pass = CANPASS_DENSITY

/obj/structure/shuttle/engine
	name = "engine"
	desc = "A bluespace engine used to make shuttles move."
	density = TRUE
	anchored = TRUE
	var/engine_power = 1
	var/state = ENGINE_WELDED //welding shmelding

//Ugh this is a lot of copypasta from emitters, welding need some boilerplate reduction
/obj/structure/shuttle/engine/can_be_unfasten_wrench(mob/user, silent)
	if(state == ENGINE_WELDED)
		if(!silent)
			to_chat(user, span_warning("[src] is welded to the floor!"))
		return FAILED_UNFASTEN
	return ..()

/obj/structure/shuttle/engine/default_unfasten_wrench(mob/user, obj/item/I, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		if(anchored)
			state = ENGINE_WRENCHED
		else
			state = ENGINE_UNWRENCHED

/obj/structure/shuttle/engine/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/shuttle/engine/welder_act(mob/living/user, obj/item/I)
	. = ..()
	switch(state)
		if(ENGINE_UNWRENCHED)
			to_chat(user, span_warning("The [src.name] needs to be wrenched to the floor!"))
		if(ENGINE_WRENCHED)
			if(!I.tool_start_check(user, amount=0))
				return TRUE

			user.visible_message(span_notice("[user.name] starts to weld the [name] to the floor."), \
				span_notice("You start to weld \the [src] to the floor..."), \
				span_hear("You hear welding."))

			if(I.use_tool(src, user, ENGINE_WELDTIME, volume=50))
				state = ENGINE_WELDED
				to_chat(user, span_notice("You weld \the [src] to the floor."))
				alter_engine_power(engine_power)

		if(ENGINE_WELDED)
			if(!I.tool_start_check(user, amount=0))
				return TRUE

			user.visible_message(span_notice("[user.name] starts to cut the [name] free from the floor."), \
				span_notice("You start to cut \the [src] free from the floor..."), \
				span_hear("You hear welding."))

			if(I.use_tool(src, user, ENGINE_WELDTIME, volume=50))
				state = ENGINE_WRENCHED
				to_chat(user, span_notice("You cut \the [src] free from the floor."))
				alter_engine_power(-engine_power)
	return TRUE

/obj/structure/shuttle/engine/Destroy()
	if(state == ENGINE_WELDED)
		alter_engine_power(-engine_power)
	. = ..()

//Propagates the change to the shuttle.
/obj/structure/shuttle/engine/proc/alter_engine_power(mod)
	if(mod == 0)
		return
	if(SSshuttle.is_in_shuttle_bounds(src))
		var/obj/docking_port/mobile/M = SSshuttle.get_containing_shuttle(src)
		if(M)
			M.alter_engines(mod)

/obj/structure/shuttle/engine/heater
	name = "engine heater"
	icon_state = "heater"
	desc = "Directs energy into compressed particles in order to power engines."
	engine_power = 0 // todo make these into 2x1 parts

/obj/structure/shuttle/engine/platform
	name = "engine platform"
	icon_state = "platform"
	desc = "A platform for engine components."
	engine_power = 0

/obj/structure/shuttle/engine/propulsion
	name = "propulsion engine"
	icon_state = "propulsion"
	desc = "A standard reliable bluespace engine used by many forms of shuttles."
	opacity = TRUE

/obj/structure/shuttle/engine/propulsion/in_wall
	name = "in-wall propulsion engine"
	icon_state = "propulsion_w"
	density = FALSE
	opacity = FALSE
	smoothing_groups = null

/obj/structure/shuttle/engine/propulsion/left
	name = "left propulsion engine"
	icon_state = "propulsion_l"

/obj/structure/shuttle/engine/propulsion/right
	name = "right propulsion engine"
	icon_state = "propulsion_r"

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst engine"
	desc = "An engine that releases a large bluespace burst to propel it."

/obj/structure/shuttle/engine/propulsion/burst/cargo
	state = ENGINE_UNWRENCHED
	anchored = FALSE

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left burst engine"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right burst engine"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "engine router"
	icon_state = "router"
	desc = "Redirects around energized particles in engine structures."

/obj/structure/shuttle/engine/large
	name = "engine"
	opacity = TRUE
	icon = 'icons/obj/2x2.dmi'
	icon_state = "large_engine"
	desc = "A very large bluespace engine used to propel very large ships."
	bound_width = 64
	bound_height = 64
	appearance_flags = LONG_GLIDE

/obj/structure/shuttle/engine/large/in_wall
	name = "in-wall engine"
	icon_state = "large_engine_w"
	density = FALSE
	opacity = FALSE
	smoothing_groups = null

/obj/structure/shuttle/engine/huge
	name = "engine"
	opacity = TRUE
	icon = 'icons/obj/3x3.dmi'
	icon_state = "huge_engine"
	desc = "An extremely large bluespace engine used to propel extremely large ships."
	bound_width = 96
	bound_height = 96
	appearance_flags = LONG_GLIDE

/obj/structure/shuttle/engine/huge/in_wall
	name = "in-wall engine"
	icon_state = "huge_engine_w"
	density = FALSE
	opacity = FALSE
	smoothing_groups = null

#undef ENGINE_UNWRENCHED
#undef ENGINE_WRENCHED
#undef ENGINE_WELDED
#undef ENGINE_WELDTIME
