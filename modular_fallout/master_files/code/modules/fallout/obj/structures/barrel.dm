//Fallout 13 barrels directory

/obj/structure/reagent_dispensers/barrel
	name = "barrel"
	desc = "A metal container with something in it.<br>By the looks of it, it was manufactured recently."
	icon = 'modular_fallout/master_files/icons/fallout/trash.dmi'
	icon_state = "single"
	tank_volume = 500
	reagent_id = /datum/reagent/fluorine
//	self_weight = 200

/obj/structure/reagent_dispensers/barrel/dangerous
	name = "waste barrel"
	desc = "A rather odd-looking metal barrel, made of strange metal that somehow hasn't rusted after all this time.<br>There is a strange label on it, but you can't quite make it out..."
	icon_state = "dangerous"
	tank_volume = 500
	reagent_id = /datum/reagent/uranium/radium
	light_color = LIGHT_COLOR_GREEN
	light_power = 3
	light_outer_range  = 2
//	self_weight = 200

/obj/structure/reagent_dispensers/barrel/dangerous/Initialize()
	. = ..()
	source.AddElement(/datum/element/radioactive)

/obj/structure/reagent_dispensers/barrel/dangerous/Destroy()
	source.RemoveElement(/datum/element/radioactive)
	..()

//Bing bang boom done
/obj/structure/reagent_dispensers/barrel/dangerous/process()
	if(QDELETED(src))
		return PROCESS_KILL

	for(var/mob/living/carbon/human/victim in view(src,1))
		if(istype(victim) && victim.stat != DEAD)
			victim.rad_act(5)

/obj/structure/reagent_dispensers/fueltank/barrel/boom()
	visible_message("<span class='danger'>\The [src] ruptures!</span>")
	chem_splash(loc, 0, list(reagents))
	qdel(src)

/obj/structure/reagent_dispensers/fueltank/barrel/explosive
	name = "fuel barrel"
	desc = "A rather odd-looking metal barrel, made of strange metal that somehow hasn't rusted after all this time.<br>There is a label on it, with a drawing of flames.<br>You wonder if there is anything left in it..."
	icon_state = "explosive"
	tank_volume = 500
	reagent_id = /datum/reagent/fuel
//	self_weight = 200

/obj/structure/reagent_dispensers/barrel/explosive/boom()
	explosion(get_turf(src), 0, 1, tank_volume/200, flame_range = tank_volume/200)
	qdel(src)

/obj/structure/reagent_dispensers/barrel/old
	name = "old barrel"
	desc = "An old barrel. Oddly enough, it stands undamaged after all this time.<br>You wonder if there is anything left in it."
	icon_state = "one_b"
	tank_volume = 500
	reagent_id = /datum/reagent/water
//	self_weight = 200

/obj/structure/reagent_dispensers/barrel/two
	name = "two old barrels"
	desc = "A couple of old barrels. Oddly enough, they stand undamaged after all this time.<br>You wonder if there is anything left in these."
	icon_state = "two_b"
	tank_volume = 1000
	reagent_id = /datum/reagent/lube
	anchored = 1
//	self_weight = 400

/obj/structure/reagent_dispensers/barrel/three
	name = "three old barrels"
	desc = "Ancient containers with something inside of them. Or are they empty? Actually, how would you know that..."
	icon_state = "three_b"
	tank_volume = 1500
	reagent_id = /datum/reagent/water
	anchored = 1
//	self_weight = 600

/obj/structure/reagent_dispensers/barrel/four
	name = "four old barrels"
	desc = "Ancient containers with something inside of them. Or are they empty? Actually, that's a lot of barrels standing in a single spot..."
	icon_state = "four_b"
	tank_volume = 800
	reagent_id = /datum/reagent/uranium/radium
	anchored = 1
//	self_weight = 60
