/obj/item/clothing/head/hooded/gamemaster
	name = "old wizard hood"
	icon_state = "culthood"
	worn_icon_state = "adminhood"
	desc = "A torn, dust-caked hood. Strange letters line the inside."

	flags_inv = HIDEFACE|HIDEHAIR|HIDEEARS
	flags_cover = HEADCOVERSEYES
	armor = list(BLUNT = 100, PUNCTURE = 100, SLASH = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, FIRE = 100, ACID = 100)

	clothing_traits = list(TRAIT_NODROP)

	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	resistance_flags = ALL

/obj/item/clothing/suit/hooded/gamemaster
	name = "old wizard robes"
	desc = "A ragged, dusty set of robes. Strange letters line the inside."

	icon_state = "cultrobes"
	worn_icon_state = "adminrobes"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list(BLUNT = 100, PUNCTURE = 100, SLASH = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, FIRE = 100, ACID = 100)
	flags_inv = HIDEJUMPSUIT
	resistance_flags = ALL

	clothing_traits = list(TRAIT_NODROP)

	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	hoodtype = /obj/item/clothing/head/hooded/gamemaster

/obj/item/clothing/shoes/sandal/gamemaster
	resistance_flags = ALL
	armor = list(BLUNT = 100, PUNCTURE = 100, SLASH = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, FIRE = 100, ACID = 100)

	clothing_traits = list(TRAIT_NODROP)
