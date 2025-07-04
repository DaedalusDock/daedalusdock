/**
 * # Ninja Shoes
 *
 * Space ninja's shoes.  Gives him armor on his feet.
 *
 * Space ninja's ninja shoes.  How mousey.  Gives him slip protection and protection against attacks.
 * Also are temperature resistant.
 *
 */
TYPEINFO_DEF(/obj/item/clothing/shoes/space_ninja)
	default_armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 0, LASER = 20, ENERGY = 15, BOMB = 30, BIO = 30, FIRE = 100, ACID = 100)

/obj/item/clothing/shoes/space_ninja
	name = "ninja shoes"
	desc = "A pair of running shoes. Excellent for running and even better for smashing skulls."
	icon_state = "s-ninja"
	inhand_icon_state = "secshoes"
	permeability_coefficient = 0.01
	clothing_traits = list(TRAIT_NO_SLIP_WATER)
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	strip_delay = 120
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	slowdown = -1
