/datum/augment_item/implant
	category = AUGMENT_CATEGORY_IMPLANTS
	slot = AUGMENT_SLOT_IMPLANTS
	/// What species can use this implant?
	var/list/allowed_species = list()

/datum/augment_item/implant/apply_to_human(mob/living/carbon/human/H, datum/species/S)
	if(!H.client?.prefs)
		return

	var/feature = H.client.prefs.read_preference(/datum/preference/blob/augments)[AUGMENT_SLOT_IMPLANTS][type]
	if(!feature) // wtf did you do
		return

	var/obj/item/organ/O = new path

	H.dna.features[O.feature_key] = feature
	O.Insert(H, TRUE)

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

