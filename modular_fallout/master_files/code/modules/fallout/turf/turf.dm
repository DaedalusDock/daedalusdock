/turf
	var/border_neighbors = null
	var/sunlight_state = NO_SUNLIGHT

	obj/item/stack/digResult = /obj/item/stack/ore/glass/basalt
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
