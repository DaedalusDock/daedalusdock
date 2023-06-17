/obj/item/organ/snout
	name = "snout"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_SNOUT
	layers = list(BODY_ADJ_LAYER)

	feature_key = "snout"
	preference = "feature_lizard_snout"
	external_bodytypes = BODYTYPE_SNOUTED

	dna_block = DNA_SNOUT_BLOCK

/obj/item/organ/snout/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.wear_mask?.flags_inv & HIDESNOUT) && !(human.head?.flags_inv & HIDESNOUT))
		return TRUE
	return FALSE

/obj/item/organ/snout/get_global_feature_list()
	return GLOB.snouts_list

///Guess what part of the vox is this?
/obj/item/organ/snout/vox
	name = "beak"
	feature_key = "vox_snout"

	external_bodytypes = BODYTYPE_VOX_BEAK
	dna_block = DNA_VOX_SNOUT_BLOCK

	color_source = ORGAN_COLOR_STATIC
	draw_color = "#E5C04B"

/obj/item/organ/snout/vox/get_global_feature_list()
	return GLOB.vox_snouts_list
