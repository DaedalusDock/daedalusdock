/turf/closed/wall/r_wall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon = 'icons/turf/walls/solid_wall_reinforced.dmi'
	opacity = TRUE
	density = TRUE
	hardness = 10
	reinf_material = /datum/material/iron
	plating_material = /datum/material/alloy/plasteel
	rad_insulation = RAD_HEAVY_INSULATION

/turf/closed/wall/r_wall/syndicate
	name = "hull"
	desc = "The armored hull of an ominous looking ship."
	icon = 'icons/turf/walls/metal_wall.dmi'
	reinf_material = /datum/material/iron
	plating_material = /datum/material/alloy/plastitanium
	color = "#3a313a" //To display in mapping softwares

/turf/closed/wall/r_wall/syndicate/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	return FALSE

/turf/closed/wall/r_wall/syndicate/nodiagonal

/turf/closed/wall/r_wall/syndicate/nosmooth

/turf/closed/wall/r_wall/syndicate/overspace
