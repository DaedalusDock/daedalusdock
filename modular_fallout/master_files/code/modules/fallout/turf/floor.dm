//Fallout 13 general destructible floor directory

/turf/open/floor/f13
	name = "floor"
	initial_gas = OPENTURF_DEFAULT_ATMOS
	icon_state = "floor"
	base_icon_state = "floor"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/floors.dmi'

/turf/open/floor/f13/TryScrapeToLattice()
	ChangeTurf(baseturfs)

/turf/open/floor/f13/wood
	icon_state = "housewood1"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/ground.dmi'
	floor_tile = /obj/item/stack/tile/wood
	base_icon_state = "housebase"
//	step_sounds = list("human" = "woodfootsteps")
	broken_states = list("housewood1-broken", "housewood2-broken", "housewood3-broken", "housewood4-broken")

/turf/open/floor/f13/wood/New()
	..()
	if(prob(5))
		broken = 1
		icon_state = pick(broken_states)
	else
		icon_state = "housewood[rand(1,4)]"

/turf/open/floor/f13/wood/make_plating()
	return ChangeTurf(/turf/open/floor/plating/wooden)

/turf/open/floor/f13/wood/attackby(obj/item/C, mob/user, params)
	if(..())
		return
	if(istype(C, /obj/item/screwdriver))
		if(broken || burnt)
			new /obj/item/stack/sheet/mineral/wood(src)
		else
			new floor_tile(src)
		to_chat(user, "<span class='danger'>You unscrew the planks.</span>")
		make_plating()
		playsound(src, C.usesound, 80, 1)
		return
