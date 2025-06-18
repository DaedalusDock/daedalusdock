TYPEINFO_DEF(/obj/item/clothing/gloves/bracer)
	default_armor = list(BLUNT = 15, PUNCTURE = 25, SLASH = 0, LASER = 15, ENERGY = 15, BOMB = 20, BIO = 10, FIRE = 0, ACID = 0)

/obj/item/clothing/gloves/bracer
	name = "bone bracers"
	desc = "For when you're expecting to get slapped on the wrist. Offers modest protection to your arms."
	icon_state = "bracers"
	inhand_icon_state = "bracers"
	strip_delay = 40
	equip_delay_other = 20
	body_parts_covered = ARMS
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION
