//IN THIS DOCUMENT: Rifle template, Lever-action rifles, Bolt-action rifles, Magazine-fed bolt-action rifles
// See gun.dm for keywords and the system used for gun balance



////////////////////
// RIFLE TEMPLATE //
////////////////////


/obj/item/gun/ballistic/rifle

	name = "rifle template"
	desc = "Should not exist"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/assault_rifle.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "shotgun"
	inhand_icon_state  = "shotgun"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	can_automatic = FALSE
	slowdown = 0.5
	fire_delay = 6
	spread = 0
	force = 15 //Decent clubs generally speaking
	flags_1 =  CONDUCT_1
	casing_ejector = FALSE
	var/recentpump = 0 // to prevent spammage
	spawnwithmagazine = TRUE
	var/pump_sound = 'modular_fallout/master_files/sound/weapons/shotgunpump.ogg'
	fire_sound = 'modular_fallout/master_files/sound/weapons/shotgun.ogg'

/obj/item/gun/ballistic/rifle/process_chamber(mob/living/user, empty_chamber = 0)
	return ..() //changed argument value

/obj/item/gun/ballistic/rifle/can_fire()
	return !!chambered?.loaded_projectile

/obj/item/gun/ballistic/rifle/attack_self(mob/living/user)
	if(recentpump > world.time)
		return
	if(IS_STAMCRIT(user))//CIT CHANGE - makes pumping shotguns impossible in stamina softcrit
		to_chat(user, "<span class='warning'>You're too exhausted for that.</span>")//CIT CHANGE - ditto
		return//CIT CHANGE - ditto
	pump(user, TRUE)
	if(HAS_TRAIT(user, TRAIT_FAST_PUMP))
		recentpump = world.time + 2
	else
		recentpump = world.time + 10
		if(istype(user))//CIT CHANGE - makes pumping shotguns cost a lil bit of stamina.
			user.adjustStaminaLossBuffered(2) //CIT CHANGE - DITTO. make this scale inversely to the strength stat when stats/skills are added
	return

/obj/item/gun/ballistic/rifle/blow_up(mob/user)
	. = 0
	if(chambered?.loaded_projectile)
		do_fire_gun(user, user, FALSE)
		. = 1

/obj/item/gun/ballistic/rifle/proc/pump(mob/M, visible = TRUE)
	if(visible)
		M.visible_message("<span class='warning'>[M] racks [src].</span>", "<span class='warning'>You rack [src].</span>")
	playsound(M, pump_sound, 60, 1)
	pump_unload(M)
	pump_reload(M)
	update_icon()	//I.E. fix the desc
	return 1

/obj/item/gun/ballistic/rifle/proc/pump_unload(mob/M)
	if(chambered)//We have a shell in the chamber
		chambered.forceMove(drop_location())//Eject casing
		chambered.bounce_away()
		chambered = null

/obj/item/gun/ballistic/rifle/proc/pump_reload(mob/M)
	if(!magazine.ammo_count())
		return 0
	var/obj/item/ammo_casing/AC = magazine.get_round() //load next casing.
	chambered = AC

/obj/item/gun/ballistic/rifle/examine(mob/user)
	. = ..()
	if (chambered)
		. += "A [chambered.loaded_projectile ? "live" : "spent"] one is in the chamber."



///////////////////
//REPEATER RIFLES//
///////////////////


/obj/item/gun/ballistic/rifle/repeater
	name = "repeater template"
	desc = "should not exist"
	can_scope = TRUE
	scope_state = "scope_long"
	fire_delay = 4.5
	scope_x_offset = 5
	scope_y_offset = 13
	pump_sound = 'modular_fallout/master_files/sound/weapons/cowboyrepeaterreload.ogg'

//Cowboy Repeater						Keywords: .357, Lever action, 12 round internal, Long barrel
/obj/item/gun/ballistic/rifle/repeater/cowboy
	name = "cowboy repeater"
	desc = "A lever action rifle chambered in .357 Magnum. Smells vaguely of whiskey and cigarettes."
	icon_state = "cowboyrepeater"
	inhand_icon_state  = "cowboyrepeater"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/tube357
	extra_damage = 5
	extra_penetration = 5
	fire_delay = 4.5
	recoil = 0.15
	fire_sound = 'modular_fallout/master_files/sound/weapons/cowboyrepeaterfire.ogg'


