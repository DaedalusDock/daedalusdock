//musket
/obj/projectile/beam/laser/musket //musket
	name = "laser beam"
	damage = 40
	hitscan = TRUE
	armor_penetration = 50
	speed = 2

//plasma caster
/obj/projectile/f13plasma/plasmacaster
	name = "plasma bolt"
	icon_state = "plasma_clot"
	damage_type = BURN
	damage = 50
	armor_penetration = 60
	armor_flag = LASER
	eyeblur = 0
	reflectable = REFLECT_NORMAL
	speed = 2

//Securitrons Beam
/obj/projectile/beam/laser/pistol/ultraweak
	damage = 15 //quantity over quality

//Alrem's plasmacaster
/obj/projectile/f13plasma/plasmacaster/arlem
	name = "plasma bolt"
	icon_state = "plasma_clot"
	damage_type = BURN
	damage = 60
	armor_penetration = 80
	armor_flag = LASER
	eyeblur = 0
	reflectable = NONE

/obj/projectile/beam/laser/lasgun //AER9
	name = "laser beam"
	damage = 35
	armor_penetration = 20

/obj/projectile/beam/laser/lasgun/hitscan //hitscan aer9 test
	name = "laser beam"
	damage = 25
	armor_penetration = 20
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/laser/pistol //AEP7
	name = "laser beam"
	damage = 35

/obj/projectile/beam/laser/pistol/hitscan //hitscan AEP7
	name = "laser beam"
	damage = 25
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/laser/ultra_pistol //unused
	name = "laser beam"
	damage = 40
	armor_penetration = 15

/obj/projectile/beam/laser/ultra_rifle //unused
	name = "laser beam"
	damage = 45
	armor_penetration = 40

/obj/projectile/beam/laser/gatling //Gatling Laser Projectile
	name = "rapid-fire laser beam"
	damage = 12
	armor_penetration = 70

/obj/projectile/beam/laser/pistol/wattz //Wattz pistol
	damage = 31

/obj/projectile/beam/laser/pistol/wattz/hitscan //hitscan wattz
	name = "weak laser beam"
	damage = 15
	armor_penetration = 0
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/laser/pistol/wattz/magneto //upgraded Wattz
	name = "penetrating laser beam"
	damage = 33
	armor_penetration = 0.20

/obj/projectile/beam/laser/pistol/wattz/magneto/hitscan
	name = "penetrating laser beam"
	damage = 15
	hitscan = TRUE
	armor_penetration = 0.2
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/laser/solar //Solar Scorcher
	name = "solar scorcher beam"
	damage = 28
	armor_penetration = 402

/obj/projectile/beam/laser/solar/hitscan
	name = "solar scorcher beam"
	damage = 27
	armor_penetration = 105
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/laser/tribeam //Tribeam laser, fires 3 shots, will melt you
	name = "tribeam laser"
	damage = 21
	armor_penetration = 0.25

/obj/projectile/beam/laser/tribeam/hitscan
	name = "tribeam laser"
	damage = 15 //if all bullets connect, this will do 45.
	armor_penetration = 0
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/f13plasma //Plasma rifle
	name = "plasma bolt"
	icon_state = "plasma_clot"
	damage_type = BURN
	damage = 46
	armor_penetration = 50
	armor_flag = LASER //checks vs. energy protection
	eyeblur = 0
	reflectable = REFLECT_NORMAL
	speed = 2

/obj/projectile/plasmacarbine //Plasma carbine
	name = "plasma bolt"
	icon_state = "plasma_clot"
	damage_type = BURN
	damage = 38
	armor_penetration = 50
	armor_flag = LASER //checks vs. energy protection
	eyeblur = 0
	reflectable = REFLECT_NORMAL
	speed = 2

/obj/projectile/f13plasma/repeater //Plasma repeater
	name = "plasma stream"
	icon_state = "plasma_clot"
	damage_type = BURN
	damage = 20
	armor_penetration = 0.25
	armor_flag = LASER //checks vs. energy protection
	eyeblur = 0
	reflectable = NONE

