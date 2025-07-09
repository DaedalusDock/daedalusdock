//In this document: Rifle calibre cartridges values for damage and penetration.

//////////////////////
// AMMUNITION TYPES //
//////////////////////
/*
FMJ (full metal jacket)		=	Baseline
AP (armor piercing)			=	-20% damage. AP increased by 0.2. Wound bonus -50%
JHP (jacketed hollow point)	=	+15% damage. AP reduced by 0.2 (not below zero). Wound bonus + 50%
SWC (semi wadcutter)		=	AP reduced by 0.1. Wound bonus +50%
P+ (overpressure)			=	extra speed 500. AP +25%
Match						=	extra speed 200. AP -10%. Wound bonus -10%. Damage + 10%.
Civilian round				=	-10% damage for .223. AP reduced by 50%
*/

// Explanation: Two major ammo stats, AP and Damage. Bullets placed in classes. Light rounds for example balanced with each other, one more AP, one more Damage.
// Balance between classes mostly done on the gun end, bigger rounds typically fire slower and have more recoil. They are not supposed to be totally equal either.

////////////////////
// 5.56 MM & .223 //
////////////////////		- Moderate damage, pretty good AP. .223 civilian version for hunting/sport.

/obj/projectile/bullet/a556
	name = "5.56 FMJ bullet"
	damage = 25
	armor_penetration = 20
	penetration_falloff = 0.25
	damage_falloff = 0.25
	projectile_phasing =  PASSTABLE | PASSGRILLE  | PASSMACHINE

/obj/projectile/bullet/a556/match
	name = "5.56 match bullet"
	damage = 35
	armor_penetration = 25
	projectile_phasing =  null


/obj/projectile/bullet/a556/sport
	name = ".223 FMJ bullet"
	damage = 25
	armor_penetration = 15

/obj/projectile/bullet/a556/rubber
	name = "5.56 rubber bullet"
	damage = 5
	stamina = 25
	sharpness = NONE
	armor_penetration = 0

/obj/projectile/bullet/a556/ap
	name = "5.56 tungsten AP bullet"
	damage = 20
	armor_penetration = 65
	penetration_falloff = 0.25
	damage_falloff = 0.15


/obj/projectile/bullet/a556/simple //for simple mobs, separate to allow balancing
	name = "5.56 bullet"

/obj/projectile/bullet/a556/ap/simple //for simple mobs, separate to allow balancing
	name = "5.56 bullet"


////////////////////
// 7.62 MM & .308 //
////////////////////			- heavy rifle round, powerful but high recoil and less rof in the guns that can use it. .308 civilian version for hunting.

/obj/projectile/bullet/a762
	name = "7.62x51mm FMJ bullet"
	damage = 45
	armor_penetration = 20
	penetration_falloff = 0.15
	damage_falloff = 0.15

//.308 Winchester
/obj/projectile/bullet/a762/sport
	name = ".308 bullet"
	damage = 50
	armor_penetration = 15
	penetration_falloff = 0.15
	damage_falloff = 0.1


/obj/projectile/bullet/a762/rubber
	name = "7.62 rubber bullet"
	damage = 10
	stamina = 35
	sharpness = NONE
	armor_penetration = 0

/obj/projectile/bullet/a762/sport/simple //for simple mobs, separate to allow balancing
	name = ".308 bullet"

/obj/projectile/bullet/a762/ap
	name = "7.62 tungsten-tipped AP bullet"
	damage = 30
	armor_penetration = 65
	penetration_falloff = 0.2
	damage_falloff = 0.1

/////////
// .50 //
/////////			-Very heavy rifle round.

/obj/projectile/bullet/a50MG
	damage = 100
	armor_penetration = 65
	speed = 0.1
	penetration_falloff = 0.1
	damage_falloff = 0.1


/obj/projectile/bullet/a50MG/explosive
	damage = 30
	armor_penetration = 30
	penetration_falloff = 1
	damage_falloff = 1


/obj/projectile/bullet/a50MG/explosive/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, 0, 1, 1, 1)

/obj/projectile/bullet/a50MG/rubber
	name = ".50 rubber bullet"
	damage = 25
	stamina = 75
	armor_penetration = 0
	sharpness = NONE
	penetration_falloff = 1
	damage_falloff = 1

/obj/projectile/bullet/a50MG/penetrator
	name = ".50 penetrator round"
	damage = 50
	armor_penetration = 100
	projectile_phasing =  PASSTABLE | PASSGLASS | PASSGRILLE  | PASSMACHINE
	penetration_falloff = 0.2
	damage_falloff = 0.2


//////////////////////
// 4.73 MM CASELESS //
//////////////////////			-Small rifle bullet

/obj/projectile/bullet/a473
	name = "4.73 FMJ bullet"
	damage = 25
	armor_penetration = 15
	penetration_falloff = 0.25
	damage_falloff = 0.25

//////////////////////////
// 5 MM minigun special //
//////////////////////////

/obj/projectile/bullet/c5mm
	damage = 20
	armor_penetration = 25
	penetration_falloff = 0.25
	damage_falloff = 0.25

/////////////////////////
//2 MM ELECTROMAGNETIC //
/////////////////////////			- Gauss rifle

/obj/projectile/bullet/c2mm
	damage = 50
	armor_penetration = 75
	speed = 0.1
	penetration_falloff = 0.1
	damage_falloff = 0.1

/// Musket

/obj/projectile/bullet/F13/musketball
	damage = 60
	armor_penetration = 0
	weak_against_armor = 1.5
