/datum/augment_item/implant
	category = AUGMENT_CATEGORY_IMPLANTS
	slot = AUGMENT_SLOT_IMPLANTS
	/// What species can use this implant?
	var/list/allowed_species = list()

/datum/augment_item/implant/apply_to_human(mob/living/carbon/human/H, datum/species/S, feature_value)
	if(!feature_value) // wtf did you do
		CRASH("Tried to assign an implant without a feature value")

	var/obj/item/organ/O = new path

	H.dna.features[O.feature_key] = feature_value
	O.Insert(H, TRUE, FALSE)

/datum/augment_item/implant/can_apply_to_species(datum/species/S)
	if(S.id in allowed_species)
		return TRUE
	return FALSE

/// Return a list of sprite accessories to choose from
/datum/augment_item/implant/proc/get_choices()
	CRASH("get_choices() unimplimented on [type]")

/datum/augment_item/implant/cat_ears
	name = "Feline Ears"
	path = /obj/item/organ/ears/cat
	allowed_species = list(
		SPECIES_HUMAN
	)

/datum/augment_item/implant/cat_ears/get_choices()
	return GLOB.ears_list

/datum/augment_item/implant/cat_tail
	name = "Feline Tail"
	path = /obj/item/organ/tail/cat
	allowed_species = list(
		SPECIES_HUMAN
	)

/datum/augment_item/implant/cat_tail/get_choices()
	return GLOB.tails_list_human
