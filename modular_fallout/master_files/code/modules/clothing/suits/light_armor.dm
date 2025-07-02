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

/obj/item/clothing/suit/armored/light/duster/battlecoat
	name = "battlecoat"
	desc = "A heavy padded coat that distributes heat efficiently, designed to protect pre-War bomber pilots from anti-aircraft lasers."
	icon_state = "maxson_battlecoat"
	inhand_icon_state = "maxson_battlecoat"
	armor = list(BLUNT = 10, PUNCTURE = 10, SLASH = 20, LASER = 25, ENERGY = 25, BOMB = 10, BIO = 5, RAD = 10, FIRE = 25, ACID = 5)

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


////////////////
// ARMOR KITS //
////////////////

/obj/item/clothing/suit/armored/light/kit
	name = "armor kit"
	desc = "Separate armor parts you can wear over your clothing, giving basic protection against bullets entering some of your organs. Very well ventilated."
	icon_state = "armorkit"
	inhand_icon_state = "armorkit"
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 1.1
	armor = list(BLUNT = 15, PUNCTURE = 25, SLASH = 35, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armored/light/kit/punk
	name = "armor kit"
	desc = "A few pieces of metal strapped to protect choice parts against sudden lead poisoning. Excellent ventilation included."
	icon_state = "armorkit_punk"
	inhand_icon_state = "armorkit_punk"
	armor = list(BLUNT = 20, PUNCTURE = 20, SLASH = 30, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armored/light/kit/shoulder
	name = "armor kit"
	desc = "A single big metal shoulderplate for the right side, keeping it turned towards the enemy is advisable."
	icon_state = "armorkit_shoulder"
	inhand_icon_state = "armorkit_shoulder"
	armor = list(BLUNT = 20, PUNCTURE = 20, SLASH = 30, LASER = 7, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armored/light/kit/plates
	name = "light armor plates"
	desc = "Well-made metal plates covering your vital organs."
	icon_state = "light_plates"
	armor = list(BLUNT = 20, PUNCTURE = 25, SLASH = 35, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)


///////////////////
// LEATHER ARMOR //
///////////////////

/obj/item/clothing/suit/armored/light/leather
	name = "leather armor"
	desc = "Before the war motorcycle-football was one of the largest specator sports in America. This armor copies the style of armor used by the players,	using leather boiled in corn oil to make hard sheets to emulate the light weight and toughness of the original polymer armor."
	icon_state = "leather_armor"
	inhand_icon_state = "leather_armor"
	armor = list(BLUNT = 25, PUNCTURE = 20, SLASH = 35, LASER = 12, ENERGY = 5, BOMB = 5, BIO = 0, RAD = 0, FIRE = 5, ACID = 0)

// Recipe the above + 2 gecko hides
/obj/item/clothing/suit/armored/light/leathermk2
	name = "leather armor mk II"
	desc = "Armor in the motorcycle-football style, either with intact original polymer plating, or reinforced with gecko hide."
	icon_state = "leather_armor_mk2"
	inhand_icon_state = "leather_armor_mk2"
	armor = list(BLUNT = 30, PUNCTURE = 25, SLASH = 40, LASER = 12, ENERGY = 5, BOMB = 5, BIO = 0, RAD = 0, FIRE = 5, ACID = 0)

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
	desc = "Stylish and has discrete lead plates inserted, just in case someone brings a laser to a fistfight."
	armor = list(BLUNT = 15, PUNCTURE = 10, SLASH = 25, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 30, FIRE = 0, ACID = 0)

////////////////
// Oasis/Town//
//////////////

/obj/item/clothing/suit/armored/light/town
	name = "town trenchcoat"
	desc = "A non-descript black trenchcoat."
	icon_state = "towntrench"
	inhand_icon_state = "hostrench"
	armor = list(BLUNT = 20, PUNCTURE = 15, SLASH = 30, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 10, RAD = 0, FIRE = 20, ACID = 5)

/obj/item/clothing/suit/armored/light/town/mayor
	name = "mayor trenchcoat"
	desc = "A symbol of the mayor's authority (or lack thereof)."
	armor = list(BLUNT = 25, PUNCTURE = 20, SLASH = 35, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 10, RAD = 0, FIRE = 20, ACID = 5)

/obj/item/clothing/suit/armored/light/town/vest
	name = "Oasis flak vest"
	desc = "A refurbished flak vest, repaired by the Oasis Police Department. The ballistic nylon has a much tougher weave, but it still will not take acid or most high-powered rounds."
	icon_state = "vest_flak"
	inhand_icon_state = "vest_flak"
	armor = list(BLUNT = 10, PUNCTURE = 30, SLASH = 40, LASER = 10, ENERGY = 0, BOMB = 20, BIO = 0, RAD = 0, FIRE = 0, ACID = -50)

////////////
// LEGION //
////////////

/obj/item/clothing/suit/armored/light/legion/recruit
	name = "legion recruit armor"
	desc = "Legion recruit armor is a common light armor, clearly inspired by gear worn by old world football players and baseball catchers, much of it restored ancient actual sports equipment, other newly made from mostly leather, tanned and boiled in oil."
	icon_state = "legion_recruit"
	armor = list(BLUNT = 30, PUNCTURE = 25, SLASH = 40, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 20, RAD = 20, FIRE = 25, ACID = 0)

/obj/item/clothing/suit/armored/light/legion/prime
	name = "legion prime armor"
	desc = "It's a legion prime armor, the warrior has been granted some additional protective pieces to add to his suit."
	icon_state = "legion_prime"
	armor = list(BLUNT = 30, PUNCTURE = 30, SLASH = 40, LASER = 15, ENERGY = 15, BOMB = 25, BIO = 20, RAD = 20, FIRE = 25, ACID = 0)

/obj/item/clothing/suit/armored/light/legion/recruit/slavemaster
	name = "slavemaster armor"
	desc = "Issued to slave masters to keep them cool during long hours of watching the slaves work in the sun."
	icon_state = "legion_master"

/obj/item/clothing/suit/armored/light/legion/explorer
	name = "legion explorer armor"
	desc = "Light armor with layered strips of laminated linen and leather and worn with a large pouch for storing your binoculars."
	icon_state = "legion_explorer"
	armor = list(BLUNT = 30, PUNCTURE = 30, SLASH = 40, LASER = 15, ENERGY = 15, BOMB = 20, BIO = 20, RAD = 20, FIRE = 25, ACID = 0)
	pocket_storage_component_path = /datum/storage/concrete/pockets/binocular


/////////
// NCR //
/////////

//Recipe bulletproof vest + duster, ranger recipe
/obj/item/clothing/suit/toggle/armored/ranger_duster
	name = "ranger recon duster"
	desc = "A light bulletproof vest under a high-quality duster. Popular with Rangers."
	icon_state = "duster_recon"
	inhand_icon_state = "duster_recon"
	permeability_coefficient = 0.9
	heat_protection = CHEST | GROIN | LEGS
	cold_protection = CHEST | GROIN | LEGS
	armor = list(BLUNT = 15, PUNCTURE = 35, SLASH = 45, LASER = 10, ENERGY = 5, BOMB = 5, BIO = 10, RAD = 10, FIRE = 15, ACID = 0)

/obj/item/clothing/suit/armored/light/rangerrig
	name = "chest gear harness"
	desc = "A handmade tactical rig made of black cloth, attached to a dusty desert-colored belt. A flask and two ammo pouches hang from the belt. Very cool to move about in."
	icon_state = "r_gear_rig"
	inhand_icon_state = "r_gear_rig"
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	armor = list(BLUNT = 25, PUNCTURE = 25, SLASH = 35, LASER = 20, ENERGY = 10, BOMB = 10, BIO = 20, RAD = 10, FIRE = 25, ACID = 0)

/obj/item/clothing/suit/armored/light/trailranger
	name = "ranger vest"
	desc = "A quaint little jacket and scarf worn by NCR trail rangers."
	icon_state = "cowboyrang"
	inhand_icon_state = "cowboyrang"
	armor = list(BLUNT = 25, PUNCTURE = 25, SLASH = 35, LASER = 20, ENERGY = 10, BOMB = 10, BIO = 20, RAD = 10, FIRE = 25, ACID = 0)


///////////////
// WAYFARERS //
///////////////

/obj/item/clothing/suit/armored/light/tribal/cloak
	name = "light tribal cloak"
	desc = "A light cloak made from gecko skins and small metal plates at vital areas to give some protection, a favorite amongst scouts of the tribe."
	icon_state = "lightcloak"
	inhand_icon_state = "lightcloak"
	armor = list(BLUNT = 30, PUNCTURE = 15, SLASH = 40, LASER = 15, ENERGY = 15, BOMB = 15, BIO = 5, RAD = 15, FIRE = 25, ACID = 5)

/obj/item/clothing/suit/armored/light/tribal/simple
	name = "simple tribal armor"
	desc = "Armor made of leather strips and a large, flat piece of turquoise. The wearer is displaying the Wayfinders traditional garb."
	icon_state = "tribal_armor"
	inhand_icon_state = "tribal_armor"
	armor = list(BLUNT = 30, PUNCTURE = 10, SLASH = 40, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 5, RAD = 5, FIRE = 20, ACID = 0)

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

/obj/item/clothing/suit/hooded/cloak/razorclaw
	name = "razorclaw cloak"
	icon_state = "razorclaw"
	desc = "A suit of armour fashioned out of the remains of a legendary deathclaw."
	armor = list(BLUNT = 45, PUNCTURE = 35, SLASH = 55, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 30, RAD = 20, FIRE = 50, ACID = 10)
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/razorclaw
	heat_protection = CHEST|GROIN|LEGS|ARMS|HANDS
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/hooded/cloakhood/razorclaw
	name = "razorclaw helm"
	icon_state = "helmet_razorclaw"
	desc = "The skull of a legendary deathclaw."
	armor = list(BLUNT = 45, PUNCTURE = 35, SLASH = 55, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 30, RAD = 25, FIRE = 50, ACID = 10)
	heat_protection = HEAD
	resistance_flags = FIRE_PROOF | ACID_PROOF


///////////
// MISC. //
///////////

// Recipe winter coat + armor kit
/obj/item/clothing/suit/toggle/armored/winterkit
	name = "armored winter coat"
	desc = "Fur lined coat with armor kit bits added to it."
	icon_state = "winter_kit"
	inhand_icon_state = "winter_kit"
	resistance_flags = FLAMMABLE
	cold_protection = CHEST | GROIN | LEGS | ARMS
	armor = list(BLUNT = 15, PUNCTURE = 25, SLASH = 35, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/armored/light/mutantkit
	name = "oversized armor kit"
	desc = "Bits of armor fitted to a giant harness. Clearly not made for use by humans."
	icon_state = "mutie_armorkit"
	inhand_icon_state = "mutie_armorkit"
	heat_protection = CHEST | GROIN | LEGS| ARMS | HEAD
	siemens_coefficient = 1.1
	armor = list(BLUNT = 15, PUNCTURE = 25, SLASH = 35, LASER = 10, ENERGY = 5, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/*
// Heavy
/obj/item/clothing/suit/armor/f13/atomzealot
	name = "zealot armor"
	desc = "Praise be to Atom."
	icon_state = "atomzealot"
	inhand_icon_state = "atomzealot"
	armor = list(BLUNT = 15, PUNCTURE = 10, LASER = 30, ENERGY = 45, BOMB = 55, BIO = 65, RAD = 100, FIRE = 60, ACID = 20)

/obj/item/clothing/suit/armor/f13/atomwitch
	name = "atomic seer robes"
	desc = "Atom be praised."
	icon_state = "atomwitch"
	inhand_icon_state = "atomwitch"
	armor = list(BLUNT = 5, PUNCTURE = 10, LASER = 30, ENERGY = 45, BOMB = 55, BIO = 65, RAD = 100, FIRE = 60, ACID = 20)
*/
