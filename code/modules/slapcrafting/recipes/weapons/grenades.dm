/datum/slapcraft_recipe/ied
	name = "improvised explosive device"
	examine_hint = "You could craft an IED, starting by filling this with fuel and adding an igniter..."
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/reagent_container/ied_can,
		/datum/slapcraft_step/item/igniter,
		/datum/slapcraft_step/stack/cable/five
		)
	result_type = /obj/item/grenade/iedcasing

/datum/slapcraft_step/reagent_container/ied_can
	desc = "Start with a soda can filled with welding fuel."
	finished_desc = "A soda can filled with welding fuel has been added."
	item_types = list(/obj/item/reagent_containers/cup/soda_cans)
	reagent_type = /datum/reagent/fuel
	reagent_volume = 50
	insert_item_into_result = TRUE

/datum/slapcraft_recipe/molotov
	name = "molotov cocktail"
	examine_hint = "With a bottle of flammable liquid and something to light, you could create a molotov..."
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/booze_bottle,
		/datum/slapcraft_step/stack/or_other/molotov_fuse
		)
	result_type = /obj/item/reagent_containers/cup/glass/bottle/molotov

/datum/slapcraft_step/booze_bottle
	desc = "Get a bottle full of alcohol or another flammable substance."
	finished_desc = "Now you just need some kind of fuse..."
	insert_item_into_result = TRUE //the rest is handled in bottle.dm
	item_types = list(/obj/item/reagent_containers/cup/glass/bottle)

/datum/slapcraft_step/stack/or_other/molotov_fuse
	desc = "Add a rag, cloth, or something else to work as a fuse."
	todo_desc = "Now you just need some kind of fuse..."
	item_types = list(
		/obj/item/reagent_containers/cup/rag,
		/obj/item/stack/sheet/cloth,
		/obj/item/clothing/neck/tie
	)
	amounts = list(
		/obj/item/stack/sheet/cloth = 1
	)
