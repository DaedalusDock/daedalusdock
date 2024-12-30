/datum/species/human
	name = "\improper Human"
	id = SPECIES_HUMAN
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, BODY_RESIZABLE, HAIRCOLOR, FACEHAIRCOLOR)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_CAN_USE_FLIGHT_POTION,
	)
	mutant_bodyparts = list("wings" = "None")
	use_skintones = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = GROSS | RAW | CLOTH
	liked_food = JUNKFOOD | FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	job_outfit_type = SPECIES_HUMAN

/datum/species/human/prepare_human_for_preview(mob/living/carbon/human/human)
	human.hairstyle = "Business Hair"
	human.hair_color = "#bb9966" // brown
	human.update_body_parts()

/datum/species/human/get_species_mechanics()
	return "Humans possess no unique traits."

/datum/species/human/get_species_lore()
	return list(
		"Humanity. Adaptable, numerous, resiliant, and viral.",
	)

/datum/species/human/get_agony_sound(mob/living/carbon/human)
	if(human.gender == MALE)
		return pick(
			'sound/voice/human/agony/male_scream_pain1.ogg',
			'sound/voice/human/agony/male_scream_pain2.ogg',
			'sound/voice/human/agony/male_scream_pain3.ogg',
		)

	return pick(
		'sound/voice/human/agony/fem_scream_pain1.ogg',
		'sound/voice/human/agony/fem_scream_pain2.ogg',
		'sound/voice/human/agony/fem_scream_pain3.ogg',
		'sound/voice/human/agony/fem_scream_pain4.ogg',
		'sound/voice/human/agony/fem_scream_pain5.ogg',
		'sound/voice/human/agony/fem_scream_pain6.ogg',
		'sound/voice/human/agony/fem_scream_pain7.ogg',
		'sound/voice/human/agony/fem_scream_pain8.ogg',
	)

/datum/species/human/get_pain_sound(mob/living/carbon/human)
	if(human.gender == MALE)
		return pick(
			'sound/voice/human/wounded/male_moan_1.ogg',
			'sound/voice/human/wounded/male_moan_2.ogg',
			'sound/voice/human/wounded/male_moan_3.ogg',
			'sound/voice/human/wounded/male_moan_4.ogg',
			'sound/voice/human/wounded/male_moan_5.ogg',
		)

	return pick(
		'sound/voice/human/wounded/female_moan_wounded1.ogg',
		'sound/voice/human/wounded/female_moan_wounded2.ogg',
		'sound/voice/human/wounded/female_moan_wounded3.ogg',
		'sound/voice/human/wounded/female_moan_wounded4.ogg',
		'sound/voice/human/wounded/female_moan_wounded5.ogg',
	)
