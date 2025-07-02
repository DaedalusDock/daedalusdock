//FOR BOTH SUITS AND ARMORS BELONGING TO FACTIONS
//PLEASE PUT CUSTOM ARMORS IN f13armor.dm. All power armors are found in f13armor.dm.

//Raider
/obj/item/clothing/suit/armor/f13/raider
	name = "base raider armor"
	desc = "for testing"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	strip_delay = 40
	armor = list(BLUNT = 40, PUNCTURE = 25, SLASH = 50, LASER = 15, ENERGY = 10, BOMB = 16, BIO = 10, RAD = 0, FIRE = 50, ACID = 0)


/obj/item/clothing/suit/armor/f13/raider/supafly
	name = "supa-fly raider armor"
	desc = "Fabulous mutant powers were revealed to me the day I held aloft my bumper sword and said...<br>BY THE POWER OF NUKA-COLA, I AM RAIDER MAN!"
	icon_state = "supafly"
	inhand_icon_state = "supafly"

/obj/item/clothing/suit/armor/f13/raider/rebel
	name = "rebel raider armor"
	desc = "Rebel, rebel. Your face is a mess."
	icon_state = "raider_rebel_icon"
	inhand_icon_state = "raider_rebel_armor"

/obj/item/clothing/suit/armor/f13/raider/sadist
	name = "sadist raider armor"
	desc = "A bunch of metal chaps adorned with severed hands at the waist with a leather plate worn on the left shoulder. Very intimidating."
	icon_state = "sadist"
	inhand_icon_state = "sadist"

/obj/item/clothing/suit/armor/f13/raider/blastmaster
	name = "blastmaster raider armor"
	desc = "A suit composed largely of blast plating, though there's so many holes it's hard to say if it will protect against much."
	icon_state = "blastmaster"
	inhand_icon_state = "blastmaster"
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	flash_protect = 2

/obj/item/clothing/suit/armor/f13/raider/yankee
	name = "yankee raider armor"
	desc = "A set of armor made from bulky plastic and rubber. A faded sports team logo is printed in various places. Go Desert Rats!"
	icon_state = "yankee"
	inhand_icon_state = "yankee"

/obj/item/clothing/suit/armor/f13/raider/badlands
	name = "badlands raider armor"
	desc = "A leather top with a bandolier over it and a straps that cover the arms."
	icon_state = "badlands"
	inhand_icon_state = "badlands"
	pocket_storage_component_path = /datum/storage/concrete/pockets/bulletbelt
	armor = list(BLUNT = 30, PUNCTURE = 35, SLASH = 45, LASER = 10, ENERGY = 10, BOMB = 16, BIO = 10, RAD = 0, FIRE = 50, ACID = 0)


/obj/item/clothing/suit/armor/f13/raider/painspike
	name = "painspike raider armor"
	desc = "A particularly unhuggable armor, even by raider standards. Extremely spiky."
	icon_state = "painspike"
	inhand_icon_state = "painspike"

/obj/item/clothing/suit/armor/f13/raider/iconoclast
	name = "iconoclast raider armor"
	desc = "A rigid armor set that appears to be fashioned from a radiation suit, or a mining suit."
	icon_state = "iconoclast"
	inhand_icon_state = "iconoclast"

/obj/item/clothing/suit/armor/f13/raider/combatduster
	name = "combat duster"
	desc = "An old military-grade pre-war combat armor under a weathered duster. It appears to be fitted with metal plates to replace the crumbling ceramic."
	icon_state = "combatduster"
	inhand_icon_state = "combatduster"

/obj/item/clothing/suit/armor/f13/raider/combatduster/patrolduster
	name = "Patrol Duster"
	desc = "What appears to be an NCR patrol ranger's armor under a green tinted duster. The armor itself looks much more well kept then the duster itself, said duster looking somewhat faded. On the back of the duster, is a symbol of a skull with an arrow piercing through the eye."
	icon_state = "patrolduster"
	inhand_icon_state = "patrolduster"

