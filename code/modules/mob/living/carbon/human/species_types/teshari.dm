/datum/species/teshari
	name = "\improper Teshari"
	plural_form = "Teshari"
	id = SPECIES_TESHARI
	species_traits = list(MUTCOLORS, EYECOLOR, NO_UNDERWEAR, HAIRCOLOR, FACEHAIRCOLOR)
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

	heatmod = 1.5
	coldmod = 0.67
	brutemod = 1.5
	burnmod = 1.5

	cold_level_1 = 180
	cold_level_2 = 130
	cold_level_3 = 70

	heat_level_1 = 320
	heat_level_2 = 370
	heat_level_3 = 600

	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		"Your hands and feet feel hot as your body tries to regulate heat.",
	)

	cold_discomfort_level = 180
	cold_discomfort_strings = list(
		"You feel a bit chilly.",
		"You fluff up your feathers against the cold.",
		"You move your arms closer to your body to shield yourself from the cold.",
		"You press your ears against your head to conserve heat",
		"You start to feel the cold on your skin",
	)

	cosmetic_organs = list(
		/obj/item/organ/teshari_feathers = "Plain",
		/obj/item/organ/teshari_ears = "None",
		/obj/item/organ/teshari_body_feathers = "Plain",
		/obj/item/organ/tail/teshari = "Default"
	)

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/teshari,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/teshari,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/teshari,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/teshari,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/teshari,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/teshari,
	)

	robotic_bodyparts = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/surplus/teshari,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/surplus/teshari,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/surplus/teshari,
		BODY_ZONE_R_LEG= /obj/item/bodypart/leg/right/robot/surplus/teshari,
	)

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/teshari,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS =  /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_KIDNEYS = /obj/item/organ/kidneys,
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

/datum/species/teshari/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	ADD_WADDLE(C, WADDLE_SOURCE_TESHARI)

/datum/species/teshari/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	REMOVE_WADDLE(C, WADDLE_SOURCE_TESHARI)
