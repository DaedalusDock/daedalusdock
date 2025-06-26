//The ammo/gun is stored in a back slot item
/obj/item/m2flamethrowertank
	name = "backpack fuel tank"
	desc = "The massive pressurized fuel tank for a M2 Flamethrower."
	icon = 'modular_fallout/master_files/icons/obj/guns/flamethrower.dmi'
	icon_state = "m2_flamethrower_back"
	inhand_icon_state  = "m2_flamethrower_back"
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/equipment/backpack_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/equipment/backpack_righthand.dmi'
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	var/obj/item/gun/ballistic/m2flamethrower/gun
	var/armed = 0 //whether the gun is attached, 0 is attached, 1 is the gun is wielded.
	var/overheat = 0
	var/overheat_max = 4
	var/heat_diffusion = 1

/obj/item/m2flamethrowertank/Initialize()
	. = ..()
	gun = new(src)
	START_PROCESSING(SSobj, src)

/obj/item/m2flamethrower/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/m2flamethrowertank/process()
	overheat = max(0, overheat - heat_diffusion)

/obj/item/m2flamethrowertank/on_attack_hand(mob/living/carbon/user)
	if(src.loc == user)
		if(!armed)
			if(user.get_item_by_slot(SLOT_BACK) == src)
				armed = 1
				if(!user.put_in_hands(gun))
					armed = 0
					to_chat(user, "<span class='warning'>You need a free hand to hold the gun!</span>")
					return
				update_icon()
				user.update_inv_back()
		else
			to_chat(user, "<span class='warning'>You are already holding the gun!</span>")
	else
		..()

/obj/item/m2flamethrowertank/attackby(obj/item/W, mob/user, params)
	if(W == gun) //Don't need armed check, because if you have the gun assume its armed.
		user.dropItemToGround(gun, TRUE)
	else
		..()

/obj/item/m2flamethrowertank/dropped(mob/user)
	. = ..()
	if(armed)
		user.dropItemToGround(gun, TRUE)

/obj/item/m2flamethrowertank/MouseDrop(atom/over_object)
	. = ..()
	if(armed)
		return
	if(iscarbon(usr))
		var/mob/M = usr

		if(!over_object)
			return

		if(!M.incapacitated())

			if(istype(over_object, /obj/screen/inventory/hand))
				var/obj/screen/inventory/hand/H = over_object
				M.putItemFromInventoryInHandIfPossible(src, H.held_index)


/obj/item/m2flamethrowertank/update_icon_state()
	if(armed)
		icon_state = "m2_flamethrower_back"
	else
		icon_state = "m2_flamethrower_back"

/obj/item/m2flamethrowertank/proc/attach_gun(mob/user)
	if(!gun)
		gun = new(src)
	gun.forceMove(src)
	armed = 0
	if(user)
		to_chat(user, "<span class='notice'>You attach the [gun.name] to the [name].</span>")
	else
		src.visible_message("<span class='warning'>The [gun.name] snaps back onto the [name]!</span>")
	update_icon()
	user.update_inv_back()


/obj/item/gun/ballistic/m2flamethrower
	name = "\improper M2 Flamethrower"
	desc = "A pre-war M2 Flamethrower, commonly found in National Guard armoies. This one has NCR armory markings and is issued to combat engineers."
	icon = 'modular_fallout/master_files/icons/obj/guns/flamethrower.dmi'
	icon_state = "m2_flamethrower_on"
	inhand_icon_state  = "m2flamethrower"
	flags_1 = CONDUCT_1
	slowdown = 1
	slot_flags = null
	w_class = WEIGHT_CLASS_HUGE
	custom_materials = null
	burst_size = 2
	burst_shot_delay = 1
	//automatic = 0
	fire_delay = 10
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'modular_fallout/master_files/sound/weapons/flamethrower.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/m2flamethrower
	casing_ejector = FALSE
	item_flags = SLOWS_WHILE_IN_HAND
	var/obj/item/m2flamethrowertank/ammo_pack

/obj/item/gun/ballistic/m2flamethrower/Initialize()
	if(istype(loc, /obj/item/m2flamethrowertank)) //We should spawn inside an ammo pack so let's use that one.
		ammo_pack = loc
	else
		return INITIALIZE_HINT_QDEL //No pack, no gun

	return ..()

/obj/item/gun/ballistic/m2flamethrower/attack_self(mob/living/user)
	return

/obj/item/gun/ballistic/m2flamethrower/dropped(mob/user)
	. = ..()
	if(ammo_pack)
		ammo_pack.attach_gun(user)
	else
		qdel(src)

/obj/item/gun/ballistic/m2flamethrower/do_fire_gun(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(ammo_pack)
		if(ammo_pack.overheat < ammo_pack.overheat_max)
			ammo_pack.overheat += burst_size
			..()
		else
			to_chat(user, "The flamethrower is extremely hot! You shouldn't fire it anymore or it might blow up!.")

/obj/item/gun/ballistic/m2flamethrower/afterattack(atom/target, mob/living/user, flag, params)
	if(!ammo_pack || ammo_pack.loc != user)
		to_chat(user, "You need the backpack fuel tank to fire the gun!")
	. = ..()

/obj/item/gun/ballistic/m2flamethrower/dropped(mob/living/user)
	. = ..()
	ammo_pack.attach_gun(user)
