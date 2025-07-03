/* Fallout stuff*/
/* Also, a terrain class or something needs to be used as the common parent  for asteroid and outside */
/* lazy Saturday coding */

/*	Planetary atmos makes the gas infinite basicaly, if you're siphoning it, the world will
	just spawn more.
*/

/turf/open/floor/plating/f13 // don't use this for anything, /f13/ is essentially just the new /unsimulated/ but for planets and should probably be phased out entirely everywhere
	gender = PLURAL
	baseturfs = /turf/open/floor/plating/f13
	attachment_holes = FALSE
	initial_gas = OPENTURF_DEFAULT_ATMOS

/* so we can't break this */
/turf/open/floor/plating/f13/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/f13/burn_tile()
	return

/turf/open/floor/plating/f13/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/floor/plating/f13/MakeDry()
	return

/turf/open/floor/plating/f13/outside
	name = "What the fuck mappers? why is this here"
	desc = "If found, scream at the github repo about this"
	icon_state = "wasteland1"
	icon = 'modular_fallout/master_files/icons/fallout/turfs/f13desert.dmi'
	sunlight_state = SUNLIGHT_SOURCE

/* Outside turfs get global lighting */
/turf/open/floor/plating/f13/outside/Initialize()
	. = ..()
	flags_2 |= GLOBAL_LIGHT_TURF_2

#define GRASS_SPONTANEOUS 		2
#define GRASS_WEIGHT 			4
#define LUSH_PLANT_SPAWN_LIST list(/obj/structure/flora/grass/wasteland = 10, /obj/structure/flora/wasteplant/wild_broc = 7, /obj/structure/flora/wasteplant/wild_mesquite = 4, /obj/structure/flora/wasteplant/wild_feracactus = 5, /obj/structure/flora/wasteplant/wild_punga = 5, /obj/structure/flora/wasteplant/wild_coyote = 5, /obj/structure/flora/wasteplant/wild_tato = 5, /obj/structure/flora/wasteplant/wild_yucca = 5, /obj/structure/flora/wasteplant/wild_mutfruit = 5, /obj/structure/flora/wasteplant/wild_prickly = 5, /obj/structure/flora/wasteplant/wild_datura = 5, /obj/structure/flora/wasteplant/wild_buffalogourd = 5, /obj/structure/flora/wasteplant/wild_pinyon = 3, /obj/structure/flora/wasteplant/wild_xander = 5, /obj/structure/flora/wasteplant/wild_agave = 5, /obj/structure/flora/tree/joshua = 3, /obj/structure/flora/tree/cactus = 2, /obj/structure/flora/tree/wasteland = 2)
#define DESOLATE_PLANT_SPAWN_LIST list(/obj/structure/flora/grass/wasteland = 1)

/turf/open/floor/plating/f13/outside/desert
	name = "\proper desert"
	desc = "A stretch of desert."
	icon = 'modular_fallout/master_files/icons/fallout/turfs/f13desert.dmi'
	icon_state = "wasteland1"

	var/obj/structure/flora/turfPlant = null
	slowdown = 0
	var/dug = FALSE				//FALSE = has not yet been dug, TRUE = has already been dug
	var/pit_sand = 2
	var/storedindex = 0			//amount of stored items
	var/mob/living/gravebody	//is there a body in the pit?
	var/obj/structure/closet/crate/coffin/gravecoffin //or maybe a coffin?
	var/pitcontents = list()
	var/obj/dugpit/mypit
	var/unburylevel = 0

/turf/open/floor/plating/f13/outside/desert/Initialize()
	. = ..()
	icon_state = "wasteland[rand(1,31)]"
	//If no fences, machines (soil patches are machines), etc. try to plant grass
	if(!((locate(/obj/structure) in src) || (locate(/obj/machinery) in src)))
		plantGrass()

//Pass PlantForce for admin stuff I guess?
/turf/open/floor/plating/f13/outside/desert/proc/plantGrass(Plantforce = FALSE)
	var/Weight = 0
	var/randPlant = null

	//spontaneously spawn grass
	if(Plantforce || prob(GRASS_SPONTANEOUS))
		randPlant = pick_weight(LUSH_PLANT_SPAWN_LIST) //Create a new grass object at this location, and assign var
		turfPlant = new randPlant(src)
		. = TRUE //in case we ever need this to return if we spawned
		return .

	//loop through neighbouring desert turfs, if they have grass, then increase weight
	for(var/turf/open/floor/plating/f13/outside/desert/T in RANGE_TURFS(3, src))
		if(T.turfPlant)
			Weight += GRASS_WEIGHT

	//use weight to try to spawn grass
	if(prob(Weight))

		//If surrounded on 5+ sides, pick from lush
		if(Weight == (5 * GRASS_WEIGHT))
			randPlant = pick_weight(LUSH_PLANT_SPAWN_LIST)
		else
			randPlant = pick_weight(DESOLATE_PLANT_SPAWN_LIST)
		turfPlant = new randPlant(src)
		. = TRUE

