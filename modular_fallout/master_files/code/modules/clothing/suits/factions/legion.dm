//////////
//LEGION//
//////////

/obj/item/clothing/suit/armor/f13/legion
	name = "legion armor template"
	desc = "should not exist. Bugreport."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_light.dmi'
	icon_state = "legrecruit"
	inhand_icon_state = "legarmor"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	allowed = list(/obj/item/gun, /obj/item/melee/onehanded, /obj/item/throwing_star/spear, /obj/item/restraints/legcuffs/bola, /obj/item/twohanded, /obj/item/melee/powered, /obj/item/melee/smith, /obj/item/melee/smith/twohand)
	armor = list("tier" = 2, ENERGY = 10, BOMB = 16, BIO = 30, RAD = 20, FIRE = 50, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/suit/armor/f13/legion/recruit
	name = "legion recruit armor"
	desc = "(II) Legion Recruits carry very basic protection, repurposed old sports gear with bits of leather and other tribal style armor that the wearer has managed to scrounge up."
	icon_state = "legion_recruit"
	inhand_icon_state = "legion_recruit"

/obj/item/clothing/suit/armor/f13/legion/prime
	name = "legion prime armor"
	desc = "(III) Legion Primes have survived some skirmishes, and when promoted often recieve a set of armor, padded leather modeled on ancient baseball catcher uniforms and various plates of metal or boiled leather."
	icon_state = "legion_prime"
	inhand_icon_state = "legion_prime"
	armor = list("tier" = 3, ENERGY = 15, BOMB = 25, BIO = 40, RAD = 20, FIRE = 60, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/vet/orator
	icon_state = "legion_orator"
	inhand_icon_state = "legion_orator"

/obj/item/clothing/suit/armor/f13/legion/prime/slavemaster
	name = "slavemaster armor"
	desc = "(III) Issued to slave masters to keep them cool during long hours of watching the slaves work in the sun."
	icon_state = "legion_master"
	inhand_icon_state = "legion_master"

/obj/item/clothing/suit/armor/f13/legion/vet
	name = "legion veteran armor"
	desc = "(IV) Armor worn by veterans, salvaged bits of enemy armor and scrap metal often reinforcing the armor."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_medium.dmi'
	icon_state = "legion_veteran"
	inhand_icon_state = "legion_veteran"
	armor = list("tier" = 4, ENERGY = 15, BOMB = 25, BIO = 50, RAD = 20, FIRE = 70, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/heavy
	name = "legion veteran decan armor"
	desc = "(V) A Legion veterans armor reinforced with a patched bulletproof vest, the wearer has the markings of a Decanus."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_heavy.dmi'
	icon_state = "legion_heavy"
	inhand_icon_state = "legion_heavy"
	armor = list("tier" = 5, ENERGY = 15, BOMB = 25, BIO = 50, RAD = 20, FIRE = 70, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/vet/explorer
	name = "legion explorer armor"
	desc = "(III) Armor based on layered strips of laminated linen and leather, the technique giving it surprising resilience for low weight."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_light.dmi'
	icon_state = "legion_explorer"
	inhand_icon_state = "legion_explorer"
	armor = list("tier" = 3, ENERGY = 15, BOMB = 25, BIO = 40, RAD = 20, FIRE = 60, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/vet/vexil
	name = "legion vexillarius armor"
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_medium.dmi'
	desc = "(IV) Worn by Vexillarius, this armor has been reinforced with circular metal plates on the chest and a back mounted pole for the flag of the Bull, making the wearer easy to see at a distance."
	icon_state = "legion_vex"
	inhand_icon_state = "legion_vex"

/obj/item/clothing/suit/armor/f13/legion/venator
	name = "legion venator armor"
	desc = "(VI) Explorer armor reinforced with metal plates and chainmail."
	icon_state = "legion-venator"
	inhand_icon_state = "legion-venator"
	armor = list("tier" = 6, ENERGY = 15, BOMB = 25, BIO = 50, RAD = 20, FIRE = 70, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/centurion
	name = "legion centurion armor"
	desc = "(VI) Every Centurion is issued some of the best armor available in the Legion, and adds better pieces from slain opponents over time."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_heavy.dmi'
	icon_state = "legion_centurion"
	inhand_icon_state = "legion_centurion"
	armor = list("tier" = 6, ENERGY = 35, BOMB = 39, BIO = 60, RAD = 20, FIRE = 80, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/palacent
	name = "paladin-slayer centurion armor"
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_medium.dmi'
	desc = "(VI) A Centurion able to defeat a Brotherhood Paladin gets the honorific title 'Paladin-Slayer', and adds bits of the looted armor to his own."
	icon_state = "legion_palacent"
	inhand_icon_state = "legion_palacent"
	armor = list("tier" = 6, ENERGY = 35, BOMB = 39, BIO = 60, RAD = 20, FIRE = 80, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/rangercent
	name = "ranger-hunter centurion armor"
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_medium.dmi'
	desc = "(V) Centurions who have led many patrols and ambushes against NCR Rangers have a distinct look from the many looted pieces of Ranger armor, and are often experienced in skirmishing."
	icon_state = "legion_rangercent"
	inhand_icon_state = "legion_rangercent"
	armor = list("tier" = 5, ENERGY = 35, BOMB = 39, BIO = 60, RAD = 20, FIRE = 80, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/legate
	name = "legion legate armor"
	desc = "(VIII) Made by the most skilled blacksmiths in Arizona, the bronzed steel of this rare armor offers good protection, and the scars on its metal proves it has seen use on the field."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_heavy.dmi'
	icon_state = "legion_legate"
	inhand_icon_state = "legion_legate"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	armor = list("tier" = 8, ENERGY = 40, BOMB = 45, BIO = 60, RAD = 20, FIRE = 80, ACID = 0)

/obj/item/clothing/suit/armor/f13/combat/legion
	name = "Legion combat armor"
	desc = "(V) Pre-war military style armor, patched and missing some parts. Modified and repainted to declare the user a fighter for Caesar's Legion."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_medium.dmi'
	icon_state = "legion_combat"
	inhand_icon_state = "legion_combat"

/obj/item/clothing/suit/armor/f13/combat/mk2/legion
	name = "reinforced Legion combat armor"
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_medium.dmi'
	desc = "(VI) Pre-war military style armor, a full set with bracers and reinforcements. Modified and repainted to declare the user a fighter for Caesar's Legion."
	icon_state = "legion_combat2"
	inhand_icon_state = "legion_combat2"

/obj/item/clothing/suit/armor/f13/slavelabor
	name = "old leather strips"
	desc = "Worn leather strips, used as makeshift protection from chafing and sharp stones by labor slaves."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/suits_utility.dmi'
	icon_state = "legion_slaveleather"
	inhand_icon_state = "legion_slaveleather"


/*
/obj/item/clothing/suit/armor/f13/legion/vet/orator
	name = "legion orator armor"
	desc = "(VI) The armor appears to be based off of a suit of Legion veteran armor, with the addition of bracers, a chainmail skirt, and large pauldrons.  A tabard emblazoned with the bull is loosely draped over the torso."
	icon_state = "legheavy"
	armor = list("tier" = 6, ENERGY = 15, BOMB = 25, BIO = 50, RAD = 20, FIRE = 70, ACID = 0)

/obj/item/clothing/suit/armor/f13/legion/palacent/custom_excess
	name = "Champion of Kanab's Armor"
	desc = "(VI) The armor of the Champion and Conqueror of the city in Utah named Kanab. The armor is made up of pieces of Power Armor and pre-war Riot Gear, the shin guards are spraypainted a dark crimson and the Power Armour pauldron has a red trim. The symbol of a Pheonix is carefully engraved and painted upon the chest piece... I wonder what it means.."
	icon_state = "palacent_excess"
	inhand_icon_state = "palacent_excess"
*/
