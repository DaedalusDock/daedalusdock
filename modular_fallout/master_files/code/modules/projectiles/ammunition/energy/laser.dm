/*
---Fallout 13---
*/

/* here are the ammo sizes since nobody ever wrote these down
electron chargepack = 2400, this is currently only used in the RCW
mfc = 2000
ec = 1600

each one goes up by 4,000 power. why? nobody fucking knows lmao

also: most hitscan weapons have more charge than their normal projectile counterparts, since the actual projectiles are lower in damage and AP. this is to represent spammability.
*/

/obj/item/ammo_casing/energy/laser/scatter/tribeam
	projectile_type = /obj/projectile/beam/laser/tribeam
	pellets = 3
	variance = 14
	select_name = "scatter"
	e_cost = 180 //11 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/tribeamfire.ogg'

/obj/item/ammo_casing/energy/laser/scatter/tribeam/hitscan
	projectile_type = /obj/projectile/beam/laser/tribeam/hitscan
	pellets = 3
	variance = 45
	select_name = "tribeam"
	e_cost = 200 //10 shots

/obj/item/ammo_casing/energy/laser/pistol
	projectile_type = /obj/projectile/beam/laser/pistol
	e_cost = 80 //20 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/aep7fire.ogg'

/obj/item/ammo_casing/energy/laser/pistol/hitscan //25 damage per, with 0 near 0 AP-4 shot crit on unarmored target, significantly less useful against armored
	projectile_type = /obj/projectile/beam/laser/pistol/hitscan
	e_cost = 53.33 //30 shots, as per FNV

/obj/item/ammo_casing/energy/laser/ultra_pistol
	projectile_type = /obj/projectile/beam/laser/ultra_pistol
	e_cost = 80 //20 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/aep7fire.ogg'

/obj/item/ammo_casing/energy/laser/ultra_rifle
	projectile_type = /obj/projectile/beam/laser/ultra_rifle
	e_cost = 80 //20 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/aep7fire.ogg'


/obj/item/ammo_casing/energy/laser/pistol/wattz
	projectile_type = /obj/projectile/beam/laser/pistol/wattz
	e_cost = 100 //16 shots

/obj/item/ammo_casing/energy/laser/pistol/wattz/magneto
	projectile_type = /obj/projectile/beam/laser/pistol/wattz/magneto

/obj/item/ammo_casing/energy/laser/pistol/wattz/hitscan
	projectile_type = /obj/projectile/beam/laser/pistol/wattz/hitscan
	e_cost = 53.33 //30 shots, as per FNV

/obj/item/ammo_casing/energy/laser/pistol/wattz/magneto/hitscan
	projectile_type = /obj/projectile/beam/laser/pistol/wattz/magneto/hitscan
	e_cost = 53.33 //30 shots, as per FNV

/obj/item/ammo_casing/energy/laser/lasgun
	projectile_type = /obj/projectile/beam/laser/lasgun
	e_cost = 100 //20 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/aer9fire.ogg'

/obj/item/ammo_casing/energy/laser/lasgun/hitscan
	projectile_type = /obj/projectile/beam/laser/lasgun/hitscan
	e_cost = 80 //25 shots, as per FNV

/obj/item/ammo_casing/energy/laser/solar
	projectile_type = /obj/projectile/beam/laser/solar
	e_cost = 30 //basically infinite shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/laser_pistol.ogg'

/obj/item/ammo_casing/energy/laser/solar/hitscan
	projectile_type = /obj/projectile/beam/laser/solar/hitscan
	e_cost = 125 //16 shots, self charges. selfchargng adds 100 each time it fires off, so 2 ticks per laser recharge.

/obj/item/ammo_casing/energy/laser/rcw
	projectile_type = /obj/projectile/beam/laser/rcw
	e_cost = 100 //11 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/rcwfire.ogg'

/obj/item/ammo_casing/energy/laser/rcw/hitscan
	projectile_type = /obj/projectile/beam/laser/rcw/hitscan
	e_cost = 50 //it's actually 24 shots now, as it fires in a burst of 2

/obj/item/ammo_casing/energy/laser/laer
	projectile_type = /obj/projectile/beam/laser/laer
	e_cost = 125 //16 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/laerfire.ogg'

/obj/item/ammo_casing/energy/laser/laer/hitscan
	projectile_type = /obj/projectile/beam/laser/laer/hitscan

/obj/item/ammo_casing/energy/laser/aer14
	projectile_type = /obj/projectile/beam/laser/aer14
	e_cost = 80 //25 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/aer14fire.ogg'

/obj/item/ammo_casing/energy/laser/aer14/hitscan
	projectile_type = /obj/projectile/beam/laser/aer14/hitscan
	e_cost = 133.33 //15 shots, i hate the decimal value too trust me

/obj/item/ammo_casing/energy/laser/aer12
	projectile_type = /obj/projectile/beam/laser/aer12
	e_cost = 100 //20 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/aer9fire.ogg'

/obj/item/ammo_casing/energy/laser/aer12/hitscan
	projectile_type = /obj/projectile/beam/laser/aer12/hitscan
	e_cost = 100 //20 shots
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/aer9fire.ogg'

/obj/item/ammo_casing/energy/gammagun
	projectile_type = /obj/projectile/beam/gamma
	e_cost = 75
	fire_sound = 'modular_fallout/master_files/sound/weapons/laser3.ogg'

/obj/item/ammo_casing/energy/wattz2k
	projectile_type = /obj/projectile/beam/laser/wattz2k
	e_cost = 125

/obj/item/ammo_casing/energy/wattz2k/hitscan
	projectile_type = /obj/projectile/beam/laser/wattz2k/hitscan
	e_cost = 80 //25 //32.5 shots

/obj/item/ammo_casing/energy/wattz2k/extended
	projectile_type = /obj/projectile/beam/laser/wattz2k
	e_cost = 62.5 //32.5 shots

/obj/item/ammo_casing/energy/wattz2k/extended/hitscan
	projectile_type = /obj/projectile/beam/laser/wattz2k/hitscan

//musket

/obj/item/ammo_casing/energy/laser/musket
	projectile_type = /obj/projectile/beam/laser/musket
	e_cost = 250
	fire_sound = 'modular_fallout/master_files/sound/f13weapons/aer9fire.ogg'

// BETA // Obsolete
/obj/item/ammo_casing/energy/laser/pistol/lasertest
	projectile_type = /obj/projectile/beam/laser/pistol/lasertesting