//Make sure we delete the plant if we ever change turfs
/turf/open/floor/plating/f13/outside/desert/ChangeTurf(path, new_baseturf, flags)
	if(turfPlant)
		qdel(turfPlant)
	. =  ..()

/turf/open/floor/plating/f13/outside/road
	name = "\proper road"
	desc = "A stretch of road."
	icon = 'modular_fallout/master_files/icons/fallout/turfs/f13road.dmi'
	icon_state = "outermiddle"

//GRAVEL INDOORS
/turf/open/floor/plating/f13/inside/gravel
	name = "gravel"
	desc = "Small pebbles, lots of them."
	icon = 'modular_fallout/master_files/icons/fallout/turfs/ground.dmi'
	icon_state = "gravel"

/turf/open/floor/plating/f13/inside/gravel/edge
	icon_state = "graveledge"

/turf/open/floor/plating/f13/inside/gravel/corner
	icon_state = "gravelcorner"


//GRAVEL OUTDOORS
/turf/open/floor/plating/f13/inside/gravel
	name = "gravel"
	desc = "Small pebbles, lots of them."
	icon = 'modular_fallout/master_files/icons/fallout/turfs/ground.dmi'
	icon_state = "gravel"
	sunlight_state = SUNLIGHT_SOURCE

/turf/open/floor/plating/f13/inside/gravel/edge
	icon_state = "graveledge"

/turf/open/floor/plating/f13/inside/gravel/corner
	icon_state = "gravelcorner"


//New standard wood floor for most areas, oak for Legion and pure log cabins only, maple for NCR and mayor only, maybe a diner.

/turf/open/floor/wood/f13
	icon = 'modular_fallout/master_files/icons/fallout/turfs/floors.dmi'
	icon_state = "housewood1"

	New()
		..()
		if(icon_state == "housewood1")
			icon_state = "housewood[rand(1,4)]"

/turf/open/floor/wood/f13/oak
	icon = 'modular_fallout/master_files/icons/fallout/turfs/floors.dmi'
	icon_state = "oakfloor1"

	New()
		..()
		if(icon_state == "oakfloor1")
			icon_state = "oakfloor[rand(1,4)]"

/turf/open/floor/wood/f13/housewoodbroken
	icon_state = "housewood1-broken"

/turf/open/floor/wood/f13/housewoodbroken2
	icon_state = "housewood2-broken"

/turf/open/floor/wood/f13/housewoodbroken3
	icon_state = "housewood3-broken"

/turf/open/floor/wood/f13/housewoodbroken4
	icon_state = "housewood4-broken"

/turf/open/floor/wood/f13/oakbroken
	icon_state = "oakfloor1-broken"

/turf/open/floor/wood/f13/oakbroken2
	icon_state = "oakfloor2-broken"

/turf/open/floor/wood/f13/oakbroken3
	icon_state = "oakfloor3-broken"

/turf/open/floor/wood/f13/oakbroken4
	icon_state = "oakfloor4-broken"

/turf/open/floor/wood/f13/maple
	icon_state = "maplefloor1"

/turf/open/floor/wood/f13/carpet
	icon_state = "carpet"

/turf/open/floor/wood/f13/old
	name = "wood planks"
	desc = "Rotting wooden flooring."

/turf/open/floor/wood/f13/old/ruinedcornerendbr	//WHAT THE FUCK IS THIS
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandcornerbr"

/turf/open/floor/wood/f13/old/ruinedcornerendbl
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandcornerbl"

/turf/open/floor/wood/f13/old/ruinedcornerendtr
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandcornertr"

/turf/open/floor/wood/f13/old/ruinedcornerendtl
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandcornertl"

/turf/open/floor/wood/f13/old/ruinedcornerbr
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandmorecornerbr"

/turf/open/floor/wood/f13/old/ruinedcornerbl
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandmorecornerbl"