//Trail carbine							Keywords: .44, Lever action, 12 round internal, Long barrel
/obj/item/gun/ballistic/rifle/repeater/trail
	name = "trail carbine"
	desc = "A lever action rifle chambered in .44 Magnum."
	icon_state = "trailcarbine"
	inhand_icon_state  = "trailcarbine"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/tube44
	extra_damage = 5
	extra_penetration = 5
	fire_delay = 4.5
	recoil = 0.25
	fire_sound = 'modular_fallout/master_files/sound/weapons/44mag.ogg'


//Brush gun								Keywords: .45-70, Lever action, 10 round internal, Long barrel
/obj/item/gun/ballistic/rifle/repeater/brush
	name = "brush gun"
	desc = "A short lever action rifle chambered in the heavy 45-70 round. Issued to NCR Veteran Rangers in the absence of heavier weaponry."
	icon_state = "brushgun"
	inhand_icon_state  = "brushgun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/tube4570
	extra_damage = 7
	extra_penetration = 5
	fire_delay = 4.5
	recoil = 0.25
	fire_sound = 'modular_fallout/master_files/sound/weapons/brushgunfire.ogg'



////////////////////////
// BOLT ACTION RIFLES //
////////////////////////


//Hunting Rifle							Keywords: .308, Bolt-action, 5 rounds internal
/obj/item/gun/ballistic/rifle/hunting
	name = "hunting rifle"
	desc = "A sturdy hunting rifle, chambered in .308. and in use before the war."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/battle_rifle.dmi'
	icon_state = "308"
	inhand_icon_state  = "308"
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/hunting
	sawn_desc = "A hunting rifle, crudely shortened with a saw. It's far from accurate, but the short barrel makes it quite portable."
	fire_delay = 4.5
	recoil = 0.35
	extra_damage = -5
	extra_penetration = -5
	spread = 1
	force = 20
	can_scope = TRUE
	scope_state = "scope_long"
	scope_x_offset = 4
	scope_y_offset = 12
	pump_sound = 'modular_fallout/master_files/sound/weapons/boltpump.ogg'
	fire_sound = 'modular_fallout/master_files/sound/weapons/hunting_rifle.ogg'

/obj/item/gun/ballistic/rifle/hunting/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/circular_saw) || istype(A, /obj/item/gun/energy/plasmacutter))
		sawoff(user)
	if(istype(A, /obj/item/melee/energy))
		var/obj/item/melee/energy/W = A
		if(W.blade_active)
			sawoff(user)

//Remington rifle						Keywords: 7.62, Bolt-action, 5 rounds internal
/obj/item/gun/ballistic/rifle/hunting/remington
	name = "Remington rifle"
	desc = "A militarized hunting rifle rechambered to 7.62. This one has had the barrel floated with shims to increase accuracy."
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/hunting/remington
	fire_delay = 4.5
	recoil = 0.2
	spread = 0

/obj/item/gun/ballistic/rifle/hunting/remington/attackby(obj/item/A, mob/user, params) //DO NOT BUBBA YOUR STANDARD ISSUE RIFLE SOLDIER!
	if(istype(A, /obj/item/circular_saw) || istype(A, /obj/item/gun/energy/plasmacutter))
		return
	else if(istype(A, /obj/item/melee/energy))
		var/obj/item/melee/energy/W = A
		if(W.blade_active)
			return
	else
		..()


//Paciencia								Keywords: UNIQUE, .308, Bolt-action, 5 rounds internal, long barrel, Scoped
/obj/item/gun/ballistic/rifle/hunting/paciencia
	name = "Paciencia"
	desc = "A modified .308 hunting rifle with a reduced magazine but an augmented receiver. A Mexican flag is wrapped around the stock. You only have three shots- make them count."
	icon_state = "paciencia"
	inhand_icon_state  = "paciencia"
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/hunting/paciencia
	fire_delay = 7
	recoil = 0.1
	extra_damage = 10
	extra_penetration = 5
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	can_scope = FALSE

/obj/item/gun/ballistic/rifle/hunting/paciencia/attackby(obj/item/A, mob/user, params) //no sawing off this one
	if(istype(A, /obj/item/circular_saw) || istype(A, /obj/item/gun/energy/plasmacutter))
		return
	else if(istype(A, /obj/item/melee/energy))
		var/obj/item/melee/energy/W = A
		if(W.blade_active)
			return
	else
		..()


