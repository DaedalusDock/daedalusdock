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
		EYECOLOR,
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

	breathid = "n2"
	cosmetic_organs = list(
		/obj/item/organ/snout/vox = "Vox Snout",
		/obj/item/organ/vox_hair = "None",
		/obj/item/organ/vox_hair/facial = "None",
		/obj/item/organ/tail/vox = "Vox Tail"
	)
	liked_food = MEAT | FRIED
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

	robotic_bodyparts = null

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/vox,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/vox,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/vox,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/vox,
		ORGAN_SLOT_EARS =  /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/vox,
		ORGAN_SLOT_KIDNEYS = /obj/item/organ/kidneys,
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

	equipping.open_internals(tank)

/datum/species/vox/give_important_for_life(mob/living/carbon/human/human_to_equip)
	. = ..()
	var/obj/item/I = human_to_equip.get_item_for_held_index(2)
	if(I)
		human_to_equip.open_internals(I)
	else
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

/datum/species/vox/get_species_mechanics()
	return "Oxygen is poisonous to Vox, requiring them to use respirators connected to a source of Nitrogen."

/datum/species/vox/get_species_lore()
	return list(
		"A reclusive race of tall humanoid nomads, rare to see in person. Most Vox have been observed to be highly xenophobic and unwilling to share information about their kind. \
		They possess a strong attraction to material goods, with the vast majority of known Vox being acclaimed tradesmen or pirates."
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

/datum/species/vox/get_random_blood_type()
	return GET_BLOOD_REF(/datum/blood/universal/vox)
