// Homemade bomb template
/obj/item/grenade/homemade
	name = "home-made bomb template "
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/explosives.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/special_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/special_righthand.dmi'
	inhand_icon_state = "ied"
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	throw_speed = 3
	throw_range = 6
	active = 0
	det_time = 50
	display_timer = 0
	var/range = 3
	var/list/times

/obj/item/grenade/homemade/Initialize()
	. = ..()
	times = list("5" = 5, "-1" = 5, "[rand(25,60)]" = 60, "[rand(65,180)]" = 30)// "Premature, Dud, Short Fuse, Long Fuse"=[weighting value]
	det_time = text2num(pickweight(times))
	if(det_time < 0) //checking for 'duds'
		range = 1
		det_time = rand(30,80)
	else
		range = pick(2,2,2,3,3,3,4)

/obj/item/grenade/homemade/examine(mob/user)
	. = ..()
	. += "You can't tell when it will explode!"


// Coffeepot Bomb
/obj/item/grenade/homemade/coffeepotbomb
	name = "coffeepot bomb"
	desc = "What happens when you fill a coffeepot with blackpowder and bits of metal, then hook up a eggclock timer to a wire stuck inside? Better throw it far away before finding out. Too bad its pretty heavy so its hard to throw far."
	icon_state = "coffeebomb"
	inhand_icon_state = "coffeebomb"
	throw_range = 4
	var/datum/looping_sound/reverse_bear_trap/soundloop

/obj/item/grenade/homemade/coffeepotbomb/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/obj/item/grenade/homemade/coffeepotbomb/attack_self(mob/user) //
	if(!active)
		if(!botch_check(user))
			to_chat(user, "<span class='warning'>You start the timer! Tick tock</span>")
			arm_grenade(user, null, FALSE)
			soundloop.start()

/obj/item/grenade/homemade/coffeepotbomb/prime(mob/living/lanced_by)
	. = ..()
	update_mob()
	explosion(src.loc, 0, 1, 2, 3, 0, flame_range = 2)
	qdel(src)


// Firebomb
/obj/item/grenade/homemade/firebomb
	name = "firebomb"
	desc = "A firebomb, basically a metal flask filled with fuel and a crude igniter to cause a small explosion that sends burning fuel over a large area."
	icon_state = "firebomb"
	inhand_icon_state = "ied"

/obj/item/grenade/homemade/firebomb/prime(mob/living/lanced_by) //Blowing that can up obsolete
	. = ..()
	update_mob()
	explosion(src.loc,-1,-1,2, flame_range = 4)	// small explosion, plus a very large fireball.
	qdel(src)