/obj/projectile/f13plasma/pistol //Plasma pistol
	damage = 42
	armor_penetration = 305

/obj/projectile/f13plasma/pistol/glock //Glock (streamlined plasma pistol)
	damage = 38
	armor_penetration = 50

/obj/projectile/f13plasma/scatter //Multiplas, fires 3 shots, will melt you
	damage = 24
	armor_penetration = 305

/obj/projectile/beam/laser/rcw //RCW
	name = "rapidfire beam"
	icon_state = "xray"
	damage = 30
	armor_penetration = 0.25
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN

/obj/projectile/beam/laser/rcw/hitscan //RCW
	name = "rapidfire beam"
	icon_state = "emitter"
	damage = 25 //ALWAYS does 50, this is a burstfire hitscan weapon that fires in bursts of 2.
	armor_penetration = 10
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/emitter
	tracer_type = /obj/effect/projectile/tracer/laser/emitter
	impact_type = /obj/effect/projectile/impact/laser/emitter
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser

/obj/projectile/f13plasma/pistol/alien
	name = "alien projectile"
	icon_state = "ion"
	damage = 90 //horrifyingly powerful, but very limited ammo
	armor_penetration = 80
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_outer_range = 2
	light_color = LIGHT_COLOR_BLUE

/obj/projectile/beam/laser/laer //Elder's/Unique LAER
	name = "advanced laser beam"
	icon_state = "u_laser"
	damage = 45
	armor_penetration = 80
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE

/obj/projectile/beam/laser/laer/hitscan
	hitscan = TRUE

/obj/projectile/beam/laser/laer/hitscan/Initialize()
	. = ..()
	transform *= 2

/obj/projectile/beam/laser/aer14 //AER14
	name = "laser beam"
	damage = 40
	armor_penetration = 50
	icon_state = "omnilaser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE

/obj/projectile/beam/laser/aer14/hitscan
	damage = 35
	armor_penetration = 0.25
	tracer_type = /obj/effect/projectile/tracer/pulse
	muzzle_type = /obj/effect/projectile/muzzle/pulse
	impact_type = /obj/effect/projectile/impact/pulse
	hitscan = TRUE
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = LIGHT_COLOR_BLUE
	muzzle_flash_intensity = 6
	muzzle_flash_range = 2
	muzzle_flash_color_override = LIGHT_COLOR_BLUE
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = LIGHT_COLOR_BLUE

/obj/projectile/beam/laser/aer12 //AER12
	name = "laser beam"
	damage = 35
	armor_penetration = 45
	icon_state = "xray"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN

/obj/projectile/beam/laser/aer12/hitscan
	name = "laser beam"
	damage = 30
	armor_penetration = 30
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/xray
	muzzle_type = /obj/effect/projectile/muzzle/xray
	impact_type = /obj/effect/projectile/impact/xray
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_LIME
	muzzle_flash_intensity = 6
	muzzle_flash_range = 2
	muzzle_flash_color_override = COLOR_LIME
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = COLOR_LIME

/obj/projectile/beam/laser/wattz2k
	name = "laser bolt"
	damage = 35
	armor_penetration = 50

/obj/projectile/beam/laser/wattz2k/hitscan
	name = "sniper laser bolt"
	damage = 40
	armor_penetration = 50
	tracer_type = /obj/effect/projectile/tracer/heavy_laser
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	impact_type = /obj/effect/projectile/impact/heavy_laser
	hitscan = TRUE

/obj/projectile/beam/laser/musket //musket
	name = "laser bolt"
	damage = 70
	armor_penetration = 0
	weak_against_armor = 1.5

/obj/projectile/beam/gamma
	name = "gamma beam"
	icon_state = "xray"
	damage = 5
	irradiate = 200
	range = 15
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF

	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN
	tracer_type = /obj/effect/projectile/tracer/xray
	muzzle_type = /obj/effect/projectile/muzzle/xray
	impact_type = /obj/effect/projectile/impact/xray



// BETA // Obsolete
/obj/projectile/beam/laser/pistol/lasertesting //Wattz pistol
	damage = 25
