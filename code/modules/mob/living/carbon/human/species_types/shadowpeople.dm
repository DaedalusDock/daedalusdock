/datum/species/shadow
	// Humans cursed to stay in the darkness, lest their life forces drain. They regain health in shadow and die in light.
	name = "\improper Shadow"
	plural_form = "Shadowpeople"
	id = SPECIES_SHADOW
	sexes = 0
	meat = /obj/item/food/meat/slab/human/mutant/shadow
	species_traits = list(NOBLOOD,NOEYESPRITES)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBREATH,
	)
	inherent_factions = list("faithless")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	species_language_holder = /datum/language_holder/shadowpeople

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/shadow,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/shadow,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/shadow,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/shadow,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/shadow,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/shadow,
	)

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = null,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS =  /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_KIDNEYS = /obj/item/organ/kidneys,
	)

/datum/species/shadow/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	var/turf/T = H.loc
	if(istype(T))
		var/light_amount = T.get_lumcount()

		if(light_amount > SHADOW_SPECIES_LIGHT_THRESHOLD) //if there's enough light, start dying
			H.take_overall_damage(0.5 * delta_time, 0.5 * delta_time, BODYTYPE_ORGANIC)
		else if (light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD) //heal in the dark
			H.heal_overall_damage(0.5 * delta_time, 0.5 * delta_time, BODYTYPE_ORGANIC)

/datum/species/shadow/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return ..()

/datum/species/shadow/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "moon",
			SPECIES_PERK_NAME = "Shadowborn",
			SPECIES_PERK_DESC = "Their skin blooms in the darkness. All kinds of damage, \
				no matter how extreme, will heal over time as long as there is no light.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "eye",
			SPECIES_PERK_NAME = "Nightvision",
			SPECIES_PERK_DESC = "Their eyes are adapted to the night, and can see in the dark with no problems.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "sun",
			SPECIES_PERK_NAME = "Lightburn",
			SPECIES_PERK_DESC = "Their flesh withers in the light. Any exposure to light is \
				incredibly painful for the shadowperson, charring their skin.",
		),
	)

	return to_add
