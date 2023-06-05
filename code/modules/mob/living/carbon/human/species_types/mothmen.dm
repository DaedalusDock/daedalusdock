/datum/species/moth
	name = "\improper Gamuioda"
	plural_form = "Gamuioda"
	id = SPECIES_MOTH
	say_mod = "flutters"
	scream_verb = "buzzes"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS, LIPS, HAS_FLESH, HAS_BONE, HAS_MARKINGS, BODY_RESIZABLE, NONHUMANHAIR)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_ANTENNAE,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("moth_markings" = "None")
	cosmetic_organs = list(/obj/item/organ/wings/moth = "Plain", /obj/item/organ/antennae = "Plain")
	meat = /obj/item/food/meat/slab/human/mutant/moth
	species_eye_path = 'icons/mob/species/moth/eyes.dmi'
	liked_food = VEGETABLES | DAIRY | CLOTH
	disliked_food = FRUIT | GROSS
	toxic_food = MEAT | RAW | SEAFOOD
	mutanteyes = /obj/item/organ/eyes/moth
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/moth
	wings_icons = list("Megamoth", "Mothra")
	has_innate_wings = TRUE
	payday_modifier = 0.75
	job_outfit_type = SPECIES_HUMAN
	family_heirlooms = list(/obj/item/flashlight/lantern/heirloom_moth)

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/moth,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/moth,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/moth,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/moth,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/moth,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/moth,
	)

/datum/species/moth/regenerate_organs(mob/living/carbon/C, datum/species/old_species, replace_current= TRUE, list/excluded_zones, visual_only)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		handle_mutant_bodyparts(H)

/datum/species/moth/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_moth_name()

	var/randname = moth_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/moth/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	. = ..()
	if(chem.type == /datum/reagent/toxin/pestkiller)
		H.adjustToxLoss(3 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)

/datum/species/moth/check_species_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/melee/flyswatter))
		return 10 //flyswatters deal 10x damage to moths
	return 1

/datum/species/moth/randomize_main_appearance_element(mob/living/carbon/human/human_mob)
	var/wings = pick(GLOB.moth_wings_list)
	mutant_bodyparts["wings"] = wings
	mutant_bodyparts["moth_wings"] = wings
	human_mob.dna.features["wings"] = wings
	human_mob.dna.features["moth_wings"] = wings
	human_mob.update_body()

/datum/species/moth/get_scream_sound(mob/living/carbon/human/human)
	return 'sound/voice/moth/scream_moth.ogg'

/datum/species/moth/get_species_description()
	return "The Gamuioda, also known as Mothpeople in various sectors due to their appearance, are a species hailing from the planet Paraco in the Orion Spur. \
		The Gamuioda are a large part of labour within various space stations and shuttles, providing materials, fuel, parts, and produce."

/datum/species/moth/get_species_lore()
	return list(
		"The native language of Gamuioda is referred to as 'Gamuid' by their population. However, 'Moffic' is used as an exonym among other species.",

		"Written transcripts of Gamuioda history remain largely untranslated to modern Gamuid, that most of the populace knows. \
		However, more recent transcripts detail the progress of Gamuioda working to accelerate the process of first contact - to get in touch with extra-terrestrials. \
		There is a long history of research and scientific development done by Gamuioda, with lower-class Gamuioda focusing on providing materials and other needed produce for upper-class researchers to utilize in advancements.",

		"Upon meeting other lifeforms outside of their planet, notably Humans, the Gamuioda would begin to offer their population as a labor force for stations, ships, and other facilities requiring employment. \
		There wasn't a fixed paycheck at first for moths when they first began work. This led to an economic crisis and a huge spike in inflation on their homeworld when converting credits into their currency, the Posis, \
		With some careful consideration, Gamuioda working on Nanotrasen facilities are paid 20% less than most, and are given a weekly lamp to supplement the unpaid money. \
		This has pleased 98% of surveyed moths, including the upper class.",

		"The working, lower, and upper classes of Gamuioda are scattered across their homeworld of Paraco, including other under-studied planets, with the wealthy more focused on settling down in rain forests, primarily to take shelter in tall trees. \
		The variety in weather and temperature endemic to Paraco has given rise to a vast amount of clothing styles, with a key focus on embroidered designs on cloth, \
		though most often those working on stations and other facilities wear heavy-duty equipment or their assigned uniforms.",
	)

/datum/species/moth/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "feather-alt",
			SPECIES_PERK_NAME = "Precious Wings",
			SPECIES_PERK_DESC = "Gamuioda can fly in pressurized, zero-g environments and safely land short falls using their wings.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "tshirt",
			SPECIES_PERK_NAME = "Meal Plan",
			SPECIES_PERK_DESC = "Gamuioda can eat clothes for nourishment.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "fire",
			SPECIES_PERK_NAME = "Ablazed Wings",
			SPECIES_PERK_DESC = "Gamuioda wings are fragile, and can be easily burnt off.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "sun",
			SPECIES_PERK_NAME = "Bright Lights",
			SPECIES_PERK_DESC = "Gamuioda need an extra layer of flash protection to protect \
				themselves, such as against security officers or when welding. Welding \
				masks will work.",
		),
	)

	return to_add

/datum/species/moth/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.mutant_colors[MUTCOLORS_GENERIC_1] = "#f4d697"
	human.update_body(TRUE)
