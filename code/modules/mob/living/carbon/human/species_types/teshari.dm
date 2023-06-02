/datum/species/teshari
	name = "\improper Teshari"
	plural_form = "Teshari"
	id = SPECIES_TESHARI
	species_traits = list(MUTCOLORS, MUTCOLORS2, MUTCOLORS3, EYECOLOR, NO_UNDERWEAR, HAS_FLESH, HAS_BONE, HAIRCOLOR, FACEHAIRCOLOR)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/teshari
	species_eye_path = 'icons/mob/species/teshari/eyes.dmi'

	fallback_clothing_path = 'icons/mob/clothing/species/teshari/fallback.dmi'
	offset_features = list(
		OFFSET_EARS = list(0, -4),
		OFFSET_FACEMASK = list(0, -5),
		OFFSET_HEAD = list(0, -4),
		OFFSET_BELT = list(0, -4),
		OFFSET_BACK = list(0, -4),
		OFFSET_ACCESSORY = list(0, -3))

	species_mob_size = MOB_SIZE_SMALL
	say_mod = "chirps"

	meat = /obj/item/food/meat/slab/chicken
	liked_food = MEAT
	disliked_food = GRAIN | GROSS

	payday_modifier = 0.75
	heatmod = 1.5
	coldmod = 0.67
	brutemod = 1.5
	burnmod = 1.5
	bodytemp_normal = BODYTEMP_NORMAL - 15 // 22°C
	bodytemp_heat_damage_limit = BODYTEMP_HEAT_DAMAGE_LIMIT - 32 // 35°C max
	bodytemp_cold_damage_limit = BODYTEMP_COLD_DAMAGE_LIMIT - 30 // -33°C min

	cosmetic_organs = list(
		/obj/item/organ/teshari_feathers = "Plain",
		/obj/item/organ/teshari_ears = "None",
		/obj/item/organ/teshari_body_feathers = "Plain",
		/obj/item/organ/tail/teshari = "Default"
	)
	mutantlungs = /obj/item/organ/lungs/teshari

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/teshari,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/teshari,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/teshari,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/teshari,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/teshari,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/teshari,
	)

#define TESH_BODY_COLOR "#DEB887" // Also in code\modules\client\preferences\species_features\teshari.dm
#define TESH_FEATHER_COLOR "#996633"

/datum/species/teshari/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.mutant_colors[MUTCOLORS_GENERIC_1] = TESH_BODY_COLOR
	human.hair_color = TESH_FEATHER_COLOR
	human.update_body(TRUE)

#undef TESH_BODY_COLOR
#undef TESH_FEATHER_COLOR

/datum/species/teshari/get_scream_sound(mob/living/carbon/human/human)
	return 'sound/voice/raptor_scream.ogg'

/datum/species/teshari/random_name(gender, unique, lastname)
	if(unique)
		return random_unique_teshari_name()
	return teshari_name()

/datum/species/teshari/get_species_description()
	return "The Teshari are a species of social, pack-based raptor-like nomadic aliens, hailing from the planet of Esmerini, or Penelope's Star VII (7), \
	a cold jungle planet full of precursor and archotechnology just outside the Goldilocks zone of their system. While still a relatively young species, \
	the Teshari have become a recent part of spacefaring species, thanks in part to efforts by the Orion Commonwealth to uplift them, \
	trading the snow-filled trees and frozen tundra for warmer ships and orbital installations."

/datum/species/teshari/get_species_lore()
	return list(
		"WIP"
	)

/datum/species/teshari/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	ADD_WADDLE(C, WADDLE_SOURCE_TESHARI)

/datum/species/teshari/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	REMOVE_WADDLE(C, WADDLE_SOURCE_TESHARI)
