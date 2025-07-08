TYPEINFO_DEF(/obj/item/clothing/suit/space/hardsuit/hop)
	default_armor = list(BLUNT = 25, PUNCTURE = 5, SLASH = 0, LASER = 30, ENERGY = 30, BOMB = 10, BIO = 100, FIRE = 50, ACID = 75)

/obj/item/clothing/suit/space/hardsuit/hop
	name = "voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "hardsuit-hop"
	inhand_icon_state = "eng_hardsuit"
	max_integrity = 300
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/hop

TYPEINFO_DEF(/obj/item/clothing/head/helmet/space/hardsuit/hop)
	default_armor = list(BLUNT = 25, PUNCTURE = 5, SLASH = 0, LASER = 10, ENERGY = 30, BOMB = 10, BIO = 100, FIRE = 50, ACID = 75)

/obj/item/clothing/head/helmet/space/hardsuit/hop
	name = "voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "hardsuit0-hop"
	inhand_icon_state = "eng_helm"
	max_integrity = 300
	hardsuit_type = "hop"

