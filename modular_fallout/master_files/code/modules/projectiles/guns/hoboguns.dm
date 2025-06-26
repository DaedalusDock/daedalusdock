// IN THIS DOCUMENT: Improvised/home made, rebuilt whacky guns
// See gun.dm for keywords and the system used for gun balance


/obj/item/gun/ballistic/automatic/hobo
	slowdown = 0.3
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'

/obj/item/gun/ballistic/automatic/hobo/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(prob(1))
		playsound(user, fire_sound, 50, 1)
		to_chat(user, "<span class='userdanger'>[src] misfires, detonating the round in the barrel prematurely!</span>")
		user.take_bodypart_damage(0,20)
		user.dropItemToGround(src)
		return FALSE
	..()

/obj/item/gun/ballistic/revolver/hobo
	slowdown = 0.2
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'

/obj/item/gun/ballistic/revolver/hobo/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(prob(1))
		playsound(user, fire_sound, 50, 1)
		to_chat(user, "<span class='userdanger'>[src] misfires, detonating the round in the barrel prematurely!</span>")
		user.take_bodypart_damage(0,22)
		user.dropItemToGround(src)
		return FALSE
	..()


/obj/item/gun/ballistic/rifle/hobo
	slowdown = 0.4
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/energy.dmi'
	can_scope = TRUE

/obj/item/gun/ballistic/rifle/hobo/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(prob(1))
		playsound(user, fire_sound, 50, 1)
		to_chat(user, "<span class='userdanger'>[src] overheats and blasts you with superheated air!</span>")
		user.take_bodypart_damage(0,20)
		user.dropItemToGround(src)
		return FALSE
	..()

/obj/item/gun/ballistic/automatic/autopipe/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(prob(1))
		playsound(user, fire_sound, 50, 1)
		to_chat(user, "<span class='userdanger'>[src] misfires, detonating the round in the barrel prematurely!</span>")
		user.take_bodypart_damage(0,20)
		user.dropItemToGround(src)
		return FALSE
	..()

/////////////
//HOBO GUNS//
/////////////


//Zip gun												Keywords: 9mm, 5 rounds internal, Extra damage +2
/obj/item/gun/ballistic/automatic/hobo/zipgun
	name = "Zip gun (9mm)"
	icon_state = "zipgun"
	desc = "A crudely handcrafted zip gun that uses 9mm ammo."
	inhand_icon_state = "gun"
	w_class = WEIGHT_CLASS_SMALL
	weapon_weight = WEAPON_LIGHT
	slowdown = 0.1
	mag_type = /obj/item/ammo_box/magazine/zipgun
	force = 16
	extra_damage = 2
	spread = 8
	fire_delay = 4
	burst_size = 1
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot.ogg'

/obj/item/gun/ballistic/automatic/hobo/zipgun/update_icon_state()
	icon_state = "zipgun[magazine ? "-[CEILING(get_ammo(0)/1, 1)*1]" : ""][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"


//Pipe rifle (add multi calibre options)				Keywords: .223, 1 round internal, Extra damage +6
/obj/item/gun/ballistic/revolver/hobo/piperifle
	name = "pipe rifle (.223)"
	desc = "A rusty piece of pipe used to fire .223 and 5,56mm ammo."
	icon_state = "piperifle"
	inhand_icon_state = "pepperbox"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/improvisedpipe
	force = 20
	fire_delay = 0.25
	extra_damage = 6
	spread = 2
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot.ogg'

/obj/item/gun/ballistic/revolver/hobo/piperifle/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(prob(1))
		playsound(user, fire_sound, 50, 1)
		to_chat(user, "<span class='userdanger'>[src] misfires, detonating the round in the barrel prematurely!</span>")
		user.take_bodypart_damage(0,20)
		user.dropItemToGround(src)
		return FALSE
	..()

//Pepperbox gun											Keywords: 10mm, 4 rounds internal, Extra damage +3
/obj/item/gun/ballistic/revolver/hobo/pepperbox
	name = "pepperbox gun (10mm)"
	desc = "Take four pipes. Tie them together. Add planks, 10mm ammo and prayers."
	icon_state = "pepperbox"
	inhand_icon_state = "pepperbox"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/improvised10mm
	force = 20
	fire_delay = 0.25
	extra_damage = 3
	spread = 7
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot.ogg'

/obj/item/gun/ballistic/revolver/hobo/pepperbox/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(prob(1))
		playsound(user, fire_sound, 50, 1)
		to_chat(user, "<span class='userdanger'>[src] misfires, detonating the round in the barrel prematurely!</span>")
		user.take_bodypart_damage(0,20)
		user.dropItemToGround(src)
		return FALSE
	..()

//Shotgun bat											Keywords: Shotgun, 1 round internal, Extra damage +2, Melee damage
/obj/item/gun/ballistic/revolver/single_shotgun
	name = "shotgun bat"
	desc = "A baseball bat, a piece of pipe and a screwdriver is all you need to fire a shotgun shell apparantly. Good for whacking things once fired too."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "shotgunbat"
	inhand_icon_state = "shotgunbat"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	mag_type = /obj/item/ammo_box/magazine/internal/shot/improvised
	force = 26 //Good club
	fire_delay = 0.5
	extra_damage = 2
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/caravan_shotgun.ogg'

/obj/item/gun/ballistic/revolver/single_shotgun/update_icon_state()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"


//Knife gun. Or maybe gunknife.			Keywords: .44, 1 round internal, Extra damage +5, Melee damage, Bootgun
/obj/item/gun/ballistic/revolver/hobo/knifegun
	name = "knife gun (.44)"
	desc = "Someone thought, whats better than a knife? A knife that can shoot a bullet from its handle, that's what. It's doubtful if its true but it�s here so might as well use it."
	icon_state = "knifegun"
	inhand_icon_state = "knifegun"
	w_class = WEIGHT_CLASS_SMALL
	weapon_weight = WEAPON_LIGHT
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/improvised44
	force = 24
	fire_delay = 0.5
	spread = 4
	extra_damage = 5
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot.ogg'


