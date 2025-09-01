// .45 (M1911 & C20r)
TYPEINFO_DEF(/obj/projectile/bullet/c45)
	default_armor = list(BLUNT = 0, PUNCTURE = 20, SLASH = 0, LASER = 0, ENERGY = 0 , BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/obj/projectile/bullet/c45
	name = ".45 bullet"
	damage = 30

TYPEINFO_DEF(/obj/projectile/bullet/c45/ap)
	default_armor = list(BLUNT = 0, PUNCTURE = 350, SLASH = 0, LASER = 0, ENERGY = 0 , BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/obj/projectile/bullet/c45/ap
	name = ".45 armor-piercing bullet"
	armor_penetration = 50

/obj/projectile/bullet/incendiary/c45
	name = ".45 incendiary bullet"
	damage = 15
	fire_stacks = 2

// 4.6x30mm (Autorifles)

/obj/projectile/bullet/c46x30mm
	name = "4.6x30mm bullet"
	damage = 20
	embed_adjustment_tile = 2

/obj/projectile/bullet/c46x30mm/ap
	name = "4.6x30mm armor-piercing bullet"
	damage = 15
	armor_penetration = 40
	embedding = null

/obj/projectile/bullet/incendiary/c46x30mm
	name = "4.6x30mm incendiary bullet"
	damage = 10
	fire_stacks = 1
