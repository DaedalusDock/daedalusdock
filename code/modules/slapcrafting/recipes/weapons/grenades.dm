/datum/slapcraft_recipe/ied
	name = "improvised explosive device"
	examine_hint = "You could craft an IED, starting by filling this with fuel and adding an igniter..."
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/reagent_container/ied_can,
		/datum/slapcraft_step/ied_igniter,
		/datum/slapcraft_step/stack/ied_cable
		)
	result_type = /obj/item/grenade/iedcasing

/datum/slapcraft_step/reagent_container/ied_can
	desc = "Start with a soda can filled with welding fuel."
	finished_desc = "A soda can filled with welding fuel has been added."
	item_types = list(/obj/item/reagent_containers/food/drinks/soda_cans)
	reagent_type = /datum/reagent/fuel
	reagent_volume = 50
	insert_item_into_result = TRUE

/datum/slapcraft_step/ied_igniter
	desc = "Attach an igniter to the soda can."
	finished_desc = "An igniter has been added to the can."
	todo_desc = "You could add an igniter to the can..."
	item_types = list(/obj/item/assembly/igniter)

	start_msg = "%USER% begins attaching an igniter to the %TARGET%."
	start_msg_self = "You begin attaching an igniter to the %TARGET%."
	finish_msg = "You attach an igniter to the %TARGET%."
	finish_msg_self = "%USER% attaches an igniter to the %TARGET%."

/datum/slapcraft_step/stack/ied_cable
	desc = "Finish the explosive device with some cables."
	finished_desc = "Some cable has been added."
	todo_desc = "You could add a some cable..."
	item_types = list(/obj/item/stack/cable_coil)
	amount = 5

	start_msg = "%USER% begins addding some cables to the %TARGET%."
	start_msg_self = "You begin addding some cables to the %TARGET%."
	finish_msg = "%USER% adds some cables to the %TARGET%."
	finish_msg_self = "You add some cables to the %TARGET%."

/datum/slapcraft_recipe/molotov
	name = "molotov cocktail"
	examine_hint = "With flammable liquid and something to light, you could create a molotov..."
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/booze_bottle,
		/datum/slapcraft_step/stack/or_other/molotov_fuse
		)
	result_type = /obj/item/reagent_containers/food/drinks/bottle/molotov

/datum/slapcraft_step/booze_bottle
	desc = "Get a bottle full of alcohol or another flammable substance."
	finished_desc = "Now you just need some kind of fuse..."
	insert_item_into_result = TRUE //the rest is handled in bottle.dm
	item_types = list(/obj/item/reagent_containers/food/drinks/bottle)

/datum/slapcraft_step/stack/or_other/molotov_fuse
	desc = "Add a rag, cloth, or something else to work as a fuse."
	todo_desc = "Now you just need some kind of fuse..."
	item_types = list(
		/obj/item/reagent_containers/glass/rag,
		/obj/item/stack/sheet/cloth,
		/obj/item/clothing/neck/tie
	)
	amounts = list(
		/obj/item/stack/sheet/cloth = 1
	)
