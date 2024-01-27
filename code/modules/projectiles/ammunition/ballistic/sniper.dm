// .50 (Sniper)

/obj/item/ammo_casing/p50
	name = ".50 BMG bullet casing"
	desc = "A .50 BMG bullet casing."
	caliber = CALIBER_50_RIFLE
	projectile_type = /obj/projectile/bullet/p50
	icon_state = ".50"

/obj/item/ammo_casing/p50/soporific
	name = ".50 BMG soporific bullet casing"
	desc = "A .50 BMG bullet casing, specialised in sending the target to sleep, instead of hell."
	projectile_type = /obj/projectile/bullet/p50/soporific
	icon_state = "sleeper"
	harmful = FALSE

/obj/item/ammo_casing/p50/penetrator
	name = ".50 BMG penetrator round bullet casing"
	desc = "A .50 BMG caliber penetrator round casing."
	projectile_type = /obj/projectile/bullet/p50/penetrator

/obj/item/ammo_casing/p50/marksman
	name = ".50 BMG marksman round bullet casing"
	desc = "A .50 BMG caliber marksman round casing."
	projectile_type = /obj/projectile/bullet/p50/marksman
