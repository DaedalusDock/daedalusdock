/// Vox Tail marks
//  - These give funny patterns to vox tails.
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

/// Vox Scutes (Ends of limbs)
//  - This complements the secondary limb recolor to
//    give vox players wildly expanded customization
//  - These are split up so they don't overlay
//    prosthetics or can be asymmetrical &/or
//    differently colored.
/datum/appearance_modifier/vox_scute
	name = "Error! (Vox Scute)"
	abstract_type = /datum/appearance_modifier/vox_scute

	icon2use = 'icons/mob/appearancemods/vox_scutes.dmi'

	species_can_use = list(SPECIES_VOX)

/datum/appearance_modifier/vox_scute/leg
	name = "Error! (Vox Scute Leg)"
	abstract_type = /datum/appearance_modifier/vox_scute/leg
	bodyzones_affected = list(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)

/datum/appearance_modifier/vox_scute/leg/right
	name = "Vox Scute (Leg, Right)"
	bodyzones_affected = list(BODY_ZONE_R_LEG)
	state2use = "vox_digitigrade_r_leg"

/datum/appearance_modifier/vox_scute/leg/left
	name = "Vox Scute (Leg, Left)"
	bodyzones_affected = list(BODY_ZONE_L_LEG)
	state2use = "vox_digitigrade_l_leg"

/datum/appearance_modifier/vox_scute/arm
	name = "Error! (Vox Scute Arm)"
	abstract_type = /datum/appearance_modifier/vox_scute/arm
	bodyzones_affected = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)

/datum/appearance_modifier/vox_scute/arm/right
	name = "Vox Scute (Arm, Right)"
	bodyzones_affected = list(BODY_ZONE_R_ARM)
	state2use = "vox_r_arm"

/datum/appearance_modifier/vox_scute/arm/left
	name = "Vox Scute (Arm, Left)"
	bodyzones_affected = list(BODY_ZONE_L_ARM)
	state2use = "vox_l_arm"

/datum/appearance_modifier/vox_scute/hand
	name = "Error! (Vox Scute Hand)"
	abstract_type = /datum/appearance_modifier/vox_scute/hand
	bodyzones_affected = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
	affects_hands = TRUE

/datum/appearance_modifier/vox_scute/hand/right
	name = "Vox Scute (Hand, Right)"
	bodyzones_affected = list(BODY_ZONE_R_ARM)
	state2use = "vox_r_hand"

/datum/appearance_modifier/vox_scute/hand/left
	name = "Vox Scute (Hand, Left)"
	bodyzones_affected = list(BODY_ZONE_L_ARM)
	state2use = "vox_l_hand"
