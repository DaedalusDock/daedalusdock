/datum/species/vox
	// Bird-like humanoids
	name = "Vox"
	id = SPECIES_VOX
	say_mod = "skrees"
	scream_verb = "shrieks"
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
		/obj/item/organ/external/vox_hair = "None",
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
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/vox,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/vox,
	)

#define VOX_BODY_COLOR "#C4DB1A" // Also in code\modules\client\preferences\species_features\vox.dm
#define VOX_SNOUT_COLOR "#E5C04B"
#define VOX_HAIR_COLOR "#997C28"

/datum/species/vox/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = VOX_BODY_COLOR
	human.dna.features["mcolor2"] = VOX_SNOUT_COLOR
	human.hair_color = VOX_HAIR_COLOR
	human.eye_color = COLOR_TEAL

	var/obj/item/organ/external/vox_hair/hair = human.internal_organs_slot[ORGAN_SLOT_EXTERNAL_VOX_HAIR]
	hair.set_sprite("Vox Short Quills")
	var/obj/item/organ/external/vox_facial_hair/facial_hair = human.internal_organs_slot[ORGAN_SLOT_EXTERNAL_VOX_FACIAL_HAIR]
	facial_hair.set_sprite("None")

	human.update_body(TRUE)

#undef VOX_BODY_COLOR
#undef VOX_SNOUT_COLOR
#undef VOX_HAIR_COLOR

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
	return "'The Vox' refers to, in most sectors, the most commonly seen type: Vox Primalis. A peculiar hybrid of reptilian and avian characteristics hailing from massive space vessels often known as Arkships. \
		Most work with utter loyalty to their creators, the Vox Auralis, though some have been known to reject it entirely and try to shape their own lives, but this is an uncommon occurrence. \
		Either way, regardless of their loyalty to their creators, Vox are condemned to an eternity of life so long as their stack exists and can be placed in a new gene form, \
		and the pigmented serial upon them will always be a reminder of their artificial origins."

/datum/species/vox/get_species_lore()
	return list(
		"The Vox hail from massive, planetoid-like ships known simply as Arks. They drift silently through the universe, and have seemingly existed since before the rise of most space-faring species of the modern era. \
		Each Primalis is created with a pre-determined destiny in mind, a function that they will fulfill until the end of their body's lifetime, whereupon they have their cortical stack extracted and implanted into a new larval form. \
		This new body will grow into the Vox according to the encoded genetic data, preserving the skills and recreating a body best fitting for their function.",

		"Historically, the Arks have been mostly silent to the majority of species, beyond the occasional garbled warning about approaching, or the smallest of trades and exchanges. \
		This has changed in recent years, with several Arkships opening communications with Nanotrasen, with discussions behind closed doors. \
		One of the first long-term deals with the Vox came in the form of a charity named Val-Biotechnica, created and sponsored by Nanotrasen. Using advanced Vox bio-technology to provide healthcare and genetic therapy at low to no cost.",

		"Conspiracy theorists have suggested that this Vox charity is a guise for kidnappings and harvestings, though Nanotrasen denies all claims, as does Val-Biotechnica. \
		A labor deal was also reached, allowing Ark-Vox to work for Nanotrasen, which can be difficult for those Vox now having to adjust to the inorganic nature of non-Vox technology. \
		Their presence brings some conflict between Ark-Vox and the Free-Vox who have fled from their creators and their homes, living in places such as The Shoal, or any station that will accept them. \
		Nanotrasen Public Relations takes great care in assuring the public that everything is fine, and that they're working in perfect harmony.",
	)

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
			SPECIES_PERK_DESC = "Vox have their organs heavily modified to resist the coldness of space.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "EMP Sensitivity",
			SPECIES_PERK_DESC = "Due to their organs being synthetic, they are susceptible to EMPs.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Nitrogen Breathing",
			SPECIES_PERK_DESC = "Vox must breathe nitrogen to survive. You receive a tank when you arrive.",
		),
	)

	return to_add
