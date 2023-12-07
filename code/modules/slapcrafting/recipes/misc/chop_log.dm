/datum/slapcraft_recipe/chop_log
	name = "chop log"
	examine_hint = "You could chop it down into planks with something sharp..."
	category = SLAP_CAT_MISC
	steps = list(
	/datum/slapcraft_step/chop_log,
	/datum/slapcraft_step/weapon/sharp/chop
	)
	result_type = /obj/item/stack/sheet/mineral/wood

/datum/slapcraft_recipe/chop_log/create_item(item_path, obj/item/slapcraft_assembly/assembly)
	var/obj/item/grown/log/log = locate() in assembly
	var/plank_amount = log.get_plank_amount()
	var/plank_type = log.plank_type
	return new plank_type(assembly.loc, plank_amount)

/datum/slapcraft_step/chop_log
	desc = "Start with a log."
	finished_desc = "It's waiting to be chopped down into planks."
	item_types = list(/obj/item/grown/log)

/datum/slapcraft_step/weapon/sharp/chop
	perform_time = 0.7 SECONDS
	desc = "Chop the log into planks."
	todo_desc = "You could chop logs in to planks..."

	finish_msg = "You finish chopping down the log into planks."
	start_msg = "%USER% begins chopping the log."
	start_msg_self = "You begin chopping the log with the sharp tool."
	finish_msg = "%USER% chops down the log into planks."
	finish_msg_self = "You chop the log into planks."
