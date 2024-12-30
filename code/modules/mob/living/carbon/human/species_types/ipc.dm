/datum/species/ipc
	name = "Integrated Positronic Chassis"
	id = SPECIES_IPC

	species_traits = list(NOEYESPRITES, NOBLOOD, NOZOMBIE, NO_UNDERWEAR, NO_DNA_COPY, NOTRANSSTING, AGENDER, BRANDEDPROSTHETICS)
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
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_NO_PAINSHOCK,
		TRAIT_NOSOFTCRIT,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NO_ADDICTION,
	)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID

	job_outfit_type = SPECIES_HUMAN

	species_language_holder = /datum/language_holder/ipc

	organs = list(
		ORGAN_SLOT_POSIBRAIN = /obj/item/organ/posibrain/ipc,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/robot,
		ORGAN_SLOT_CELL = /obj/item/organ/cell,
	)

	cosmetic_organs = list(
		/obj/item/organ/ipc_screen = "console",
		/obj/item/organ/ipc_antenna = "None",
	)

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/ipc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/ipc,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/ipc,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/ipc,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/ipc,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/ipc,
	)
	meat = /obj/item/stack/sheet/plasteel{amount = 5}
	skinned_type = /obj/item/stack/sheet/iron{amount = 10}

	robotic_bodyparts = null

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500		// Gives them about 25 seconds in space before taking damage
	heat_level_2 = 1000
	heat_level_3 = 2000

	heat_discomfort_level = 373.15
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)

	special_step_sounds = list('sound/effects/servostep.ogg')

	changesource_flags = NONE

/datum/species/ipc/saurian
	name = "Integrated Positronic Chassis (Jinan)"
	plural_form = "Integrated Positronic Chassis (Jinan)"
	id = SPECIES_SAURIAN
	species_traits = list(NOEYESPRITES, MUTCOLORS, NOBLOOD, NOZOMBIE, NO_UNDERWEAR, NO_DNA_COPY, NOTRANSSTING, AGENDER, EYECOLOR)
	cosmetic_organs = list(
		/obj/item/organ/saurian_screen = "basic",
		/obj/item/organ/saurian_tail = "basic",
		/obj/item/organ/saurian_scutes = "default",
		/obj/item/organ/saurian_antenna = "default"
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

/datum/species/ipc/body_temperature_core(mob/living/carbon/human/humi, delta_time, times_fired)
	humi.adjust_coretemperature(5, 0, 500)

/datum/species/ipc/spec_death(gibbed, mob/living/carbon/human/H)
	if(gibbed)
		return

	var/obj/item/organ/ipc_screen/screen = H.getorganslot(ORGAN_SLOT_EXTERNAL_IPC_SCREEN)
	if(!screen)
		return
	screen.set_sprite("None")

/datum/species/ipc/get_deathgasp_sound()
	return 'sound/voice/borg_deathsound.ogg'
