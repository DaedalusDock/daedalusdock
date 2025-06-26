// In this document: Medium armor

///////////////
// WASTELAND //
///////////////

/obj/item/clothing/suit/f13/medium/bone
	name = "bone armor"
	desc = "Primitive armor made from animal bones and sinew. Rattles when walking. Hard for critters to bite through and fire to burn."
	icon_state = "bone"
	inhand_icon_state = "bone"
	armor = list(BLUNT = 45, PUNCTURE = 10, SLASH = 55, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 0, RAD = 5, FIRE = 25, ACID = 0)

// Kevlar
/obj/item/clothing/suit/f13/medium/vestarmor
	name = "armored vest"
	desc = "Large bulletproof vest with ballistic plates."
	icon_state = "vest_armor"
	inhand_icon_state = "vest_armor"
	armor = list(BLUNT = 15, PUNCTURE = 45, SLASH = 55, LASER = 10, ENERGY = 10, BOMB = 30, BIO = 0, RAD = 0, FIRE = 5, ACID = -5)

/obj/item/clothing/suit/f13/medium/vestchinese
	name = "chinese flak vest"
	desc = "An uncommon suit of pre-war Chinese armor. It's a very basic and straightforward piece of armor that covers the front of the user."
	icon_state = "vest_chicom"
	inhand_icon_state = "vest_chicom"
	armor = list(BLUNT = 20, PUNCTURE = 35, SLASH = 45, LASER = 5, ENERGY = 5, BOMB = 25, BIO = 0, RAD = 0, FIRE = 0, ACID = -10)

// Plated medium armor
/obj/item/clothing/suit/f13/medium/scrapchest
	name = "scrap metal chestplate"
	desc = "Various metal bits welded together to form a crude chestplate."
	icon_state = "metal_chestplate"
	inhand_icon_state = "metal_chestplate"
	siemens_coefficient = 1.3
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 50, LASER = 15, ENERGY = 15, BOMB = 30, BIO = 0, RAD = 5, FIRE = 10, ACID = 0)
	slowdown = 0.125

/obj/item/clothing/suit/f13/medium/scrapchest/reinforced
	name = "reinforced metal chestplate"
	desc = "Various metal bits welded together to form a crude chestplate, with extra bits of metal top of the first layer. Heavy."
	icon_state = "metal_chestplate2"
	inhand_icon_state = "metal_chestplate2"
	armor = list(BLUNT = 40, PUNCTURE = 35, SLASH = 50, LASER = 20, ENERGY = 15, BOMB = 30, BIO = 0, RAD = 5, FIRE = 10, ACID = 0)

/obj/item/clothing/suit/f13/medium/brokencombat
	name = "broken combat armor chestpiece"
	desc = "It's barely holding together, but the plates might still work, you hope."
	icon_state = "combat_chestpiece"
	inhand_icon_state = "combat_chestpiece"
	armor = list(BLUNT = 20, PUNCTURE = 20, SLASH = 30, LASER = 15, ENERGY = 10, BOMB = 20, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/f13/medium/steelbib
	name = "steel breastplate"
	desc = "a steel breastplate inspired by a pre-war design. It provides some protection against impacts, cuts, and medium-velocity bullets. It's pressed steel construction feels heavy."
	icon_state = "steel_bib"
	inhand_icon_state = "steel_bib"
	armor = list(BLUNT = 25, PUNCTURE = 25, SLASH = 35, LASER = 30, ENERGY = 10, BOMB = 5, BIO = 0, RAD = 0, FIRE = 20, ACID = -10)
	slowdown = 0.11

// Combat armor
/obj/item/clothing/suit/f13/medium/combat
	name = "combat armor"
	desc = "Military grade pre-war combat armor."
	icon_state = "combat_armor"
	inhand_icon_state = "combat_armor"
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 50, LASER = 30, ENERGY = 20, BOMB = 25, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/f13/medium/combat/dark
	name = "combat armor"
	desc = "An old military grade pre war combat armor. Now in dark, and extra-crispy!"
	color = "#514E4E"

/obj/item/clothing/suit/f13/medium/combat/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/armor/f13/combat/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/f13/medium/combat/mk2
	name = "reinforced combat armor"
	desc = "(VI) A reinforced set of bracers, greaves, and torso plating of prewar design. This one is kitted with additional plates."
	icon = 'modular_fallout/master_files/icons/obj/clothing/suits.dmi'
	icon_state = "combat_armor_mk2"
	inhand_icon_state = "combat_armor_mk2"
	armor = list("tier" = 6, ENERGY = 45, BOMB = 55, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)

/obj/item/clothing/suit/f13/medium/combat/mk2/dark
	name = "reinforced combat armor"
	desc = "A reinforced model based of the pre-war combat armor. Now in dark, light, and smoky barbeque!"
	color = "#302E2E"

/obj/item/clothing/suit/f13/medium/combat/swat
	name = "SWAT combat armor"
	desc = "(V) A custom version of the pre-war combat armor, slimmed down and minimalist for domestic S.W.A.T. teams."
	icon_state = "armoralt"
	inhand_icon_state = "armoralt"
	armor = list("tier" = 5, ENERGY = 45, BOMB = 55, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)

/obj/item/clothing/suit/f13/medium/combat/chinese
	name = "chinese combat armor"
	desc = "(IV) An uncommon suit of pre-war Chinese combat armor. It's a very basic and straightforward piece of armor that covers the front of the user."
	icon_state = "chicom_armor"
	inhand_icon_state = "chicom_armor"
	armor = list("tier" = 4, ENERGY = 40, BOMB = 60, BIO = 0, RAD = 0, FIRE = 0, ACID = 10)

/obj/item/clothing/suit/f13/medium/combatrusted
	name = "rusted combat armor"
	desc = "(V) An old military grade pre war combat armor. This set has seen better days, weathered by time. The composite plates look sound and intact still."
	icon_state = "rusted_combat_armor"
	inhand_icon_state = "rusted_combat_armor"
	armor = list("tier" = 5, ENERGY = 38, BOMB = 48, BIO = 58, RAD = 10, FIRE = 58, ACID = 18)

/obj/item/clothing/suit/f13/medium/combat/environmental
	name = "environmental armor"
	desc = "(V) A pre-war suit developed for use in heavily contaminated environments, and is prized in the Wasteland for its ability to protect against biological threats."
	icon_state = "environmental_armor"
	inhand_icon_state = "environmental_armor"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.9
	permeability_coefficient = 0.5
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list("tier" = 5,ENERGY = 45, BOMB = 55, BIO = 70, RAD = 100, FIRE = 60, ACID = 50)
	strip_delay = 60
	equip_delay_other = 60
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/f13/medium/combat/environmental/Initialize()
	. = ..()
	AddComponent(/datum/component/rad_insulation, RAD_NO_INSULATION, TRUE, FALSE)

/obj/item/clothing/suit/f13/medium/combat/mk2/raider
	name = "raider combat armor"
	desc = "(IV) An old set of reinforced combat armor with some parts supplanted with painspike armor. It seems less protective than a mint-condition set of combat armor."
	armor = list("tier" = 4, ENERGY = 35, BOMB = 45, BIO = 30, RAD = 5, FIRE = 50, ACID = 35)
	icon_state = "combat_armor_raider"
	inhand_icon_state = "combat_armor_raider"

//recipe any combat armor + duster
/obj/item/clothing/suit/f13/medium/combat/duster
	name = "combat duster"
	desc = "Refurbished combat armor under a weathered duster. Simple metal plates replace the ceramic plates that has gotten damaged."
	icon_state = "combatduster"
	inhand_icon_state = "combatduster"
	permeability_coefficient = 0.9
	heat_protection = CHEST | GROIN | LEGS
	cold_protection = CHEST | GROIN | LEGS
	armor = list(BLUNT = 30, PUNCTURE = 35, SLASH = 45, LASER = 30, ENERGY = 20, BOMB = 25, BIO = 10, RAD = 15, FIRE = 25, ACID = 10)

/obj/item/clothing/suit/f13/medium/combat/swat
	name = "SWAT combat armor"
	desc = "A custom version of the pre-war combat armor, slimmed down and minimalist for domestic S.W.A.T. teams."
	icon_state = "armoralt"
	inhand_icon_state = "armoralt"
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 50, LASER = 25, ENERGY = 15, BOMB = 30, BIO = 10, RAD = 10, FIRE = 25, ACID = 10)

