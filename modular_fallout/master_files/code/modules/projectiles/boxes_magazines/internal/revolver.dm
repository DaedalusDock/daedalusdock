/obj/item/ammo_box/magazine/internal/cylinder/rev38
	name = "detective revolver cylinder"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = "38"
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/cylinder/rus357
	name = "\improper Russian revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 6
	multiload = 0

/obj/item/ammo_box/magazine/internal/cylinder/lucky37
	name = "\improper Lucky 37 cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/cylinder/rev6520
	name = "6520 10mm cylinder"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 12

/obj/item/ammo_box/magazine/internal/cylinder/rev4570
	name = "4570 cylinder"
	ammo_type = /obj/item/ammo_casing/c4570
	caliber = "4570"
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/cylinder/revneedler
	name = "needler internal mag"
	ammo_type = /obj/item/ammo_casing/caseless/needle
	caliber = "needle"
	max_ammo = 10

/obj/item/ammo_box/magazine/internal/rus357/Initialize()
	stored_ammo += new ammo_type(src)
	. = ..()

/obj/item/ammo_box/magazine/internal/cylinder/improvisedpipe
	name = "improvised internal magazine piperifle"
	ammo_type = /obj/item/ammo_casing/a556/sport
	caliber = "a556"
	max_ammo = 1

/obj/item/ammo_box/magazine/internal/cylinder/improvised38
	name = "improvised internal magazine .38"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = "38"
	max_ammo = 4

/obj/item/ammo_box/magazine/internal/cylinder/improvised9mm
	name = "improvised internal magazine 9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 5

/obj/item/ammo_box/magazine/internal/cylinder/improvised10mm
	name = "improvised internal magazine 10mm"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 4

/obj/item/ammo_box/magazine/internal/cylinder/improvised44
	name = "improvised internal magazine .44"
	ammo_type = /obj/item/ammo_casing/m44
	caliber = "44"
	max_ammo = 1

/obj/item/ammo_box/magazine/internal/cylinder/improvised762
	name = "improvised internal magazine .308"
	ammo_type = /obj/item/ammo_casing/a762/sport
	caliber = "a762"
	max_ammo = 2

/obj/item/ammo_box/magazine/internal/cylinder/thatgun
	name = ".223 pistol cylinder"
	ammo_type = /obj/item/ammo_casing/a556
	caliber = "a556"
	max_ammo = 5

/obj/item/ammo_box/magazine/internal/cylinder/rev44
	name = "44 magnum cylinder"
	ammo_type = /obj/item/ammo_casing/m44
	caliber = "44"
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/cylinder/rev357
	name = "357 magnum cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/cylinder/rev45
	name = ".45 ACP revolver cylinder"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 7

/obj/item/ammo_box/magazine/internal/cylinder/rev45/gunslinger
	name = ".45 LC revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a45lc
	caliber = "a45lc"
	max_ammo = 6
