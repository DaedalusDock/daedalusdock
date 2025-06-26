/obj/item/ammo_casing/energy/ion
	projectile_type = /obj/projectile/ion/weak
	select_name = "ion"
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/pulsegunfire.ogg'

/obj/item/ammo_casing/energy/ion/hos
	projectile_type = /obj/projectile/ion/weak
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/pulsepistolfire.ogg'
	e_cost = 200

/obj/item/ammo_casing/energy/declone
	projectile_type = /obj/projectile/energy/declone
	select_name = "declone"
	fire_sound = 'modular_fallout/master_files/sound/weapons/pulse3.ogg'

/obj/item/ammo_casing/energy/flora
	fire_sound = 'sound/effects/stealthoff.ogg'
	harmful = FALSE

/obj/item/ammo_casing/energy/flora/yield
	projectile_type = /obj/projectile/energy/florayield
	select_name = "yield"

/obj/item/ammo_casing/energy/flora/mut
	projectile_type = /obj/projectile/energy/floramut
	select_name = "mutation"

/obj/item/ammo_casing/energy/temp
	projectile_type = /obj/projectile/temp
	select_name = "freeze"
	e_cost = 250
	fire_sound = 'modular_fallout/master_files/sound/weapons/pulse3.ogg'

/obj/item/ammo_casing/energy/temp/hot
	projectile_type = /obj/projectile/temp/hot
	select_name = "bake"

/obj/item/ammo_casing/energy/meteor
	projectile_type = /obj/projectile/meteor
	select_name = "goddamn meteor"

/obj/item/ammo_casing/energy/net
	projectile_type = /obj/projectile/energy/net
	select_name = "netting"
	pellets = 6
	variance = 40
	harmful = FALSE

/obj/item/ammo_casing/energy/trap
	projectile_type = /obj/projectile/energy/trap
	select_name = "snare"
	harmful = FALSE

/obj/item/ammo_casing/energy/instakill
	projectile_type = /obj/projectile/beam/instakill
	e_cost = 0
	select_name = "DESTROY"

/obj/item/ammo_casing/energy/instakill/blue
	projectile_type = /obj/projectile/beam/instakill/blue

/obj/item/ammo_casing/energy/instakill/red
	projectile_type = /obj/projectile/beam/instakill/red

/obj/item/ammo_casing/energy/tesla_revolver
	fire_sound = 'sound/magic/lightningbolt.ogg'
	e_cost = 200
	select_name = "stun"
	projectile_type = /obj/projectile/energy/tesla/revolver

/obj/item/ammo_casing/energy/emitter
	fire_sound = 'modular_fallout/master_files/sound/weapons/emitter.ogg'
	e_cost = 2000 //20,000 is in the cell making this 10 shots before reload
	projectile_type = /obj/projectile/beam/emitter

/obj/item/ammo_casing/energy/shrink
	projectile_type = /obj/projectile/beam/shrink
	select_name = "shrink ray"
	e_cost = 200

/obj/item/ammo_casing/energy/pickle //ammo for an adminspawn gun
	projectile_type = /obj/projectile/energy/pickle
	select_name = "pickle ray"
	e_cost = 0
