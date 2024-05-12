/obj/item/ammo_box/magazine/wt550m9
	name = "20-round magazine (4.6x30mm)"
	icon_state = "46x30mmt-20"
	base_icon_state = "46x30mmt"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	caliber = CALIBER_46X30MM
	max_ammo = 20

/obj/item/ammo_box/magazine/wt550m9/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 4)]"

/obj/item/ammo_box/magazine/wt550m9/wtap
	name = "20-round magazine (4.6x30mm armor piercing)"
	icon_state = "46x30mmtA-20"
	base_icon_state = "46x30mmtA"
	ammo_type = /obj/item/ammo_casing/c46x30mm/ap

/obj/item/ammo_box/magazine/wt550m9/wtap/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 4)]"

/obj/item/ammo_box/magazine/wt550m9/wtic
	name = "20-round magazine (4.6x30mm incendiary)"
	icon_state = "46x30mmtI-20"
	base_icon_state = "46x30mmtI"
	ammo_type = /obj/item/ammo_casing/c46x30mm/inc

/obj/item/ammo_box/magazine/wt550m9/wtic/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 4)]"

/obj/item/ammo_box/magazine/plastikov9mm
	name = "50-round magazine (9x19mm)"
	icon_state = "9x19-50"
	base_icon_state = "9x19"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 50

/obj/item/ammo_box/magazine/plastikov9mm/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[ammo_count() ? 50 : 0]"

/obj/item/ammo_box/magazine/uzim9mm
	name = "32-round magazine (9x19mm)"
	icon_state = "uzi9mm-32"
	base_icon_state = "uzi9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 32

/obj/item/ammo_box/magazine/uzim9mm/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 4)]"

/obj/item/ammo_box/magazine/smgm9mm
	name = "21-round magazine (9x19mm)"
	icon_state = "smg9mm-42"
	base_icon_state = "smg9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 21

/obj/item/ammo_box/magazine/smgm9mm/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[ammo_count() ? 42 : 0]"

/obj/item/ammo_box/magazine/smgm9mm/ap
	name = "21-round magazine (9x19mm armor piercing)"
	ammo_type = /obj/item/ammo_casing/c9mm/ap

/obj/item/ammo_box/magazine/smgm9mm/fire
	name = "21-round magazine (9x19mm incendiary)"
	ammo_type = /obj/item/ammo_casing/c9mm/fire

/obj/item/ammo_box/magazine/smgm45
	name = "24-round magazine (.45 ACP)"
	icon_state = "c20r45-24"
	base_icon_state = "c20r45"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = CALIBER_45
	max_ammo = 24

/obj/item/ammo_box/magazine/smgm45/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 2)]"

/obj/item/ammo_box/magazine/smgm45/ap
	name = "24-round magazine (.45 ACP armor piercing)"
	ammo_type = /obj/item/ammo_casing/c45/ap

/obj/item/ammo_box/magazine/smgm45/incen
	name = "24-round magazine (.45 ACP incendiary)"
	ammo_type = /obj/item/ammo_casing/c45/inc

/obj/item/ammo_box/magazine/tommygunm45
	name = "50-round drum magazine (.45 ACP)"
	icon_state = "drum45"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = CALIBER_45
	max_ammo = 50
