TYPEINFO_DEF(/obj/item/clothing/head/helmet/space/hardsuit/security)
	default_armor = list(BLUNT = 35, PUNCTURE = 15, SLASH = 0, LASER = 30, ENERGY = 40, BOMB = 10, BIO = 100, FIRE = 75, ACID = 75)

/obj/item/clothing/head/helmet/space/hardsuit/security
	name = "security voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "hardsuit0-security"
	inhand_icon_state = "sec_helm"
	hardsuit_type = "security"


TYPEINFO_DEF(/obj/item/clothing/suit/space/hardsuit/security)
	default_armor = list(BLUNT = 35, PUNCTURE = 15, SLASH = 0, LASER = 30, ENERGY = 40, BOMB = 10, BIO = 100, FIRE = 75, ACID = 75)

/obj/item/clothing/suit/space/hardsuit/security
	icon_state = "hardsuit-security"
	name = "security voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	inhand_icon_state = "sec_hardsuit"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security
