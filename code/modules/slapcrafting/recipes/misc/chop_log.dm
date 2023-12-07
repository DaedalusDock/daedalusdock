/datum/slapcraft_recipe/chop_log
	name = "chop log"
	examine_hint = "You could chop it down into planks with something sharp..."
	category = SLAP_CAT_MISC
	steps = list(
		/datum/slapcraft_step/chop_log,
		/datum/slapcraft_step/attack/sharp/chop
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

