/// For use on the splashcreen
/obj/effect/abstract/splashscreen
	name = null
	desc = null

	// Debug stuff, shows the physical positions
	// icon = 'icons/area/areas_misc.dmi'
	// icon_state = "cordon"

	vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_ID | VIS_INHERIT_PLANE

INITIALIZE_IMMEDIATE(/obj/effect/abstract/splashscreen)
/obj/effect/abstract/splashscreen/master
	name = "Space Station 13"
	desc = null
	icon = null
	icon_state = null
	vis_flags = NONE
	plane = SPLASHSCREEN_PLANE

/obj/effect/abstract/splashscreen/master/Initialize(mapload)
	. = ..()
	SStitle.master_object = src
	add_viscontents(new /obj/effect/abstract/splashscreen/backdrop)

/obj/effect/abstract/splashscreen/backdrop
	icon = 'icons/blanks/blank_title.png'
	icon_state = ""

/obj/effect/abstract/splashscreen/backdrop/Initialize(mapload)
	. = ..()
	SStitle.backdrop = src
	if(SStitle.icon)
		icon = SStitle.icon
		handle_generic_titlescreen_sizes()

///helper proc that will center the screen if the icon is changed to a generic width, to make admins have to fudge around with pixel_x less. returns null
/obj/effect/abstract/splashscreen/backdrop/proc/handle_generic_titlescreen_sizes()
	var/icon/size_check = icon(SStitle.backdrop.icon, SStitle.backdrop.icon_state)
	var/width = size_check.Width()
	if(width == 480) // 480x480 is nonwidescreen
		pixel_x = 0
	else if(width == 608) // 608x480 is widescreen
		pixel_x = -64

/obj/effect/abstract/splashscreen/backdrop/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, icon))
				icon = var_value
				handle_generic_titlescreen_sizes()
