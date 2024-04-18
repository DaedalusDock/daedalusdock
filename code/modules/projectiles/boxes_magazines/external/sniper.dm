/obj/item/ammo_box/magazine/sniper_rounds
	name = "6-round magazine (.50 BMG)"
	icon_state = ".50mag"
	base_icon_state = ".50mag"
	ammo_type = /obj/item/ammo_casing/p50
	max_ammo = 6
	caliber = CALIBER_50_RIFLE

/obj/item/ammo_box/magazine/sniper_rounds/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][ammo_count() ? "-ammo" : ""]"

/obj/item/ammo_box/magazine/sniper_rounds/soporific
	name = "3-round magazine (.50 Zzzzz)"
	desc = "Soporific sniper rounds, designed for happy days and dead quiet nights..."
	icon_state = "soporific"
	ammo_type = /obj/item/ammo_casing/p50/soporific
	max_ammo = 3
	caliber = CALIBER_50_RIFLE

/obj/item/ammo_box/magazine/sniper_rounds/penetrator
	name = "5-round magazine (.50 BMG penetrator)"
	desc = "An extremely powerful round capable of passing straight through cover and anyone unfortunate enough to be behind it."
	ammo_type = /obj/item/ammo_casing/p50/penetrator
	max_ammo = 5

/obj/item/ammo_box/magazine/sniper_rounds/marksman
	name = "5-round magazine (.50 BMG high velocity)"
	desc = "An extremely fast sniper round able to pretty much instantly shoot through something."
	ammo_type = /obj/item/ammo_casing/p50/marksman
	max_ammo = 5
