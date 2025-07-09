//Fallout 13 campfire directory

/obj/structure/campfire
	name = "campfire"

	density = 0
	anchored = 1
	opacity = 0

	var/fired = 0
	var/fuel = 300
	light_color = LIGHT_COLOR_FIRE
	var/burned = 0
	desc = "A warm, bright, and hopeful fire source - when it's burning, of course."

	icon = 'modular_fallout/master_files/icons/fallout/objects/furniture/heating.dmi'
	icon_state = "campfire"

/obj/structure/campfire/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/structure/campfire/attackby(obj/item/P, mob/user, params)
	if(P.get_temperature())
		fire(user)
	if(istype(P, /obj/item/shovel))
		to_chat(user, "You remove some campfire ashes.")
		qdel(src)
		return
	else if(istype(P, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/W = P
		if(fuel > 3000)
			to_chat(user, "You can't add more fuel - wait untill some of it burns away!")
			return
		if(W.use(1))
			user.visible_message("[user] has added fuel to [src].", "<span class='notice'>You have added fuel to [src].</span>")
			fuel += 300
	else if(fired && istype(P, /obj/item/food))
		if(!ishuman(user))
			return
		if(istype(P, /obj/item/food))
			var/obj/item/food/F = P
			if(F.microwaved_type)
				to_chat(user, "You start cooking a [F.name].")
				if(do_after(user, 20, target = src))
					F.microwave_act()
	else
		. = ..()
		if(fired)
			P.fire_act(1000, 500)

/obj/structure/campfire/fire_act(exposed_temperature, exposed_volume)
	fire()

/obj/structure/campfire/Crossed(atom/movable/AM)
	if(fired)
		burn_process()

/obj/structure/campfire/process()
	if(fuel <= 0)
		extinguish()
		return
	burn_process()
	fuel--
	if(fuel > 1500)
		set_light(8)
	else if(fuel > 300)
		set_light(3)
	else
		set_light(1)
//	var/turf/open/location = get_turf(src)//shity code detected
//	if(istype(location))
//		var/datum/gas_mixture/affected = location.air
//		affected.temperature *= 1.01

/obj/structure/campfire/proc/fire(mob/living/user)

//	BeginAmbient('sound/effects/comfyfire.ogg', 20, 12)

	playsound(src, 'sound/items/welder.ogg', 25, 1, -3)
	START_PROCESSING(SSobj, src)
	fired = 1
	desc = "A warm, bright, and hopeful fire source."
	if(user)
		user.visible_message("[user] has lit a [src].", "<span class='notice'>You have lit a [src].</span>")
	update_icon()
	burned = 0
	burn_process()

/obj/structure/campfire/proc/burn_process()
	var/turf/location = get_turf(src)
	for(var/A in location)
		if(A == src)
			continue
		if(isobj(A))
			var/obj/O = A
			O.fire_act(1000, 500)
		else if(isliving(A))
			var/mob/living/L = A
			L.adjust_fire_stacks(5)
			L.ignite_mob()

/obj/structure/campfire/update_icon()
	if(fired)
		icon_state = "[initial(icon_state)]-lit"
//		overlays = list(image(icon,icon_state = "campfire_o"))
	else
		icon_state = initial(icon_state)
//		overlays.Cut()
	..()

/*/obj/structure/campfire/extinguish()
	name = "burned campfire"
	desc = "It has burned to ashes..."
	icon_state = initial(icon_state)
	fired = 0
	burned = 1
	set_light(0)
//	StopAmbient()
	STOP_PROCESSING(SSobj, src)
	update_icon()*/

/obj/structure/campfire/infinity
	fired = 1
	icon_state = "campfire21"
	fuel = 999999999

/obj/structure/campfire/barrel
	name = "steel drum firepit"
	desc = "A campfire made out of an old steel drum. You're not going to fall into the fire, but you feel like a hobo using it. Which you are."
	icon_state = "drumfire"
	density = 1

/obj/structure/campfire/stove
	name = "pot belly stove"
	desc = "A warm stove, for cooking food, or keeping warm in the winter. It's really old fashioned, but works wonders when there's no electricity."
	density = 1
	icon_state = "potbelly"
