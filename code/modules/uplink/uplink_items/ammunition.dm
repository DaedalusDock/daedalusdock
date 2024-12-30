// File ordered by progression

/datum/uplink_category/ammo
	name = "Ammunition"
	weight = 7

/datum/uplink_item/ammo
	category = /datum/uplink_category/ammo
	surplus = 40

// Low progression cost

/datum/uplink_item/ammo/pistol
	name = "8-round 9x19mm Magazine"
	desc = "A magazine containing eight 9x19mm rounds, compatible with most small arms."
	progression_minimum = 10 MINUTES
	item = /obj/item/ammo_box/magazine/m9mm
	cost = 2
	purchasable_from = ~UPLINK_CLOWN_OPS
	illegal_tech = FALSE

// Medium progression cost

/datum/uplink_item/ammo/pistolap
	name = "8-round 9x19mm Armour Piercing Magazine"
	desc = "A magazine containing eight 9x19mm rounds, compatible with most small arms. \
			These bullets are highly effective against armor."
	progression_minimum = 30 MINUTES
	item = /obj/item/ammo_box/magazine/m9mm/ap
	cost = 4
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolhp
	name = "8-round 9x19mm Hollow-Point Magazine"
	desc = "A magazine containing eight 9x19mm rounds, compatible with most small arms. \
			These bullets will tear through flesh, but lack penetration."
	progression_minimum = 30 MINUTES
	item = /obj/item/ammo_box/magazine/m9mm/hp
	cost = 4
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolfire
	name = "8-round 9x19mm Incendiary Magazine"
	desc = "A magazine containing eight 9x19mm rounds, compatible with most small arms. \
			These bullets have low stopping power, but will ignite flesh upon impact."
	progression_minimum = 30 MINUTES
	item = /obj/item/ammo_box/magazine/m9mm/fire
	cost = 6
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/revolver
	name = ".357 S&W Speed Loader"
	desc = "A speed loader that contains seven .357 S&W Magnum rounds. Sometimes, you just need a little more gun."
	progression_minimum = 30 MINUTES
	item = /obj/item/ammo_box/a357
	cost = 6
	purchasable_from = ~UPLINK_CLOWN_OPS
	illegal_tech = FALSE
