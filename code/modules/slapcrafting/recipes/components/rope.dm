/datum/slapcraft_recipe/rope
	name = "rope"
	examine_hint = "You could tie together cloth."
	category = SLAP_CAT_COMPONENTS
	show_finish_text = TRUE

	steps = list(
		/datum/slapcraft_step/stack/cloth,
		/datum/slapcraft_step/stack/cloth/rope
	)
	result_type = /obj/item/rope
