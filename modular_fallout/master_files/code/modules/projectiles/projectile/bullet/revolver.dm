// 7.62x38mmR (Nagant Revolver)

/obj/projectile/bullet/n762
	name = "7.62x38mmR bullet"
	damage = 60

// .50AE (Desert Eagle)

/obj/projectile/bullet/a50ae
	name = ".50 AE bullet"
	damage = 60

// .38 (Detective's Gun)

/obj/projectile/bullet/c38
	name = ".38 bullet"
	damage = 25

/obj/projectile/bullet/c38/match
	name = ".38 Match bullet"

/obj/projectile/bullet/c38/match/bouncy
	name = ".38 Rubber bullet"
	damage = 10
	stamina = 30
	weak_against_armor = 3

// .357 (Revolver)

/obj/projectile/bullet/a357
	name = ".357 bullet"
	damage = 60

// admin only really, for ocelot memes
/obj/projectile/bullet/a357/match
	name = ".357 match bullet"
	ricochets_max = 5
	ricochet_chance = 140
	ricochet_auto_aim_angle = 50
	ricochet_auto_aim_range = 6
	ricochet_incidence_leeway = 80
	ricochet_decay_chance = 1
