//generic "shaping metal sheet(s) into items" recipies go here.
//these are a bit silly, and a more fleshed-out method of making metal crafts by hand would be nice to add later.
/datum/slapcraft_recipe/metal_rods
	name = "metal rods"
	examine_hint = "You could cut this into rods with a welder..."
	category = SLAP_CAT_COMPONENTS
	steps = list(
		/datum/slapcraft_step/stack/iron/one,
		/datum/slapcraft_step/tool/welder
	)
	result_type = /obj/item/stack/rods/two


/datum/slapcraft_recipe/metal_ball
	name = "metal ball"
	examine_hint = "You could form this into a ball, starting by heating it with a welder..."
	category = SLAP_CAT_COMPONENTS
	can_disassemble = FALSE
	steps = list(
		/datum/slapcraft_step/stack/iron/one,
		/datum/slapcraft_step/tool/welder,
		/datum/slapcraft_step/attack/bludgeon/heavy/metal
	)
	result_type = /obj/item/metal_ball

/datum/slapcraft_step/attack/bludgeon/heavy/metal
	desc = "Use something heavy and blunt to hammer the metal into shape."
	todo_desc = "You'll need to hammer the metal into shape..."

/datum/slapcraft_recipe/pipe_from_metal
	name = "metal pipe"
	examine_hint = "You could form this into a pipe, starting by heating it with a welder..."
	category = SLAP_CAT_COMPONENTS
	can_disassemble = FALSE
	steps = list(
		/datum/slapcraft_step/stack/iron/one,
		/datum/slapcraft_step/tool/welder,
		/datum/slapcraft_step/attack/bludgeon/heavy/metal
	)
	result_type = /obj/item/pipe/quaternary

/datum/slapcraft_recipe/pipe_from_metal/create_item(item_path, obj/item/slapcraft_assembly/assembly)
	var/obj/item/pipe/crafted_pipe = ..()//say thanks to smart pipes for this
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/pipe/smart
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.p_init_dir = ALL_CARDINALS
	crafted_pipe.setDir(SOUTH)
	crafted_pipe.update()
	return crafted_pipe
