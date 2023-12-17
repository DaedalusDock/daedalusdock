//Is a flamethrower a gun? I'm still not sure.
/datum/slapcraft_recipe/flamethrower
	name = "flamethrower"
	examine_hint = "You could craft a flamethrower, starting by attaching an igniter..."
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/item/welder/base_only,
		/datum/slapcraft_step/item/igniter,
		/datum/slapcraft_step/stack/rod/one,
		/datum/slapcraft_step/tool/screwdriver/secure
	)
	result_type = /obj/item/flamethrower

/datum/slapcraft_recipe/pneumatic_cannon
	name = "pneumatic cannon"
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/item/pipe,
		/datum/slapcraft_step/stack/rod/two
		/datum/slapcraft_step/item/pipe,
		/datum/slapcraft_step/tool/welder/weld_together
	)
	result_type = /obj/item/pneumatic_cannon/ghetto
