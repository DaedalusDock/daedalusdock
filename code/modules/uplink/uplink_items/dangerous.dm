// File organised based on progression

//All bundles and telecrystals
/datum/uplink_category/dangerous
	name = "Conspicuous Weapons"
	weight = 9

/datum/uplink_item/dangerous
	category = /datum/uplink_category/dangerous

// Low progression cost

/datum/uplink_item/dangerous/pistol
	name = "9x19mm Pistol"
	desc = "A servicable handgun chambered in 9x19mm Parabellum."
	progression_minimum = 10 MINUTES
	item = /obj/item/gun/ballistic/automatic/pistol
	cost = 10
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/throwingweapons
	name = "Box of Throwing Weapons"
	desc = "A box of shurikens and reinforced bolas from ancient Earth martial arts. They are highly effective \
			throwing weapons. The bolas can knock a target down and the shurikens will embed into limbs."
	progression_minimum = 10 MINUTES
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 3
	illegal_tech = FALSE

/datum/uplink_item/dangerous/sword
	name = "Energy Sword"
	desc = "The energy sword is an edged weapon with a blade of pure energy. Activating it produces a loud, distinctive noise."
	progression_minimum = 20 MINUTES
	item = /obj/item/melee/energy/sword/saber
	cost = 12
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/powerfist
	name = "Power Fist"
	desc = "The power-fist is a metal gauntlet with a built-in piston-ram powered by an external gas supply.\
			Upon hitting a target, the piston-ram will extend forward to make contact for some serious damage. \
			Using a wrench on the piston valve will allow you to tweak the amount of gas used per punch to \
			deal extra damage and hit targets further. Use a screwdriver to take out any attached tanks."
	progression_minimum = 20 MINUTES
	item = /obj/item/melee/powerfist
	cost = 6

/datum/uplink_item/dangerous/rapid
	name = "Gloves of the North Star"
	desc = "These gloves let the user punch people very fast. Does not improve weapon attack speed or the meaty fists of a hulk."
	progression_minimum = 20 MINUTES
	item = /obj/item/clothing/gloves/rapid
	cost = 8


// Medium progression cost
/datum/uplink_item/dangerous/revolver
	name = ".357 Magnum Revolver"
	desc = "A modern classic, 7-chamber revolver chambered in .357 S&W."
	item = /obj/item/gun/ballistic/revolver
	progression_minimum = 30 MINUTES
	cost = 14
	surplus = 50
	purchasable_from = ~UPLINK_CLOWN_OPS
