//Stunprods
/datum/slapcraft_recipe/stunprod
	name = "stunprod"
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/item/wirerod,
		/datum/slapcraft_step/item/igniter
	)
	result_type = /obj/item/melee/baton/security/cattleprod

/datum/slapcraft_recipe/stunprod
	name = "teleprod"
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/item/wirerod,
		/datum/slapcraft_step/item/igniter,
		/datum/slapcraft_step/stack/teleprod_crystal
	)
	result_type = /obj/item/melee/baton/security/cattleprod/teleprod

/datum/slapcraft_step/stack/teleprod_crystal
	desc = "Attach a bluespace crystal to the wiring."
	item_types = list(/obj/item/stack/ore/bluespace_crystal)
