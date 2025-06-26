/obj/item/ammo_casing/caseless/magspear
	name = "magnetic spear"
	desc = "A reusable spear that is typically loaded into kinetic spearguns."
	projectile_type = /obj/projectile/bullet/reusable/magspear
	caliber = "speargun"
	icon_state = "magspear"
	throwforce = 15 //still deadly when thrown
	throw_speed = 3

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
	icon = 'modular_fallout/master_files/icons/mob/robots.dmi'
	icon_state = "floor1"
	projectile_type = /obj/projectile/incendiary/flamethrower
	pellets = 3
	variance = 20
