//Fallout 13 boarding simulation

/obj/structure/barricade/wooden/planks
	icon = 'modular_fallout/master_files/icons/fallout/objects/decals.dmi'
	icon_state = "board"
	obj_integrity = 150
	max_integrity = 150
	layer = 5
	proj_pass_rate = 20
	drop_amount = 0
	var/planks = 3
	var/maxplanks = 3

/obj/structure/barricade/wooden/planks/New()
	..()
	checkplanks()
	max_integrity = maxplanks * 50

/obj/structure/barricade/wooden/planks/examine()
	. = ..()
	. += span_notice("There are [planks] boards left.")

/obj/structure/barricade/wooden/planks/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/crowbar))
		visible_message("<span class='danger'>[user] begins to pry off a board...</span>")
		var/current_planks = planks
		if(do_after(user, 25, target = src))
			if(current_planks  != planks)
				to_chat(user, "<span class='warning'>That board was already pried off!</span>")
				return
			visible_message("<span class='danger'>[user] pries off a board!</span>")
			planks --
			checkplanks()
			new /obj/item/stack/sheet/mineral/wood(user.loc)
			return
	else
		return..()

/obj/structure/barricade/wooden/planks/take_damage()
	..()
	if(obj_integrity <= (planks - 1) * 50)
		planks --
		if(prob(50))
			new /obj/item/stack/sheet/mineral/wood(src.loc)
		checkplanks()
	return

/obj/structure/barricade/wooden/planks/proc/checkplanks()
	obj_integrity = planks * 50 //Each board adds 50 health
	icon_state = "board-[planks]"
	if(obj_integrity <= 0)
		qdel(src)

/obj/structure/barricade/wooden/planks/pregame/Initialize() //Place these in the map maker to have a bit of randomization with boarded up windows/doors
	planks = rand(1, maxplanks)
	checkplanks()
	. = ..()
