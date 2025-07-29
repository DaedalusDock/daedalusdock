/turf
	var/border_neighbors = null
	var/sunlight_state = NO_SUNLIGHT

	var/obj/item/stack/dig_result = /obj/item/stack/ore/glass/basalt
	/// Icon state to use when broken
	var/can_dig = FALSE
/*
/// Drops itemstack when dug and changes icon
/turf/proc/getDug()
	if(can_dig)
		dug = TRUE
		new digResult(src, 5)
		icon_state = "[base_icon_state]_dug"
*/
/turf/Initialize(mapload)
	.=..()
	var/area/our_area = loc
	if(!our_area.luminosity && always_lit) //Only provide your own lighting if the area doesn't for you
		add_overlay(global.fullbright_overlay)
	else
		switch(sunlight_state)
			if(SUNLIGHT_SOURCE)
				setup_sunlight_source()
			if(SUNLIGHT_BORDER)
				border_neighbors = null
				smooth_sunlight_border()
	..()

/turf/open/misc/asteroid/proc/get_Dug()
	dug = TRUE
	new dig_result(src, 5)
	icon_state = "[base_icon_state]_dug"

/turf/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(.)
		return TRUE

	if(W.tool_behaviour == TOOL_SHOVEL || W.tool_behaviour == TOOL_MINING)
		if(!can_dig(user))
			return TRUE

		if(!isturf(user.loc))
			return

		to_chat(user, span_notice("You start digging..."))

		if(W.use_tool(src, user, 40, volume=50))
			if(!can_dig(user))
				return TRUE
			to_chat(user, span_notice("You dig a hole."))
			get_Dug()
			SSblackbox.record_feedback("tally", "pick_used_mining", 1, W.type)
			return TRUE
	else if(istype(W, /obj/item/storage/bag/ore))
		for(var/obj/item/stack/ore/O in src)
			SEND_SIGNAL(W, COMSIG_PARENT_ATTACKBY, O)
