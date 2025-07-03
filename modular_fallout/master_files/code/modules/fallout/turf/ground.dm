//Fallout 13 general indestructible floor directory

/turf
	var/baseturf_icon
	var/baseturf_dir = 0

/turf/open/indestructible/ground
	icon = 'modular_fallout/master_files/icons/fallout/turfs/ground.dmi'
	name = "\proper ground"
	icon_state = "wasteland1"
	initial_gas = OPENTURF_DEFAULT_ATMOS
	tiled_dirt = FALSE
	flags_1 = NONE
	turf_flags = CAN_BE_DIRTY_1 | IS_SOLID | NO_RUST

	var/obj/structure/flora/turfPlant = null

/turf/open/indestructible/ground/New()
	..()
	baseturfs = src.type
	baseturf_icon = icon_state
	baseturf_dir = dir

/turf/open/indestructible/ground/attack_paw(mob/user)
	return src.attack_hand(user)

/turf/open/indestructible/ground/attackby(obj/item/C, mob/user, params)
	if(istype(C,/obj/item/stack/tile))
		var/obj/item/stack/tile/S = C
		if(S.use(1))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You build a floor.</span>")
			ChangeTurf(/turf/open/floor/plating)
		else
			to_chat(user, "<span class='warning'>You need one floor tile to build a floor!</span>")
	else
		return ..()
/*
/turf/ground/Entered(go/A)
	..()

/turf/open/indestructible/ground/handle_slip()
	return
*/
/turf/open/indestructible/ground/singularity_act()
	return

/turf/open/indestructible/ground/can_have_cabling()
	return TRUE

//////////////////////////////////////////////////////////////////////

/turf/open/indestructible/ground/outside
	sunlight_state = SUNLIGHT_SOURCE
	slowdown = 0.2

/turf/open/indestructible/ground/outside/Initialize()
	. = ..()
	flags_2 |= GLOBAL_LIGHT_TURF_2

#define GRASS_SPONTANEOUS_GROUND 		2
#define GRASS_WEIGHT_GROUND			4
#define LUSH_PLANT_SPAWN_LIST_GROUND list(/obj/structure/flora/grass/wasteland = 10, /obj/structure/flora/wasteplant/wild_broc = 7, /obj/structure/flora/wasteplant/wild_mesquite = 4, /obj/structure/flora/wasteplant/wild_feracactus = 5, /obj/structure/flora/wasteplant/wild_punga = 5, /obj/structure/flora/wasteplant/wild_coyote = 5, /obj/structure/flora/wasteplant/wild_tato = 5, /obj/structure/flora/wasteplant/wild_yucca = 5, /obj/structure/flora/wasteplant/wild_mutfruit = 5, /obj/structure/flora/wasteplant/wild_prickly = 5, /obj/structure/flora/wasteplant/wild_datura = 5, /obj/structure/flora/wasteplant/wild_buffalogourd = 5, /obj/structure/flora/wasteplant/wild_pinyon = 3, /obj/structure/flora/wasteplant/wild_xander = 5, /obj/structure/flora/wasteplant/wild_agave = 5, /obj/structure/flora/tree/joshua = 3, /obj/structure/flora/tree/cactus = 2, /obj/structure/flora/tree/wasteland = 2)
#define DESOLATE_PLANT_SPAWN_LIST_GROUND list(/obj/structure/flora/grass/wasteland = 1)

/turf/open/indestructible/ground/outside/dirthole
	name = "Dirt hole"
	icon_state = "dirthole"
	desc = "A dirt hole."
	slowdown = 3

/turf/open/indestructible/ground/outside/river
	name = "river"
	icon_state = "riverwateruhh"
	desc = "A river."
	slowdown = 3

/turf/open/indestructible/ground/outside/savannah
	name = "savannah"
	icon_state = "savannahcenter"
	desc = "Some savannah."
	slowdown = 1
	flags_1 = CAN_HAVE_NATURE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND

/turf/open/indestructible/ground/outside/savannah/bottomright
	icon_state = "savannah1"
/turf/open/indestructible/ground/outside/savannah/bottomcenter
	icon_state = "savannah2"
/turf/open/indestructible/ground/outside/savannah/bottomleft
	icon_state = "savannah3"
/turf/open/indestructible/ground/outside/savannah/leftcenter
	icon_state = "savannah4"
/turf/open/indestructible/ground/outside/savannah/topleft
	icon_state = "savannah5"
/turf/open/indestructible/ground/outside/savannah/topcenter
	icon_state = "savannah6"
/turf/open/indestructible/ground/outside/savannah/topright
	icon_state = "savannah7"
/turf/open/indestructible/ground/outside/savannah/rightcenter
	icon_state = "savannah8"
/turf/open/indestructible/ground/outside/savannah/bottomleftcorner
	icon_state = "savannah9"
/turf/open/indestructible/ground/outside/savannah/bottomrightcorner
	icon_state = "savannah10"
/turf/open/indestructible/ground/outside/savannah/topleftcorner
	icon_state = "savannah11"
/turf/open/indestructible/ground/outside/savannah/toprightcorner
	icon_state = "savannah12"
/turf/open/indestructible/ground/outside/savannah/cornersnew
	icon_state = "savannah13"
/turf/open/indestructible/ground/outside/savannah/edgesnew
	icon_state = "savannah14"

/turf/open/indestructible/ground/outside/desert
	name = "desert"
	icon_state = "wasteland"
//	step_sounds = list("human" = "dirtfootsteps")
//	allowed_plants = list(/obj/item/seeds/poppy/broc, /obj/item/seeds/xander, /obj/item/seeds/mutfruit,
//	/obj/item/seeds/feracactus, /obj/item/seeds/corn,/obj/item/seeds/shroom, /obj/item/seeds/agave)
	slowdown = 1
	flags_1 = CAN_HAVE_NATURE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	var/dug = FALSE				//FALSE = has not yet been dug, TRUE = has already been dug
	var/pit_sand = 1
	var/storedindex = 0			//amount of stored items
	var/mob/living/gravebody	//is there a body in the pit?
	var/obj/structure/closet/crate/coffin/gravecoffin //or maybe a coffin?
	var/obj/salvage //or salvage
	var/pitcontents = list()
	var/obj/dugpit/mypit
	var/unburylevel = 0
	var/list/loots = list(
						/obj/item/stack/crafting/metalparts/five = 30,
						/obj/item/stack/crafting/goodparts/five = 30,
//						/obj/item/stack/sheet/mineral/limestone/twenty = 10,
						/obj/item/stack/ore/blackpowder/twenty = 10,
						/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/mid = 3,
//						/obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/low = 3
						)

//For sculpting with more precision, the random picking does not work very well. Slowdown 0.5 instead of 1. No random armor or gunpowder or titanium. Use directions for control. - Pebbles
/turf/open/indestructible/ground/outside/desert/sonora
	icon = 'modular_fallout/master_files/icons/fallout/turfs/wasteland.dmi'
	icon_state = "desertsmooth"
	slowdown = 0.5
	list/loots = list(
						/obj/item/stack/crafting/metalparts/five = 30,
//						/obj/item/stack/sheet/mineral/limestone/twenty = 10,
						)
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND

/turf/open/indestructible/ground/outside/desert/sonora/coarse
	icon_state = "desertcoarse"
	slowdown = 0.6

/turf/open/indestructible/ground/outside/desert/sonora/coarse2
	icon_state = "desertcoarse2"
	slowdown = 0.6

/turf/open/indestructible/ground/outside/desert/sonora/rough
	icon_state = "desertrough"
	slowdown = 1

