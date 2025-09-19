

TYPEINFO_DEF(/turf/closed/wall/r_wall)
	default_armor = list(BLUNT = 50, PUNCTURE = 50, SLASH = 50, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/turf/closed/wall/r_wall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon = 'icons/turf/walls/solid_wall_reinforced.dmi'
	opacity = TRUE
	density = TRUE
	hardness = 10
	reinf_material = /datum/material/iron
	plating_material = /datum/material/alloy/plasteel
	explosion_block = 6
	rad_insulation = RAD_HEAVY_INSULATION

// DMEd Specific Simplified wall icons
#if defined(SIMPLE_MAPHELPERS)
/turf/closed/wall/r_wall
	icon='icons/effects/simplified_wall_helpers.dmi'
	icon_state="r_generic"
#endif

/turf/closed/wall/r_wall/syndicate
	name = "hull"
	desc = "The armored hull of an ominous looking ship."
	icon = 'icons/turf/walls/metal_wall.dmi'
	explosion_block = 20
	reinf_material = /datum/material/iron
	plating_material = /datum/material/alloy/plastitanium
	color = "#3a313a" //To display in mapping softwares

/turf/closed/wall/r_wall/syndicate/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	return FALSE

/turf/closed/wall/r_wall/syndicate/nodiagonal

/turf/closed/wall/r_wall/syndicate/nosmooth

/turf/closed/wall/r_wall/syndicate/overspace
