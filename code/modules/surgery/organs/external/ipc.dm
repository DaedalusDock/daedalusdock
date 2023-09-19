/obj/item/organ/ipc_screen
	name = "ipc screen"
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_SCREEN
	layers = list(BODY_ADJ_LAYER)

	feature_key = "ipc_screen"
	preference = "ipc_screen"

	dna_block = DNA_IPC_SCREEN_BLOCK

/obj/item/organ/ipc_screen/get_global_feature_list()
	return GLOB.ipc_screens_list

/obj/item/organ/ipc_screen/can_draw_on_bodypart(mob/living/carbon/human/human)
	return human.is_face_visible()

/obj/item/organ/ipc_antenna
	name = "ipc antenna"
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_ANTENNA
	layers = list(BODY_ADJ_LAYER)

	feature_key = "ipc_antenna"
	preference = "ipc_antenna"

	dna_block = DNA_IPC_ANTENNA_BLOCK
	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_IPC_ANTENNA

/obj/item/organ/ipc_antenna/get_global_feature_list()
	return GLOB.ipc_antenna_list

/obj/item/organ/saurian_screen
	name = "saurian ipc screen"
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_SCREEN
	layers = list(BODY_ADJ_LAYER)

	feature_key = "saurian_screen"
	//preference = "feature_lizard_snout"

	dna_block = DNA_SAURIAN_SCREEN_BLOCK
	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_GENERIC

/obj/item/organ/saurian_screen/get_global_feature_list()
	return GLOB.saurian_screens_list

/obj/item/organ/saurian_screen/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.wear_mask?.flags_inv & HIDESNOUT) && !(human.head?.flags_inv & HIDESNOUT))
		return TRUE
	return FALSE

/obj/item/organ/saurian_screen/build_overlays(physique, image_dir)
	. = ..()

	for(var/image_layer in layers)
		var/state2use = build_icon_state(physique, image_layer)

		if(!icon_exists(sprite_datum.icon, "[state2use]_secondary", FALSE))
			continue
		var/image/secondary = image(sprite_datum.icon, "[state2use]_secondary")
		secondary.color = mutcolors[MUTCOLORS_GENERIC_2]
		. += secondary

	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	var/image/I = image(sprite_datum.icon, "eyes", layer = -EYE_LAYER)
	I.color = H.eye_color_left
	. += I
	. += emissive_appearance(sprite_datum.icon, "eyes", -EYE_LAYER)

/obj/item/organ/saurian_tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon_state = "severedtail"
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_EXTERNAL_TAIL
	layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)
	feature_key = "saurian_tail"
	dna_block = DNA_SAURIAN_TAIL_BLOCK

/obj/item/organ/saurian_tail/get_global_feature_list()
	return GLOB.saurian_tails_list
