/obj/item/organ/external/vox_hair
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_VOX_HAIR
	layers = EXTERNAL_FRONT|EXTERNAL_ADJACENT

	dna_block = DNA_VOX_HAIR_BLOCK

	feature_key = "vox_hair"
	preference = "feature_vox_hair"

	color_source = ORGAN_COLOR_HAIR
	//draw_color = "#997C28"

/obj/item/organ/external/vox_hair/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/external/vox_hair/get_global_feature_list()
	return GLOB.vox_hair_list

/obj/item/organ/external/vox_hair/facial
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_VOX_FACIAL_HAIR
	layers = EXTERNAL_FRONT|EXTERNAL_ADJACENT

	dna_block = DNA_VOX_FACIAL_HAIR_BLOCK

	feature_key = "vox_facial_hair"
	preference = "feature_vox_facial_hair"

/obj/item/organ/external/vox_hair/facial/get_global_feature_list()
	return GLOB.vox_facial_hair_list
