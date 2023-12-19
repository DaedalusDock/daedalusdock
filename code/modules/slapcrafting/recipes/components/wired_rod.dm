/datum/slapcraft_recipe/wirerod
	name = "wired rod"
	examine_hint = "With ten cable, you could attach something to this rod..."
	category = SLAP_CAT_COMPONENTS
	steps = list(
		/datum/slapcraft_step/stack/rod/one,
		/datum/slapcraft_step/stack/cable/ten
	)
	result_type = /obj/item/wirerod

/datum/slapcraft_recipe/wirerod_dissasemble
	name = "unwired rod"
	examine_hint = "You could cut the wire off with wirecutters..."
	category = SLAP_CAT_COMPONENTS
	steps = list(
		/datum/slapcraft_step/tool/wirecutter
	)
	result_list = list(
		/obj/item/stack/rods,
		/obj/item/stack/cable_coil/ten
	)