/obj/item/clothing/suit/f13/medium/combat/rusted
	name = "rusted combat armor"
	desc = "Weathered set of combat armor, it has clearly seen use for a long time by various previous owners, judging by the patched holes. The composite plates are a little cracked but it should still work. Probably."
	icon_state = "combat_rusted"
	inhand_icon_state = "combat_rusted"
	armor = list(BLUNT = 35, PUNCTURE = 30, SLASH = 45, LASER = 25, ENERGY = 15, BOMB = 20, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/f13/medium/combat/mk2
	name = "reinforced combat armor"
	desc = "A reinforced set of bracers, greaves, and torso plating of prewar design. This one is kitted with additional plates."
	icon_state = "combat_armor_mk2"
	inhand_icon_state = "combat_armor_mk2"
	armor = list(BLUNT = 35, PUNCTURE = 40, SLASH = 50, LASER = 35, ENERGY = 20, BOMB = 30, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/f13/medium/combat/mk2/raider
	name = "painspike combat armor"
	desc = "Take one set of combat armor, add a classic suit of painspike armor, forget hugging your friends ever again."
	icon_state = "combat_painspike"
	inhand_icon_state = "combat_painspike"

////////////
// OUTLAW //
////////////

/obj/item/clothing/suit/armor/f13/medium/supafly
	name = "supa-fly raider armor"
	desc = "Fabulous mutant powers were revealed to me the day I held aloft my bumper sword and said...<br>BY THE POWER OF NUKA-COLA, I AM RAIDER MAN!"
	icon_state = "supafly"
	inhand_icon_state = "supafly"
	armor = list(BLUNT = 25, PUNCTURE = 40, SLASH = 50, LASER = 20, ENERGY = 10, BOMB = 20, BIO = 0, RAD = 0, FIRE = 25, ACID = 25)

/obj/item/clothing/suit/armor/f13/medium/rebel
	name = "rebel raider armor"
	desc = "Rebel, rebel. Your face is a mess."
	icon_state = "raider_rebel_icon"
	inhand_icon_state = "raider_rebel_armor"
	armor = list(BLUNT = 25, PUNCTURE = 30, SLASH = 40, LASER = 20, ENERGY = 20, BOMB = 40, BIO = 0, RAD = 0, FIRE = 25, ACID = 20)

/obj/item/clothing/suit/armor/f13/medium/sadist
	name = "sadist raider armor"
	desc = "A bunch of metal chaps adorned with severed hands at the waist with a leather plate worn on the left shoulder. Very intimidating."
	icon_state = "sadist"
	inhand_icon_state = "sadist"
	armor = list(BLUNT = 30, PUNCTURE = 25, SLASH = 40, LASER = 25, ENERGY = 25, BOMB = 30, BIO = 0, RAD = 0, FIRE = 15, ACID = 5)

/obj/item/clothing/suit/armor/f13/medium/blastmaster
	name = "blastmaster raider armor"
	desc = "A suit composed largely of blast plating, though there's so many holes it's hard to say if it will protect against much."
	icon_state = "blastmaster"
	inhand_icon_state = "blastmaster"
	flash_protect = 2
	armor = list(BLUNT = 25, PUNCTURE = 25, SLASH = 35, LASER = 20, ENERGY = 25, BOMB = 60, BIO = 0, RAD = 0, FIRE = 50, ACID = 25)

/obj/item/clothing/suit/armor/f13/medium/yankee
	name = "yankee raider armor"
	desc = "A set of armor made from bulky plastic and rubber. A faded sports team logo is printed in various places. Go Desert Rats!"
	icon_state = "yankee"
	inhand_icon_state = "yankee"
	armor = list(BLUNT = 40, PUNCTURE = 20, SLASH = 50, LASER = 15, ENERGY = 15, BOMB = 30, BIO = 0, RAD = 0, FIRE = 25, ACID = 25)

/obj/item/clothing/suit/armor/f13/medium/painspike
	name = "painspike raider armor"
	desc = "A particularly unhuggable armor, even by raider standards. Extremely spiky."
	icon_state = "painspike"
	inhand_icon_state = "painspike"
	armor = list(BLUNT = 40, PUNCTURE = 25, SLASH = 50, LASER = 10, ENERGY = 5, BOMB = 5, BIO = 0, RAD = 0, FIRE = 25, ACID = 5)

/obj/item/clothing/suit/armor/f13/medium/iconoclast
	name = "iconoclast raider armor"
	desc = "A rigid armor set that appears to be fashioned from a radiation suit, or a mining suit."
	icon_state = "iconoclast"
	inhand_icon_state = "iconoclast"
	permeability_coefficient = 0.8
	armor = list(BLUNT = 25, PUNCTURE = 30, SLASH = 40, LASER = 25, ENERGY = 30, BOMB = 30, BIO = 40, RAD = 60, FIRE = 25, ACID = 40)

/obj/item/clothing/suit/armor/f13/medium/khancoat
	name = "khan battlecoat"
	desc = "Affluent pushers can affort fancy coats with a lot of metal and ceramic plates stuffed inside."
	icon_state = "khanbattle"
	inhand_icon_state = "khanbattle"
	armor = list(BLUNT = 35, PUNCTURE = 25, SLASH = 45, LASER = 15, ENERGY = 20, BOMB = 20, BIO = 5, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/armor/f13/medium/ncrexile
	name = "modified NCR armor"
	desc = "A modified detoriated armor kit consisting of NCR gear and scrap metal."
	icon_state = "ncrexile"
	inhand_icon_state = "ncrexile"
	armor = list(BLUNT = 30, PUNCTURE = 35, SLASH = 45, LASER = 30, ENERGY = 25, BOMB = 30, BIO = 20, RAD = 20, FIRE = 15, ACID = 0)

/obj/item/clothing/suit/f13/medium/legexile
	name = "modified Legion armor"
	desc = "A modified detoriated armor kit consisting of Legion gear and scrap metal."
	icon_state = "legexile"
	inhand_icon_state = "legexile"
	armor = list(BLUNT = 45, PUNCTURE = 30, SLASH = 55, LASER = 20, ENERGY = 15, BOMB = 30, BIO = 25, RAD = 20, FIRE = 35, ACID = 0)

/// END OUTLAW

/obj/item/clothing/suit/f13/medium/duster_renegade
	name = "renegade duster"
	desc = "Metal armor worn under a stylish duster. For the bad boy who wants to look good while commiting murder."
	icon_state = "duster-renegade"
	inhand_icon_state = "duster-renegade"
	armor = list(BLUNT = 20, PUNCTURE = 35, SLASH = 45, LASER = 30, ENERGY = 25, BOMB = 20, BIO = 5, RAD = 10, FIRE = 25, ACID = 5)

/obj/item/clothing/suit/f13/medium/slam
	name = "slammer raider armor"
	desc = "Crude armor using a premium selection of sawn up tires and thick layers of filthy cloth to give that murderous hobo look.<br>Come on and slam and turn your foes to jam! Pretty warm, but it is made of very flammable stuff. It's probably fine."
	icon_state = "slam"
	inhand_icon_state = "slam"
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 0.9
	armor = list(BLUNT = 45, PUNCTURE = 20, SLASH = 55, LASER = 0, ENERGY = 0, BOMB = 40, BIO = 10, RAD = 10, FIRE = -25, ACID = 0)

/obj/item/clothing/suit/armored/medium/scrapcombat
	name = "scrap combat armor"
	desc = "Scavenged military combat armor, repaired by unskilled hands many times, most of the original plating having cracked or crumbled to dust."
	icon_state = "raider_combat"
	inhand_icon_state = "raider_combat"
	armor = list(BLUNT = 35, PUNCTURE = 25, SLASH = 45, LASER = 15, ENERGY = 10, BOMB = 15, BIO = 0, RAD = 0, FIRE = 10, ACID = 5)


////////////
// LEGION //
////////////

/obj/item/clothing/suit/armored/medium/forgemaster
	name = "forgemaster armor"
	desc = "Legion armor reinforced with metal, worn with a Forgemaster apron with the bull insignia over it."
	icon_state = "opifex_apron"
	inhand_icon_state = "opifex_apron"
	blood_overlay_type = "armor"
	armor = list(BLUNT = 45, PUNCTURE = 30, SLASH = 55, LASER = 20, ENERGY = 20, BOMB = 30, BIO = 5, RAD = 10, FIRE = 45, ACID = 10)

/obj/item/clothing/suit/armored/medium/vet
	name = "legion veteran armor"
	desc = "Armor worn by veteran legionaries who have proven their combat prowess in many battles, its hardened leather is sturdier than that of previous ranks."
	icon_state = "legion_veteran"
	armor = list(BLUNT = 45, PUNCTURE = 30, SLASH = 55, LASER = 20, ENERGY = 15, BOMB = 30, BIO = 5, RAD = 5, FIRE = 35, ACID = 0)
	slowdown = 0.075

/obj/item/clothing/suit/armored/medium/vexil
	name = "legion vexillarius armor"
	desc = "The armor appears to be based off of a suit of Legion veteran armor, with the addition of circular metal plates attached to the torso, as well as a banner displaying the flag of the Legion worn on the back."
	icon_state = "legion_vex"
	armor = list(BLUNT = 45, PUNCTURE = 35, SLASH = 55, LASER = 25, ENERGY = 20, BOMB = 35, BIO = 5, RAD = 5, FIRE = 35, ACID = 0)
	slowdown = 0.075

/obj/item/clothing/suit/armored/medium/combat/legion
	name = "Legion combat armor"
	desc = "An old military grade pre war combat armor and, repainted to the colour scheme of Caesar's Legion."
	icon_state = "legion_combat"
	inhand_icon_state = "legion_combat"
	armor = list(BLUNT = 35, PUNCTURE = 35, SLASH = 45, LASER = 30, ENERGY = 20, BOMB = 25, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)



/////////
// NCR //
/////////

/obj/item/clothing/suit/armored/medium/ncrarmor
	name = "NCR armor vest"
	desc = "A standard issue NCR Infantry armor vest."
	icon_state = "ncr_infantry_vest"
	inhand_icon_state = "ncr_infantry_vest"
	armor = list(BLUNT = 15, PUNCTURE = 35, SLASH = 45, LASER = 15, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 5, ACID = 0)

/obj/item/clothing/suit/armored/medium/ncrarmormant
	name = "NCR mantle vest"
	desc = "A standard issue NCR Infantry vest with a mantle on the shoulder."
	icon_state = "ncr_standard_mantle"
	inhand_icon_state = "ncr_standard_mantle"
	armor = list(BLUNT = 15, PUNCTURE = 35, SLASH = 45, LASER = 15, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 10, ACID = 5)

/obj/item/clothing/suit/armored/medium/ncrarmorreinf
	name = "NCR reinforced armor vest"
	desc = "A standard issue NCR Infantry vest reinforced with a groinpad."
	icon_state = "ncr_reinforced_vest"
	inhand_icon_state = "ncr_reinforced_vest"
	armor = list(BLUNT = 20, PUNCTURE = 40, SLASH = 50, LASER = 15, ENERGY = 10, BOMB = 15, BIO = 0, RAD = 0, FIRE = 5, ACID = 0)

/obj/item/clothing/suit/armored/medium/ncrarmormantreinf
	name = "NCR reinforced mantle vest"
	desc = "A standard issue NCR Infantry vest reinforced with a groinpad and a mantle."
	icon_state = "ncr_reinforced_mantle"
	inhand_icon_state = "ncr_reinforced_mantle"
	armor = list(BLUNT = 20, PUNCTURE = 40, SLASH = 50, LASER = 15, ENERGY = 10, BOMB = 15, BIO = 0, RAD = 0, FIRE = 10, ACID = 5)

/obj/item/clothing/suit/armored/medium/ncrarmorofficer
	name = "NCR officer armor vest"
	desc = "A reinforced set of NCR mantle armour, with added padding on the groin, neck and shoulders. Intended for use by the officer class."
	icon_state = "ncr_lt_armour"
	inhand_icon_state = "ncr_lt_armour"
	armor = list(BLUNT = 25, PUNCTURE = 45, SLASH = 45, LASER = 15, ENERGY = 10, BOMB = 20, BIO = 0, RAD = 0, FIRE = 10, ACID = 5)

/obj/item/clothing/suit/armored/medium/ncrarmorofficer/captain
	name = "NCR captain´s armor"
	desc = "The captain gets to wear a non-regulation coat over his armor because he is in charge, and don't you forget it."
	icon_state = "ncr_officer_coat"
	inhand_icon_state = "ncr_officer_coat"

/obj/item/clothing/suit/armored/medium/combat/ncr
	name = "NCR combat armor"
	desc = "Combat armor painted in the khaki of the New California Republic, displaying its flag on the chest."
	icon_state = "ncr_armor"
	inhand_icon_state = "ncr_armor"
	armor = list(BLUNT = 35, PUNCTURE = 35, SLASH = 45, LASER = 15, ENERGY = 20, BOMB = 25, BIO = 10, RAD = 10, FIRE = 15, ACID = 10)

/obj/item/clothing/suit/armored/medium/ncrarmorcolonel
	name = "NCR colonels armor"
	desc = "A heavily reinforced set of NCR mantle armour, ceramic inserts protects the vital organs quite well. Used by high ranking NCR officers in dangerous zones."
	icon_state = "ncr_captain_armour"
	inhand_icon_state = "ncr_captain_armour"
	armor = list(BLUNT = 45, PUNCTURE = 45, SLASH = 55, LASER = 40, ENERGY = 40, BOMB = 45, BIO = 40, RAD = 45, FIRE = 45, ACID = 20)

/obj/item/clothing/suit/armored/medium/combat/ncrranger
	name = "ranger patrol armor"
	desc = "The standard issue ranger patrol armor is based on pre-war combat armor design, and has similar capabilities."
	icon_state = "ncr_patrol"
	inhand_icon_state = "ncr_patrol"
	armor = list(BLUNT = 35, PUNCTURE = 35, SLASH = 45, LASER = 30, ENERGY = 20, BOMB = 25, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/armored/medium/combat/vetranger
	name = "veteran ranger combat armor"
	desc = "The NCR veteran ranger combat armor, or black armor consists of a pre-war L.A.P.D. riot suit under a duster with rodeo jeans. Considered one of the most prestigious suits of armor to earn and wear while in service of the NCR Rangers."
	icon_state = "ranger"
	inhand_icon_state = "ranger"
	armor = list(BLUNT = 45, PUNCTURE = 45, SLASH = 55, LASER = 30, ENERGY = 25, BOMB = 25, BIO = 10, RAD = 20, FIRE = 35, ACID = 10)


//////////////////////////
// BROTHERHOOD OF STEEL //
//////////////////////////

/obj/item/clothing/suit/armored/medium/combat/bos
	name = "initiate armor"
	desc = "An old military grade pre war combat armor, repainted to the colour scheme of the Brotherhood of Steel."
	icon_state = "brotherhood_armor"
	inhand_icon_state = "brotherhood_armor"
	armor = list(BLUNT = 35, PUNCTURE = 35, SLASH = 45, LASER = 30, ENERGY = 20, BOMB = 25, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/armored/medium/combatmk2/bos
	name = "reinforced initiate armor"
	desc = "A reinforced set of bracers, greaves, and torso plating of prewar design This one is kitted with additional plates and, repainted to the colour scheme of the Brotherhood of Steel."
	icon_state = "brotherhood_armor_mk2"
	inhand_icon_state = "brotherhood_armor_mk2"
	armor = list(BLUNT = 35, PUNCTURE = 40, SLASH = 50, LASER = 35, ENERGY = 20, BOMB = 30, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/armored/medium/combatmk2/knight
	name = "brotherhood armor"
	desc = "(V) A combat armor set made by the Brotherhood of Steel, standard issue for all Knights. It bears a red stripe."
	icon_state = "brotherhood_armor_knight"
	inhand_icon_state = "brotherhood_armor_knight"
	armor = list(BLUNT = 35, PUNCTURE = 40, SLASH = 50, LASER = 40, ENERGY = 30, BOMB = 30, BIO = 10, RAD = 20, FIRE = 25, ACID = 10)

/obj/item/clothing/suit/armored/medium/combatmk2/senknight
	name = "brotherhood senior knight armor"
	desc = "(VI) A combat armor set made by the Brotherhood of Steel, standard issue for all Senior Knight. It bears a silver stripe."
	icon_state = "brotherhood_armor_senior"
	inhand_icon_state = "brotherhood_armor_senior"
	armor = list(BLUNT = 40, PUNCTURE = 40, SLASH = 50, LASER = 40, ENERGY = 30, BOMB = 30, BIO = 10, RAD = 25, FIRE = 25, ACID = 10)

/obj/item/clothing/suit/armored/medium/combatmk2/headknight
	name = "brotherhood knight-captain armor"
	desc = "(VI) A combat armor set made by the Brotherhood of Steel, standard issue for all Knight-Captains. It bears golden embroidery."
	icon_state = "brotherhood_armor_captain"
	inhand_icon_state = "brotherhood_armor_captain"
	armor = list(BLUNT = 40, PUNCTURE = 40, SLASH = 50, LASER = 40, ENERGY = 30, BOMB = 30, BIO = 15, RAD = 25, FIRE = 30, ACID = 15)

////////////////
// OASIS/TOWN //
////////////////

/obj/item/clothing/suit/armored/medium/lawcoat
	name = "deputy trenchcoat"
	desc = "An armored trench coat with added shoulderpads, a chestplate, and leg guards."
	icon_state = "towntrench_medium"
	inhand_icon_state = "hostrench"
	armor = list(BLUNT = 40, PUNCTURE = 40, SLASH = 50, LASER = 30, ENERGY = 25, BOMB = 30, BIO = 30, RAD = 30, FIRE = 40, ACID = 5)

/obj/item/clothing/suit/armored/medium/lawcoat/sheriff
	name = "sheriff trenchcoat"
	desc = "A trenchcoat which does a poor job at hiding the full-body combat armor beneath it."
	icon_state = "towntrench_heavy"
	armor = list(BLUNT = 45, PUNCTURE = 45, SLASH = 55, LASER = 35,  ENERGY = 40, BOMB = 30, BIO = 40, RAD = 40, FIRE = 50, ACID = 10)

/obj/item/clothing/suit/armored/medium/lawcoat/commissioner
	name = "commissioner's jacket"
	desc = "A navy-blue jacket with blue shoulder designations, '/OPD/' stitched into one of the chest pockets, and hidden ceramic trauma plates. It has a small compartment for a holdout pistol."
	icon_state = "warden_alt"
	inhand_icon_state = "armor"
	armor = list(BLUNT = 40, PUNCTURE = 60, SLASH = 70, LASER = 30,  ENERGY = 35, BOMB = 30, BIO = 40, RAD = 40, FIRE = 50, ACID = 10)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/holdout

/obj/item/clothing/suit/armored/medium/steelbib/town
	name = "steel breastplate"
	desc = "a steel breastplate inspired by a pre-war design, this one was made locally in Oasis. It uses a stronger steel alloy in it's construction, still heavy though"
	armor = list(BLUNT = 30, PUNCTURE = 35, SLASH = 45, LASER = 35, ENERGY = 15, BOMB = 10, BIO = 0, RAD = 0, FIRE = 20, ACID = -10)
	slowdown = 0.11

///////////////
// WAYFARERS //
///////////////

/obj/item/clothing/suit/armored/medium/combat/tribal
	name = "tribal combat armor"
	desc = "Military grade pre war combat armor, now decorated with sinew and the bones of the hunted for its new wearer."
	icon_state = "tribecombatarmor"
	inhand_icon_state = "tribecombatarmor"
	armor = list(BLUNT = 35, PUNCTURE = 35, SLASH = 45, LASER = 30, ENERGY = 20, BOMB = 25, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)


////////////
// CUSTOM //
////////////

/obj/item/clothing/suit/armored/medium/combat/cloak_armored
	name = "armored cloak"
	desc = "A dark cloak worn over protective plating."
	icon_state = "cloak_armored"
	inhand_icon_state = "cloak_armored"
	armor = list(BLUNT = 25, PUNCTURE = 35, SLASH = 45, LASER = 20, ENERGY = 15, BOMB = 20, BIO = 5, RAD = 10, FIRE = 25, ACID = 5)

/obj/item/clothing/suit/armored/medium/scrapchest/mutant
	name = "mutant armour"
	desc = "Metal plates rigged to fit the frame of a super mutant. Maybe he's the big iron with a ranger on his hip?"
	icon_state = "mutie_heavy_metal"
	inhand_icon_state = "mutie_heavy_metal"
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 50, LASER = 15, ENERGY = 15, BOMB = 30, BIO = 0, RAD = 5, FIRE = 10, ACID = 0)
	slowdown = 0.1
	allowed = list(/obj/item/gun, /obj/item/melee/onehanded, /obj/item/twohanded, /obj/item/melee/smith, /obj/item/melee/smith/twohand)

/obj/item/clothing/suit/armored/medium/motorball
	name = "motorball suit"
	desc = "Reproduction motorcycle-football suit, made in vault 75 that was dedicated to a pure sports oriented culture."
	icon_state = "motorball"
	inhand_icon_state = "motorball"
	armor = list(BLUNT = 40, PUNCTURE = 25, SLASH = 50, LASER = 15, ENERGY = 15, BOMB = 10, BIO = 0, RAD = 0, FIRE = 40, ACID = 10)

//THE GRAVEYARD
//IF PUT BACK INTO USE, PLEASE FILE IT BACK SOMEWHERE ABOVE

/*

/obj/item/clothing/suit/armored/medium/lawcoat/mayor
	name = "mayor trenchcoat"
	desc = "A symbol of the mayor's authority (or lack thereof)."
	armor = list(BLUNT = 40, PUNCTURE = 35, LASER = 30, ENERGY = 40, BOMB = 30, BIO = 40, RAD = 40, FIRE = 40, ACID = 0)

//Enclave/Remnants

/obj/item/clothing/suit/armor/f13/combat/enclave
	name = "enclave combat armor"
	desc = "A set of matte black advanced pre-war combat armor."
	icon_state = "enclave_new"
	inhand_icon_state = "enclave_new"
	armor = list(BLUNT = 35, PUNCTURE = 40, LASER = 35, ENERGY = 20, BOMB = 30, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/armor/f13/enclave/armorvest
	name = "armored vest"
	desc = "Efficient prewar design issued to Enclave personell."
	icon_state = "armor_enclave_peacekeeper"
	inhand_icon_state = "armor_enclave_peacekeeper"
	armor = list(BLUNT = 35, PUNCTURE = 50, LASER = 30, ENERGY = 30, BOMB = 10, BIO = 0, RAD = 0, FIRE = 10, ACID = 0)

/obj/item/clothing/suit/armor/f13/enclave/officercoat
	name = "armored coat"
	desc = "Premium prewar armor fitted into a coat for Enclave officers."
	icon_state = "armor_enclave_officer"
	inhand_icon_state = "armor_enclave_officer"
	armor = list(BLUNT = 60, PUNCTURE = 45, ENERGY = 40, BOMB = 10, BIO = 0, RAD = 0, FIRE = 10, ACID = 0)
*/