/turf/open/floor/wood/f13/old/ruinedcornertr
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandmorecornertr"

/turf/open/floor/wood/f13/old/ruinedcornertl
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandmorecornertl"

/turf/open/floor/wood/f13/old/ruinedstraightsouth
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandsouth"

/turf/open/floor/wood/f13/old/ruinedstraightnorth
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandnorth"

/turf/open/floor/wood/f13/old/ruinedstraighteast
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandeast"

/turf/open/floor/wood/f13/old/ruinedstraightwest
	name = "wood planks"
	desc = "Rotting wooden flooring, with a mix of dirt."
	icon_state = "housewastelandwest"

/turf/open/floor/wood/f13/stage_tl
	icon_state = "housewood_stage_top_left"
/turf/open/floor/wood/f13/stage_t
	icon_state = "housewood_stage_top"
/turf/open/floor/wood/f13/stage_l
	icon_state = "housewood_stage_left"
/turf/open/floor/wood/f13/stage_bl
	icon_state = "housewood_stage_bottom_left"
/turf/open/floor/wood/f13/stage_b
	icon_state = "housewood_stage_bottom"
/turf/open/floor/wood/f13/stage_tr
	icon_state = "housewood_stage_top_right"
/turf/open/floor/wood/f13/stage_r
	icon_state = "housewood_stage_right"
/turf/open/floor/wood/f13/stage_br
	icon_state = "housewood_stage_bottom_right"

//WOOD FLOOR FOR BRIDGES ETC, OUTDOORS
/turf/open/floor/wood/f13/stage_b/outdoors
	sunlight_state = SUNLIGHT_SOURCE

#define SHROOM_SPAWN	1

/turf/open/floor/plating/f13/inside/mountain
	name = "mountain"
	desc = "Damp cave flooring."
	icon = 'icons/turf/f13floors2.dmi'
	icon_state = "mountain0"
	var/obj/structure/flora/turfPlant = null

/turf/open/floor/plating/f13/inside/mountain/Initialize()
	. = ..()
	icon_state = "mountain[rand(0,10)]"
	//If no fences, machines, etc. try to plant mushrooms
	if(!(\
			(locate(/obj/structure) in src) || \
			(locate(/obj/machinery) in src) ))
		plantShrooms()

/turf/open/floor/plating/f13/inside/mountain/proc/plantShrooms()
	if(prob(SHROOM_SPAWN))
		turfPlant = new /obj/structure/flora/wasteplant/wild_fungus(src)
		. = TRUE //in case we ever need this to return if we spawned
		return.

/turf/open/floor/plasteel/f13/vault_floor
	name = "vault floor"
	icon = 'icons/turf/f13floors2.dmi'
	icon_state = "vault_floor"

/turf/open/floor/plasteel/f13/vault_floor/plating
	icon_state = "plating"

/turf/open/floor/plasteel/f13/vault_floor/floor
	icon_state = "floor"

/turf/open/floor/plasteel/f13/vault_floor/floor/floorsolid
	icon_state = "floorsolid"
/*
	/* DARK TILES */

/turf/open/floor/plasteel/f13/vault_floor/dark
	icon_state = "dark"

/turf/open/floor/plasteel/f13/vault_floor/dark/darksolid
	icon_state = "darksolid"

	/* WHITE TILES */

/turf/open/floor/plasteel/f13/vault_floor/white
	icon_state = "white"

/turf/open/floor/plasteel/f13/vault_floor/white/whitesolid
	icon_state = "whitesolid"

	/* RED TILES */

/turf/open/floor/plasteel/f13/vault_floor/red
	icon_state = "redfull"

/turf/open/floor/plasteel/f13/vault_floor/red/whiteredfull
	icon_state = "whiteredfull"

/turf/open/floor/plasteel/f13/vault_floor/red/side
	icon_state = "red"

/turf/open/floor/plasteel/f13/vault_floor/red/corner
	icon_state = "redcorner"

/turf/open/floor/plasteel/f13/vault_floor/red/redchess
	icon_state = "redchess"

/turf/open/floor/plasteel/f13/vault_floor/red/redchess/redchess2
	icon_state = "redchess2"

/turf/open/floor/plasteel/f13/vault_floor/red/white/side
	icon_state = "whitered"

/turf/open/floor/plasteel/f13/vault_floor/red/white/corner
	icon_state = "whiteredcorner"

