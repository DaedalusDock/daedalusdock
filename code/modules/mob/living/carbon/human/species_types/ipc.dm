/datum/species/ipc
	name = "Integrated Positronic Chassis"
	id = SPECIES_IPC

	species_traits = list(NOEYESPRITES)
	inherent_traits = list(
		TRAIT_GENELESS,
		TRAIT_RADIMMUNE,
		TRAIT_CAN_STRIP,
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
	)
	job_outfit_type = SPECIES_HUMAN

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS =  /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
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
	species_traits = list(NOEYESPRITES, MUTCOLORS)
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
