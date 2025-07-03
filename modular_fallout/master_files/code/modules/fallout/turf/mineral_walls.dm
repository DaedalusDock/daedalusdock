/*
/turf/closed/wall/mineral/diamond/thermitemelt(mob/user)
	return

/turf/closed/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating. Rough."
	icon = 'icons/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone"
	sheet_type = /obj/item/stack/sheet/mineral/sandstone
	explosion_block = 0
	canSmoothWith = list(/turf/closed/wall/mineral/sandstone, /obj/structure/falsewall/sandstone)

/turf/closed/wall/mineral/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium"
	sheet_type = /obj/item/stack/sheet/mineral/uranium
	canSmoothWith = list(/turf/closed/wall/mineral/uranium, /obj/structure/falsewall/uranium)

/turf/closed/wall/mineral/uranium/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			radiation_pulse(get_turf(src), 3, 3, 4, 0)
			for(var/turf/closed/wall/mineral/uranium/T in orange(1,src))
				T.radiate()
			last_event = world.time
			active = null
			return
	return

/turf/closed/wall/mineral/uranium/attack_hand(mob/user)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/attackby(obj/item/weapon/W, mob/user, params)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/Bumped(AM as mob|obj)
	radiate()
	..()

/turf/closed/wall/mineral/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definitely a bad idea."
	icon = 'icons/turf/walls/plasma_wall.dmi'
	icon_state = "plasma"
	sheet_type = /obj/item/stack/sheet/mineral/plasma
	thermal_conductivity = 0.04
	canSmoothWith = list(/turf/closed/wall/mineral/plasma, /obj/structure/falsewall/plasma)

/turf/closed/wall/mineral/plasma/attackby(obj/item/weapon/W, mob/user, params)
	if(W.is_hot() > 300)//If the temperature of the object is over 300, then ignite
		message_admins("Plasma wall ignited by [key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("Plasma wall ignited by [key_name(user)] in ([x],[y],[z])")
		ignite(W.is_hot())
		return
	..()

/turf/closed/wall/mineral/plasma/proc/PlasmaBurn(temperature)
	new girder_type(src)
	src.ChangeTurf(/turf/open/floor/plasteel)
	var/turf/open/T = src
	T.atmos_spawn_air("plasma=400;TEMP=1000")

/turf/closed/wall/mineral/plasma/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/closed/wall/mineral/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/closed/wall/mineral/plasma/bullet_act(obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		PlasmaBurn(2500)
	else if(istype(Proj,/obj/item/projectile/ion))
		PlasmaBurn(500)
	..()

*/
/turf/closed/wall/mineral/wood
	name = "wooden wall"
	desc = "A wall made by a wasteland dweller."
	icon = 'modular_fallout/master_files/icons/fallout/turfs/walls/wood_crafted.dmi'
	icon_state = "wood"
	plating_material = /obj/item/stack/sheet/mineral/wood
	hardness = 70
	explosion_block = 0
	//canSmoothWith = list(/turf/closed/wall/mineral/wood, /obj/structure/falsewall/wood)

/turf/closed/wall/mineral/wood/New()
	..()
	for(var/turf/closed/wall/mineral/wood/W in range(src,1))
		W.relativewall()
	..()

/turf/closed/wall/mineral/wood/Del()
	for(var/turf/closed/wall/mineral/wood/W in range(src,1))
		W.relativewall()
	..()

//Bringing back an old version of wall smoothing code because this has a bit of a special icon.
/turf/closed/wall/mineral/wood/proc/relativewall()
	var/junction = 0

	for(var/cdir in GLOB.cardinals)
		var/turf/T = get_step(src,cdir)
		if(istype(T, /turf/closed/wall/mineral/wood))
			junction |= cdir
			continue
		for(var/atom/A in T)
			if(istype(A, /obj/structure/window/fulltile))
				junction |= cdir
				break


	switch(junction)
		if(3)
			icon_state = "wood1"
		if(12)
			icon_state = "wood2"
		else
			icon_state = "wood"

/turf/closed/wall/mineral/iron
	name = "rough metal wall"
	desc = "A wall with rough metal plating."
	icon = 'icons/turf/walls/iron_wall.dmi'
	icon_state = "iron"
	plating_material = /obj/item/stack/rods

/turf/closed/wall/mineral/snow
	name = "packed snow wall"
	desc = "A wall made of densely packed snow blocks."
	icon = 'icons/turf/walls/snow_wall.dmi'
	icon_state = "snow"
	hardness = 80
	plating_material = /obj/item/stack/sheet/mineral/snow

/turf/closed/wall/mineral/abductor
	name = "polymer wall" // Fortuna edit: alien alloy -> polymer
	desc = "A wall with an advanced polymer alloy plating."
	icon = 'icons/turf/walls/abductor_wall.dmi'
	icon_state = "abductor"
	plating_material = /obj/item/stack/sheet/mineral/abductor
	slicing_duration = 200   //alien wall takes twice as much time to slice
	explosion_block = 3
/*
/turf/closed/wall/mineral/titanium //has to use this path due to how building walls works
	name = "wall"
	desc = "A lightweight titanium wall used in shuttles."
	icon = 'icons/turf/walls/shuttle_wall.dmi'
	icon_state = "map-shuttle"
	sheet_type = /obj/item/stack/sheet/mineral/titanium
	smooth = SMOOTH_MORE|SMOOTH_DIAGONAL
	canSmoothWith = list(/turf/closed/wall/mineral/titanium, /obj/machinery/door/airlock/shuttle, /obj/machinery/door/airlock/, /turf/closed/wall/shuttle, /obj/structure/window/shuttle, /obj/structure/shuttle/engine, /obj/structure/shuttle/engine/heater, )

/turf/closed/wall/mineral/titanium/nodiagonal
	smooth = SMOOTH_MORE
	icon_state = "map-shuttle_nd"

/turf/closed/wall/mineral/titanium/nosmooth
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall"
	smooth = SMOOTH_FALSE

/turf/closed/wall/mineral/titanium/overspace
	icon_state = "map-overspace"
	fixed_underlay = list("space"=1)

//sub-type to be used for interior shuttle walls
//won't get an underlay of the destination turf on shuttle move
/turf/closed/wall/mineral/titanium/interior/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colours = atom_colours.Copy()
		T.update_atom_colour()
	if(T.dir != dir)
		T.dir = dir
	T.transform = transform
	return T

/turf/closed/wall/mineral/titanium/copyTurf(turf/T)
	. = ..()
	T.transform = transform

/turf/closed/wall/mineral/plastitanium
	name = "wall"
	desc = "An evil wall of plasma and titanium."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall3"
	sheet_type = /obj/item/stack/sheet/mineral/plastitanium
	smooth = SMOOTH_FALSE

//have to copypaste this code
/turf/closed/wall/mineral/plastitanium/interior/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colours = atom_colours.Copy()
		T.update_atom_colour()
	if(T.dir != dir)
		T.dir = dir
	T.transform = transform
	return T

/turf/closed/wall/mineral/plastitanium/copyTurf(turf/T)
	. = ..()
	T.transform = transform
*/
