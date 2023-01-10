/datum/appearance_modifier/lizard_chest_marks
	abstract_type = /datum/appearance_modifier/lizard_chest_marks

	icon2use = 'icons/mob/appearancemods/lizardmarks.dmi'
	species_can_use = list(SPECIES_LIZARD)
	bodyzones_affected = list(BODY_ZONE_CHEST)

/datum/appearance_modifier/lizard_chest_marks/light
	name = "Light Tiger Markings"
	state2use = "light_markings"

/datum/appearance_modifier/lizard_chest_marks/dark
	name = "Dark Tiger Markings"
	state2use = "dark_markings"

/datum/appearance_modifier/lizard_chest_marks/light_belly
	abstract_type = /datum/appearance_modifier/lizard_chest_marks/light_belly

/datum/appearance_modifier/lizard_chest_marks/light_belly/male
	name = "Light Belly (Male)"
	state2use = "light_chest_male"

/datum/appearance_modifier/lizard_chest_marks/light_belly/female
	name = "Light Belly (Female)"
	state2use = "light_chest_female"
