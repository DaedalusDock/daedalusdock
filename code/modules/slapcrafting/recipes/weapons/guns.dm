/*
/datum/slapcraft_recipe/pneumatic_cannon
	name = "pneumatic cannon"
	category = SLAP_CAT_WEAPONS
	steps = list(
		/datum/slapcraft_step/item/pipe,
		/datum/slapcraft_step/stack/rod/two/pneumatic,
		/datum/slapcraft_step/item/pipe/add,


	)
	result_type = /obj/item/pneumatic_cannon/ghetto

/datum/slapcraft_step/item/pipe
	desc = "Start with a pipe."
	item_types = list(/obj/item/pipe/quaternary)

/datum/slapcraft_step/stack/rod/two/pneumatic
	desc = "Use a rod to make a frame around the pipe."
	todo_desc = "You could build a frame with some rods..."

/datum/slapcraft_step/item/pipe/add //it would be cool if this was a bent pipe. too bad those don't exist
	desc = "Add a second pipe to the frame."

/datum/crafting_recipe/improvised_pneumatic_cannon //Pretty easy to obtain but
	name = "Pneumatic Cannon"
	result = /obj/item/pneumatic_cannon/ghetto
	tool_behaviors = list(TOOL_WELDER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/iron = 4,
				/obj/item/stack/package_wrap = 8,
				/obj/item/pipe/quaternary = 2)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
*/
