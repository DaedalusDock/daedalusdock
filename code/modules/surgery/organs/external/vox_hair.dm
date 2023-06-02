/obj/item/organ/vox_hair
	name = "head quills"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_VOX_HAIR
	layers = list(BODY_ADJ_LAYER)

	dna_block = DNA_VOX_HAIR_BLOCK

	feature_key = "vox_hair"
	preference = "feature_vox_hair"

	color_source = ORGAN_COLOR_HAIR
	//draw_color = "#997C28"

/obj/item/organ/vox_hair/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/vox_hair/get_global_feature_list()
	return GLOB.vox_hair_list

/obj/item/organ/vox_hair/facial
	name = "facial quills"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_VOX_FACIAL_HAIR
	layers = list(BODY_ADJ_LAYER)

	dna_block = DNA_VOX_FACIAL_HAIR_BLOCK

	feature_key = "vox_facial_hair"
	preference = "feature_vox_facial_hair"

	color_source = ORGAN_COLOR_HAIR

/obj/item/organ/vox_hair/facial/get_global_feature_list()
	return GLOB.vox_facial_hair_list