//Mosin-Nagant							Keywords: 7.62, Bolt-action, 5 rounds internal
/obj/item/gun/ballistic/rifle/mosin
	name = "Mosin-Nagant m38"
	desc = "A rusty old Russian bolt action chambered in 7.62."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/battle_rifle.dmi'
	icon_state = "mosin"
	inhand_icon_state  = "308"
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction
	fire_delay = 9
	force = 20
	can_scope = TRUE
	scope_state = "scope_mosin"
	scope_x_offset = 3
	scope_y_offset = 13
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 22
	knife_y_offset = 21
	pump_sound = 'modular_fallout/master_files/sound/weapons/boltpump.ogg'
	fire_sound = 'modular_fallout/master_files/sound/weapons/boltfire.ogg'

//Lee-Enfield,SMLE 						Keywords: 7.62, Bolt-action, 5 rounds internal, short barrel (less damage, penetration and slower firing rate)
/obj/item/gun/ballistic/rifle/enfield
	name = "Lee-Enfield rifle"
	desc = "A british rifle sometimes known as the SMLE. It seems to have been re-chambered in .308."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/battle_rifle.dmi'
	icon_state = "enfield2"
	inhand_icon_state  = "308"
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction
	extra_damage = -3
	extra_penetration = -5
	extra_speed = -100
	fire_delay = 12
	slowdown = 0.35
	force = 15
	can_scope = TRUE
	scope_state = "scope_mosin"
	scope_x_offset = 3
	scope_y_offset = 13
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 22
	knife_y_offset = 21
	pump_sound = 'modular_fallout/master_files/sound/weapons/boltpump.ogg'
	fire_sound = 'modular_fallout/master_files/sound/weapons/boltfire.ogg'




/////////////////////////////////////
// MAGAZINE FED BOLT-ACTION RIFLES //
/////////////////////////////////////


/obj/item/gun/ballistic/rifle/mag
	name = "magazine fed bolt-action rifle template"
	desc = "should not exist."
	extra_speed = 800

/obj/item/gun/ballistic/rifle/mag/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to remove the magazine.</span>"

/obj/item/gun/ballistic/rifle/mag/AltClick(mob/living/user)
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(magazine)
		magazine.forceMove(drop_location())
		user.put_in_hands(magazine)
		magazine.update_icon()
		if(magazine.ammo_count())
			playsound(src, 'modular_fallout/master_files/sound/weapons/gun_magazine_remove_full.ogg', 70, 1)
		else
			playsound(src, "gun_remove_empty_magazine", 70, 1)
		magazine = null
		to_chat(user, "<span class='notice'>You pull the magazine out of \the [src].</span>")
	else if(chambered)
		AC.forceMove(drop_location())
		AC.bounce_away()
		chambered = null
		to_chat(user, "<span class='notice'>You unload the round from \the [src]'s chamber.</span>")
		playsound(src, "gun_slide_lock", 70, 1)
	else
		to_chat(user, "<span class='notice'>There's no magazine in \the [src].</span>")
	update_icon()
	return

/obj/item/gun/ballistic/rifle/mag/update_icon_state()
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"]"


//Anti-Material Rifle						Keywords: .50, Bolt-action, 8 round magazine
/obj/item/gun/ballistic/rifle/mag/antimateriel
	name = "anti-materiel rifle"
	desc = "The Hecate II is a heavy, high-powered bolt action sniper rifle chambered in .50 caliber ammunition. Lacks an iron sight."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/heavy_rifle.dmi'
	icon_state = "amr"
	inhand_icon_state  = "amr"
	mag_type = /obj/item/ammo_box/magazine/amr
	fire_delay = 10 //Heavy round, tiny bit slower
	recoil = 1
	spread = 0
	force = 10 //Big clumsy and sensitive scope, makes for a poor club
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	fire_sound = 'modular_fallout/master_files/sound/weapons/antimaterielfire.ogg'
	pump_sound = 'modular_fallout/master_files/sound/weapons/antimaterielreload.ogg'

// BETA // Obsolete
/obj/item/gun/ballistic/rifle/rifletesting
	name = "hunting"
	mag_type = /obj/item/ammo_box/magazine/testbullet
	extra_damage = 30
