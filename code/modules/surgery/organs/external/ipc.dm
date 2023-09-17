/obj/item/organ/ipc_screen
	name = "FUCK FUCK FUCK FUCK"
	organ_flags = ORGAN_UNREMOVABLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_SCREEN
	layers = list(BODY_ADJ_LAYER)

	feature_key = "ipc_screen"
	//preference = "feature_lizard_snout"

	dna_block = DNA_IPC_SCREEN_BLOCK

/obj/item/organ/ipc_screen/get_global_feature_list()
	return GLOB.ipc_screens_list

/obj/item/organ/ipc_screen/can_draw_on_bodypart(mob/living/carbon/human/human)
	return human.is_face_visible()
