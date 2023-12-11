//generic "shaping metal sheet(s) into items" recipies go here.
//these are a bit silly, and a more fleshed-out method of making metal crafts by hand would be nice to add later.
/datum/slapcraft_recipe/metal_rods
	name = "metal rods"
	examine_hint = "You could cut the metal into rods with a welder..."
	category = SLAP_CAT_COMPONENTS
	steps = list(
		/datum/slapcraft_step/stack/iron/one,
		/datum/slapcraft_step/tool/welder
	)
	result_type = /obj/item/stack/rods

/datum/slapcraft_recipe/metal_rods/create_item(item_path, obj/item/slapcraft_assembly/assembly)
	return new item_path(assembly.drop_location(), 2)

/datum/slapcraft_recipe/pipe_from_metal
	name = "metal pipe"
	examine_hint = "You could heat the metal with a welder..."
	category = SLAP_CAT_COMPONENTS
	steps = list(
		/datum/slapcraft_step/stack/iron/one,
		/datum/slapcraft_step/tool/welder,
		/datum/slapcraft_step/attack/blunt/metal
	)
	result_type = /obj/item/pipe/quaternary //say thanks to smart pipes for this one

/datum/slapcraft_step/attack/blunt/metal
	desc = "Use something heavy and blunt to hammer the metal into shape."
	todo_desc = "You'll need to hammer the metal into shape..."
