/obj/item/clothing/head/helmet/space/hardsuit/security
	name = "security hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "hardsuit0-security"
	inhand_icon_state = "sec_helm"
	hardsuit_type = "security"
	armor = list(MELEE = 35, BULLET = 15, LASER = 30,ENERGY = 40, BOMB = 10, BIO = 100, FIRE = 75, ACID = 75, WOUND = 20)


/obj/item/clothing/suit/space/hardsuit/security
	icon_state = "hardsuit-security"
	name = "security hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	inhand_icon_state = "sec_hardsuit"
	armor = list(MELEE = 35, BULLET = 15, LASER = 30, ENERGY = 40, BOMB = 10, BIO = 100, FIRE = 75, ACID = 75, WOUND = 20)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security