/turf/open/floor/plasteel/f13/vault_floor/red/white/whiteredchess
	icon_state = "whiteredchess"

/turf/open/floor/plasteel/f13/vault_floor/red/white/whiteredchess/whiteredchess2
	icon_state = "whiteredchess2"

	/* BLUE TILES */

/turf/open/floor/plasteel/f13/vault_floor/blue
	icon_state = "bluefull"

/turf/open/floor/plasteel/f13/vault_floor/blue/whitebluefull
	icon_state = "whitebluefull"

/turf/open/floor/plasteel/f13/vault_floor/blue/side
	icon_state = "blue"

/turf/open/floor/plasteel/f13/vault_floor/blue/corner
	icon_state = "bluecorner"

/turf/open/floor/plasteel/f13/vault_floor/blue/bluechess
	icon_state = "bluechess"

/turf/open/floor/plasteel/f13/vault_floor/blue/bluechess/bluechess2
	icon_state = "bluechess2"

/turf/open/floor/plasteel/f13/vault_floor/blue/white/side
	icon_state = "whiteblue"

/turf/open/floor/plasteel/f13/vault_floor/blue/white/corner
	icon_state = "whitebluecorner"

/turf/open/floor/plasteel/f13/vault_floor/blue/white/whitebluechess
	icon_state = "whitebluechess"

/turf/open/floor/plasteel/f13/vault_floor/blue/white/whitebluechess/whitebluechess2
	icon_state = "whitebluechess2"

	/* GREEN TILES */

/turf/open/floor/plasteel/f13/vault_floor/green
	icon_state = "greenfull"

/turf/open/floor/plasteel/f13/vault_floor/green/whitegreenfull
	icon_state = "whitegreenfull"

/turf/open/floor/plasteel/f13/vault_floor/green/side
	icon_state = "green"

/turf/open/floor/plasteel/f13/vault_floor/green/corner
	icon_state = "greencorner"

/turf/open/floor/plasteel/f13/vault_floor/green/greenchess
	icon_state = "greenchess"

/turf/open/floor/plasteel/f13/vault_floor/green/greenchess/greenchess2
	icon_state = "greenchess2"

/turf/open/floor/plasteel/f13/vault_floor/green/white/side
	icon_state = "whitegreen"

/turf/open/floor/plasteel/f13/vault_floor/green/white/corner
	icon_state = "whitegreencorner"

/turf/open/floor/plasteel/f13/vault_floor/green/white/whitegreenchess
	icon_state = "whitegreenchess"

/turf/open/floor/plasteel/f13/vault_floor/green/white/whitegreenchess/whitegreenchess2
	icon_state = "whitegreenchess2"

	/* YELLOW TILES */

/turf/open/floor/plasteel/f13/vault_floor/yellow
	icon_state = "yellowfull"

/turf/open/floor/plasteel/f13/vault_floor/yellow/whiteyellowfull
	icon_state = "whiteyellowfull"

/turf/open/floor/plasteel/f13/vault_floor/yellow/side
	icon_state = "yellow"

/turf/open/floor/plasteel/f13/vault_floor/yellow/corner
	icon_state = "yellowcorner"

/turf/open/floor/plasteel/f13/vault_floor/yellow/yellowchess
	icon_state = "yellowchess"

/turf/open/floor/plasteel/f13/vault_floor/yellow/yellowchess/yellowchess2
	icon_state = "yellowchess2"

/turf/open/floor/plasteel/f13/vault_floor/yellow/white/side
	icon_state = "whiteyellow"

/turf/open/floor/plasteel/f13/vault_floor/yellow/white/corner
	icon_state = "whiteyellowcorner"

/turf/open/floor/plasteel/f13/vault_floor/yellow/white/whiteyellowchess
	icon_state = "whiteyellowchess"

/turf/open/floor/plasteel/f13/vault_floor/yellow/white/whiteyellowchess/whiteyellowchess2
	icon_state = "whiteyellowchess2"

	/* PURPLE TILES */

/turf/open/floor/plasteel/f13/vault_floor/purple
	icon_state = "purplefull"

/turf/open/floor/plasteel/f13/vault_floor/purple/whitepurplefull
	icon_state = "whitepurplefull"

/turf/open/floor/plasteel/f13/vault_floor/purple/side
	icon_state = "purple"

/turf/open/floor/plasteel/f13/vault_floor/purple/corner
	icon_state = "purplecorner"

