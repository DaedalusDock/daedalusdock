//Fallout 13 main windows directory

/obj/structure/window/fulltile/ruins
	icon = 'modular_fallout/master_files/icons/obj/wood_window.dmi'
	icon_state = "ruinswindow"
	dir = 5
	max_integrity = 20

/obj/structure/window/fulltile/ruins/broken
	icon_state = "ruinswindowbroken"
	max_integrity = 1

/obj/structure/window/fulltile/house
	icon = 'modular_fallout/master_files/icons/obj/wood_window.dmi'
	icon_state = "housewindow"
	dir = 5
	max_integrity = 40

/obj/structure/window/fulltile/house/broken
	icon_state = "housewindowbroken"
	max_integrity = 1

/obj/structure/window/fulltile/wood
	icon = 'modular_fallout/master_files/icons/obj/wood_window.dmi'
	icon_state = "woodwindow"
	dir = 5
	max_integrity = 50

/obj/structure/window/fulltile/wood/broken
	icon_state = "woodwindowbroken"
	max_integrity = 1

/obj/structure/window/fulltile/store
	icon = 'modular_fallout/master_files/icons/obj/wood_window.dmi'
	icon_state = "storewindowhorizontal"
	dir = 5
	max_integrity = 100

/obj/structure/window/fulltile/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/Z = W
		if(locate(/obj/structure/barricade/wooden/planks) in get_turf(src))
			to_chat(user, "<span class='warning'>This window is already barricaded!</span>")
			return
		if(!anchored)
			to_chat(user, "<span class='warning'>The window must be firmly anchored to the ground!</span>")
			return
		if(Z.get_amount() < 3)
			to_chat(user, "<span class='warning'>You need atleast 3 wooden planks to reinforce this window!</span>")
			return
		else
			to_chat(user, "<span class='notice'>You start adding [Z] to [src]...</span>")
			if(do_after(user, 50, target=src))
				if(locate(/obj/structure/barricade/wooden/planks) in get_turf(src))
					to_chat(user, "<span class='warning'>This window is already barricaded!</span>")
					return
				if(!anchored)
					to_chat(user, "<span class='warning'>The window must be firmly anchored to the ground!</span>")
					return
				if(Z.get_amount() < 3)
					to_chat(user, "<span class='warning'>You need atleast 3 wooden planks to reinforce this window!</span>")
					return
				Z.use(3)
				new /obj/structure/barricade/wooden/planks(get_turf(src))
				user.visible_message("<span class='notice'>[user] reinforces the window with some planks</span>", "<span class='notice'>You reinforce the window with some planks.</span>")
				return
	else if(!istype(W, /obj/item/stack/sheet/mineral/wood))
		if(locate(/obj/structure/barricade/wooden/planks) in get_turf(src))
			for(var/obj/structure/barricade/wooden/planks/P in loc)
				P.attackby(W, user, params)
				return TRUE
		else
			return ..()
