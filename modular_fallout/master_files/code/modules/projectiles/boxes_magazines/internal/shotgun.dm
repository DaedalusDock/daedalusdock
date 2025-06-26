/obj/item/ammo_box/magazine/internal/shot
	name = "shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	caliber = "shotgun"
	max_ammo = 4
	multiload = 0

/obj/item/ammo_box/magazine/internal/shot/ammo_count(countempties = 1)
	if (!countempties)
		var/boolets = 0
		for(var/obj/item/ammo_casing/bullet in stored_ammo)
			if(bullet.loaded_projectile)
				boolets++
		return boolets
	else
		return ..()
/obj/item/ammo_box/magazine/internal/shot/trench
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 5

/obj/item/ammo_box/magazine/internal/shot/tube
	name = "dual feed shotgun internal tube"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/shot/lethal
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/ammo_box/magazine/internal/shot/com
	name = "combat shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/shot/com/compact
	name = "compact combat shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 4

/obj/item/ammo_box/magazine/internal/shot/com/citykiller
	name = "city killer shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 12

/obj/item/ammo_box/magazine/internal/shot/dual
	name = "double-barrel shotgun internal magazine"
	max_ammo = 2

/obj/item/ammo_box/magazine/internal/shot/dual/simple
	name = "double-barrel shotgun internal magazine (simple)"
	ammo_type = /obj/item/ammo_casing/shotgun/improvised

/obj/item/ammo_box/magazine/internal/shot/improvised
	name = "improvised shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/improvised
	max_ammo = 1

/obj/item/ammo_box/magazine/internal/shot/police
	name = "police shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/shot/bounty
	name = "triple-barrel shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/incapacitate
	max_ammo = 3

/obj/item/ammo_box/magazine/internal/shot/tube44
	name = ".44 magnum internal tube magazine" //trail carbine
	ammo_type = /obj/item/ammo_casing/m44
	caliber = "44"
	max_ammo = 12
	multiload = 1

/obj/item/ammo_box/magazine/internal/shot/tube357
	name = ".357 magnum internal tube magazine" //cowboy repeater
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 12
	multiload = 1

/obj/item/ammo_box/magazine/internal/shot/tube4570
	name = "4570 internal tube magazine" //brush gun
	ammo_type = /obj/item/ammo_casing/c4570
	caliber = "4570"
	max_ammo = 10
	multiload = 1

/obj/item/ammo_box/magazine/internal/shot/lasmusket
	name = "lasmusket magazine"
	desc = "Oh god, this shouldn't be here"
	ammo_type = /obj/item/ammo_casing/caseless/lasermusket
	caliber = "lasmusket"
	max_ammo = 6
	multiload = 1

/obj/item/ammo_box/magazine/internal/plasmacaster
	name = "plasmacaster magazine"
	desc = "Oh god, this shouldn't be here"
	ammo_type = /obj/item/ammo_casing/caseless/plasmacaster
	caliber = "plasmacaster"
	max_ammo = 2
	multiload = 1
