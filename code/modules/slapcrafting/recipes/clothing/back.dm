/datum/slapcraft_recipe/sling
	name = "cloth sling"
	examine_hint = "You could craft a sling with some rope."
	category = SLAP_CAT_COMPONENTS
	show_finish_text = TRUE

	steps = list(
		/datum/slapcraft_step/stack/cloth/five,
		/datum/slapcraft_step/item/rope,
	)

	result_type = /obj/item/storage/backpack/sling

/datum/slapcraft_recipe/sling/finish_recipe(mob/living/user, obj/item/slapcraft_assembly/assembly)
	. = ..()
