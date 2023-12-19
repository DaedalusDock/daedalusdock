//this is incredibly silly, but it's not like they function as eyes.
//it would still be nice to add more sane prosthetic crafts later.
/datum/slapcraft_recipe/flashlight_eyes
	name = "flashlight eyes"
	examine_hint = "You could connect two flashlights with some cable. Not sure why you'd want to..."
	category = SLAP_CAT_MEDICAL
	steps = list(
		/datum/slapcraft_step/item/flashlight,
		/datum/slapcraft_step/stack/cable/fifteen,
		/datum/slapcraft_step/item/flashlight
	)
	result_type = /obj/item/organ/eyes/robotic/flashlight
