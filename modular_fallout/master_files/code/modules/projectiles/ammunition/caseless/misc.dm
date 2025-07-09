/obj/item/ammo_casing/caseless/laser
	name = "laser casing"
	desc = "You shouldn't be seeing this."
	caliber = "laser"
	icon_state = "s-casing-live"
	projectile_type = /obj/projectile/beam
	fire_sound = 'modular_fallout/master_files/sound/weapons/laser.ogg'
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/energy

/obj/item/ammo_casing/caseless/laser/gatling
	projectile_type = /obj/projectile/beam/laser/gatling
	variance = 0.5
	click_cooldown_override = 1

/obj/item/ammo_casing/caseless/flamethrower
	name = "napalm"
	desc = "a bunch of napalm fuel for a flamethrower. A bit useless now that it's been spilt on the ground."
	caliber = "fuel"
	icon = 'modular_fallout/master_files/icons/fallout/mobs/robots.dmi'
	icon_state = "floor1"
	projectile_type = /obj/projectile/incendiary/flamethrower
	pellets = 3
	variance = 20
