/// This step requires an amount of a stack items which will be split off and put into the assembly.
/datum/slapcraft_step/material
	abstract_type = /datum/slapcraft_step/material
	insert_item = TRUE
	item_types = list(/obj/item/stack)

	/// The type of material required
	var/datum/material/mat_type
	/// Amount (cm3) of the material required
	var/amount = 0

/datum/slapcraft_step/material/can_perform(mob/living/user, obj/item/item)
	. = ..()
	if(!.)
		return

	var/obj/item/stack/stack = item
	if(stack.custom_materials[GET_MATERIAL_REF(mat_type)] < amount)
		return FALSE
	return TRUE

/datum/slapcraft_step/material/move_item_to_assembly(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	var/obj/item/stack/stack = item
	var/obj/item/item_to_move

	var/sheets_needed = ceil(amount / stack.mats_per_unit[GET_MATERIAL_REF(mat_type)])

	// Exactly how much we needed, just put the entirety in the assembly
	if(stack.amount == sheets_needed)
		item_to_move = stack
	else
		// We have more than we need, split the stacks off
		var/obj/item/stack/split_stack = stack.split_stack(null, amount)
		item_to_move = split_stack
	item = item_to_move
	return ..()

/datum/slapcraft_step/material/make_list_desc()
	return "[amount] cm3 [initial(mat_type.name)]"
