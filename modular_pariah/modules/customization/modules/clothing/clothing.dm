//Overrides for digitigrade and snouted clothing handling
/obj/item
	//Icon file for mob worn overlays, if the user is digitigrade.
	var/icon/worn_icon_digitigrade
	//Same as above, but for if the user is snouted.
	var/icon/worn_icon_snouted

	var/greyscale_config_worn_digitigrade

/obj/item/clothing/under
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/suit
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/shoes
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/mask
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION
