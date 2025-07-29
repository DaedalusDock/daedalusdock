//IN THIS DOCUMENT: Automatic template, SMGs, Carbines, Semi-auto rifles, Assault rifles, Machineguns and Misc.
// See gun.dm for keywords and the system used for gun balance



//////////////////////
//AUTOMATIC TEMPLATE//
//////////////////////


/obj/item/gun/ballistic/automatic
	name = "automatic gun template"
	desc = "should not be here, bugreport."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/assault_rifle.dmi'
	slowdown = 0.5
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = 0
	force = 15
	burst_size = 2
	burst_shot_delay = 3
	var/automatic_burst_overlay = TRUE
	var/auto_eject = 0
	var/auto_eject_sound = null
	var/alarmed = 0
	can_suppress = FALSE
	equipsound = 'modular_fallout/master_files/sound/weapons/equipsounds/riflequip.ogg'

/obj/item/gun/ballistic/automatic/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/attachments/auto_sear))
		var/obj/item/attachments/auto_sear/A = I
		if(!auto_sear && can_automatic && semi_auto)
			if(!user.transferItemToLoc(I, src))
				return
			auto_sear = A
			src.desc += " It has an automatic sear installed."
			src.burst_size += 1
			src.spread += 6
			src.recoil += 0.1
			src.automatic_burst_overlay = TRUE
			src.semi_auto = FALSE
			to_chat(user, "<span class='notice'>You attach \the [A] to \the [src].</span>")
			update_icon()
	else
		return ..()

/obj/item/gun/ballistic/automatic/update_overlays()
	. = ..()
	if(automatic_burst_overlay)
		if(!select)
			. += ("[initial(icon_state)]semi")
		if(select == 1)
			. += "[initial(icon_state)]burst"

