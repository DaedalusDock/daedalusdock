/datum/species/ipc
	name = "Integrated Positronic Chassis"
	id = SPECIES_IPC

	species_traits = list(NOEYESPRITES, NOBLOOD, NOZOMBIE, NO_UNDERWEAR, NO_DNA_COPY, NOTRANSSTING, AGENDER)
	inherent_traits = list(
		TRAIT_GENELESS,
		TRAIT_RADIMMUNE,
		TRAIT_CAN_STRIP,
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
		TRAIT_NOEARS,
		TRAIT_NOMETABOLISM,
	)

	job_outfit_type = SPECIES_HUMAN

	organs = list(
		ORGAN_SLOT_POSIBRAIN = /obj/item/organ/posibrain/ipc,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/robot,
	)

	cosmetic_organs = list(
		/obj/item/organ/ipc_screen = "console",
	)

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/ipc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/ipc,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/ipc,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/ipc,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/ipc,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/ipc,
	)


/datum/species/ipc/saurian
	name = "Saurian"
	id = SPECIES_SAURIAN
	species_traits = list(NOEYESPRITES, MUTCOLORS, NOBLOOD, NOZOMBIE, NO_UNDERWEAR, NO_DNA_COPY, NOTRANSSTING, AGENDER)
	cosmetic_organs = list(
		/obj/item/organ/saurian_screen = "basic",
		/obj/item/organ/saurian_tail = "basic"
	)
	examine_limb_id = SPECIES_IPC

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/ipc/saurian,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/ipc/saurian,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/ipc/saurian,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/ipc/saurian,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/ipc/saurian,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/ipc/saurian,
	)

/datum/species/ipc/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	. = ..()
	if(H.stat == UNCONSCIOUS && prob(2) && H.undergoing_cardiac_arrest())
		H.visible_message("<b>[H]</b> [pick("emits low pitched whirr","beeps urgently")]")

/datum/species/ipc/get_cryogenic_factor(bodytemperature)
	return 0