/turf/open/indestructible/ground/outside/desert/Initialize()
	. = ..()
	if(prob(2))
		var/obj/derp = pick_weight(loots)
		salvage = new derp()
	if(!((locate(/obj/structure) in src) || (locate(/obj/machinery) in src)))
		plantGrass()
	if(icon_state != "wasteland")
		icon_state = "wasteland[rand(1,31)]"
	for(var/direction in GLOB.cardinals)
		var/turf/turf_to_check = get_step(src, direction)
		if(istype(turf_to_check, /turf/open/water))
			var/obj/effect/overlay/desert_side/DS = new /obj/effect/overlay/desert_side(src)
			switch(direction)
				if(NORTH)
					DS.pixel_y = 32
				if(SOUTH)
					DS.pixel_y = -32
				if(EAST)
					DS.pixel_x = 32
				if(WEST)
					DS.pixel_x = -32
			DS.dir = dir = turn(direction, 180)

/obj/effect/overlay/desert_side
	name = "desert"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/smoothing.dmi'
	icon_state = "wasteland_side"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE

// Two edge smootheners for the new desert turf
/obj/effect/overlay/desert/sonora/edge
	name = "desert edge"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/wasteland.dmi'
	icon_state = "desertedge"

/obj/effect/overlay/desert/sonora/edge/corner
	icon_state = "desertcorner"

/turf/open/indestructible/ground/outside/desert/proc/plantGrass(Plantforce = FALSE)
	var/Weight = 0
	var/randPlant = null

	//spontaneously spawn grass
	if(Plantforce || prob(GRASS_SPONTANEOUS_GROUND))
		randPlant = pick_weight(LUSH_PLANT_SPAWN_LIST_GROUND) //Create a new grass object at this location, and assign var
		turfPlant = new randPlant(src)
		. = TRUE //in case we ever need this to return if we spawned
		return .

	//loop through neighbouring desert turfs, if they have grass, then increase weight
	for(var/turf/open/indestructible/ground/outside/desert/T in RANGE_TURFS(3, src))
		if(T.turfPlant)
			Weight += GRASS_WEIGHT

	//use weight to try to spawn grass
	if(prob(Weight))

		//If surrounded on 5+ sides, pick from lush
		if(Weight == (5 * GRASS_WEIGHT))
			randPlant = pick_weight(LUSH_PLANT_SPAWN_LIST_GROUND)
		else
			randPlant = pick_weight(DESOLATE_PLANT_SPAWN_LIST_GROUND)
		turfPlant = new randPlant(src)
		. = TRUE

/turf/open/indestructible/ground/outside/desert/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return //I mean, it makes sense that deserts don't get slippery, I guess... :(

//Make sure we delete the plant if we ever change turfs
/turf/open/indestructible/ground/outside/desert/ChangeTurf(path, list/new_baseturfs, flags)
	if(turfPlant)
		qdel(turfPlant)
	return ..()

/turf/open/indestructible/ground/outside/dirt
	name = "dirt"
	icon_state = "dirtfull"
//	step_sounds = list("human" = "dirtfootsteps")
//	allowed_plants = list(/obj/item/seeds/poppy/broc, /obj/item/seeds/xander, /obj/item/seeds/mutfruit,
//	/obj/item/seeds/potato, /obj/item/seeds/carrot, /obj/item/seeds/pumpkin, /obj/item/seeds/corn, /obj/item/seeds/agave)
	slowdown = 0.3
	flags_1 = CAN_HAVE_NATURE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND

/turf/open/indestructible/ground/outside/dirt/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return //same thing here, dirt absorbs the liquid... :(

/turf/open/indestructible/ground/outside/road
	name = "\proper road"
	icon_state = "innermiddle"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/asphalt.dmi'
	footstep = FOOTSTEP_ROAD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
//	step_sounds = list("human" = "erikafootsteps")

/turf/open/indestructible/ground/outside/sidewalk
	name = "\proper sidewalk"
	icon_state = "outermiddle"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/sidewalk.dmi'
	footstep = FOOTSTEP_ROAD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
