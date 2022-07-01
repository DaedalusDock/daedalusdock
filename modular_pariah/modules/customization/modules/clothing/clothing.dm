//Overrides for digitigrade and snouted clothing handling
/obj/item
	//Icon file for mob worn overlays, if the user is digitigrade.
	var/icon/worn_icon_digitigrade
	//Same as above, but for if the user is snouted.
	var/icon/worn_icon_snouted

	var/greyscale_config_worn_digitigrade

	//this is somewhat awful, but ¯\_(ツ)_/¯
	var/greyscale_config_worn_vox
	var/icon/worn_icon_vox
