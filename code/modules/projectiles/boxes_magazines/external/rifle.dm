/obj/item/ammo_box/magazine/m10mm/rifle
	name = "10-round magazine (10mm Auto)"
	desc = "A well-worn magazine fitted for the surplus rifle."
	icon_state = "75-8"
	base_icon_state = "75"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 10

/obj/item/ammo_box/magazine/m10mm/rifle/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[ammo_count() ? "8" : "0"]"

/obj/item/ammo_box/magazine/m556
	name = "30-round magazine (5.56x45mm)"
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/a556
	caliber = CALIBER_A556
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/m556/phasic
	name = "30-round magazine (5.56x45mm phasic)"
	ammo_type = /obj/item/ammo_casing/a556/phasic
