// Grease Gun //
/*
/obj/item/gun/ballistic/automatic/smg/greasegun/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m45
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/low
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/greasegun/mid
	name = "enhanced m3a1 grease gun"

/obj/item/gun/ballistic/automatic/smg/greasegun/mid/enable_burst()
	. = ..()
	spread = 7.5

/obj/item/gun/ballistic/automatic/smg/greasegun/mid/disable_burst()
	. = ..()
	spread = 0
/*
/obj/item/gun/ballistic/automatic/smg/greasegun/mid/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m45
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/mid
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/greasegun/high
	name = "advanced m3a1 grease gun"
	burst_size = 3
	fire_delay = 2
	burst_shot_delay = 2
	extra_penetration = 0.1
	extra_damage = 5

/obj/item/gun/ballistic/automatic/smg/greasegun/mid/enable_burst()
	. = ..()
	spread = 5

/obj/item/gun/ballistic/automatic/smg/greasegun/mid/disable_burst()
	. = ..()
	spread = 0

/*
/obj/item/gun/ballistic/automatic/smg/greasegun/high/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m45
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/high
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()

//10mm smg//
/obj/item/gun/ballistic/automatic/smg/smg10mm/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm10
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/low
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/smg10mm/mid
	name = "enhanced 10mm submachine gun"
	extra_penetration = 0
	extra_damage = 0

/obj/item/gun/ballistic/automatic/smg/smg10mm/mid/enable_burst()
	. = ..()
	spread = 13.5

/obj/item/gun/ballistic/automatic/smg/smg10mm/mid/disable_burst()
	. = ..()
	spread = 0

/*
/obj/item/gun/ballistic/automatic/smg/smg10mm/mid/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm10
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/mid
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/smg10mm/high
	name = "advanced 10mm submachine gun"
	burst_size = 3
	fire_delay = 2
	burst_shot_delay = 2
	extra_damage = 6
	extra_penetration = 0.12

/obj/item/gun/ballistic/automatic/smg/smg10mm/high/enable_burst()
	. = ..()
	spread = 9

/obj/item/gun/ballistic/automatic/smg/smg10mm/high/disable_burst()
	. = ..()
	spread = 0
/*
/obj/item/gun/ballistic/automatic/smg/smg10mm/high/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm10
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/high
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()

// PPSH-41 //
/obj/item/gun/ballistic/automatic/smg/ppsh/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm9
		var/obj/item/F = new /obj/item/prefabs/complex/stock/low
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/low
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/ppsh/mid
	name = "enhanced ppsh-41"
	fire_delay = 5
	extra_damage = -9
	extra_penetration = 0

/obj/item/gun/ballistic/automatic/smg/ppsh/mid/enable_burst()
	. = ..()
	spread = 15

/obj/item/gun/ballistic/automatic/smg/ppsh/mid/disable_burst()
	. = ..()
	spread = 0
/*
/obj/item/gun/ballistic/automatic/smg/ppsh/mid/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm9
		var/obj/item/F = new /obj/item/prefabs/complex/stock/low
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/mid
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/ppsh/high
	name = "advanced ppsh41"
	extra_damage = 0
	extra_penetration = 0.1

/obj/item/gun/ballistic/automatic/smg/ppsh/high/enable_burst()
	. = ..()
	spread = 10

/obj/item/gun/ballistic/automatic/smg/ppsh/high/disable_burst()
	. = ..()
	spread = 0
/*
/obj/item/gun/ballistic/automatic/smg/ppsh/high/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm9
		var/obj/item/F = new /obj/item/prefabs/complex/stock/low
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/high
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/ppsh/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 3
			spread = 28
			if (burst_improvement)
				burst_size = 4
			if (recoil_decrease)
				spread = 20
			to_chat(user, "<span class='notice'>You switch to [burst_size]-rnd burst.</span>")
		if(1)
			select = 0
			burst_size = 1
			spread = 10
			if (recoil_decrease)
				spread = 2
			to_chat(user, "<span class='notice'>You switch to semi-automatic.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return
/*
/obj/item/gun/ballistic/automatic/smg/mini_uzi/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm9
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/low
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
// UZI //
/obj/item/gun/ballistic/automatic/smg/mini_uzi/mid
	name = "enhanced uzi"
	fire_delay = 4
	extra_penetration = 0
	extra_damage = 0

/obj/item/gun/ballistic/automatic/smg/mini_uzi/mid/enable_burst()
	. = ..()
	spread = 7.5

/obj/item/gun/ballistic/automatic/smg/mini_uzi/mid/disable_burst()
	. = ..()
	spread = 0
/*
/obj/item/gun/ballistic/automatic/smg/mini_uzi/mid/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm9
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/mid
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/mini_uzi/high
	name = "advanced uzi"
	fire_delay = 3
	extra_damage = 5
	extra_penetration = 0.1

/obj/item/gun/ballistic/automatic/smg/mini_uzi/high/enable_burst()
	. = ..()
	spread = 5

/obj/item/gun/ballistic/automatic/smg/mini_uzi/high/disable_burst()
	. = ..()
	spread = 0
/*
/obj/item/gun/ballistic/automatic/smg/mini_uzi/high/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/mm9
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/high
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/smg/mini_uzi/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select += 1
			burst_size = 2
			spread = 18
			if (burst_improvement)
				burst_size = 3
			if (recoil_decrease)
				spread = 10
			to_chat(user, "<span class='notice'>You switch to [burst_size]-rnd burst.</span>")
		if(1)
			select = 0
			burst_size = 1
			spread = 1
			if (recoil_decrease)
				spread = 0
			to_chat(user, "<span class='notice'>You switch to semi-automatic.</span>")
	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return

// R91 //
/*
/obj/item/gun/ballistic/automatic/assault_rifle/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/high
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m556
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/low
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		var/obj/item/Z = new /obj/item/advanced_crafting_components/assembly
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		Z.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/assault_rifle/mid
	name = "enhanced r91 assault rifle"
	fire_delay = 3
	extra_penetration = 0
	extra_damage = 0
	burst_shot_delay = 2

/obj/item/gun/ballistic/automatic/assault_rifle/mid/enable_burst()
	. = ..()
	spread = 6

/obj/item/gun/ballistic/automatic/assault_rifle/mid/disable_burst()
	. = ..()
	spread = 0
/*
/obj/item/gun/ballistic/automatic/assault_rifle/mid/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m556
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/low
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		var/obj/item/Z = new /obj/item/advanced_crafting_components/assembly
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		Z.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/assault_rifle/high
	name = "advanced r91 assault rifle"
	fire_delay = 3
	extra_damage = 6
	extra_penetration = 0.12
	burst_shot_delay = 2
	burst_size = 3

/obj/item/gun/ballistic/automatic/assault_rifle/high/enable_burst()
	. = ..()
	spread = 6

/obj/item/gun/ballistic/automatic/assault_rifle/high/disable_burst()
	. = ..()
	spread = 0
/*
/obj/item/gun/ballistic/automatic/assault_rifle/high/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/auto
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m556
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/high
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		var/obj/item/Z = new /obj/item/advanced_crafting_components/assembly
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		Z.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/service/mid
	name = "service rifle (improved)"
	randomspread = 0
	fire_delay = 4
	extra_damage = 0
	extra_penetration = 0
/*
/obj/item/gun/ballistic/automatic/service/mid/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/simple
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m556
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/mid
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/service/high
	name = "service rifle (masterwork)"
	randomspread = 0
	fire_delay = 3
	extra_damage = 10
	extra_penetration = 0.2
	weapon_weight = WEAPON_LIGHT
/*
/obj/item/gun/ballistic/automatic/service/high/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/simple
		var/obj/item/D = new /obj/item/prefabs/complex/action/simple
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m556
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/high
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()

// Rangemaster //
/obj/item/gun/ballistic/automatic/rangemaster/scoped/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/high
		var/obj/item/D = new /obj/item/prefabs/complex/action/simple
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m762
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/low
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		var/obj/item/Z = new /obj/item/advanced_crafting_components/assembly
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		Z.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/rangemaster/scoped/mid
	name = "enhanced colt rangemaster"
	extra_penetration = 0
	extra_damage = 0
/*
/obj/item/gun/ballistic/automatic/rangemaster/scoped/mid/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/high
		var/obj/item/D = new /obj/item/prefabs/complex/action/simple
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m762
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/mid
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		var/obj/item/Z = new /obj/item/advanced_crafting_components/assembly
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		Z.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
/obj/item/gun/ballistic/automatic/rangemaster/scoped/high
	name = "advanced colt rangemaster"
	fire_delay = 4
	extra_penetration = 0.14
	extra_damage = 7
/*
/obj/item/gun/ballistic/automatic/rangemaster/scoped/high/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/screwdriver))
		var/obj/item/A = new /obj/item/prefabs/complex/screw
		var/obj/item/B = new /obj/item/prefabs/complex/trigger
		var/obj/item/C = new /obj/item/prefabs/complex/bolt/high
		var/obj/item/D = new /obj/item/prefabs/complex/action/simple
		var/obj/item/E = new /obj/item/prefabs/complex/barrel/m762
		var/obj/item/F = new /obj/item/prefabs/complex/stock/mid
		var/obj/item/G = new /obj/item/prefabs/complex/complexWeaponFrame/high
		var/obj/item/H = new /obj/item/advanced_crafting_components/receiver
		var/obj/item/Z = new /obj/item/advanced_crafting_components/assembly
		A.forceMove(usr.loc)
		B.forceMove(usr.loc)
		C.forceMove(usr.loc)
		D.forceMove(usr.loc)
		E.forceMove(usr.loc)
		F.forceMove(usr.loc)
		G.forceMove(usr.loc)
		H.forceMove(usr.loc)
		Z.forceMove(usr.loc)
		qdel(src)
		to_chat(usr,"You dissasemble the [src].")
	. = ..()
*/
