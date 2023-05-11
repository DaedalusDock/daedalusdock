/obj/item/organ/external/skrell_headtails
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HEADTAILS
	layers = list(BODY_FRONT_LAYER, BODY_ADJ_LAYER)

	dna_block = DNA_HEADTAILS_BLOCK

	feature_key = "headtails"
	preference = "feature_headtails"

	color_source = ORGAN_COLOR_HAIR

/obj/item/organ/external/skrell_headtails/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/external/skrell_headtails/get_global_feature_list()
	return GLOB.headtails_list
