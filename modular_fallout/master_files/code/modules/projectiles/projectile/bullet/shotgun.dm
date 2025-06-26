/obj/projectile/bullet/shotgun_slug
	name = "12g shotgun slug"
	damage = 65
	sharpness = SHARP_POINTY
	armor_penetration = 15
	spread = 2
	penetration_falloff = 0.5
	damage_falloff = 0.5

/obj/projectile/bullet/shotgun_slug/ap
	name = "12g shotgun tungsten AP slug"
	damage = 45
	armor_penetration = 40
	penetration_falloff = 0.5
	damage_falloff = 0.5

/obj/projectile/bullet/shotgun_beanbag
	name = "beanbag slug"
	damage = 15
	stamina = 35
	sharpness = NONE
	embedding = null

/obj/projectile/incendiary/flamethrower
	name = "FIREEEEEEEEEE!!!!!"
	icon = 'modular_fallout/master_files/icons/effects/fire.dmi'
	icon_state = "3"
	light_outer_range = light_outer_range_FIRE
	light_color = LIGHT_COLOR_FIRE
	damage_type = BURN
	damage = 12 //slight damage on impact
	range = 10

/obj/projectile/bullet/pellet
	tile_dropoff = 0.45
	tile_dropoff_s = 1.25

/obj/projectile/bullet/pellet/shotgun_buckshot
	name = "buckshot pellet"
	damage = 11

/obj/projectile/bullet/pellet/shotgun_rubbershot
	name = "rubbershot pellet"
	damage = 2
	stamina = 10
	embedding = null

/obj/projectile/bullet/pellet/Range()
	..()
	if(damage > 0)
		damage -= tile_dropoff
	if(stamina > 0)
		stamina -= tile_dropoff_s
	if(damage < 0 && stamina < 0)
		qdel(src)

/obj/projectile/bullet/pellet/shotgun_improvised
	tile_dropoff = 0.35		//Come on it does 6 damage don't be like that.
	damage = 6

/obj/projectile/bullet/pellet/shotgun_improvised/Initialize()
	. = ..()
	range = rand(1, 8)

/obj/projectile/bullet/pellet/shotgun_improvised/on_range()
	do_sparks(1, TRUE, src)
	..()
