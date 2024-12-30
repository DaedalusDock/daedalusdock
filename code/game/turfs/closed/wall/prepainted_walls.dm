/obj/item/wallpainter

/obj/item/wallpainter/attack_self(mob/user, modifiers)
	. = ..()
	var/wall_paint = alert(usr, "Wallpaint", "Wallpaint", "Yes", "No") == "Yes"
	var/wall_trim = alert(usr, "Walltrim", "Walltrim", "Yes", "No") == "Yes"

	var/_color = input(usr, "Pick Color") as color
	for(var/turf/closed/wall/W in view(user))
		if(wall_paint)
			W.wall_paint = _color
		if(wall_trim)
			W.stripe_paint = _color
		W.update_appearance()

	for(var/obj/structure/low_wall/L in view(user))
		if(wall_paint)
			L.wall_paint = _color
		if(wall_trim)
			L.stripe_paint = _color
		L.update_appearance()

///Dummy types for prepainted walls
/turf/closed/wall/prepainted
	name = "Pre-Painted Wall"

/turf/closed/wall/r_wall/prepainted
	name = "PRe-Painted Reinforced Wall"

//Daedalus/"Standard" walls

/turf/closed/wall/prepainted/daedalus
	color = PAINT_WALL_DAEDALUS
	wall_paint = PAINT_WALL_DAEDALUS
	stripe_paint = PAINT_STRIPE_DAEDALUS

/turf/closed/wall/r_wall/prepainted/daedalus
	color = PAINT_WALL_DAEDALUS
	wall_paint = PAINT_WALL_DAEDALUS
	stripe_paint = PAINT_STRIPE_DAEDALUS

/turf/closed/wall/prepainted/medical
	color = PAINT_WALL_MEDICAL
	wall_paint = PAINT_WALL_MEDICAL
	stripe_paint = PAINT_STRIPE_MEDICAL


/turf/closed/wall/r_wall/prepainted/medical
	color = PAINT_WALL_MEDICAL
	wall_paint = PAINT_WALL_MEDICAL
	stripe_paint = PAINT_STRIPE_MEDICAL

/turf/closed/wall/prepainted/bridge
	color = PAINT_WALL_COMMAND
	wall_paint = PAINT_WALL_COMMAND
	stripe_paint = PAINT_STRIPE_COMMAND

/turf/closed/wall/r_wall/prepainted/bridge
	color = PAINT_WALL_COMMAND
	wall_paint = PAINT_WALL_COMMAND
	stripe_paint = PAINT_STRIPE_COMMAND

/turf/closed/wall/prepainted/mars
	color = PAINT_WALL_MARS
	wall_paint = PAINT_WALL_MARS
	stripe_paint = PAINT_STRIPE_MARS

/turf/closed/wall/r_wall/prepainted/mars
	color = PAINT_WALL_MARS
	wall_paint = PAINT_WALL_MARS
	stripe_paint = PAINT_STRIPE_MARS
