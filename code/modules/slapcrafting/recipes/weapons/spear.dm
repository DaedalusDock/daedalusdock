/datum/slapcraft_recipe/spear
	name = "spear"
	category = SLAP_CAT_WEAPONS

	steps = list(
		/datum/slapcraft_step/item/wirerod,
		/datum/slapcraft_step/item/glass_shard,
	)

	result_type = /obj/item/spear

/datum/slapcraft_recipe/wirerod
	name = "wirerod"
	category = SLAP_CAT_MISC
	examine_hint = "You could add some wire..."

	steps = list(
		/datum/slapcraft_step/stack/rod/one,
		/datum/slapcraft_step/stack/cable/one
	)

	result_type = /obj/item/wirerod
