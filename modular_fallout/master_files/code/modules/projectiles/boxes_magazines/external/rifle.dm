/*
---Fallout 13---
*/

/obj/item/ammo_box/magazine/autopipe
	name = "pipe rifle ammo belt (.357)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "autopipe_belt"
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 18
	multiple_sprites = 2

/obj/item/ammo_box/magazine/autopipe/empty
	start_empty = 1

/obj/item/ammo_box/magazine/autopipe/update_icon()
	..()
	icon_state = "autopipe_belt-[round(ammo_count(),9)]"

/obj/item/ammo_box/magazine/m556/rifle
	name = "rifle magazine (5.56mm)"
	icon_state = "r20"
	caliber = "a556"
	max_ammo = 20
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m556/rifle/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m556/rifle/small
	name = "small rifle magazine (5.56mm)"
	icon_state = "r10"
	max_ammo = 10

/obj/item/ammo_box/magazine/m556/rifle/small/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m556/rifle/assault
	name = "rifle magazine (5.56mm)"
	icon_state = "r30"
	max_ammo = 30

/obj/item/ammo_box/magazine/m556/rifle/assault/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m556/rifle/extended
	name = "extended rifle magazine (5.56mm)"
	icon_state = "r50"
	max_ammo = 50

/obj/item/ammo_box/magazine/m556/rifle/extended/empty
	start_empty = 1

/obj/item/ammo_box/magazine/garand308
	name = "en-bloc clip (7.62x51mm)"
	icon_state = "enbloc-8"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	max_ammo = 8


/obj/item/ammo_box/magazine/garand308/update_icon()
	..()
	if (ammo_count() >= 8)
		icon_state = "enbloc-8"
	else
		icon_state = "enbloc-[ammo_count()]"

/obj/item/ammo_box/magazine/garand308/empty
	start_empty = 1

/obj/item/ammo_box/magazine/sks
	name = "7.62mm clip (SKS)"
	icon_state = "enbloc-10"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	max_ammo = 10

/obj/item/ammo_box/magazine/sks/update_icon()
	..()
	if (ammo_count() >= 10)
		icon_state = "enbloc-10"
	else
		icon_state = "enbloc-[ammo_count()]"

/obj/item/ammo_box/magazine/sks/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m762
	name = "rifle magazine (7.62x51)"
	icon_state = "mag308"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	max_ammo = 10
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m762/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m762/ext
	name = "extended rifle magazine (7.62x51)"
	icon_state = "extmag308"
	max_ammo = 20
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m762/ext/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m473
	name = "g11 magazine (4.73mm)"
	icon_state = "473mm"
	caliber = "473mm"
	ammo_type = /obj/item/ammo_casing/caseless/g11
	max_ammo = 50
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m473/explosive
	name = "g11 magazine (4.73mm explosive)"
	icon_state = "473mm"
	caliber = "473mm"
	ammo_type = /obj/item/ammo_casing/caseless/g11/explosive
	max_ammo = 50
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m473/empty
	start_empty = 1