/obj/item/clothing/suit/armor/f13/exile
	name = "base faction exile armor"
	desc = "this is for testing."
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	strip_delay = 30
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_medium.dmi'
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/armor_medium.dmi'

/obj/item/clothing/suit/armor/f13/exile/ncrexile
	name = "modified NCR armor"
	desc = "A modified detoriated armor kit consisting of NCR gear and scrap metal."
	icon_state = "ncrexile"
	inhand_icon_state = "ncrexile"

/obj/item/clothing/suit/armor/f13/exile/legexile
	name = "modified Legion armor"
	desc = "A modified detoriated armor kit consisting of Legion gear and scrap metal."
	icon_state = "legexile"
	inhand_icon_state = "legexile"

/obj/item/clothing/suit/armor/f13/exile/bosexile
	name = "modified Brotherhood armor"
	desc = "A modified detoriated armor kit consisting of brotherhood combat armor and scrap metal."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_heavy.dmi'
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/armor_heavy.dmi'
	icon_state = "exile_bos"
	inhand_icon_state = "exile_bos"

/obj/item/clothing/suit/armor/f13/raider/raidercombat
	name = "combat raider armor"
	desc = "An old military-grade pre-war combat armor. It appears to be fitted with metal plates to replace the crumbling ceramic."
	icon_state = "raider_combat"
	inhand_icon_state = "raider_combat"
	armor = list(BLUNT = 30, PUNCTURE = 30, SLASH = 40, LASER = 15, ENERGY = 10, BOMB = 16, BIO = 10, RAD = 0, FIRE = 50, ACID = 0)

//Great Khan
/obj/item/clothing/suit/armor/khan_jacket
	name = "khan armored jacket"
	desc = "(IV) The symbol of the greatest pushers."
	icon_state = "khan_jacket"
	inhand_icon_state = "khan_jacket"
	armor = list("tier" = 4, ENERGY = 20, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

//Vault

/obj/item/clothing/suit/armor/f13/riot/vault
	name = "VTCC riot armour"
	desc = "(VII) A suit of riot armour adapted from the design of the pre-war U.S.M.C. armour, painted blue and white."
	icon_state = "vtcc_riot_gear"
	inhand_icon_state = "vtcc_riot_gear"
	armor = list("tier" = 7, ENERGY = 35, BOMB = 35, BIO = 40, RAD = 10, FIRE = 60, ACID = 10)


//THE GRAVEYARD
//UNUSED or LEGACY - RETAINED IN CASE DESIRED FOR ADMIN SPAWN OR REIMPLEMENATION. MAY NOT BE EVERYTHING THAT'S UNUSED. TEST BEFORE USING
//IF PUT BACK INTO USE, PLEASE FILE IT BACK SOMEWHERE ABOVE

/obj/item/clothing/suit/armor/f13/town/embroidered
	name = "embroidered trenchcoat"
	desc = "(V) A custom armored trench coat with extra-length and a raised collar. There's a flower embroidered onto the back, although the color is a little faded."
	icon_state = "towntrench_special"
	inhand_icon_state = "towntrench_special"
	armor = list("tier" = 5, ENERGY = 40, BOMB = 25, BIO = 40, RAD = 35, FIRE = 80, ACID = 0)

/obj/item/clothing/suit/armor/f13/rangercombat/eliteriot
	name = "elite riot gear"
	desc = "(VIII) A heavily reinforced set of military grade armor, commonly seen in the Divide now repurposed and reissued to Chief Rangers."
	icon_state = "elite_riot"
	inhand_icon_state = "elite_riot"
	armor = list("tier" = 8, ENERGY = 60, BOMB = 70, BIO = 60, RAD = 60, FIRE = 90, ACID = 50)
	icon = 'modular_fallout/master_files/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/armor/f13/rangercombat/desert
	name = "desert ranger combat armor"
	desc = "(VIII) This is the original armor the NCR Ranger Combat armor was based off of. An awe inspiring suit of armor used by the legendary Desert Rangers."
	icon_state = "desert_ranger"
	inhand_icon_state = "desert_ranger"
