///////////////////
// SMG MAGAZINES //
///////////////////


/obj/item/ammo_box/magazine/cg45
	name = "Carl Gustaf magazine (10mm)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "cg45"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 36
	multiple_sprites = 2

/obj/item/ammo_box/magazine/cg45/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/greasegun
	name = "Grease gun magazine (.45)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "grease"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 30
	multiple_sprites = 2

/obj/item/ammo_box/magazine/greasegun/empty
	start_empty = 1

/obj/item/ammo_box/magazine/uzim9mm/rockwell
	name = "Rockwell magazine (9mm)"
	icon_state = "rock"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 20

/obj/item/ammo_box/magazine/uzim9mm/rockwell/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/uzim9mm
	name = "Uzi magazine (9mm)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "uzi9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 32

/obj/item/ammo_box/magazine/uzim9mm/update_icon()
	..()
	icon_state = "[initial(icon_state)]-[round(ammo_count(),4)]"

/obj/item/ammo_box/magazine/uzim9mm/empty
	start_empty = 1

/obj/item/ammo_box/magazine/pps9mm
	name = "Ppsh magazine (9mm)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "ppshDrum"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 71
	multiple_sprites = 2

/obj/item/ammo_box/magazine/pps9mm/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m22smg
	name = "toploader magazine (.22lr)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "smg22"
	ammo_type = /obj/item/ammo_casing/a22
	caliber = ".22lr"
	max_ammo = 180
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m22smg/empty
	start_empty = 1

/obj/item/ammo_box/magazine/tommygunm45
	name = "drum magazine (.45)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "tommydrum"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 50

/obj/item/ammo_box/magazine/tommygunm45/stick
	name = "drum magazine (.45)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "tommystick"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 30
	multiple_sprites = 2

/obj/item/ammo_box/magazine/tommygunm45/empty
	start_empty = 1

/obj/item/ammo_box/magazine/m10mm_p90
	name = "toploader magazine (10mm)"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 50
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m10mm_p90/empty
	start_empty = 1