/turf/open/floor/plasteel/f13/vault_floor/purple/purplechess
	icon_state = "purplechess"

/turf/open/floor/plasteel/f13/vault_floor/purple/purplechess/purplechess2
	icon_state = "purplechess2"

/turf/open/floor/plasteel/f13/vault_floor/purple/white/side
	icon_state = "whitepurple"

/turf/open/floor/plasteel/f13/vault_floor/purple/white/corner
	icon_state = "whitepurplecorner"

/turf/open/floor/plasteel/f13/vault_floor/purple/white/whitepurplechess
	icon_state = "whitepurplechess"

/turf/open/floor/plasteel/f13/vault_floor/purple/white/whitepurplechess/whitepurplechess2
	icon_state = "whitepurplechess2"


	/* neutral TILES */

/turf/open/floor/plasteel/f13/vault_floor/neutral
	icon_state = "neutralfull2"

/turf/open/floor/plasteel/f13/vault_floor/neutral/neutralsolid
	icon_state = "neutralsolid"

/turf/open/floor/plasteel/f13/vault_floor/neutral/side
	icon_state = "neutral"

/turf/open/floor/plasteel/f13/vault_floor/neutral/corner
	icon_state = "neutralcorner"

/turf/open/floor/plasteel/f13/vault_floor/neutral/neutralchess
	icon_state = "neutralchess"

/turf/open/floor/plasteel/f13/vault_floor/neutral/neutralchess/neutralchess2
	icon_state = "neutralchess2"

/turf/open/floor/plasteel/f13/vault_floor/neutral/white/side
	icon_state = "whiteneutral"

/turf/open/floor/plasteel/f13/vault_floor/neutral/white/corner
	icon_state = "whiteneutralcorner"

/turf/open/floor/plasteel/f13/vault_floor/neutral/white/whitepurplechess
	icon_state = "whitepurplechess"

/turf/open/floor/plasteel/f13/vault_floor/neutral/white/whitepurplechess/whitepurplechess2
	icon_state = "whitepurplechess2"

	/* MISC TILES */

/turf/open/floor/plasteel/f13/vault_floor/misc/bar
	icon_state = "bar"

/turf/open/floor/plasteel/f13/vault_floor/misc/cafeteria
	icon_state = "cafeteria"

/turf/open/floor/plasteel/f13/vault_floor/misc/cmo
	icon_state = "cmo"

/turf/open/floor/plasteel/f13/vault_floor/misc/rarewhite
	icon_state = "rarewhite"

/turf/open/floor/plasteel/f13/vault_floor/misc/rarewhite/rarecyan
	icon_state = "rarecyan"

/turf/open/floor/plasteel/f13/vault_floor/misc/rarewhite/side
	icon_state = "rare"

/turf/open/floor/plasteel/f13/vault_floor/misc/rarewhite/corner
	icon_state = "rarecorner"

/turf/open/floor/plasteel/f13/vault_floor/misc/recharge
	icon_state = "recharge"

/turf/open/floor/plasteel/f13/vault_floor/misc/plaque
	icon_state = "plaque"

/turf/open/floor/plasteel/f13/vault_floor/misc/vaultrust
	icon_state = "vaultrust"

/turf/open/floor/plasteel/f13/vault_floor/misc/vault1
	icon_state = "vault1"


/turf/open/floor/circuit/f13_blue
	icon = 'icons/turf/f13floors2.dmi'
	icon_state = "bcircuit2"
	icon_normal = "bcircuit2"

/turf/open/floor/circuit/f13_blue/off
	icon_state = "bcircuitoff2"
	on = FALSE

/turf/open/floor/circuit/f13_green
	icon = 'icons/turf/f13floors2.dmi'
	icon_state = "gcircuit2"
	icon_normal = "gcircuit2"
	light_color = LIGHT_COLOR_GREEN
	floor_tile = /obj/item/stack/tile/circuit/green

/turf/open/floor/circuit/f13_green/off
	icon_state = "gcircuitoff2"
	on = FALSE

/turf/open/floor/circuit/f13_red
	icon = 'icons/turf/f13floors2.dmi'
	icon_state = "rcircuit1"
	icon_normal = "rcircuit1"
	light_color = LIGHT_COLOR_FLARE
	floor_tile = /obj/item/stack/tile/circuit/red

/turf/open/floor/circuit/f13_red/off
	icon_state = "rcircuitoff1"
	on = FALSE
*/
