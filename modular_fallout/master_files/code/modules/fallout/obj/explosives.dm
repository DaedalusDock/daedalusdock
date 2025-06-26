#define DISABLED 0
#define PREACTIVE 1
#define ACTIVE 2

/obj/item/bottlecap_mine
	name = "bottlecap mine"
	desc = "It has an adjustable timer. It can explode in 5 seconds after activating."
	w_class = 2
	icon = 'modular_fallout/master_files/icons/fallout/objects/crafting.dmi'
	icon_state = "capmine"
	inhand_icon_state = "capmine"
	throw_speed = 1
	throw_range = 0
//	flags = CONDUCT
	resistance_flags = FLAMMABLE
	obj_integrity = 80
	max_integrity = 80
	var/state = FALSE
	layer = 10

/obj/item/bottlecap_mine/attack_self(mob/user as mob)
	toggle_activate(user)


/obj/item/bottlecap_mine/proc/toggle_activate(mob/user)
	switch(state)
		if(DISABLED)
			state = PREACTIVE
			update_icon()
			spawn(50)
				if(state == PREACTIVE)
					state = ACTIVE
					update_icon()
					playsound(get_turf(src),'modular_fallout/master_files/sound/f13weapons/mine_one.ogg',50)
					START_PROCESSING(SSobj, src)
		if(PREACTIVE)
			state = DISABLED
			update_icon()
		if(ACTIVE)
			state = DISABLED
			update_icon()
			STOP_PROCESSING(SSobj, src)

/obj/item/bottlecap_mine/proc/boom()
	explosion(src.loc,0,2,3, flame_range = 6)

/obj/item/bottlecap_mine/process()
	if(state != ACTIVE)
		STOP_PROCESSING(SSobj, src)
		return
	var/list/Mobs = hearers(1, get_turf(src)) - src
	if(Mobs.len)
		playsound(get_turf(src),'modular_fallout/master_files/sound/f13weapons/mine_five.ogg',50)
		spawn(5)
			boom()
			STOP_PROCESSING(SSobj, src)
			return
	if(prob(15))
		playsound(get_turf(src),'modular_fallout/master_files/sound/f13weapons/mine_one.ogg',100, extrarange = -5)
/*
/obj/item/bottlecap_mine/Crossed(go/AM)
	if(state == ACTIVE && ishuman(AM))
		boom()
*/

/obj/item/bottlecap_mine/update_icon()
	switch(state)
		if(DISABLED)
			icon_state = "capmine"
		if(PREACTIVE)
			icon_state = "capmine_preactive"
		if(ACTIVE)
			icon_state = "capmine_active"

/obj/item/bottlecap_mine/examine(mob/user)
	. = ..()
	. += span_warning("It seems activated!")
