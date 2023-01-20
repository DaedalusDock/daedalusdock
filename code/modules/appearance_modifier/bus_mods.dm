/datum/appearance_modifier/pawsocks
	abstract_type = /datum/appearance_modifier/pawsocks
	name = "Pawsocks"
	icon2use = 'icons/mob/appearancemods/bay12.dmi'
	state2use = "pawsocks"

	species_can_use = list(SPECIES_FELINE)

	bodyzones_affected = list(BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG)
	affects_hands = TRUE
