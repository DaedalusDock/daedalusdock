//Fallout 13 decorative decals - the rest of pure decorative stuff is in decor.dm

/obj/effect/decal/waste
	name = "puddle of goo"
	desc = "A puddle of sticky, incredibly toxic and likely radioactive green goo."
	icon = 'modular_fallout/master_files/icons/fallout/objects/decals.dmi'
	icon_state = "goo1"
	anchored = 1
	layer = 2.1
	light_color = LIGHT_COLOR_GREEN
	light_power = 3
	light_outer_range  = 3
	var/range = 2
	var/intensity = 20

/obj/effect/decal/waste/New()
	..()
	icon_state = "goo[rand(1,13)]"
	AddComponent(/datum/component/radioactive, 200, src, 0, TRUE, TRUE) //half-life of 0 because we keep on going.

/obj/effect/decal/waste/Destroy()
	source.RemoveElement(/datum/element/radioactive)
	..()
/*
//Bing bang boom done
/obj/effect/decal/waste/process()
	if(QDELETED(src))
		return PROCESS_KILL

	for(var/mob/living/carbon/human/victim in view(src,range))
		if(istype(victim) && victim.stat != DEAD)
			victim.rad_act(intensity)
*/
#warn fix radiation
/obj/effect/decal/marking
	name = "road marking"
	desc = "Road surface markings were used on paved roadways to provide guidance and information to drivers and pedestrians.<br>Nowadays, those wandering the wasteland commonly use them as directional landmarks."
	icon = 'modular_fallout/master_files/icons/fallout/objects/decals.dmi'
	icon_state = "singlevertical" //See decals.dmi for different icon states of road markings.
	anchored = 1
	layer = 2.1
	resistance_flags = INDESTRUCTIBLE

/obj/effect/decal/riverbank
	name = "riverbank"
	desc = "try"
	icon = 'modular_fallout/master_files/icons/fallout/objects/decals.dmi'
	icon_state = "riverbank"
	anchored = 1
	layer = 2.1
	resistance_flags = INDESTRUCTIBLE

/obj/effect/decal/riverbankcorner
	name = "riverbankcorner"
	desc = "try2"
	icon = 'modular_fallout/master_files/icons/fallout/objects/decals.dmi'
	icon_state = "riverbank2"
	anchored = 1
	layer = 2.1
	resistance_flags = INDESTRUCTIBLE
