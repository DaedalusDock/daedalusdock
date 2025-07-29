//IN THIS DOCUMENT: Pistol template, Light pistols, Heavy pistols
// See gun.dm for keywords and the system used for gun balance



///////////////////
//PISTOL TEMPLATE//
///////////////////


/obj/item/gun/ballistic/automatic/pistol
	slowdown = 0.1
	name = "pistol template"
	desc = "should not be here. Bugreport."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/pistol.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	inhand_icon_state  = "gun"
	w_class = WEIGHT_CLASS_NORMAL //How much space it takes in a bag
	slot_flags = ITEM_SLOT_BELT
	select = FALSE
	automatic_burst_overlay = FALSE
	can_automatic = FALSE
	semi_auto = TRUE
	can_suppress = TRUE
	fire_sound = 'modular_fallout/master_files/sound/weapons/policepistol.ogg'

	weapon_weight = WEAPON_LIGHT //Makes dual wield possible
	force = 12 //Pistol whip
	mag_type = /obj/item/ammo_box/magazine/m10mm_adv/simple
	spread = 2
	burst_size = 1
	fire_delay = 4

/obj/item/gun/ballistic/automatic/pistol/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/update_icon_state()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/pistol/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)



/////////////////
//LIGHT PISTOLS//
/////////////////


//.22 Sport								Keywords: .22, Semi-auto, 16 round magazine, Suppressed
/obj/item/gun/ballistic/automatic/pistol/pistol22
	name = ".22 pistol"
	desc = "The silenced .22 pistol is a sporting handgun with an integrated silencer."
	icon_state = "silenced22"
	mag_type = /obj/item/ammo_box/magazine/m22
	can_attachments = TRUE
	can_suppress = FALSE
	can_unsuppress = FALSE
	suppressed = 1
	fire_sound = 'modular_fallout/master_files/sound/weapons/22pistol.ogg'


//N99  10mm								Keywords: 10mm, Semi-auto, 12/24 round magazine
/obj/item/gun/ballistic/automatic/pistol/n99
	name = "10mm pistol"
	desc = "A pre-war large-framed, gas-operated advanced 10mm pistol."
	icon_state = "n99"
	mag_type = /obj/item/ammo_box/magazine/m10mm_adv/simple
	can_attachments = TRUE
	can_automatic = TRUE
	suppressor_state = "n99_suppressor"
	suppressor_x_offset = 29
	suppressor_y_offset = 15
	fire_sound = 'modular_fallout/master_files/sound/weapons/10mm_fire_02.ogg'

//the Executive							Keywords: UNIQUE, 10mm, Automatic, 12/24 round magazine. Special modifiers: damage +4
/obj/item/gun/ballistic/automatic/pistol/n99/executive
	name = "the Executive"
	desc = "A modified N99 pistol with an accurate two-round-burst and a blue Vault-Tec finish, a status symbol for some Overseers."
	icon_state = "executive"
	semi_auto = FALSE
	can_automatic = FALSE

	burst_size = 2

//Crusader pistol
/obj/item/gun/ballistic/automatic/pistol/n99/crusader
	name = "\improper Crusader pistol"
	desc = "A large-framed N99 pistol emblazoned with the colors and insignia of the Brotherhood of Steel. It feels heavy in your hand."
	icon_state = "crusader"
	inhand_icon_state  = "crusader"
	can_attachments = FALSE
	can_automatic = FALSE

	extra_penetration = 5
	extra_damage = 2
	force = 18

//Type 17								Keywords: 10mm, Semi-auto, 12/24 round magazine. Special modifiers: damage +1, spread +1
/obj/item/gun/ballistic/automatic/pistol/type17
	name = "Type 17"
	desc = "Chinese military sidearm at the time of the Great War. The ones around are old and worn, but somewhat popular due to the long barrel and rechambered in 10mm after the original ammo ran dry decades ago."
	icon_state = "chinapistol"
	mag_type = /obj/item/ammo_box/magazine/m10mm_adv/simple
	can_suppress = FALSE
	fire_sound = 'modular_fallout/master_files/sound/weapons/10mm_fire_02.ogg'

	fire_delay = 3
	spread = 3

//Browning Hi-power						Keywords: 9mm, Semi-auto, 10 round magazine
/obj/item/gun/ballistic/automatic/pistol/ninemil
	name = "Browning Hi-power"
	desc = "A mass produced pre-war Browning Hi-power 9mm pistol."
	icon_state = "ninemil"
	mag_type = /obj/item/ammo_box/magazine/m9mm
	can_attachments = TRUE
	suppressor_state = "pistol_suppressor"
	suppressor_x_offset = 30
	suppressor_y_offset = 19
	fire_sound = 'modular_fallout/master_files/sound/weapons/ninemil.ogg'

	fire_delay = 2

