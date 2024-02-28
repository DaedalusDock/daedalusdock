/datum/slapcraft_recipe/improvised_pickaxe
	name = "improvised_pickaxe"
	examine_hint = "You could attach a knife and use it as a makeshift pickaxe..."
	category = SLAP_CAT_TOOLS
	steps = list(
		/datum/slapcraft_step/item/crowbar,
		/datum/slapcraft_step/item/metal_knife,
		/datum/slapcraft_step/tool/welder/weld_together
	)
	result_type = /obj/item/pickaxe/improvised