//	step_sounds = list("human" = "erikafootsteps")

/turf/open/indestructible/ground/outside/ruins
	name = "ruins"
	desc = "It's just a pile of concrete rubble."
	icon_state = "rubblefull"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/ground.dmi'
	footstep = FOOTSTEP_ROAD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
//	step_sounds = list("human" = "erikafootsteps")

/turf/open/indestructible/ground/outside/wood
	name = "\proper wood planks"
	icon_state = "housewood1"
	icon = 'icons/turf/floors.dmi'
	//	step_sounds = list("human" = "woodfootsteps")

/turf/open/indestructible/ground/outside/water
	gender = PLURAL
	name = "river water"
	desc = "Shallow river water."
	icon = 'icons/turf/floors.dmi'
	icon_state = "riverwater_motion"
	slowdown = 2
	depth = 1
	bullet_sizzle = TRUE
	bullet_bounce_sound = null //needs a splashing sound one day.
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

/turf/open/indestructible/ground/outside/water/Initialize()
	. = ..()
	update_icon()

/turf/open/indestructible/ground/outside/water/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/open/indestructible/ground/outside/water))
			to_chat(L, "<span class='warning'>You get drenched in water!</span>")
	AM.water_act(5)
	..()

/turf/open/indestructible/ground/outside/water/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(newloc, /turf/open/indestructible/ground/outside/water))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/turf/open/indestructible/ground/outside/water/update_icon()
	. = ..()

/turf/open/indestructible/ground/outside/snow
	initial_gas_mix = "o2=22;n2=82;TEMP=285"
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	desc = "Looks cold."
	icon_state = "snow"
	footstep = FOOTSTEP_SNOW
	barefootstep = FOOTSTEP_SNOW
	clawfootstep = FOOTSTEP_SNOW

/turf/open/indestructible/ground/outside/ruins/ex_act(severity, target)
	contents_explosion(severity, target)
	switch(severity)
		if(4)
			if(prob(5))
				ChangeTurf(baseturfs)
		if(3)
			if(prob(25))
				ChangeTurf(baseturfs)
		if(2)
			if(prob(50))
				ChangeTurf(baseturfs)
		if(1)
			ChangeTurf(baseturfs)

/////////////////////////////////////////////////////////

#define SHROOM_SPAWN_GROUND	1

/turf/open/indestructible/ground/inside/mountain
	name = "cave"
	icon_state = "rockfloor1"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/mining.dmi'
//	allowed_plants = list(/obj/item/seeds/glow)
//	step_sounds = list("human" = "erikafootsteps")

/turf/open/indestructible/ground/inside/mountain/Initialize()
	. = ..()
	//If no fences, machines, etc. try to plant mushrooms
	if(!(\
			(locate(/obj/structure) in src) || \
			(locate(/obj/machinery) in src) ))
		plantShrooms()
	for(var/direction in GLOB.cardinals)
		var/turf/turf_to_check = get_step(src, direction)
		if(istype(turf_to_check, /turf/open/water))
			var/obj/effect/overlay/rockfloor_side/DS = new /obj/effect/overlay/rockfloor_side(src)
			switch(direction)
				if(NORTH)
					DS.pixel_y = 32
				if(SOUTH)
					DS.pixel_y = -32
				if(EAST)
					DS.pixel_x = 32
				if(WEST)
					DS.pixel_x = -32
			DS.dir = turn(direction, 180)

/obj/effect/overlay/rockfloor_side
	name = "cave"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/smoothing.dmi'
	icon_state = "rockfloor_side"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE

/turf/open/indestructible/ground/inside/mountain/proc/plantShrooms()
	if(prob(SHROOM_SPAWN_GROUND))
		turfPlant = new /obj/structure/flora/wasteplant/wild_fungus(src)
		. = TRUE //in case we ever need this to return if we spawned
		return.

