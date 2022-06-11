/turf/closed/wall/r_wall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon = 'icons/turf/walls/solid_wall_reinforced.dmi'
	opacity = TRUE
	density = TRUE
	hardness = 10
	reinf_material = /datum/material/iron
	plating_material = /datum/material/alloy/plasteel
	explosion_block = 2
	rad_insulation = RAD_HEAVY_INSULATION
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall. also indicates the temperature at wich the wall will melt (currently only able to melt with H/E pipes)

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
