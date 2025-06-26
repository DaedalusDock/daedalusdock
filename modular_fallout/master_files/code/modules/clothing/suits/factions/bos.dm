//Brotherhood of Steel (PA in f13armor.dm)

/obj/item/clothing/suit/armor/f13/headscribe
	name = "brotherhood head scribe robe"
	desc = "(IV) A red cloth robe with gold trimmings, worn eclusively by the Head Scribe of a chapter."
	icon_state = "headscribe"
	inhand_icon_state = "headscribe"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	armor = list("tier" = 4, ENERGY = 60, BOMB = 36, BIO = 50, RAD = 69, FIRE = 10, ACID = 70)

/obj/item/clothing/suit/f13/scribe
	name = "Brotherhood Scribe's robe"
	desc = "(II) A red cloth robe worn by the Brotherhood of Steel Scribes."
	icon_state = "scribe"
	inhand_icon_state = "scribe"
	body_parts_covered = CHEST|ARMS|LEGS
	armor = list("tier" = 2, ENERGY = 0, BOMB = 16, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/f13/seniorscribe
	name = "Brotherhood Senior Scribe's robe"
	desc = "(II) A red cloth robe with silver gildings worn by the Brotherhood of Steel Senior Scribes."
	icon_state = "seniorscribe"
	inhand_icon_state = "seniorscribe"
	body_parts_covered = CHEST|ARMS|LEGS
	armor = list("tier" = 2, ENERGY = 0, BOMB = 16, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/f13/elder
	name = "Brotherhood Elder's robe"
	desc = "(II) A blue cloth robe with some scarlet red parts, traditionally worn by the Brotherhood of Steel Elder."
	icon_state = "elder"
	inhand_icon_state = "elder"
	body_parts_covered = CHEST|ARMS|LEGS
	armor = list("tier" = 2, ENERGY = 0, BOMB = 16, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	allowed = list(/obj/item/gun)

/obj/item/clothing/suit/armor/f13/combat/brotherhood
	name = "brotherhood armor"
	desc = "(V) A combat armor set made by the Brotherhood of Steel, standard issue for all Knights. It bears a red stripe."
	icon_state = "brotherhood_armor_knight"
	inhand_icon_state = "brotherhood_armor_knight"
	armor = list("tier" = 5, ENERGY = 45, BOMB = 60, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)

/obj/item/clothing/suit/armor/f13/combat/brotherhood/senior
	name = "brotherhood senior knight armor"
	desc = "(VI) A combat armor set made by the Brotherhood of Steel, standard issue for all Senior Knight. It bears a silver stripe."
	icon_state = "brotherhood_armor_senior"
	inhand_icon_state = "brotherhood_armor_senior"
	armor = list("tier" = 6, ENERGY = 45, BOMB = 60, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)
/obj/item/clothing/suit/armor/f13/combat/brotherhood/captain
	name = "brotherhood knight-captain armor"
	desc = "(VI) A combat armor set made by the Brotherhood of Steel, standard issue for all Knight-Captains. It bears golden embroidery."
	icon_state = "brotherhood_armor_captain"
	inhand_icon_state = "brotherhood_armor_captain"
	armor = list("tier" = 6, ENERGY = 45, BOMB = 60, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)
/obj/item/clothing/suit/armor/f13/combat/brotherhood/initiate
	name = "initiate armor"
	desc = "(IV) An old degraded pre war combat armor, repainted to the colour scheme of the Brotherhood of Steel."
	icon_state = "brotherhood_armor"
	inhand_icon_state = "brotherhood_armor"
	armor = list("tier" = 4, ENERGY = 40, BOMB = 50, BIO = 60, RAD = 10, FIRE = 60, ACID = 20)

/obj/item/clothing/suit/armor/f13/combat/brotherhood/initiate/mk2
	name = "reinforced knight armor"
	desc = "(VI) A reinforced set of bracers, greaves, and torso plating of prewar design This one is kitted with additional plates and, repainted to the colour scheme of the Brotherhood of Steel."
	icon_state = "brotherhood_armor_mk2"
	inhand_icon_state = "brotherhood_armor_mk2"
	armor = list("tier" = 6, ENERGY = 45, BOMB = 55, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)

/obj/item/clothing/suit/armor/f13/combat/brotherhood/outcast
	name = "brotherhood armor" //unused?
	desc = "(V) A superior combat armor set made by the Brotherhood of Steel, bearing a series of red markings."
	icon_state = "brotherhood_armor_outcast"
	inhand_icon_state = "brotherhood_armor_outcast"
	armor = list("tier" = 5, ENERGY = 45, BOMB = 60, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)
