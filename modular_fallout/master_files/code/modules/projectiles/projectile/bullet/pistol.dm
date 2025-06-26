//In this document: Pistol calibre cartridges values for damage and penetration.

//////////////////////
// AMMUNITION TYPES //
//////////////////////
/*
FMJ (full metal jacket)		=	Baseline
AP (armor piercing)			=	-20% damage. AP increased by 0.2. Wound bonus -50%
JHP (jacketed hollow point)	=	+15% damage. AP reduced by 0.2 (not below zero). Wound bonus + 50%
SWC (semi wadcutter)		=	AP reduced by 0.1. Wound bonus +50%
P+ (overpressure)			=	extra speed 500. AP +25%
Match						=	extra speed 200. AP +10%. Wound bonus -10%
Civilian round				=	-10% damage. AP reduced by 50%
*/

// Explanation: Two major ammo stats, AP and Damage. Bullets placed in classes. Light rounds for example balanced with each other, one more AP, one more Damage.
// Balance between classes mostly done on the gun end, bigger rounds typically fire slower and have more recoil. They are not supposed to be totally equal either.

////////////////////
// .22 LONG RIFLE //
////////////////////		-very light round

/obj/projectile/bullet/c22
	name = ".22lr bullet"
	damage = 12
	armor_penetration = 0
	damage_falloff = 0.15
	penetration_falloff = 0

/obj/projectile/bullet/c22/rubber
	name = ".22lr rubber bullet"
	damage = 2
	armor_penetration = 0
	stamina = 15
	sharpness = NONE
	damage_falloff = 0.1

/////////////////
// .38 SPECIAL //
/////////////////		-Light round, slight damage focus

/obj/projectile/bullet/c38
	name = ".38 bullet"
	damage = 25
	armor_penetration = 0
	damage_falloff = 0.25

/obj/projectile/bullet/c38/rubber
	name = ".38 rubber bullet"
	damage = 5
	armor_penetration = 0
	sharpness = NONE
	damage_falloff = 0.25


//////////
// 9 MM //
//////////				-Light round, allround

/obj/projectile/bullet/c9mm
	name = "9mm FMJ bullet"
	damage = 25
	armor_penetration = 5
	damage_falloff = 0.15
	penetration_falloff = 0.25

/obj/projectile/bullet/c9mm/op
	name = "9mm +P bullet"
	damage = 28
	armor_penetration = 10
	var/extra_speed = 500
	damage_falloff = 0.2
	penetration_falloff = 0.25

/obj/projectile/bullet/c9mm/rubber
	name = "9mm rubber bullet"
	damage = 5
	weak_against_armor = 2
	stamina = 15
	armor_penetration = 0
	sharpness = NONE
	damage_falloff = 0.25

/obj/projectile/bullet/c9mm/wounding
	name = "9mm JHP bullet"
	damage = 35
	weak_against_armor = 2
	ricochets_max = 0
	sharpness = SHARP_EDGED
	damage_falloff = 0.75

/obj/projectile/bullet/c9mm/simple //for simple mobs, separate to allow balancing
	name = "9mm bullet"


///////////
// 10 MM //
///////////				-Medium round

/obj/projectile/bullet/c10mm
	name = "10mm FMJ bullet"
	damage = 33
	armor_penetration = 0
	damage_falloff = 0.25

/obj/projectile/bullet/c10mm/rubber
	name = "10mm rubber bullet"
	damage = 8
	armor_penetration = 0
	stamina = 20
	sharpness = NONE
	damage_falloff = 0.5

/obj/projectile/bullet/c10mm/wounding
	name = "10mm JHP bullet"
	damage = 45
	weak_against_armor = 2
	armor_penetration = 0
	ricochets_max = 0
	sharpness = SHARP_EDGED
	damage_falloff = 1

/////////////
// .45 ACP //
/////////////			-Medium round, damage focus

/obj/projectile/bullet/c45
	name = ".45 FMJ bullet"
	damage = 30
	armor_penetration = 0
	damage_falloff = 0.25

/obj/projectile/bullet/c45/op
	name = ".45 +P bullet"
	damage = 32
	var/extra_speed = 500
	damage_falloff = 0.25

/obj/projectile/bullet/c45/rubber
	name = ".45 rubber bullet"
	damage = 10
	stamina = 20
	armor_penetration = 0
	sharpness = NONE
	damage_falloff = 1

/////////////////
// .357 MAGNUM //
/////////////////		-High power round

/obj/projectile/bullet/a357
	name = ".357 FMJ bullet"
	damage = 35
	armor_penetration = 5
	damage_falloff = 0.25
	penetration_falloff = 0.25

/obj/projectile/bullet/a357/hp
	name = ".357 JHP bullet"
	damage = 55
	weak_against_armor = 2
	armor_penetration = 0
	damage_falloff = 1

////////////////
// .44 MAGNUM //
////////////////		- High power round

/obj/projectile/bullet/m44
	name = ".44 FMJ bullet"
	damage = 45
	armor_penetration = 10
	damage_falloff = 0.25
	penetration_falloff = 0.35

/obj/projectile/bullet/m44
	name = ".44 FMJ bullet"
	damage = 65
	weak_against_armor = 2
	armor_penetration = 0
	damage_falloff = 1

////////////
// .45-70 //
////////////			-Heavy round, AP focus

/obj/projectile/bullet/c4570
	name = ".45-70 FMJ bullet"
	damage = 50
	armor_penetration = 15
	damage_falloff = 0.1
	penetration_falloff = 0.2

/obj/projectile/bullet/c4570/hp
	name = ".45-70 JHP bullet"
	damage = 70
	armor_penetration = 0
	weak_against_armor = 2
	damage_falloff = 1

///////////
// 14 MM //
///////////				-Heavy round, damage focus

/obj/projectile/bullet/mm14
	name = "14mm FMJ bullet"
	damage = 60
	armor_penetration = 10
	damage_falloff = 1.5
	penetration_falloff = 0.5

//////////////////////
//SPECIAL AMMO TYPES//
//////////////////////

//45 Long Colt.
/obj/projectile/bullet/a45lc
	name = ".45 LC bullet"
	damage = 45
	armor_penetration = 10
	damage_falloff = 10
	penetration_falloff = 0.25

/////////////
// NEEDLER //
/////////////			- AP focus

/obj/projectile/bullet/needle
	name = "needle"
	icon_state = "cbbolt"
	damage = 20
	armor_penetration = 35
	penetration_falloff = 3.5 // It's a needle. It has no mass and isn't even powered by gunpowder.

/////////////
// SHRAPNEL //
/////////////

/obj/projectile/bullet/shrapnel
	name = "flying shrapnel shard"
	damage = 20
	range = 20
	armour_penetration = 0
	damage_falloff = 1
	sharpness = SHARP_EDGED
