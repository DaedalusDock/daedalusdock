/*
/////////////////////////////////////
/  =---------------------------=    /
/  == Gradient Hair Definitions ==  /
/  =---------------------------=    /
/////////////////////////////////////
*/

/datum/sprite_accessory/gradient
	icon = 'icons/mob/hair_gradients.dmi'
	///whether this gradient applies to hair and/or beards. Some gradients do not work well on beards.
	var/gradient_category = GRADIENT_APPLIES_TO_HAIR|GRADIENT_APPLIES_TO_FACIAL_HAIR

/datum/sprite_accessory/gradient/none
	name = "None"
	icon_state = "none"

/datum/sprite_accessory/gradient/fadeup
	name = "Fade Up"
	icon_state = "fadeup"

/datum/sprite_accessory/gradient/fadedown
	name = "Fade Down"
	icon_state = "fadedown"

/datum/sprite_accessory/gradient/vertical_split
	name = "Vertical Split"
	icon_state = "vsplit"

/datum/sprite_accessory/gradient/horizontal_split
	name = "Horizontal Split"
	icon_state = "bottomflat"

/datum/sprite_accessory/gradient/reflected
	name = "Reflected"
	icon_state = "reflected_high"
	gradient_category = GRADIENT_APPLIES_TO_HAIR

/datum/sprite_accessory/gradient/reflected/beard
	icon_state = "reflected_high_beard"
	gradient_category = GRADIENT_APPLIES_TO_FACIAL_HAIR

/datum/sprite_accessory/gradient/reflected_inverse
	name = "Reflected Inverse"
	icon_state = "reflected_inverse_high"
	gradient_category = GRADIENT_APPLIES_TO_HAIR

/datum/sprite_accessory/gradient/reflected_inverse/beard
	icon_state = "reflected_inverse_high_beard"
	gradient_category = GRADIENT_APPLIES_TO_FACIAL_HAIR

/datum/sprite_accessory/gradient/wavy
	name = "Wavy"
	icon_state = "wavy"
	gradient_category = GRADIENT_APPLIES_TO_HAIR

/datum/sprite_accessory/gradient/long_fade_up
	name = "Long Fade Up"
	icon_state = "long_fade_up"

/datum/sprite_accessory/gradient/long_fade_down
	name = "Long Fade Down"
	icon_state = "long_fade_down"

/datum/sprite_accessory/gradient/short_fade_up
	name = "Short Fade Up"
	icon_state = "short_fade_up"
	gradient_category = GRADIENT_APPLIES_TO_HAIR

/datum/sprite_accessory/gradient/short_fade_up/beard
	icon_state = "short_fade_down"
	gradient_category = GRADIENT_APPLIES_TO_FACIAL_HAIR

/datum/sprite_accessory/gradient/short_fade_down
	name = "Short Fade Down"
	icon_state = "short_fade_down_beard"
	gradient_category = GRADIENT_APPLIES_TO_HAIR

/datum/sprite_accessory/gradient/short_fade_down/beard
	icon_state = "short_fade_down_beard"
	gradient_category = GRADIENT_APPLIES_TO_FACIAL_HAIR

/datum/sprite_accessory/gradient/wavy_spike
	name = "Spiked Wavy"
	icon_state = "wavy_spiked"
	gradient_category = GRADIENT_APPLIES_TO_HAIR

/datum/sprite_accessory/gradient/striped
	name = "striped"
	icon_state = "striped"

/datum/sprite_accessory/gradient/striped_vertical
	name = "Striped Vertical"
	icon_state = "striped_vertical"
