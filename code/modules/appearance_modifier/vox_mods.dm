/datum/appearance_modifier/vox_tail_mark
	name = "Error! (Vox Tail Mark)"
	abstract_type = /datum/appearance_modifier/vox_tail_mark

	icon2use = 'icons/mob/appearancemods/vox_spines.dmi'

	species_can_use = list(SPECIES_VOX)
	eorgan_slots_affected = list(ORGAN_SLOT_EXTERNAL_TAIL)


/datum/appearance_modifier/vox_tail_mark/bands
	name = "Vox Tail Bands"
	state2use = "bands"

/datum/appearance_modifier/vox_tail_mark/tip
	name = "Vox Tail Tip"
	state2use = "tip"

/datum/appearance_modifier/vox_tail_mark/stripe
	name = "Vox Tail Stripe"
	state2use = "stripe"