/obj/item/gun/ballistic/automatic/update_icon_state()
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(.)
		return
	if(istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if(istype(AM, mag_type))
			var/obj/item/ammo_box/magazine/oldmag = magazine
			if(user.transferItemToLoc(AM, src))
				magazine = AM
				if(oldmag)
					to_chat(user, "<span class='notice'>You perform a tactical reload on \the [src], replacing the magazine.</span>")
					oldmag.forceMove(get_turf(src.loc))
					oldmag.update_icon()
				else
					to_chat(user, "<span class='notice'>You insert the magazine into \the [src].</span>")

				playsound(user, 'modular_fallout/master_files/sound/weapons/autoguninsert.ogg', 60, 1)
				chamber_round()
				A.update_icon()
				update_icon()
				return 1
			else
				to_chat(user, "<span class='warning'>You cannot seem to get \the [src] out of your hands!</span>")

/obj/item/gun/ballistic/automatic/proc/enable_burst()
	burst_size = initial(burst_size)
	if(auto_sear)
		burst_size += initial(burst_size)
	if(burst_improvement)
		burst_size += initial(burst_size)
	if(burst_improvement && auto_sear)
		burst_size += 1 + initial(burst_size)

/obj/item/gun/ballistic/automatic/proc/disable_burst()
	burst_size = initial(burst_size)

/obj/item/gun/ballistic/automatic/proc/empty_alarm()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(src.loc, 'modular_fallout/master_files/sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/gun/ballistic/automatic/afterattack(atom/target, mob/living/user)
	..()
	if(auto_eject && magazine && magazine.stored_ammo && !magazine.stored_ammo.len && !chambered)
		magazine.unequipped()
		user.visible_message(
			"[magazine] falls out and clatters on the floor!",
			"<span class='notice'>[magazine] falls out and clatters on the floor!</span>"
		)
		if(auto_eject_sound)
			playsound(user, auto_eject_sound, 40, 1)
		magazine.forceMove(get_turf(src.loc))
		magazine.update_icon()
		magazine = null
		update_icon()



///////////////////
//SUBMACHINE GUNS//
///////////////////


//SMG TEMPLATE
/obj/item/gun/ballistic/automatic/smg/
	name = "SMG TEMPLATE"
	desc = "should not exist"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/smg.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_HEAVY //Automatic fire and onehanded use mix poorly.
	slowdown = 0.2
	fire_delay = 3.75
	burst_shot_delay = 3
	spread = 10
	force = 12
	actions_types = list(/datum/action/item_action/toggle_firemode)


//Rockwell gun				Keywords: 9mm, Automatic, 20/32 rounds. Special modifiers: damage -2
/obj/item/gun/ballistic/automatic/smg/rockwell
	name = "Rockwell gun"
	desc = "Post-war submachine gun in 9mm, based on old schematics by T.G. Rockwell for home-made weapons if under enemy occupation. The Rockwell is basically a toploaded sten gun with a pistol grip, allowing makeshift magazines without a spring."
	icon_state = "rockwell"
	base_icon_state = "rockwell"
	mag_type = /obj/item/ammo_box/magazine/uzim9mm
	init_mag_type = /obj/item/ammo_box/magazine/uzim9mm/rockwell
	burst_shot_delay = 3.25
	recoil = 0.1
	spread = 12
	can_attachments = TRUE
	actions_types = null

//American 180				Keywords: .22 LR, Automatic, 180 rounds
/obj/item/gun/ballistic/automatic/smg/american180
	name = "American 180"
	desc = "An integrally suppressed submachinegun chambered in the common .22 long rifle. Top loaded drum magazine."
	icon_state = "smg22"
	base_icon_state = "shotgun"
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/m22smg
	can_unsuppress = FALSE
	burst_shot_delay = 1.5 //rapid fire
	suppressed = 1
	actions_types = null
	fire_sound = 'modular_fallout/master_files/sound/weapons/american180.ogg'


//Greasegun				Keywords: .45 ACP, Automatic, 30 rounds
/obj/item/gun/ballistic/automatic/smg/greasegun
	name = "M3A1 Grease Gun"
	desc = "An inexpensive submachine gun chambered in .45 ACP. Slow fire rate allows the operator to conserve ammunition in controllable bursts."
	icon_state = "grease_gun"
	base_icon_state = "smg9mm"
	mag_type = /obj/item/ammo_box/magazine/greasegun
	spread = 8
	extra_damage = 3
	extra_speed = 100
	burst_shot_delay = 3.25 //Slow rate of fire
	can_attachments = TRUE
	suppressor_state = "uzi_suppressor"
	suppressor_x_offset = 26
	suppressor_y_offset = 19
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/greasegun.ogg'

/obj/item/gun/ballistic/automatic/smg/greasegun/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 8
			fire_delay =3.5
			recoil = 0.1
			weapon_weight = WEAPON_HEAVY
			to_chat(user, "<span class='notice'>You switch to automatic fire.</span>")
			enable_burst()
		if(1)
			select = 0
			burst_size = 1
			fire_delay = 3.25
			spread = 2
			weapon_weight = WEAPON_MEDIUM
			to_chat(user, "<span class='notice'>You switch to semi-auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return

/obj/item/gun/ballistic/automatic/smg/greasegun/worn
	name = "beat up M3A1 Grease Gun"
	desc = "What was once an inexpensive, but reliable submachine gun is now an inexpensive piece of shit. It's impressive this thing still fires at all."
	can_attachments = FALSE
	recoil = 0.3
	extra_damage = -4
	extra_penetration = -0.1

/obj/item/gun/ballistic/automatic/smg/greasegun/worn/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 12.5
			fire_delay =3.5
			recoil = 0.3
			weapon_weight = WEAPON_HEAVY
			to_chat(user, "<span class='notice'>You switch to automatic fire.</span>")
			enable_burst()
		if(1)
			select = 0
			burst_size = 1
			fire_delay = 3.5
			spread = 2
			weapon_weight = WEAPON_HEAVY
			recoil = 0.2
			to_chat(user, "<span class='notice'>You switch to semi-auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return

//10mm SMG			Keywords: 10mm, Automatic, 12/24 rounds
/obj/item/gun/ballistic/automatic/smg/smg10mm
	name = "10mm submachine gun"
	desc = "One of the most common personal-defense weapons of the Great War, a sturdy and reliable open-bolt 10mm submachine gun."
	icon_state = "smg10mm"
	base_icon_state = "smg10mm"
	mag_type = /obj/item/ammo_box/magazine/m10mm_adv
	init_mag_type = /obj/item/ammo_box/magazine/m10mm_adv/ext
	fire_delay = 3.75
	extra_damage = 3
	extra_speed = 100
	recoil = 0.3
	can_attachments = TRUE
	suppressor_state = "10mm_suppressor" //activate if sprited
	suppressor_x_offset = 30
	suppressor_y_offset = 16
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/10mm_fire_03.ogg'

/obj/item/gun/ballistic/automatic/smg/smg10mm/worn
	name = "worn-out 10mm submachine gun"
	desc = "Mass-produced weapon from the Great War, this one has seen use ever since. Grip is wrapped in tape to keep the plastic from crumbling, the metals are oxidizing, but the gun still works."
	init_mag_type = /obj/item/ammo_box/magazine/m10mm_adv/ext
	worn_out = TRUE

/obj/item/gun/ballistic/automatic/smg/smg10mm/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 9
			fire_delay = 3.75
			recoil = 0.1
			weapon_weight = WEAPON_HEAVY
			to_chat(user, "<span class='notice'>You switch to automatic fire.</span>")
			enable_burst()
		if(1)
			select = 0
			burst_size = 1
			fire_delay = 3.5
			spread = 2
			weapon_weight = WEAPON_MEDIUM
			to_chat(user, "<span class='notice'>You switch to semi-auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return

//Uzi				Keywords: 9mm, Automatic, 32 rounds
/obj/item/gun/ballistic/automatic/smg/mini_uzi
	name = "Uzi"
	desc = "A lightweight, burst-fire submachine gun, for when you really want someone dead. Uses 9mm rounds."
	icon_state = "uzi"
	base_icon_state = "uzi"
	mag_type = /obj/item/ammo_box/magazine/uzim9mm
	fire_delay = 2
	burst_shot_delay = 2.5
	can_suppress = TRUE
	can_attachments = TRUE
	spread = 10
	suppressor_state = "uzi_suppressor"
	suppressor_x_offset = 29
	suppressor_y_offset = 16
	actions_types = list(/datum/action/item_action/toggle_firemode)

/obj/item/gun/ballistic/automatic/smg/mini_uzi/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 11
			fire_delay = 3
			recoil = 0.1
			weapon_weight = WEAPON_HEAVY
			to_chat(user, "<span class='notice'>You switch to automatic fire.</span>")
			enable_burst()
		if(1)
			select = 0
			burst_size = 1
			fire_delay = 3
			spread = 3
			weapon_weight = WEAPON_MEDIUM
			to_chat(user, "<span class='notice'>You switch to semi-auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return


//Carl Gustaf			Keywords: 10mm, Automatic, 36 rounds
/obj/item/gun/ballistic/automatic/smg/cg45
	name = "Carl Gustaf 10mm"
	desc = "Post-war submachine gun made in workshops in Phoenix, a copy of a simple old foreign design."
	icon_state = "cg45"
	base_icon_state = "cg45"
	mag_type = /obj/item/ammo_box/magazine/cg45
	fire_delay = 3.5
	spread = 8
	recoil = 0.1
	can_attachments = TRUE
	fire_sound = 'modular_fallout/master_files/sound/weapons/10mm_fire_03.ogg'


//Tommygun			Keywords: .45 ACP, Automatic, 30/50 rounds. Special modifiers: damage -1
/obj/item/gun/ballistic/automatic/smg/tommygun
	name = "ancient Thompson SMG"
	desc = "Rusty, dinged up, but somehow still functional."
	icon_state = "tommygun"
	base_icon_state = "shotgun"
	slowdown = 0.4
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/tommygunm45
	init_mag_type = /obj/item/ammo_box/magazine/tommygunm45/stick
	fire_sound = 'modular_fallout/master_files/sound/weapons/gunshot_smg.ogg'
	burst_size = 3
	burst_shot_delay = 3.25
	fire_delay = 5
	extra_damage = -3
	extra_speed = -50
	spread = 10
	recoil = 0.2


//P90				Keywords: 10mm, Automatic, 50 rounds. Special modifiers: damage +1
/obj/item/gun/ballistic/automatic/smg/p90
	name = "FN P90c"
	desc = "The Fabrique Nationale P90c was just coming into use at the time of the war. The weapon's bullpup layout, and compact design, make it easy to control. The durable P90c is prized for its reliability, and high firepower in a ruggedly-compact package. Chambered in 10mm."
	icon_state = "p90"
	base_icon_state = "m90"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/m10mm_p90
	burst_size = 3
	fire_delay = 3
	spread = 7
	burst_shot_delay = 2.5
	extra_damage = 3
	extra_penetration = 5
	recoil = 0.2
	can_suppress = TRUE
	suppressor_state = "pistol_suppressor"
	suppressor_x_offset = 29
	suppressor_y_offset = 16
	fire_sound = 'modular_fallout/master_files/sound/weapons/10mm_fire_03.ogg'

/obj/item/gun/ballistic/automatic/smg/p90/worn
	name = "Worn FN P90c"
	desc = "A FN P90 manufactured by Fabrique Nationale. This one is beat to hell but still works."
	fire_delay = 5
	burst_size = 2


//MP-5 SD				Keywords: 9mm, Automatic, 32 rounds, Suppressed
/obj/item/gun/ballistic/automatic/smg/mp5
	name = "MP-5 SD"
	desc = "An integrally suppressed submachinegun chambered in 9mm."
	icon_state = "mp5"
	base_icon_state = "fnfal"
	mag_type = /obj/item/ammo_box/magazine/uzim9mm
	spread = 8
	fire_delay = 3.5
	burst_shot_delay = 2
	extra_damage = 3
	suppressed = 1
	recoil = 0.2
	can_attachments = TRUE
	can_suppress = FALSE
	can_unsuppress = FALSE
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot_silenced.ogg'


//Ppsh-41				Keywords: 9mm, Automatic, 71 rounds. Special modifiers: damage -4
/obj/item/gun/ballistic/automatic/smg/ppsh
	name = "Ppsh-41"
	desc = "An extremely fast firing, inaccurate submachine gun from World War 2. Low muzzle velocity. Uses 9mm rounds."
	icon_state = "pps"
	slowdown = 0.3
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/pps9mm
	spread = 20
	burst_size = 3
	fire_delay = 5
	burst_shot_delay = 1.5
	recoil = 0.25
	can_attachments = TRUE
	can_scope = TRUE
	scope_state = "AEP7_scope"
	scope_x_offset = 9
	scope_y_offset = 21



////////////
//CARBINES//
////////////

//M1 Carbine				Keywords: 10mm, Semi-auto, 12/24 rounds, Long barrel
/obj/item/gun/ballistic/automatic/m1carbine
	name = "m1 carbine"
	desc = "The M1 Carbine was mass produced during some old war, and at some point NCR found stockpiles and rechambered them to 10mm to make up for the fact their service rifle production can't keep up with demand."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/battle_rifle.dmi'
	icon_state = "m1carbine"
	base_icon_state = "rifle"
	mag_type = /obj/item/ammo_box/magazine/m10mm_adv
	burst_size = 1
	fire_delay = 5
	spread = 2
	extra_damage = 2
	automatic_burst_overlay = FALSE
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 22
	knife_y_offset = 21
	can_scope = TRUE
	scope_state = "scope_medium"
	scope_x_offset = 5
	scope_y_offset = 14
	can_attachments = TRUE
	can_automatic = TRUE
	semi_auto = TRUE
	can_suppress = TRUE
	suppressor_state = "rifle_suppressor"
	suppressor_x_offset = 26
	suppressor_y_offset = 31
	fire_sound = 'modular_fallout/master_files/sound/weapons/varmint_rifle.ogg'


//M1/n Carbine				Keywords: NCR, 10mm, Semi-auto, 12/24 rounds, Long barrel, No autosear, Damage +1
/obj/item/gun/ballistic/automatic/m1carbine/m1n
	name = "m1/n carbine"
	desc = "An M1 Carbine with markings identifying it as issued to the NCR Mojave Expedtionary Force. Looks beat up but functional."
	can_automatic = FALSE
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/battle_rifle.dmi'
	icon_state = "ncr-m1carbine"
	base_icon_state = "rifle"
	extra_damage = 3


//M1A1 Carbine				Keywords: 10mm, Semi-auto, 12/24 rounds, Long barrel, Folding stock.
/obj/item/gun/ballistic/automatic/m1carbine/compact
	name = "m1a1 carbine"
	desc = "The M1A1 carbine is an improvement of the original, with this particular model having a folding stock allowing for greater mobility. Chambered in 10mm."
	icon_state = "m1a1carbine"
	var/stock = FALSE
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/ballistic/automatic/m1carbine/compact/AltClick(mob/user)
	if(user.canUseTopic(src, USE_CLOSE|USE_DEXTERITY))
		return
	toggle_stock(user)

/obj/item/gun/ballistic/automatic/m1carbine/compact/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to toggle the stock.</span>"

/obj/item/gun/ballistic/automatic/m1carbine/compact/proc/toggle_stock(mob/living/user)
	stock = !stock
	if(stock)
		w_class = WEIGHT_CLASS_BULKY
		to_chat(user, "You unfold the stock.")
		spread = 2
	else
		w_class = WEIGHT_CLASS_NORMAL
		to_chat(user, "You fold the stock.")
		recoil = 0.5
		spread = 5
	update_icon()

/obj/item/gun/ballistic/automatic/m1carbine/compact/update_icon_state()
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"][stock ? "" : "-f"]"



////////////////////
//SEMI-AUTO RIFLES//
////////////////////


//Varmint rifle								Keywords: 5.56, 10/20/30 round magazine, Reduced damage
/obj/item/gun/ballistic/automatic/varmint
	name = "varmint rifle"
	desc = "A simple bolt action rifle in 5.56mm calibre. Easy to use and maintain."
	icon_state = "varmint"
	base_icon_state = "varmintrifle"
	force = 15
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	init_mag_type = /obj/item/ammo_box/magazine/m556/rifle/small
	fire_delay = 5
	burst_size = 1
	spread = 0
	extra_damage = -3
	extra_penetration = -3
	can_bayonet = FALSE
	semi_auto = TRUE
	automatic_burst_overlay = FALSE
	scope_state = "scope_short"
	scope_x_offset = 4
	scope_y_offset = 12
	can_suppress = TRUE
	suppressor_state = "rifle_suppressor"
	suppressor_x_offset = 27
	suppressor_y_offset = 31
	fire_sound = 'modular_fallout/master_files/sound/weapons/varmint_rifle.ogg'

//De Lisle carbine							Keywords: Pre-war, 9mm, Long barrel, Suppressed
/obj/item/gun/ballistic/automatic/delisle
	name = "De Lisle carbine"
	desc = "A integrally suppressed carbine, known for being one of the quietest firearms ever made. Chambered in 9mm."
	icon_state = "delisle"
	base_icon_state = "varmintrifle"
	mag_type = /obj/item/ammo_box/magazine/m9mmds
	extra_damage = 5
	extra_penetration = 10
	fire_delay = 5
	burst_size = 1
	spread = 0
	can_scope = FALSE
	can_unsuppress = FALSE
	suppressed = 1
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot_large_silenced.ogg'

//Commando carbine (BoS De Lisle variant)							Keywords: BoS, .45 ACP, 12 round magazine, Long barrel, Suppressed
/obj/item/gun/ballistic/automatic/delisle/commando
	name = "commando carbine"
	desc = "A integrally suppressed carbine, known for being one of the quietest firearms ever made. This modified version is often used by the Brotherhood of Steel. Its stock has been replaced by post-war polymer furniture, with space to mount a scope. Chambered in .45 ACP."
	icon_state = "commando"
	base_icon_state = "commando"
	mag_type = /obj/item/ammo_box/magazine/m45exp
	can_scope = TRUE
	semi_auto = TRUE
	automatic_burst_overlay = FALSE
	scope_state = "scope_medium"
	scope_x_offset = 6
	scope_y_offset = 14

//Ratslayer									Keywords: UNIQUE, 5.56, 10/20/30 round magazine, Suppressed, Scoped, Extra damage +3
/obj/item/gun/ballistic/automatic/varmint/ratslayer
	name = "Ratslayer"
	desc = "A modified varmint rifle with better stopping power, a scope, and suppressor. Oh, don't forget the sick paint job."
	icon_state = "ratslayer"
	base_icon_state = "ratslayer"
	extra_damage = 7
	extra_penetration = 7
	extra_speed = 200
	recoil = 0.1
	spread = 0
	suppressed = 1
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	can_scope = FALSE
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot_large_silenced.ogg'

//Service rifle			Keywords: NCR, 5.56mm, Semi-auto, 20 (10-50) round magazine
/obj/item/gun/ballistic/automatic/service
	name = "service rifle"
	desc = "A 5.56x45 semi-automatic service rifle with a trimmed barrel, manufactured by the NCR and issued to all combat personnel."
	icon_state = "service_rifle"
	base_icon_state = "servicerifle"
	extra_damage = -3
	extra_penetration = -5
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	fire_delay = 3
	burst_size = 1
	spread = 1
	can_attachments = TRUE
	automatic_burst_overlay = FALSE
	semi_auto = TRUE
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 22
	knife_y_offset = 21
	fire_sound = 'modular_fallout/master_files/sound/weapons/varmint_rifle.ogg'

//ALR15			Keywords: Donor, 5.56mm, Semi-auto
/obj/item/gun/ballistic/automatic/service/alr
	name = "ALR15"
	desc = "A 5.56x45mm rifle custom built off of a reproduction model AR15-style weapon. Sports a fancy holographic sight picture, forward grip, and a comfortable synthetic thumbhole stock. Bang bang."
	icon_state = "alr15"
	base_icon_state = "alr15"
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	fire_delay = 3
	burst_size = 2
	spread = 0.5
	can_attachments = FALSE
	automatic_burst_overlay = FALSE
	semi_auto = TRUE
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 22
	knife_y_offset = 21
	fire_sound = 'modular_fallout/master_files/sound/weapons/varmint_rifle.ogg'


//Scout carbine			Keywords: NCR, 5.56mm, Semi-auto, 20 (10-50) round magazine. Special modifiers: spread -1
/obj/item/gun/ballistic/automatic/service/carbine
	name = "scout carbine"
	desc = "A cut down version of the standard-issue service rifle tapped with mounting holes for a scope. Shorter barrel, lower muzzle velocity."
	icon_state = "scout_carbine"
	extra_damage = -5
	extra_penetration = -7
	fire_delay = 2.5
	spread = 1
	can_scope = TRUE
	scope_state = "scope_short"
	scope_x_offset = 4
	scope_y_offset = 15
	suppressor_x_offset = 26
	suppressor_y_offset = 28


//Police rifle			Keywords: OASIS, 5.56mm, Semi-auto, 20 (10-50) round magazine
/obj/item/gun/ballistic/automatic/marksman/policerifle
	name = "Police Rifle"
	desc = "A pre-war Rifle that has been constantly repaired and rebuilt by the Oasis Police Department. Held together by duct tape and prayers, it somehow still shoots."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/assault_rifle.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "rifle-police"
	base_icon_state = "assault_carbine"
	init_mag_type = /obj/item/ammo_box/magazine/m556/rifle
	extra_damage = -3
	spread = 1.1
	fire_delay = 4.2
	can_suppress = FALSE
	can_scope = TRUE
	zoomable = FALSE


//Marksman carbine			Keywords: 5.56mm, Semi-auto, 20 (10-50) round magazine, Small scope
/obj/item/gun/ballistic/automatic/marksman
	name = "marksman carbine"
	desc = "A marksman carbine built off the AR platform chambered in 5.56x45. Seen heavy usage in pre-war conflicts. This particular model is a civilian version and is semi-auto only."
	icon_state = "marksman_rifle"
	base_icon_state = "marksman"
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	fire_delay = 4
	extra_penetration = 5
	extra_damage = 5
	extra_speed = 100
	burst_size = 1
	spread = 1
	can_attachments = TRUE
	semi_auto = TRUE
	automatic_burst_overlay = FALSE
	can_scope = FALSE
	zoomable = TRUE
	zoom_amt = 6
	zoom_out_amt = 9
	can_bayonet = FALSE
	bayonet_state = "rifles"
	knife_x_offset = 22
	knife_y_offset = 12
	can_suppress = TRUE
	suppressor_state = "suppressor"
	suppressor_x_offset = 31
	suppressor_y_offset = 15
	fire_sound = 'modular_fallout/master_files/sound/weapons/marksman_rifle.ogg'


//Colt Rangemaster				Keywords: 7.62mm, Semi-auto, 10/20 round magazine
/obj/item/gun/ballistic/automatic/rangemaster
	name = "Colt Rangemaster"
	desc = "A Colt Rangemaster semi-automatic rifle, chambered for 7.62x51. Single-shot only."
	icon_state = "rangemaster"
	base_icon_state = "308"
	force = 20
	mag_type = /obj/item/ammo_box/magazine/m762
	burst_size = 1
	fire_delay = 5
	spread = 1
	automatic_burst_overlay = FALSE
	semi_auto = TRUE
	can_attachments = TRUE
	can_scope = TRUE
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 24
	knife_y_offset = 21
	scope_state = "scope_long"
	scope_x_offset = 4
	scope_y_offset = 11
	fire_sound = 'modular_fallout/master_files/sound/weapons/hunting_rifle.ogg'


// Enfield SLR				Keywords: 7.62mm, Semi-auto, 10/20 round magazine
/obj/item/gun/ballistic/automatic/slr
	name = "Enfield SLR"
	desc = "A self-loading rifle in 7.62mm NATO. Semi-auto only."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/assault_rifle.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "slr"
	base_icon_state = "slr"
	force = 20
	mag_type = /obj/item/ammo_box/magazine/m762
	burst_size = 1
	fire_delay = 5
	spread = 1
	automatic_burst_overlay = FALSE
	semi_auto = TRUE
	can_attachments = TRUE
	can_scope = TRUE
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 24
	knife_y_offset = 21
	scope_state = "scope_long"
	scope_x_offset = 4
	scope_y_offset = 11
	fire_sound = 'modular_fallout/master_files/sound/weapons/hunting_rifle.ogg'


//M1 Garand					Keywords: .308, Semi-auto, 8 rounds internal
/obj/item/gun/ballistic/automatic/m1garand
	name = "M1 Garand"
	desc = "The WWII American Classic. Still has that satisfiying ping."
	icon_state = "m1garand"
	base_icon_state = "rifle"
	force = 20
	mag_type = /obj/item/ammo_box/magazine/garand308
	fire_delay = 5.5
	burst_size = 1
	spread = 1
	en_bloc = 1
	auto_eject = 1
	semi_auto = TRUE
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 22
	knife_y_offset = 21
	can_scope = TRUE
	scope_state = "scope_long"
	scope_x_offset = 5
	scope_y_offset = 14
	auto_eject_sound = 'modular_fallout/master_files/sound/weapons/garand_ping.ogg'
	fire_sound = 'modular_fallout/master_files/sound/weapons/hunting_rifle.ogg'

/obj/item/gun/ballistic/automatic/m1garand/update_icon()
	..()
	icon_state = "[initial(icon_state)]"

/obj/item/gun/ballistic/automatic/m1garand/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(.)
		return

//Old Glory					Keywords: UNIQUE, .308, Semi-auto, 8 rounds internal, Damage +10
/obj/item/gun/ballistic/automatic/m1garand/oldglory
	name = "Old Glory"
	desc = "This Machine kills communists!"
	icon_state = "oldglory"
	extra_damage = 10

//Republics Pride			Keywords: UNIQUE, 7.62mm, Semi-auto, 8 rounds internal, Scoped, Damage +8, Penetration +0.1
/obj/item/gun/ballistic/automatic/m1garand/republicspride
	name = "Republic's Pride"
	desc = "A well-tuned scoped M1C rifle crafted by master gunsmith from the Gunrunners. Chambered in 7.62x51."
	icon_state = "republics_pride"
	base_icon_state = "scoped308"
	extra_damage = 5
	extra_penetration = 5
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	can_scope = FALSE


//SKS				Keywords: LEGION, .308, Semi-auto, 10 rounds internal
/obj/item/gun/ballistic/automatic/m1garand/sks
	name = "SKS"
	desc = "Old hunting rifle taken from disovered stockpiles and refurbished in Phoenix workshops. The standard heavy rifle of the Legion, still rare. .308, semi-auto only, internal magazine."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/assault_rifle.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "sks"
	base_icon_state = "sks"
	mag_type = /obj/item/ammo_box/magazine/sks
	fire_delay = 5
	bayonet_state = "bayonet"
	knife_x_offset = 24
	knife_y_offset = 23
	scope_state = "scope_mosin"
	scope_x_offset = 4
	scope_y_offset = 12
	auto_eject_sound = 'modular_fallout/master_files/sound/weapons/magout.ogg'
	fire_sound = 'modular_fallout/master_files/sound/weapons/hunting_rifle.ogg'


//DKS 501 sniper rifle				Keywords: .308, Semi-auto, 7 round magazine, Scoped, Extra speed +500, Fire delay +1
/obj/item/gun/ballistic/automatic/marksman/sniper
	name = "sniper rifle"
	desc = "A DKS 501, chambered in .308 Winchester.  With a light polymer body, it's suited for long treks through the desert."
	icon_state = "sniper_rifle"
	base_icon_state = "sniper_rifle"
	mag_type = /obj/item/ammo_box/magazine/w308
	fire_delay = 7
	recoil = 0.35
	burst_size = 1
	extra_speed = 200
	extra_penetration = 5
	extra_damage = 5
	zoom_amt = 10
	zoom_out_amt = 13
	semi_auto = TRUE
	can_automatic = FALSE
	can_bayonet = FALSE
	fire_sound = 'modular_fallout/master_files/sound/weapons/hunting_rifle.ogg'

/obj/item/gun/ballistic/automatic/marksman/sniper/gold
	name = "golden sniper rifle"
	desc = "A DKS 501, chambered in .308 Winchester. This one has a gold trim and the words 'Old Cassius' engraved into the stock."
	icon_state = "gold_sniper"
	base_icon_state = "gold_sniper"



//////////////////
//ASSAULT RIFLES//
//////////////////


//R82				Keywords: 5.56mm, Semi-auto, 20 (10-50) round magazine	NOT CANON
/obj/item/gun/ballistic/automatic/service/r82
	name = "R82 heavy service rifle"
	desc = "The assault rifle variant of the R84, based off the pre-war FN FNC. Issued to high-ranking troopers and specialized units. Chambered in 5.56."
	icon_state = "R82"
	base_icon_state = "R84"
	fire_delay = 2
	recoil = 0.1
	extra_damage = 3
	extra_penetration = 3
	extra_speed = 100
	can_suppress = TRUE
	suppressor_state = "rifle_suppressor"
	suppressor_x_offset = 27
	suppressor_y_offset = 28


//R91 assault rifle				Keywords: 5.56mm, Automatic, 20 (10-50) round magazine
/obj/item/gun/ballistic/automatic/assault_rifle
	name = "r91 assault rifle"
	desc = "The R91 was the standard US Army assault rifle, and so saw wide-spread use after the war. Most are worn out by now."
	icon_state = "assault_rifle"
	base_icon_state = "fnfal"
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	fire_delay = 3
	spread = 3
	recoil = 0.1
	can_attachments = TRUE
	can_bayonet = FALSE
	bayonet_state = "rifles"
	knife_x_offset = 23
	knife_y_offset = 11
	can_suppress = TRUE
	suppressor_x_offset = 32
	suppressor_y_offset = 15
	suppressor_state = "ar_suppressor"
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/varmint_rifle.ogg'


//Infiltrator			Keywords: 5.56mm, Automatic, 20 (10-50) round magazine, Suppressed, Small scope, Damage -1, Pistol grip
/obj/item/gun/ballistic/automatic/assault_rifle/infiltrator
	name = "infiltrator"
	desc = "A customized R91 assault rifle, with an integrated suppressor, small scope, shortened barrel, cut down stock and polymer furniture."
	icon_state = "infiltrator"
	base_icon_state = "fnfal"
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	extra_damage = -5
	extra_penetration = -5
	spread = 9
	fire_delay = 2
	burst_shot_delay = 2
	recoil = 0.6
	can_suppress = FALSE
	can_unsuppress = FALSE
	suppressed = 1
	can_bayonet = FALSE
	can_scope = FALSE
	zoomable = TRUE
	zoom_amt = 6
	zoom_out_amt = 9
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot_large_silenced.ogg'


//R93 PDW		Keywords: 5.56mm, Semi-Automatic, 20 (10-50) round magazine, Pistol grip
/obj/item/gun/ballistic/automatic/r93
	name = "R93 PDW"
	desc = "A lightweight assault rifle manufactured by the Brotherhood of Steel with a folding stock, based on weapons from the R-series platforms. It is generally issued to Brotherhood Knights for scouting missions."
	icon_state = "r93"
	base_icon_state = "r93"
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	extra_damage = -5
	extra_penetration = -5
	fire_delay = 3.25
	spread = 1
	can_attachments = FALSE
	semi_auto = TRUE
	automatic_burst_overlay = FALSE
	can_scope = FALSE
	zoomable = TRUE
	zoom_amt = 6
	zoom_out_amt = 9
	can_bayonet = FALSE
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/Gunshot_large_silenced.ogg'


/obj/item/gun/ballistic/automatic/r93/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 8
			fire_delay = 3.75
			recoil = 0.1
			weapon_weight = WEAPON_HEAVY
			to_chat(user, "<span class='notice'>You switch to 2-rnd burst.</span>")
			enable_burst()
		if(1)
			select = 0
			burst_size = 1
			fire_delay = 3.25
			spread = 1
			weapon_weight = WEAPON_MEDIUM
			to_chat(user, "<span class='notice'>You switch to semi-auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return


//Type 93 Chinese rifle				Keywords: 5.56mm, Automatic, 20 (10-50) round magazine
/obj/item/gun/ballistic/automatic/type93
	name = "type 93 assault rifle"
	desc = "The Type 93 Chinese assault rifle was designed and manufactured by a Chinese industrial conglomerate for the People's Liberation Army during the Resource Wars, for the purpose of equipping the Chinese infiltrators and American fifth-columnists. Chambered in 5.56x45."
	icon_state = "type93"
	base_icon_state = "handmade_rifle"
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	fire_delay = 4
	spread = 10
	recoil = 0.1
	can_suppress = TRUE
	suppressor_state = "rifle_suppressor"
	suppressor_x_offset = 27
	suppressor_y_offset = 27
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/assaultrifle_fire.ogg'

/obj/item/gun/ballistic/automatic/type93/worn
	name = "\improper Worn Type 56"
	desc = "The original Type 56 was a copy of the Soviet AKM, and this is a copy of that copy produced in a garage. The bore is shot to hell, the threading is destroyed, but atleast it works."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/assault_rifle.dmi'
	icon_state = "type93"
	base_icon_state = "handmade_rifle"
	fire_delay = 5
	spread = 13
	extra_damage = -3
	can_suppress = FALSE


//Bozar					Keywords: 5.56mm, Automatic, 20 (10-50) round magazine
/obj/item/gun/ballistic/automatic/bozar
	name = "Bozar"
	desc = "The ultimate refinement of the sniper's art, the Bozar is a scoped, accurate, light machine gun that will make nice big holes in your enemy. Uses 5.56."
	icon_state = "bozar"
	base_icon_state = "sniper"
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	burst_size = 3
	burst_shot_delay = 1.5
	fire_delay = 2
	spread = 2
	recoil = 0.1
	can_attachments = FALSE
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	can_scope = FALSE
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/bozar_fire.ogg'


//Assault Carbine				Keywords: 5.56mm, Automatic, 20 (10-50) round magazine, Flashlight
/obj/item/gun/ballistic/automatic/assault_carbine
	name = "assault carbine"
	desc = "The U.S. army carbine version of the R91, made by Colt and issued to special forces."
	icon_state = "assault_carbine"
	base_icon_state = "assault_carbine"
	extra_damage = -3
	extra_penetration = -5
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	fire_delay = 3
	burst_shot_delay = 2.5
	spread = 7
	recoil = 0.1
	can_attachments = TRUE
	can_scope = TRUE
	scope_state = "scope_short"
	scope_x_offset = 4
	scope_y_offset = 15
	can_suppress = TRUE
	suppressor_state = "rifle_suppressor"
	suppressor_x_offset = 26
	suppressor_y_offset = 28
	can_flashlight = TRUE
	gunlight_state = "flightangle"
	flight_x_offset = 21
	flight_y_offset = 21
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/assault_carbine.ogg'


//FN-FAL				Keywords: 7.62mm, Automatic, 10/20 round magazine NOT CANON
/obj/item/gun/ballistic/automatic/fnfal
	name = "FN FAL"
	desc = "This rifle has been more widely used by armed forces than any other rifle in history. It's a reliable assault weapon for any terrain or tactical situation."
	icon_state = "fnfal"
	base_icon_state = "fnfal"
	force = 20
	fire_delay = 3.5
	mag_type = /obj/item/ammo_box/magazine/m762
	spread = 12
	fire_delay = 4
	recoil = 0.25
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/assaultrifle_fire.ogg'


//H&K G11				Keywords: 4.73mm, Automatic, 50 round magazine
/obj/item/gun/ballistic/automatic/g11
	name = "g11"
	desc = "This experimental german gun fires a caseless cartridge consisting of a block of propellant with a bullet buried inside. The weight and space savings allows for a very high magazine capacity. Chambered in 4.73mm."
	icon_state = "g11"
	base_icon_state = "g11"
	mag_type = /obj/item/ammo_box/magazine/m473
	extra_damage = 5
	fire_delay = 2.5
	burst_shot_delay = 1.5
	can_attachments = TRUE
	can_automatic = TRUE
	semi_auto = TRUE
	can_scope = FALSE
	spread = 8
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13



////////////////
//MACHINE-GUNS//
////////////////


//R84 Light machinegun				Keywords: NCR, 5.56mm, Automatic, 60 rounds
/obj/item/gun/ballistic/automatic/r84
	name = "R84 LMG"
	desc = "A light machinegun using 60 round belts fed from an ammobox, its one of the few heavy weapons designs NCR has produced."
	icon_state = "R84"
	base_icon_state = "R84"
	slowdown = 1
	mag_type = /obj/item/ammo_box/magazine/lmg
	burst_size = 1
	fire_delay = 6
	burst_shot_delay = 2.5
	can_attachments = FALSE
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/assaultrifle_fire.ogg'

/obj/item/gun/ballistic/automatic/r84/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 8
			recoil = 0.25
			to_chat(user, "<span class='notice'>You switch to burst fire.</span>")
		if(1)
			select = 0
			burst_size = 5
			spread = 14
			recoil = 0.75
			to_chat(user, "<span class='notice'>You switch to full auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return


//LSW squad support weapon				Keywords: 5.56mm, Automatic, 20 (10-50) round magazine, Scoped, Damage decrease (bullethose)
/obj/item/gun/ballistic/automatic/lsw
	name = "LSW (Light Support Weapon)"
	desc = "This squad-level support weapon has a bullpup design. The bullpup design makes it difficult to use while lying down. Because of this it was remanded to National Guard units. It, however, earned a reputation as a reliable weapon that packs a lot of punch for its size."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ballistic/assault_rifle.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "lsw"
	base_icon_state = "lsw"
	slowdown = 1
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	fire_delay = 4.5
	burst_shot_delay = 2.25
	spread = 12
	spawnwithmagazine = TRUE
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	can_attachments = TRUE
	can_scope = FALSE
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/assaultrifle_fire.ogg'

/obj/item/gun/ballistic/automatic/lsw/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 10
			extra_damage = -3
			recoil = 0.25
			to_chat(user, "<span class='notice'>You switch to burst fire.</span>")
		if(1)
			select = 0
			burst_size = 4
			spread = 14
			extra_damage = -6
			recoil = 0.5
			to_chat(user, "<span class='notice'>You switch to full auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return


//M1919 Machinegun				Keywords: LEGION, .308, Automatic, 80 round belt.
/obj/item/gun/ballistic/automatic/m1919
	name = "Browning M1919"
	desc = "This ancient machine gun has been dug up and put into working order by the Legion Forgemasters. It's loud, heavy and terrifying."
	icon_state = "M38"
	base_icon_state = "M38"
	slot_flags = 0
	slowdown = 1.25
	mag_type = /obj/item/ammo_box/magazine/mm762
	burst_size = 1
	burst_shot_delay = 1.5
	fire_delay = 4
	spread = 8
	can_attachments = FALSE
	var/cover_open = FALSE
	var/require_twohands = FALSE
	actions_types = list(/datum/action/item_action/toggle_firemode)
	fire_sound = 'modular_fallout/master_files/sound/weapons/assaultrifle_fire.ogg'

/obj/item/gun/ballistic/automatic/m1919/update_icon()
	icon_state = "M38[cover_open ? "open" : "closed"][magazine ? CEILING(get_ammo(0)/20, 1)*20 : "-empty"]"
	base_icon_state = "M38[cover_open ? "open" : "closed"][magazine ? "mag" : "nomag"]"

/obj/item/gun/ballistic/automatic/m1919/examine(mob/user)
	. = ..()
	if(cover_open && magazine)
		. += "<span class='notice'>It seems like you could use an <b>empty hand</b> to remove the magazine.</span>"

/obj/item/gun/ballistic/automatic/m1919/attack_self(mob/user)
	cover_open = !cover_open
	to_chat(user, "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>")
	if(cover_open)
		playsound(user, 'modular_fallout/master_files/sound/weapons/sawopen.ogg', 60, 1)
	else
		playsound(user, 'modular_fallout/master_files/sound/weapons/sawclose.ogg', 60, 1)
	update_icon()

/obj/item/gun/ballistic/automatic/m1919/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params) //what I tried to do here is just add a check to see if the cover is open or not and add an icon_state change because I can't figure out how c-20rs do it with overlays
	if(cover_open)
		to_chat(user, "<span class='warning'>[src]'s cover is open! Close it before firing!</span>")
	else
		. = ..()
		update_icon()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/gun/ballistic/automatic/m1919/attack_hand(mob/user, list/modifiers)
	if (loc != user)
		..()
		return
	if (!cover_open)
		to_chat(user, span_warning("[src]'s cover is closed! Open it before trying to remove the magazine!"))
		return
	..()

/obj/item/gun/ballistic/automatic/m1919/attackby(obj/item/A, mob/user, params)
	if(!cover_open && istype(A, mag_type))
		to_chat(user, "<span class='warning'>[src]'s cover is closed! You can't insert a new mag.</span>")
		return
	..()

/obj/item/gun/ballistic/automatic/m1919/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 8
			recoil = 0.25
			to_chat(user, "<span class='notice'>You switch to burst fire.</span>")
		if(1)
			select = 0
			burst_size = 4
			spread = 14
			recoil = 0.5
			to_chat(user, "<span class='notice'>You switch to full auto.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return



////////
//MISC//
////////

//M72 Gauss rifle
/obj/item/gun/ballistic/automatic/m72
	name = "\improper M72 gauss rifle"
	desc = "The M72 rifle is of German design. It uses an electromagnetic field to propel rounds at tremendous speed... and pierce almost any obstacle. Its range, accuracy and stopping power is almost unparalleled."
	icon_state = "m72"
	base_icon_state = "sniper"
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/m2mm
	burst_size = 1
	fire_delay = 12
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	recoil = 2
	semi_auto = TRUE
	fire_sound = 'modular_fallout/master_files/sound/weapons/gauss_rifle.ogg'

/obj/item/gun/ballistic/automatic/xl70e3
	name = "xl70e3"
	desc = "This was an experimental weapon at the time of the war. Manufactured, primarily, from high-strength polymers, the weapon is almost indestructible. It's light, fast firing, accurate, and can be broken down without the use of any tools. Chamebered in 5.56mm."
	icon_state = "xl70e3"
	base_icon_state = "xl70e3"
	mag_type = /obj/item/ammo_box/magazine/m556/rifle
	fire_delay = 2
	burst_shot_delay = 2
	spawnwithmagazine = TRUE
	spread = 4
	can_attachments = TRUE
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	can_scope = FALSE

// BETA STUFF // =Obsolete
/obj/item/gun/ballistic/automatic/smgtesting
	name = "SMG"
	mag_type = /obj/item/ammo_box/magazine/testbullet
	extra_damage = 20

/obj/item/gun/ballistic/automatic/snipertesting
	name = "sniper rifle"
	mag_type = /obj/item/ammo_box/magazine/testbullet
	extra_damage = 25

/obj/item/gun/ballistic/automatic/rifletesting
	name = "rifle"
	mag_type = /obj/item/ammo_box/magazine/testbullet
	extra_damage = 22