/turf/open/indestructible/ground/inside/mountain/New()
	..()
	icon_state = "rockfloor[rand(1,2)]"

/turf/open/indestructible/ground/inside/dirt
	name = "dirt"
	icon_state = "dirtfull"
//	step_sounds = list("human" = "dirtfootsteps")
//	allowed_plants = list(/obj/item/seeds/poppy/broc, /obj/item/seeds/xander, /obj/item/seeds/mutfruit,
//	/obj/item/seeds/potato, /obj/item/seeds/carrot, /obj/item/seeds/pumpkin, /obj/item/seeds/corn, /obj/item/seeds/agave)
	slowdown = 0.2
	flags_1 = CAN_HAVE_NATURE

/turf/open/indestructible/ground/inside/subway
	name = "subway tunnel"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/ground.dmi'
	icon_state = "railsnone"

/turf/open/indestructible/ground/inside/subway/Initialize()
	. = ..()
	for(var/direction in GLOB.cardinals)
		var/turf/turf_to_check = get_step(src, direction)
		if(istype(turf_to_check, /turf/open))
			var/obj/effect/overlay/railsnone_side/DS = new /obj/effect/overlay/railsnone_side(src)
			switch(direction)
				if(NORTH)
					DS.pixel_y = 32
				if(SOUTH)
					DS.pixel_y = -32
				if(EAST)
					DS.pixel_x = 32
				if(WEST)
					DS.pixel_x = -32
			DS.dir = turn(direction, 180)

/obj/effect/overlay/railsnone_side
	name = "cave"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/smoothing.dmi'
	icon_state = "railsnone_side"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE


/turf/open/indestructible/ground/outside/roaddirt
	name = "road"
	icon_state = "innermiddle"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/asphaltdirt.dmi'
//	step_sounds = list("human" = "erikafootsteps")

/turf/open/indestructible/ground/outside/sidewalkdirt
	name = "sidewalk"
	icon_state = "outermiddle"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/sidewalkdirt.dmi'
	footstep = FOOTSTEP_ROAD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
//	step_sounds = list("human" = "erikafootsteps")

//Obsolete but used in yucky Pahrump
/turf/open/indestructible/ground/outside/graveldirt
	name = "gravel"
	icon_state = "graveldirt"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/ground.dmi'
//	step_sounds = list("human" = "erikafootsteps")

// New gravel, organized. Use directions for control. - Pebbles
/turf/open/indestructible/ground/outside/gravel
	name = "gravel"
	icon_state = "gravel"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/gravel.dmi'
	footstep = FOOTSTEP_GRAVEL
	barefootstep = FOOTSTEP_GRAVEL
	clawfootstep = FOOTSTEP_GRAVEL

/turf/open/indestructible/ground/outside/gravel/alt
	name = "gravel"
	icon_state = "gravel_alt"

/turf/open/indestructible/ground/outside/gravel/path_desert
	name = "gravel path"
	icon_state = "path_desert"

/turf/open/indestructible/ground/outside/gravel/path_desert/intersection
	name = "gravel path"
	icon_state = "path_desert_intersection"

/turf/open/indestructible/ground/outside/gravel/path_desert/end
	name = "gravel path"
	icon_state = "path_desert_end"

/turf/open/indestructible/ground/outside/gravel/path_dirt
	name = "gravel path"
	icon_state = "path_dirt"

/turf/open/indestructible/ground/outside/gravel/path_dirt/intersection
	name = "gravel path"
	icon_state = "path_dirt_intersection"

/turf/open/indestructible/ground/outside/gravel/path_dirt/end
	name = "gravel path"
	icon_state = "path_dirt_end"

// Two edge smootheners for the new gravel turf
/obj/effect/overlay/gravel/edge
	name = "gravel edge"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/gravel.dmi'
	icon_state = "graveledge"

/obj/effect/overlay/gravel/edge/corner
	icon_state = "gravelcorner"
