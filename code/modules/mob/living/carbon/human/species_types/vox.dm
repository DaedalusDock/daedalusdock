/datum/species/vox
	// Bird-like humanoids
	name = "Vox"
	id = SPECIES_VOX
	plural_form = "Vox"
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
		NO_UNDERWEAR,
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
	cosmetic_organs = list(
		/obj/item/organ/snout/vox = "Vox Snout",
		/obj/item/organ/vox_hair = "None",
		/obj/item/organ/vox_hair/facial = "None",
		/obj/item/organ/tail/vox = "Vox Tail"
	)
	liked_food = MEAT | FRIED
	payday_modifier = 0.75
	outfit_important_for_life = /datum/outfit/vox
	species_language_holder = /datum/language_holder/vox
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/vox,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/vox,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/vox,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/vox,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/vox,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/vox,
	)

#define VOX_BODY_COLOR "#C4DB1A" // Also in code\modules\client\preferences\species_features\vox.dm
#define VOX_SNOUT_COLOR "#E5C04B"

/datum/species/vox/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.mutant_colors[MUTCOLORS_GENERIC_1] = VOX_BODY_COLOR
	human.eye_color_right = COLOR_TEAL
	human.eye_color_left = COLOR_TEAL

	human.update_body(TRUE)

#undef VOX_BODY_COLOR
#undef VOX_SNOUT_COLOR

/datum/species/vox/pre_equip_species_outfit(datum/outfit/O, mob/living/carbon/human/equipping, visuals_only)
	if(!O)
		give_important_for_life(equipping)
		return

	var/obj/item/clothing/mask = O.mask
	if(!(mask && (initial(mask.clothing_flags) & MASKINTERNALS)))
		equipping.equip_to_slot(new /obj/item/clothing/mask/breath/vox, ITEM_SLOT_MASK, TRUE, FALSE)

	var/obj/item/tank/internals/nitrogen/belt/full/tank = new
	if(!O.r_hand)
		equipping.put_in_r_hand(tank)
	else if(!O.l_hand)
		equipping.put_in_l_hand(tank)
	else
		equipping.put_in_r_hand(tank)

	equipping.internal = tank

/datum/species/vox/give_important_for_life(mob/living/carbon/human/human_to_equip)
	. = ..()
	human_to_equip.internal = human_to_equip.get_item_for_held_index(2)
	if(!human_to_equip.internal)
		var/obj/item/tank/internals/nitrogen/belt/full/new_tank = new(null)
		if(human_to_equip.equip_to_slot_or_del(new_tank, ITEM_SLOT_BELT))
			human_to_equip.internal = human_to_equip.belt
		else
			stack_trace("Vox going without internals. Uhoh.")

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
