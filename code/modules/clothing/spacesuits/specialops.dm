TYPEINFO_DEF(/obj/item/clothing/head/helmet/space/beret)
	default_armor = list(BLUNT = 80, PUNCTURE = 80, SLASH = 0, LASER = 50, ENERGY = 60, BOMB = 100, BIO = 100, FIRE = 100, ACID = 100)

/obj/item/clothing/head/helmet/space/beret
	name = "CentCom officer's beret"
	desc = "An armored beret commonly used by special operations officers. Uses advanced force field technology to protect the head from space."
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	icon_state = "beret_badge"
	greyscale_colors = "#397F3F#FFCE5B"

	flags_inv = 0
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF

TYPEINFO_DEF(/obj/item/clothing/suit/space/officer)
	default_armor = list(BLUNT = 80, PUNCTURE = 80, SLASH = 0, LASER = 50, ENERGY = 60, BOMB = 100, BIO = 100, FIRE = 100, ACID = 100)

/obj/item/clothing/suit/space/officer
	name = "CentCom officer's coat"
	desc = "An armored, space-proof coat used in special operations."
	icon_state = "centcom_coat"
	inhand_icon_state = "centcom"
	blood_overlay_type = "coat"
	slowdown = 0
	flags_inv = 0
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