//Maria									Keywords: UNIQUE, 9mm, Semi-auto, 10 round magazine. Special modifiers: fire delay -1, damage +10, penetration +0.2
/obj/item/gun/ballistic/automatic/pistol/ninemil/maria
	name = "Maria"
	desc = "An ornately-decorated pre-war Browning Hi-power 9mm pistol with pearl grips and a polished nickel finish. The firing mechanism has been upgraded, so for anyone on the receiving end, it must seem like an eighteen-karat run of bad luck."
	icon_state = "maria"

	fire_delay = 1
	extra_damage = 5
	extra_penetration = 5


//Sig Sauer P220						Keywords: 9mm, Semi-auto, 10 round magazine
/obj/item/gun/ballistic/automatic/pistol/sig
	name = "Sig P220"
	desc = "The P220 Sig Sauer. A Swiss designed pistol that is compact and has a good rate of fire."
	icon_state = "sig"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/m9mm
	can_attachments = TRUE
	suppressor_state = "pistol_suppressor"
	suppressor_x_offset = 30
	suppressor_y_offset = 20
	fire_sound = 'modular_fallout/master_files/sound/weapons/9mm.ogg'

	fire_delay = 3
	extra_damage = -2

//side grade to the peacemaker 		    Keywords: OASIS, 9mm, Semi-auto, +5 damage, 10 round magazine, 0 spread, faster rate of fire, bullet speed +100, probably needs a new sprite
/obj/item/gun/ballistic/automatic/pistol/sig/commissioner
	name = "The Defender"
	desc = "A modified Sig P225 salvaged from the boneyard. Boasts a faster rate of fire and laser-like accuracy. It has 'To Protect and Serve' etched on the side."
	w_class = WEIGHT_CLASS_SMALL

	fire_delay = 1
	extra_damage = -1
	spread = 0

//Beretta M9FS							Keywords: 9mm, Semi-auto, 15 round magazine. Special modifiers: spread -1
/obj/item/gun/ballistic/automatic/pistol/beretta
	name = "Beretta M9FS"
	desc = "One of the more common 9mm pistols, the Beretta is popular due to its reliability, 15 round magazine and good looks."
	icon_state = "beretta"
	mag_type = /obj/item/ammo_box/magazine/m9mmds
	can_attachments = TRUE
	can_suppress = "pistol_suppressor"
	suppressor_x_offset = 30
	suppressor_y_offset = 20
	fire_sound = 'modular_fallout/master_files/sound/weapons/9mm.ogg'

	fire_delay = 2
	spread = 1

//Beretta M93R							Keywords: 9mm, Automatic, 15 round magazine
/obj/item/gun/ballistic/automatic/pistol/beretta/automatic
	name = "Beretta M93R"
	desc = "A rare select fire variant of the M93R."
	icon_state = "m93r"
	actions_types = list(/datum/action/item_action/toggle_firemode)
	automatic_burst_overlay = TRUE
	can_attachments = FALSE
	semi_auto = FALSE
	actions_types = list(/datum/action/item_action/toggle_firemode)

	burst_size = 2
	burst_shot_delay = 2.5
	spread = 9
	recoil = 0.1

/obj/item/gun/ballistic/automatic/pistol/beretta/automatic/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 9
			recoil = 0.1
			weapon_weight = WEAPON_HEAVY
			to_chat(user, "<span class='notice'>You switch to automatic fire.</span>")
		if(1)
			select = 0
			burst_size = 1
			spread = 1
			recoil = 0
			weapon_weight = WEAPON_MEDIUM
			to_chat(user, "<span class='notice'>You switch to semi-auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return


//M1911									Keywords: .45 ACP, Semi-auto, 8 round magazine.
/obj/item/gun/ballistic/automatic/pistol/m1911
	name = "M1911"
	desc = "A classic .45 handgun with a small magazine capacity."
	icon_state = "m1911"
	inhand_icon_state  = "pistolchrome"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/m45
	can_attachments = TRUE
	suppressor_state = "pistol_suppressor"
	suppressor_x_offset = 30
	suppressor_y_offset = 21
	fire_sound = 'modular_fallout/master_files/sound/weapons/45revolver.ogg'

//M1911	Custom							Keywords: .45 ACP, Semi-auto, 8 round magazine.
/obj/item/gun/ballistic/automatic/pistol/m1911/custom
	name = "M1911 Custom"
	desc = "A well-maintained stainless-steel frame 1911, with genuine wooden grips."
	icon_state = "m1911_custom"
	fire_delay = 2

//M1911	compact							Keywords: .45 ACP, Semi-auto, Short barrel, 8 round magazine. Special modifiers: damage -2
/obj/item/gun/ballistic/automatic/pistol/m1911/compact
	name = "M1911 compact"
	desc = "The compact version of the classic .45 handgun."
	icon_state = "c1911"
	w_class = WEIGHT_CLASS_SMALL
	suppressor_x_offset = 29
	suppressor_y_offset = 21

	extra_damage = -2
	fire_delay = 3
	spread = 4

/obj/item/gun/ballistic/automatic/pistol/m1911/no_mag
	spawnwithmagazine = FALSE


//Mk. 23								Keywords: .45 ACP, Semi-auto, Long barrel (lasersight), 12 round magazine, Flashlight
/obj/item/gun/ballistic/automatic/pistol/mk23
	name = "Mk. 23"
	desc = "A very tactical pistol chambered in .45 ACP with a built in laser sight and attachment point for a seclite."
	icon_state = "mk23"
	mag_type = /obj/item/ammo_box/magazine/m45exp
	can_flashlight = TRUE
	gunlight_state = "flight"
	flight_x_offset = 16
	flight_y_offset = 13
	suppressor_state = "pistol_suppressor"
	suppressor_x_offset = 28
	suppressor_y_offset = 20
	fire_sound = 'modular_fallout/master_files/sound/weapons/45revolver.ogg'

	fire_delay = 2
	spread = 1
	extra_damage = 2

/////////////////
//HEAVY PISTOLS//
/////////////////


//Desert Eagle							Keywords: .44 Magnum, Semi-auto, Long barrel, 8 round magazine, Heavy.
/obj/item/gun/ballistic/automatic/pistol/deagle
	name = "Desert Eagle"
	desc = "A robust .44 magnum semi-automatic handgun."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/pistol_heavy.dmi'
	icon_state = "deagle"
	inhand_icon_state  = "deagle"
	mag_type = /obj/item/ammo_box/magazine/m44
	can_suppress = FALSE
	automatic_burst_overlay = FALSE
	fire_sound = 'modular_fallout/master_files/sound/weapons/44mag.ogg'

	weapon_weight = WEAPON_MEDIUM
	force = 15
	recoil = 0.5
	fire_delay = 5

//El Capitan			Keywords: 14mm, Semi-auto, 7 round magazine, Heavy. Special modifiers: fire_delay = 5
/obj/item/gun/ballistic/automatic/pistol/deagle/elcapitan
	name = "El Capitan"
	desc = "The Captain loves his gun, despite some silly gunsmith adding some gas venting to the barrel after his second visit to the surgeon for recoil-related wrist injuries."
	icon_state = "elcapitan"
	inhand_icon_state  = "deagle"
	mag_type = /obj/item/ammo_box/magazine/m14mm
	fire_sound = 'modular_fallout/master_files/sound/weapons/magnum_fire.ogg'

	fire_delay = 3
	recoil = 0.3

//Automag			Keywords: .44 Magnum, Semi-auto, Long barrel, 7 rounds, Heavy. Special modifiers: damage +2
/obj/item/gun/ballistic/automatic/pistol/automag
	name = "Automag"
	desc = "A long-barreled .44 magnum semi-automatic handgun."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/pistol_heavy.dmi'
	icon_state = "automag"
	inhand_icon_state  = "deagle"
	mag_type = /obj/item/ammo_box/magazine/automag
	can_suppress = FALSE
	automatic_burst_overlay = FALSE
	fire_sound = 'modular_fallout/master_files/sound/weapons/44mag.ogg'

	weapon_weight = WEAPON_MEDIUM
	fire_delay = 5
	recoil = 0.5

//14mm Pistol		Keywords: 14mm, Semi-auto, 7 rounds, Heavy
/obj/item/gun/ballistic/automatic/pistol/pistol14
	name = "14mm pistol"
	desc = "A Swiss SIG-Sauer 14mm handgun, powerful but a little inaccurate"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/pistol_heavy.dmi'
	icon_state = "pistol14"
	mag_type = /obj/item/ammo_box/magazine/m14mm
	can_suppress = FALSE
	fire_sound = 'modular_fallout/master_files/sound/weapons/magnum_fire.ogg'

	weapon_weight = WEAPON_MEDIUM
	force = 15
	fire_delay = 5
	recoil = 0.5

//14mm compact		Keywords: 14mm, Semi-auto, Short barrel, 7 rounds, Heavy
/obj/item/gun/ballistic/automatic/pistol/pistol14/compact
	name = "compact 14mm pistol"
	desc = "A Swiss SIG-Sauer 14mm handgun, this one is a compact model for concealed carry."
	icon_state = "pistol14_compact"

	w_class = WEIGHT_CLASS_SMALL
	extra_damage = -5
	spread = 5
	fire_delay = 7
	recoil = 0.7

//Little Devil							Keywords: UNIQUE, 14mm, Semi-auto, Short barrel, 7 Rounds, Heavy. Special modifiers: damage +4, penetration +0.05, spread -3
/obj/item/gun/ballistic/automatic/pistol/pistol14/lildevil
	name= "Little Devil 14mm pistol"
	desc = "A Swiss SIG-Sauer 14mm handgun, this one is a finely tuned custom firearm from the Gunrunners."
	icon_state = "lildev"

	w_class = WEIGHT_CLASS_SMALL
	fire_delay = 5
	recoil = 0.5


/////////////////////////////////
// TEMPORARY REMOVE AFTER BETA //
/////////////////////////////////obsolete

/obj/item/gun/ballistic/automatic/pistol/pistoltesting
	name = "pistol"
	mag_type = /obj/item/ammo_box/magazine/testbullet

	extra_damage = 18
