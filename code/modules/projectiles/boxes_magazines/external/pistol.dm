/obj/item/ammo_box/magazine/m10mm
	name = "8-round pistol magazine (10mm Auto)"
	desc = "A gun magazine."
	icon_state = "9x19p"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = CALIBER_10MM
	max_ammo = 8
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/m45
	name = "8-round pistol magazine (.45 ACP)"
	icon_state = "45-8"
	base_icon_state = "45"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = CALIBER_45
	max_ammo = 8

/obj/item/ammo_box/magazine/m45/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[min(ammo_count(), 8)]"

/obj/item/ammo_box/magazine/m9mm
	name = "8-round pistol magazine (9x19mm)"
	icon_state = "9x19p-8"
	base_icon_state = "9x19p"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 8

/obj/item/ammo_box/magazine/m9mm/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[ammo_count() ? "8" : "0"]"

/obj/item/ammo_box/magazine/m9mm/fire
	name = "8-round pistol magazine (9x19mm incendiary)"
	icon_state = "9x19pI"
	desc = "A gun magazine. Loaded with rounds which ignite the target."
	ammo_type = /obj/item/ammo_casing/c9mm/fire

/obj/item/ammo_box/magazine/m9mm/hp
	name = "8-round pistol magazine (9x19mm HP)"
	icon_state = "9x19pH"
	desc= "A gun magazine. Loaded with hollow-point rounds, extremely effective against unarmored targets, but nearly useless against protective clothing."
	ammo_type = /obj/item/ammo_casing/c9mm/hp

/obj/item/ammo_box/magazine/m9mm/ap
	name = "8-round pistol magazine (9x19mm AP)"
	icon_state = "9x19pA"
	desc= "A gun magazine. Loaded with rounds which penetrate armour, but are less effective against normal targets."
	ammo_type = /obj/item/ammo_casing/c9mm/ap

/obj/item/ammo_box/magazine/m9mm_aps
	name = "15-round pistol magazine (9x19mm)"
	icon_state = "9mmaps-15"
	base_icon_state = "9mmaps"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 15

/obj/item/ammo_box/magazine/m9mm_aps/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 5)]"

/obj/item/ammo_box/magazine/m9mm_aps/fire
	name = "15-round pistol magazine (9x19mm incendiary)"
	ammo_type = /obj/item/ammo_casing/c9mm/fire
	max_ammo = 15

/obj/item/ammo_box/magazine/m9mm_aps/hp
	name = "15-round pistol magazine (9x19mm HP)"
	ammo_type = /obj/item/ammo_casing/c9mm/hp
	max_ammo = 15

/obj/item/ammo_box/magazine/m9mm_aps/ap
	name = "15-round pistol magazine (9x19mm AP)"
	ammo_type = /obj/item/ammo_casing/c9mm/ap
	max_ammo = 15

/obj/item/ammo_box/magazine/m50
	name = "7-round pistol magazine (.50 AE)"
	icon_state = "50ae"
	ammo_type = /obj/item/ammo_casing/a50ae
	caliber = CALIBER_50_PISTOL
	max_ammo = 7
	multiple_sprites = AMMO_BOX_PER_BULLET
