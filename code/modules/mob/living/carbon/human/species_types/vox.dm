/datum/species/vox
	// Bird-like humanoids
	name = "Vox"
	id = SPECIES_VOX
	say_mod = "skrees"
	default_color = "#1e5404"
	species_eye_path = 'icons/mob/species/vox/eyes.dmi'
	species_traits = list(
		MUTCOLORS,
		MUTCOLORS2,
		MUTCOLORS3,
		EYECOLOR,
		HAS_FLESH,
		HAS_BONE,
		HAIRCOLOR,
		FACEHAIRCOLOR,
	)
	inherent_traits = list(
		TRAIT_RESISTCOLD,
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_CAN_USE_FLIGHT_POTION,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutantlungs = /obj/item/organ/lungs/vox
	mutantbrain = /obj/item/organ/brain/vox
	mutantheart = /obj/item/organ/heart/vox
	mutanteyes = /obj/item/organ/eyes/vox
	mutantliver = /obj/item/organ/liver/vox
	breathid = "n2"
	mutant_bodyparts = list(
		"tail_vox" = "Vox Tail",
		"spines_vox" = "None"
	)
	external_organs = list(
		/obj/item/organ/external/snout/vox = "Vox Snout",
		/obj/item/organ/external/vox_hair = "Vox Afro",
		/obj/item/organ/external/vox_facial_hair = "None")
	attack_verb = "slash"
	attack_effect = ATTACK_EFFECT_CLAW
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT | FRIED
	payday_modifier = 0.75
	outfit_important_for_life = /datum/outfit/vox
	species_language_holder = /datum/language_holder/vox
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/vox,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/vox,
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/vox,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/vox,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/digitigrade/vox,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/digitigrade/vox,
	)

/datum/species/vox/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = "#99FF99"
	human.dna.features["mcolor2"] = "#F0F064"
	human.hair_color = "#FF9966"
	human.facial_hair_color = "#FF9966"
	human.eye_color = COLOR_TEAL
	human.update_body(TRUE)

/datum/species/vox/pre_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only)
	. = ..()
	var/datum/outfit/vox/O = new /datum/outfit/vox
	equipping.equipOutfit(O, visuals_only)
	equipping.internal = equipping.get_item_for_held_index(2)
	equipping.update_internals_hud_icon(1)

/datum/species/vox/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_vox_name()

	var/randname = vox_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/vox/get_species_description()
	return ""

/datum/species/vox/get_species_lore()
	return list("")

/datum/species/vox/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	var/real_tail_type = C.dna.features["tail_vox"]
	var/real_spines = C.dna.features["spines_vox"]

	. = ..()

	if(pref_load)
		C.dna.features["tail_vox"] = real_tail_type
		C.dna.features["spines_vox"] = real_spines

		var/obj/item/organ/tail/vox/new_tail = new /obj/item/organ/tail/vox()

		new_tail.tail_type = C.dna.features["tail_vox"]
		new_tail.spines = C.dna.features["spines_vox"]

		// organ.Insert will qdel any existing organs in the same slot, so
		// we don't need to manage that.
		new_tail.Insert(C, TRUE, FALSE)

/datum/species/vox/get_scream_sound(mob/living/carbon/human/vox)
	return 'sound/voice/vox/shriek1.ogg'

/datum/species/vox/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "temperature-low",
			SPECIES_PERK_NAME = "Cold Resistance",
			SPECIES_PERK_DESC = "Voxes have their organs heavily modified to resist the coldness of space",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "EMP Sensitivity",
			SPECIES_PERK_DESC = "Due to their organs being synthetic, they are susceptible to emps.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Nitrogen Breathing",
			SPECIES_PERK_DESC = "Voxes must breathe nitrogen to survive. You receive a tank when you arrive.",
		),
	)

	return to_add