//Knucklegun											Keywords: .38, 3 rounds internal, Extra damage +2, Melee damage
/obj/item/gun/ballistic/revolver/hobo/knucklegun
	name = "knucklegun (.38)"
	desc = "An attempt to combine a knuckleduster and four short gun barrels. Does not work as a ballistic fist, be happy if it doesn't explode and take your fingers off."
	icon_state = "knucklegun"
	inhand_icon_state = "knucklegun"
	w_class = WEIGHT_CLASS_SMALL
	weapon_weight = WEAPON_LIGHT
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/improvised38
	force = 23
	fire_delay = 0.25
	spread = 5
	extra_damage = 2
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot.ogg'


//Auto-pipe rifle										Keywords: .357, 18 round belt, Extra damage -8, no AP (bullet hose style)
/obj/item/gun/ballistic/automatic/autopipe
	name = "Auto-pipe rifle (.357)"
	desc = "A belt fed pipe rifle held together with duct tape. Highly inaccurate. What could go wrong."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "autopipe"
	inhand_icon_state = "autopipe"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/autopipe
	force = 20
	extra_damage = -8
	extra_penetration = -0.15
	burst_size = 4
	fire_delay = 6
	burst_shot_delay = 6
	spread = 15
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot.ogg'

/obj/item/gun/ballistic/automatic/autopipe/update_icon_state()
	icon_state = "autopipe[magazine ? "-[CEILING(get_ammo(0)/1, 6)*1]" : ""][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"



/////////////////////
//PREMIUM HOBO GUNS//
/////////////////////


//Laser musket
/obj/item/gun/ballistic/rifle/hobo/lasmusket
	name = "Laser Musket"
	desc = "In the wasteland, one must make do. And making do is what the creator of this weapon does. Made from metal scraps, electronic parts. an old rifle stock and a bottle full of dreams, the Laser Musket is sure to stop anything in their tracks and make those raiders think twice."
	icon_state = "lasmusket"
	inhand_icon_state = "lasmusket"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/lasmusket
	fire_delay = 15
	isenergy = TRUE
	var/bolt_open = FALSE
	can_bayonet = TRUE
	knife_x_offset = 22
	knife_y_offset = 20
	bayonet_state = "bayonet"
	scope_state = "scope_long"
	scope_x_offset = 11
	scope_y_offset = 14
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/lasmusket_fire.ogg'
	pump_sound = 'modular_fallout/master_files/sound/f13weapons/lasmusket_crank.ogg'
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aep7equip.ogg'


//Plasma musket.
/obj/item/gun/ballistic/rifle/hobo/plasmacaster
	name = "Plasma Musket"
	desc = "The cooling looks dubious and is that a empty can of beans used as a safety valve? Pray the plasma goes towards the enemy and not your face when you pull the trigger."
	icon_state = "plasmamusket"
	inhand_icon_state = "plasmamusket"
	mag_type = /obj/item/ammo_box/magazine/internal/plasmacaster
	fire_delay = 20
	var/bolt_open = FALSE
	isenergy = TRUE
	scope_state = "scope_medium"
	scope_x_offset = 9
	scope_y_offset = 20
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/lasmusket_fire.ogg'
	pump_sound = 'modular_fallout/master_files/sound/f13weapons/lasmusket_crank.ogg'
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aep7equip.ogg'


//Destroyer carbine										Keywords: .45 ACP, Automatic, 30 rounds, Long barrel, Suppressor
/obj/item/gun/ballistic/automatic/hobo/destroyer
	name = "destroyer carbine"
	desc = "There are many ways to describe this, very few of them nice. This is a .45 caliber silenced bolt action rifle - that via the expertise of a gun runner mainlining 50 liters of psycho, mentats, and turbo - has been converted into a semi auto."
	icon_state = "destroyer-carbine"
	inhand_icon_state = "varmintrifle"
	mag_type = /obj/item/ammo_box/magazine/greasegun
	extra_damage = 2
	fire_delay = 5
	burst_size = 2
	can_attachments = FALSE
	can_automatic = FALSE
	automatic_burst_overlay = TRUE
	can_scope = FALSE
	scope_state = "scope_medium"
	scope_x_offset = 6
	scope_y_offset = 14
	semi_auto = FALSE


//Obrez, sawn off bolt action rifle						Keywords: .308, 5 round internal
/obj/item/gun/ballistic/rifle/hunting/obrez
	name = "Obrez"
	desc = "A cut down bolt action rifle. Uses .308."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "308-sawn"
	inhand_icon_state = "308-sawn"
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM
	slowdown = 0.1
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/hunting
	extra_speed = 0
	spread = 7
	force = 16
	can_scope = FALSE


//Winchester rebore. 									Keywords: .308, 2 round internal, saw-off
/obj/item/gun/ballistic/revolver/winchesterrebored
	name = "rebored Winchester"
	desc = "A Winchester double-barreled shotgun rebored to fire .308 ammunition."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "winchesterbore"
	inhand_icon_state = "shotgundouble"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/improvised762
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	extra_damage = -1
	fire_delay = 0.25
	force = 20
	spread = 5
	sawn_desc = "Someone took the time to chop the last few inches off the barrel and stock of this shotgun. Now, the wide spread of this hand-cannon's short-barreled shots makes it perfect for short-range crowd control."
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/max_sawn_off.ogg'
	can_be_sawn_off = TRUE
