/obj/item/clothing/suit/jacket
	name = "bomber jacket"
	desc = "Aviators not included."
	icon_state = "bomberjacket"
	inhand_icon_state = "brownjsuit"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/radio)
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

	equip_self_flags = EQUIP_ALLOW_MOVEMENT | EQUIP_SLOWDOWN
	equip_delay_self = EQUIP_DELAY_COAT
	equip_delay_other = EQUIP_DELAY_COAT * 1.5
	strip_delay = EQUIP_DELAY_COAT * 1.5

/obj/item/clothing/suit/jacket/leather
	name = "leather jacket"
	desc = "Pompadour not included."
	icon_state = "leatherjacket"
	inhand_icon_state = "hostrench"
	resistance_flags = NONE
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/gun/ballistic/automatic/pistol, /obj/item/gun/ballistic/revolver, /obj/item/gun/ballistic/revolver/detective, /obj/item/radio)

/obj/item/clothing/suit/jacket/leather/overcoat
	name = "leather overcoat"
	desc = "That's a damn fine coat."
	icon_state = "leathercoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/suit/jacket/puffer
	name = "puffer jacket"
	desc = "A thick jacket with a rubbery, water-resistant shell."
	icon_state = "pufferjacket"
	inhand_icon_state = "hostrench"
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 0, ACID = 0)
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/suit/jacket/puffer/vest
	name = "puffer vest"
	desc = "A thick vest with a rubbery, water-resistant shell."
	icon_state = "puffervest"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 30, FIRE = 0, ACID = 0)
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/suit/jacket/miljacket
	name = "military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket"
	inhand_icon_state = "militaryjacket"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/gun/ballistic/automatic/pistol, /obj/item/gun/ballistic/revolver, /obj/item/radio)
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/suit/jacket/letterman
	name = "letterman jacket"
	desc = "A classic brown letterman jacket. Looks pretty hot and heavy."
	icon_state = "letterman"
	inhand_icon_state = "letterman"

	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/suit/jacket/letterman_red
	name = "red letterman jacket"
	desc = "A letterman jacket in a sick red color. Radical."
	icon_state = "letterman_red"
	inhand_icon_state = "letterman_red"

	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/suit/jacket/letterman_syndie
	name = "blood-red letterman jacket"
	desc = "Oddly, this jacket seems to have a large S on the back..."
	icon_state = "letterman_s"
	inhand_icon_state = "letterman_s"

	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/suit/jacket/letterman_nanotrasen
	name = "blue letterman jacket"
	desc = "A blue letterman jacket with a proud Nanotrasen N on the back. The tag says that it was made in Space China."
	icon_state = "letterman_n"
	inhand_icon_state = "letterman_n"

	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION
