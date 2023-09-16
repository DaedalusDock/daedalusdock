/obj/item/organ/spines
	name = "spines"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_SPINES
	layers = list(BODY_ADJ_LAYER, BODY_BEHIND_LAYER)
	feature_key = "spines"
	render_key = "spines"
	preference = "feature_lizard_spines"
	dna_block = DNA_SPINES_BLOCK
	///A two-way reference between the tail and the spines because of wagging sprites. Bruh.
	var/obj/item/organ/tail/lizard/paired_tail

/obj/item/organ/spines/get_global_feature_list()
	return GLOB.spines_list

/obj/item/organ/spines/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
		return FALSE

/obj/item/organ/spines/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	. = ..()
	if(.)
		paired_tail = locate(/obj/item/organ/tail/lizard) in reciever.organs //We want specifically a lizard tail, so we don't use the slot.

/obj/item/organ/spines/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()
	if(paired_tail)
		paired_tail.paired_spines = null
		paired_tail = null
