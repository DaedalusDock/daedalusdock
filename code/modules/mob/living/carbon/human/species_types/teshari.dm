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
	attack_verb = "slash"
	attack_effect = ATTACK_EFFECT_CLAW
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'

	meat = /obj/item/food/meat/slab/chicken
	liked_food = MEAT
	disliked_food = GRAIN | GROSS

	payday_modifier = 0.75
	punchdamagehigh = 6
	heatmod = 1.5
	coldmod = 0.67
	brutemod = 1.5
	burnmod = 1.5
	bodytemp_normal = BODYTEMP_NORMAL - 15 // 22°C
	bodytemp_heat_damage_limit = BODYTEMP_HEAT_DAMAGE_LIMIT - 32 // 35°C max
	bodytemp_cold_damage_limit = BODYTEMP_COLD_DAMAGE_LIMIT - 30 // -33°C min

	external_organs = list(
		/obj/item/organ/external/teshari_feathers = "Plain",
		/obj/item/organ/external/teshari_ears = "None",
		/obj/item/organ/external/teshari_body_feathers = "Plain",
		/obj/item/organ/external/tail/teshari = "Default"
	)
	mutantlungs = /obj/item/organ/lungs/teshari

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/teshari,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/teshari,
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/teshari,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/teshari,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/teshari,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/teshari,
	)

#define TESH_BODY_COLOR "#DEB887" // Also in code\modules\client\preferences\species_features\teshari.dm
#define TESH_FEATHER_COLOR "#996633"

/datum/species/teshari/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = TESH_BODY_COLOR
	human.hair_color = TESH_FEATHER_COLOR

	var/obj/item/organ/external/teshari_feathers/head_feathers = human.internal_organs_slot[ORGAN_SLOT_EXTERNAL_TESHARI_FEATHERS]
	head_feathers.set_sprite("Plain")
	var/obj/item/organ/external/teshari_body_feathers/body_feathers = human.internal_organs_slot[ORGAN_SLOT_EXTERNAL_TESHARI_BODY_FEATHERS]
	body_feathers.set_sprite("None")
	var/obj/item/organ/external/teshari_ears/ears = human.internal_organs_slot[ORGAN_SLOT_EXTERNAL_TESHARI_EARS]
	ears.set_sprite("None")
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
