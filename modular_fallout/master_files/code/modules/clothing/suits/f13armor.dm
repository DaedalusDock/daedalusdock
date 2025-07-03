// In this document: Light armor


/////////////////////
// DUSTERS & COATS //
/////////////////////

/obj/item/clothing/suit/armored/light/duster
	name = "duster"
	desc = "A long brown leather overcoat with discrete protective reinforcements sewn into the lining."
	icon_state = "duster"
	inhand_icon_state = "duster"
	permeability_coefficient = 0.9
	heat_protection = CHEST | GROIN
	cold_protection = CHEST | GROIN
	armor = list(BLUNT = 15, PUNCTURE = 20, SLASH = 30, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 10, RAD = 0, FIRE = 20, ACID = 5)

/obj/item/clothing/suit/armored/light/duster/lonesome
	name = "lonesome duster"
	desc = "A blue leather coat with the number 21 on the back.<br><i>If war doesn't change, men must change, and so must their symbols.</i><br><i>Even if there is nothing at all, know what you follow.</i>"
	icon_state = "duster_courier"
	inhand_icon_state = "duster_courier"
	armor = list(BLUNT = 25, PUNCTURE = 30, SLASH = 40, LASER = 25, ENERGY = 25, BOMB = 25, BIO = 5, RAD = 15, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/armored/light/duster/autumn //Based of Colonel Autumn's uniform.
	name = "tan trenchcoat"
	desc = "A heavy-duty tan trenchcoat typically worn by pre-War generals."
	icon_state = "duster_autumn"
	inhand_icon_state = "duster_autumn"
	armor = list(BLUNT = 15, PUNCTURE = 15, SLASH = 25, LASER = 20, ENERGY = 20, BOMB = 20, BIO = 5, RAD = 0, FIRE = 15, ACID = 5)

/obj/item/clothing/suit/armored/light/duster/vet
	name = "merc veteran coat"
	desc = "A blue leather coat with its sleeves cut off, adorned with war medals.<br>This type of outfit is common for professional mercenaries and bounty hunters."
	icon_state = "duster_vet"
	inhand_icon_state = "duster_vet"
	armor = list(BLUNT = 20, PUNCTURE = 20, SLASH = 30, LASER = 10, ENERGY = 10, BOMB = 20, BIO = 0, RAD = 5, FIRE = 10, ACID = 5)

/obj/item/clothing/suit/armored/light/duster/brahmin
	name = "brahmin leather duster"
	desc = "A duster made from tanned brahmin hide. It has a thick waxy surface from the processing, making it surprisingly laser resistant."
	icon_state = "duster_brahmin"
	inhand_icon_state = "duster_brahmin"
	armor = list(BLUNT = 14, PUNCTURE = 14, SLASH = 24, LASER = 25, ENERGY = 20, BOMB = 10, BIO = 5, RAD = 0, FIRE = 25, ACID = 5)

/obj/item/clothing/suit/armored/light/duster/desperado
	name = "desperado's duster"
	desc = "A dyed brahmin hide duster, with a thick waxy surface, making it less vulnerable to lasers and energy based weapons."
	icon_state = "duster_lawman"
	inhand_icon_state = "duster_lawman"


//////////////////
// KEVLAR VESTS //
//////////////////

/obj/item/clothing/suit/armored/light/vest/flak
	name = "ancient flak vest"
	desc = "Poorly maintained, this patched vest will still still stop some bullets, but don't expect any miracles. The ballistic nylon used in its construction is inferior to kevlar, and very weak to acid, but still quite tough."
	icon_state = "vest_flak"
	inhand_icon_state = "vest_flak"
	armor = list(BLUNT = 15, PUNCTURE = 30, SLASH = 40, LASER = 0, ENERGY = 0, BOMB = 15, BIO = 0, RAD = 0, FIRE = 0, ACID = -50)

/obj/item/clothing/suit/armored/light/vest/kevlar
	name = "kevlar vest"
	desc = "Worn but serviceable, the vest is is effective against ballistic impacts."
	icon_state = "vest_kevlar"
	inhand_icon_state = "vest_kevlar"
	armor = list(BLUNT = 15, PUNCTURE = 35, SLASH = 45, LASER = 5, ENERGY = 0, BOMB = 5, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armored/light/vest/bulletproof
	name = "bulletproof vest"
	desc = "This vest is in good shape, the layered kevlar lightweight yet very good at stopping bullets."
	icon_state = "vest_bullet"
	inhand_icon_state = "vest_bullet"
	armor = list(BLUNT = 30, PUNCTURE = 40, SLASH = 50, LASER = 5, ENERGY = 5, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armored/light/vest/followers
	name = "followers armor vest"
	desc = "A coat in light colors with the markings of the Followers, concealing a bullet-proof vest."
	icon_state = "vest_follower"
	inhand_icon_state = "vest_follower"
	armor = list(BLUNT = 15, PUNCTURE = 35, SLASH = 45, LASER = 5, ENERGY = 0, BOMB = 5, BIO = 10, RAD = 0, FIRE = 5, ACID = 0)


/////////////////
// MIXED ARMOR //
/////////////////

/obj/item/clothing/suit/armored/light/rustedcowboy
	name = "rusted cowboy outfit"
	desc = "A weather treated leather cowboy outfit. Yeehaw Pard'!"
	icon_state = "rusted_cowboy"
	inhand_icon_state = "rusted_cowboy"
	flags_inv = HIDEJUMPSUIT
	heat_protection = CHEST | GROIN | LEGS | ARMS
	cold_protection = CHEST | GROIN | LEGS | ARMS
	permeability_coefficient = 0.5
	armor = list(BLUNT = 25, PUNCTURE = 20, SLASH = 35, LASER = 15, ENERGY = 15, BOMB = 30, BIO = 10, RAD = 10, FIRE = 40, ACID = 10,)

/obj/item/clothing/suit/armored/light/chitinarmor
	name = "insect chitin armor"
	desc = "A suit made from gleaming insect chitin. The glittering black scales are remarkably resistant to hostile environments, except cold."
	icon_state = "insect"
	inhand_icon_state = "insect"
	flags_inv = HIDEJUMPSUIT
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	resistance_flags = FIRE_PROOF | ACID_PROOF
	siemens_coefficient = 0.5
	permeability_coefficient = 0.5
	armor = list(BLUNT = 15, PUNCTURE = 15, SLASH = 25, LASER = 20, ENERGY = 20, BOMB = 10, BIO = 50, RAD = 50, FIRE = 70, ACID = 80)

/obj/item/clothing/suit/armored/light/wastetribe
	name = "wasteland tribe armor"
	desc = "Soft armor made from layered dog hide strips glued together, with some metal bits here and there."
	icon_state = "tribal"
	inhand_icon_state = "tribal"
	flags_inv = HIDEJUMPSUIT
	armor = list(BLUNT = 25, PUNCTURE = 5, SLASH = 35, LASER = 10, ENERGY = 10, BOMB = 5, BIO = 0, RAD = 5, FIRE = 5, ACID = 0)

/obj/item/clothing/suit/armored/light/vaquero
	name = "vaquero suit"
	desc = "An ornate suit popularized by traders from the south, using tiny metal studs and plenty of silver thread wich serves as decoration and also reflects energy very well, useful when facing the desert sun or a rogue Eyebot."
	icon_state = "vaquero"
	inhand_icon_state = "vaquero"
	flags_inv = HIDEJUMPSUIT
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 1.1
	armor = list(BLUNT = 10, PUNCTURE = 10, SLASH = 20, LASER = 30, ENERGY = 25, BOMB = 5, BIO = 0, RAD = 0, FIRE = 20, ACID = 0)

/obj/item/clothing/suit/armored/light/wastewar
	name = "wasteland warrior armor"
	desc = "a mad attempt to recreate armor based of images of japanese samurai, using a sawn up old car tire as shoulder pads, bits of chain to cover the hips and pieces of furniture for a breastplate. Might stop a blade but nothing else, burns easily too."
	icon_state = "wastewar"
	inhand_icon_state = "wastewar"
	resistance_flags = FLAMMABLE
	armor = list(BLUNT = 25, PUNCTURE = 5, SLASH = 25, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = -10, ACID = 0)

// Outlaw
/obj/item/clothing/suit/toggle/armored/khanlight
	name = "great khan jacket"
	desc = "With small lead plate inserts giving some defense, the jackets and vests popular with the Great Khans show off their emblem on the back."
	icon_state = "khanjacket"
	inhand_icon_state = "khanjacket"
	armor = list(BLUNT = 30, PUNCTURE = 20, SLASH = 40, LASER = 15, ENERGY = 10, BOMB = 5, BIO = 0, RAD = 30, FIRE = 0, ACID = 5)

/obj/item/clothing/suit/armored/light/badlands
	name = "badlands raider armor"
	desc = "A leather top with a bandolier over it and a straps that cover the arms. Suited for warm climates, comes with storage space."
	icon_state = "badlands"
	inhand_icon_state = "badlands"
	pocket_storage_component_path = /datum/storage/concrete/pockets
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	armor = list(BLUNT = 25, PUNCTURE = 25, SLASH = 35, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 0, FIRE = 5, ACID = 0)

/obj/item/clothing/suit/armored/light/tribalraider
	name = "tribal raider wear"
	desc = "Very worn bits of clothing and armor in a style favored by many tribes."
	icon_state = "tribal_outcast"
	inhand_icon_state = "tribal_outcast"
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	armor = list(BLUNT = 30, PUNCTURE = 20, SLASH = 40, LASER = 15, ENERGY = 10, BOMB = 5, BIO = 0, RAD = 0, FIRE = 15, ACID = 0)

/obj/item/clothing/suit/hooded/outcast
	name = "patched heavy leather cloak"
	desc = "A robust cloak made from layered gecko skin patched with various bits of leather from dogs and other animals, able to absorb more force than one would expect from leather."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/armored_light.dmi'
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/armor_light.dmi'
	icon_state = "cloak_outcast"
	inhand_icon_state = "cloak_outcast"
	armor = list(BLUNT = 35, PUNCTURE = 20, SLASH = 45, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 20, RAD = 30, FIRE = 30, ACID = 20)
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/tribaloutcast
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/head/hooded/cloakhood/outcast
	name = "patched leather hood"
	desc = "Thick layered leather, patched together."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/hats.dmi'
	icon_state = "hood_tribaloutcast"
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/head.dmi'
	inhand_icon_state = "hood_tribaloutcast"
	armor = list(BLUNT = 35, PUNCTURE = 20, SLASH = 45, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 20, RAD = 30, FIRE = 30, ACID = 20)
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR

///////////////////
// LEATHER ARMOR //
///////////////////

/obj/item/clothing/suit/armored/light/leather
	name = "leather armor"
	desc = "Before the war motorcycle-football was one of the largest specator sports in America. This armor copies the style of armor used by the players,	using leather boiled in corn oil to make hard sheets to emulate the light weight and toughness of the original polymer armor."
	icon_state = "leather_armor"
	inhand_icon_state = "leather_armor"
	armor = list(BLUNT = 25, PUNCTURE = 20, SLASH = 40, LASER = 12, ENERGY = 5, BOMB = 5, BIO = 0, RAD = 0, FIRE = 5, ACID = 0)

// Recipe the above + 2 gecko hides
/obj/item/clothing/suit/armored/light/leathermk2
	name = "leather armor mk II"
	desc = "Armor in the motorcycle-football style, either with intact original polymer plating, or reinforced with gecko hide."
	icon_state = "leather_armor_mk2"
	inhand_icon_state = "leather_armor_mk2"
	armor = list(BLUNT = 30, PUNCTURE = 25, SLASH = 50, LASER = 12, ENERGY = 5, BOMB = 5, BIO = 0, RAD = 0, FIRE = 5, ACID = 0)

/obj/item/clothing/suit/armored/light/leathersuit
	name = "leather suit"
	desc = "Comfortable suit of tanned leather leaving one arm mostly bare. Keeps you warm and cozy."
	icon_state = "leather_suit"
	inhand_icon_state = "leather_suit"
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 0.9
	armor = list(BLUNT = 20, PUNCTURE = 15, SLASH = 30, LASER = 15, ENERGY = 5, BOMB = 5, BIO = 5, RAD = 0, FIRE = 15, ACID = 5)

/obj/item/clothing/suit/armored/light/leather_jacket
	name = "bouncer jacket"
	icon_state = "leather_jacket_fighter"
	inhand_icon_state = "leather_jacket_fighter"
	desc = "A very stylish pre-War black, heavy leather jacket. Not always a good choice to wear this the scorching sun of the desert, and one of the arms has been torn off"
	armor = list(BLUNT = 15, PUNCTURE = 5, SLASH = 25, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 5, RAD = 0, FIRE = 5, ACID = 0)

/obj/item/clothing/suit/armored/light/leather_jacketmk2
	name = "thick leather jacket"
	desc = "This heavily padded leather jacket is unusual in that it has two sleeves. You'll definitely make a fashion statement whenever, and wherever, you rumble."
	icon_state = "leather_jacket_thick"
	inhand_icon_state = "leather_jacket_thick"
	armor = list(BLUNT = 25, PUNCTURE = 10, SLASH = 35, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 15, RAD = 0, FIRE = 10, ACID = 0)

// Recipe : one of the above + a suit_fashion leather coat
/obj/item/clothing/suit/armored/light/leathercoat
	name = "thick leather coat"
	desc = "Reinforced leather jacket with a overcoat. Well insulated, creaks a lot while moving."
	icon_state = "leather_coat_fighter"
	inhand_icon_state = "leather_coat_fighter"
	siemens_coefficient = 0.8
	cold_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	armor = list(BLUNT = 25, PUNCTURE = 15, SLASH = 35, LASER = 15, ENERGY = 15, BOMB = 15, BIO = 20, RAD = 10, FIRE = 15, ACID = 5)

/obj/item/clothing/suit/armored/light/tanvest
	name = "tanned vest"
	icon_state = "tanleather"
	inhand_icon_state = "tanleather"
	desc = "Layers of leather glued together to make a stiff vest, crude but gives some protection against wild beasts and knife stabs to the liver."
	armor = list(BLUNT = 20, PUNCTURE = 5, SLASH = 30, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armored/light/cowboyvest
	name = "cowboy vest"
	icon_state = "cowboybvest"
	inhand_icon_state = "cowboybvest"
	desc = "Stylish and has discrete, thin, steel plates inserted, just in case someone brings a knife to a fistfight."
	armor = list(BLUNT = 25, PUNCTURE = 10, SLASH = 35, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 30, FIRE = 0, ACID = 0)

///////////////
// TRIBALS //
///////////////

/obj/item/clothing/suit/hooded/cloak/birdclaw
	name = "quickclaw armour"
	icon_state = "birdarmor"
	desc = "A suit of armour fashioned out of the remains of a legendary deathclaw, this one has been crafted to remove a good portion of its protection to improve on speed and trekking."
	slowdown = 0.025
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 50, LASER = 20, ENERGY = 20, BOMB = 40, BIO = 30, RAD = 20, FIRE = 50, ACID = 10)
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/birdclaw
	heat_protection = CHEST|GROIN|LEGS|ARMS|HANDS
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/hooded/cloakhood/birdclaw
	name = "quickclaw hood"
	icon_state = "hood_bird"
	desc = "A hood made of deathclaw hides, light while also being comfortable to wear, designed for speed."
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 50, LASER = 20, ENERGY = 20, BOMB = 40, BIO = 30, RAD = 20, FIRE = 50, ACID = 10)
	heat_protection = HEAD
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/hooded/cloak/deathclaw
	name = "deathclaw cloak"
	icon_state = "deathclaw"
	desc = "Made from the sinew and skin of the fearsome deathclaw, this cloak will shield its wearer from harm."
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 50, LASER = 20, ENERGY = 20, BOMB = 40, BIO = 20, RAD = 20, FIRE = 40, ACID = 10)
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/deathclaw
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/head/hooded/cloakhood/deathclaw
	name = "deathclaw cloak hood"
	icon_state = "hood_deathclaw"
	desc = "A protective and concealing hood."
	armor = list(BLUNT = 40, PUNCTURE = 30, SLASH = 50, LASER = 20, ENERGY = 20, BOMB = 40, BIO = 20, RAD = 20, FIRE = 40, ACID = 10)
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR

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

////////////
// COMBAT //
////////////

/obj/item/clothing/suit/f13/medium/combat
	name = "combat armor"
	desc = "A set of lightweight, minimalist pre-war military grade armor, this one is still in good condition."
	icon = 'modular_fallout/master_files/icons/obj/clothing/suits.dmi'
	icon_state = "combat_armor_mk2"
	inhand_icon_state = "combat_armor_mk2"
	body_parts_covered = CHEST|GROIN
	armor = list(BLUNT = 30, PUNCTURE = 40, SLASH = 50, LASER = 30, ENERGY = 15, BOMB = 30, BIO = 10, RAD = 10, FIRE = 25, ACID = 10)


/obj/item/clothing/suit/f13/medium/combat/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/armor/f13/combat/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/f13/medium/combat/dark
	name = "combat armor"
	desc = "An old military grade pre war combat armor. Now in dark, and extra-crispy!"
	color = "#514E4E"

/obj/item/clothing/suit/f13/medium/combat/mk2
	name = "reinforced combat armor"
	desc = "A set of pre-war military grade armor, this one is still in good condition, and contains additional plating to cover the arms and legs."
	icon = 'modular_fallout/master_files/icons/obj/clothing/suits.dmi'
	icon_state = "combat_armor_mk2"
	inhand_icon_state = "combat_armor_mk2"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	slowdown = 0.2
	armor = list(BLUNT = 45, PUNCTURE = 50, SLASH = 60, LASER = 30, ENERGY = 15, BOMB = 30, BIO = 10, RAD = 10, FIRE = 25, ACID = 10)

/obj/item/clothing/suit/f13/medium/combat/mk2/dark
	name = "reinforced combat armor"
	desc = "A reinforced model based of the pre-war combat armor. Now in dark, light, and smoky barbeque!"
	color = "#302E2E"

/obj/item/clothing/suit/f13/medium/combat/rusted
	name = "rusted combat armor"
	desc = "An old military grade pre war combat armor. This set has seen better days, weathered by time. The composite plates look sound and intact still."
	icon_state = "rusted_combat_armor"
	inhand_icon_state = "rusted_combat_armor"
	armor = list(BLUNT = 35, PUNCTURE = 35, SLASH = 45, LASER = 25, ENERGY = 15, BOMB = 30, BIO = 10, RAD = 10, FIRE = 25, ACID = 10)

/obj/item/clothing/suit/f13/medium/combat/swat
	name = "SWAT combat armor"
	desc = "A custom version of the pre-war combat armor, slimmed down and minimalist for domestic S.W.A.T. teams."
	icon_state = "armoralt"
	inhand_icon_state = "armoralt"
	body_parts_covered = CHEST|GROIN
	armor = list(BLUNT = 30, PUNCTURE = 50, SLASH = 60, LASER = 25, ENERGY = 15, BOMB = 30, BIO = 10, RAD = 10, FIRE = 25, ACID = 10)


////////////
// RAIDER & WASTE //
////////////

/obj/item/clothing/suit/armor/f13/medium/supafly
	name = "supa-fly raider armor"
	desc = "Fabulous mutant powers were revealed to me the day I held aloft my bumper sword and said...<br>BY THE POWER OF NUKA-COLA, I AM RAIDER MAN!"
	icon_state = "supafly"
	inhand_icon_state = "supafly"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
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

/obj/item/clothing/suit/armored/heavy/raidermetal
	name = "iron raider suit"
	desc = "More rust than metal, with gaping holes in it, this armor looks like a pile of junk. Under the rust some quality steel still remains however."
	icon_state = "raider_metal"
	inhand_icon_state = "raider_metal"
	slowdown = 0.35
	armor = list(BLUNT = 50, PUNCTURE = 40, SLASH = 60, LASER = 15, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 15, FIRE = 20, ACID = 0)

// Recipe Firesuit + metal chestplate + 50 welding fuel + 1 HQ + 1 plasteel
/obj/item/clothing/suit/armored/heavy/sulphite
	name = "sulphite raider suit"
	desc = "There are still some old asbestos fireman suits laying around from before the war. How about adding a ton of metal, plasteel and a combustion engine to one? The resulting armor is surprisingly effective at dissipating energy."
	icon_state = "sulphite"
	inhand_icon_state = "sulphite"
	slowdown = 0.5
	armor = list(BLUNT = 50, PUNCTURE = 40, SLASH = 60, LASER = 75, ENERGY = 60, BOMB = 30, BIO = 25, RAD = 30, FIRE = 95, ACID = 15)
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/armored/heavy/metal
	name = "metal armor suit"
	desc = "A suit of welded, fused metal plates. Bulky, but with great protection."
	icon_state = "raider_metal"
	inhand_icon_state = "raider_metal"
	slowdown = 0.5
	armor = list(BLUNT = 45, PUNCTURE = 45, SLASH = 55, LASER = 20, ENERGY = 20, BOMB = 30, BIO = 10, RAD = 25, FIRE = 20, ACID = 20)

/obj/item/clothing/suit/armored/heavy/recycled_power
	name = "recycled power armor"
	desc = "Taking pieces off from a wrecked power armor will at least give you thick plating, but don't expect too much of this shot up, piecemeal armor.."
	icon_state = "recycled_power"
	slowdown = 0.35
	armor = list(BLUNT = 60, PUNCTURE = 60, SLASH = 70, LASER = 20, ENERGY = 20, BOMB = 35, BIO = 5, RAD = 15, FIRE = 15, ACID = 5)

/obj/item/clothing/suit/armored/heavy/wardenplate
	name = "warden plates"
	desc = "Thick metal breastplate with a decorative skull on the shoulder."
	icon_state = "wardenplate"
	body_parts_covered = CHEST|GROIN
	slowdown = 0.25
	armor = list(BLUNT = 60, PUNCTURE = 60, SLASH = 70, LASER = 35, ENERGY = 25, BOMB = 30, BIO = 0, RAD = 15, FIRE = 10, ACID = 10)

/obj/item/clothing/suit/armored/heavy/riotpolice
	name = "riot police armor"
	icon_state = "bulletproof_heavy"
	inhand_icon_state = "bulletproof_heavy"
	desc = "Heavy armor with ballistic inserts, sewn into a padded riot police coat."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	slowdown = 0.25
	armor = list(BLUNT = 70, PUNCTURE = 45, SLASH = 80, LASER = 20, ENERGY = 20, BOMB = 45, BIO = 35, RAD = 10, FIRE = 50, ACID = 10)

/obj/item/clothing/suit/armored/heavy/salvaged_raider
	name = "raider salvaged power armor"
	desc = "A destroyed T-45b power armor has been brought back to life with the help of a welder and lots of scrap metal."
	icon_state = "raider_salvaged"
	inhand_icon_state = "raider_salvaged"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	slowdown = 0.75
	armor = list(BLUNT = 60, PUNCTURE = 65, SLASH = 75, LASER = 50, ENERGY = 40, BOMB = 40, BIO = 55, RAD = 25, FIRE = 55, ACID = 15, "wound" = 25)

/obj/item/clothing/suit/armored/heavy/salvaged_t45
	name = "salvaged T-45b power armor"
	desc = "It's a set of early-model T-45 power armor with a custom air conditioning module and stripped out servomotors. Bulky and slow, but almost as good as the real thing."
	icon_state = "t45b_salvaged"
	inhand_icon_state = "t45b_salvaged"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	slowdown = 1
	armor = list(BLUNT = 65, PUNCTURE = 70, SLASH = 80, LASER = 55, ENERGY = 45, BOMB = 45, BIO = 60, RAD = 30, FIRE = 60, ACID = 20, "wound" = 30)

/obj/item/clothing/suit/armored/medium/steelbib
	name = "steel breastplate"
	desc = "a steel breastplate inspired by a pre-war design."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	slowdown = 0.1
	armor = list(BLUNT = 40, PUNCTURE = 40, SLASH = 50, LASER = 35, ENERGY = 15, BOMB = 10, BIO = 0, RAD = 0, FIRE = 20, ACID = -10)

/obj/item/clothing/suit/armored/heavy/eliteriot
	name = "elite riot gear"
	desc = "A heavily reinforced set of military grade armor, commonly seen in the Divide now repurposed and reissued to Chief Rangers."
	icon_state = "elite_riot"
	inhand_icon_state = "elite_riot"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(BLUNT = 70, PUNCTURE = 50, SLASH = 80, LASER = 30, ENERGY = 35, BOMB = 45, BIO = 40, RAD = 30, FIRE = 50, ACID = 0)
