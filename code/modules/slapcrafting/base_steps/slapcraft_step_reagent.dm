/// This step requires and uses a reagent to finish itself. This step is great as a last step since reagents can't be recovered from disassembly.
/// This alternatively can also transfer to a container inside the crafting assembly too!
/datum/slapcraft_step/reagent
	abstract_type = /datum/slapcraft_step/reagent
	insert_item = FALSE
	item_types = list(/obj/item/reagent_containers)
	finish_msg = "%USER% finishes adding some reagents to %TARGET%."
	start_msg = "%USER% starts adding some reagents to %TARGET%."
	finish_msg_self = "You add some reagents to %TARGET%."
	start_msg_self = "You begin adding some reagents to %TARGET%."
	/// Readable string describing reagentst that we auto generate. such as "fuel, acid and milk". Used as a helper in auto desc generations
	var/readable_reagent_string
	/// Type of the reagent to use.
	var/reagent_type
	/// Volume of the reagent to use.
	var/reagent_volume
	/// Reagent list to be used for checks and interactions instead of above single type.
	var/list/reagent_list
	/// Whether we need an open container to do this
	var/needs_open_container = TRUE
	/// Whether we want to transfer to another container in the assembly. Requires a container in assembly and enough space for that inside it.
	var/transfer_to_assembly_container = FALSE
	/// If defined, it's the minimum required temperature for the step to work.
	var/temperature_min
	/// If defined it's the maximum required temperature for the step to work.
	var/temperature_max

/datum/slapcraft_step/reagent/New()
	make_readable_reagent_string()
	return ..()

/datum/slapcraft_step/reagent/can_perform(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	var/obj/item/reagent_containers/container = item
	if(!container.reagents)
		return FALSE
	if(needs_open_container && !container.is_open_container())
		return FALSE
	if(!isnull(temperature_min) && container.reagents.chem_temp < temperature_min)
		return FALSE
	if(!isnull(temperature_max) && container.reagents.chem_temp > temperature_max)
		return FALSE
	if(reagent_list)
		if(!container.reagents.has_reagent_list(reagent_list))
			return FALSE
	else
		if(!container.reagents.has_reagent(reagent_type, reagent_volume))
			return FALSE
	if(transfer_to_assembly_container && assembly)
		var/obj/item/reagent_containers/assembly_container = locate() in assembly
		if(!assembly_container)
			return FALSE
		var/required_free_volume
		if(reagent_list)
			required_free_volume = 0
			for(var/r_id in reagent_list)
				required_free_volume += reagent_list[r_id]
		else
			required_free_volume = reagent_volume
		var/free_space = assembly_container.reagents.maximum_volume - assembly_container.reagents.total_volume
		if(free_space < required_free_volume)
			return FALSE
	return TRUE

/datum/slapcraft_step/reagent/on_perform(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	var/obj/item/reagent_containers/container = item
	if(transfer_to_assembly_container)
		// Here we already asserted that the container exists and has free space in `can_perform()`
		var/obj/item/reagent_containers/assembly_container = locate() in assembly
		// Well it says "transfer", but it actually adds new because there isn't an easy way to transfer specifically a certain type.
		// I guess this issue is only relevant for blood and viruses, which I doubt people will slapcraft with.
		if(reagent_list)
			assembly_container.reagents.add_reagent_list(reagent_list)
		else
			assembly_container.reagents.add_reagent(reagent_type, reagent_volume)

	if(reagent_list)
		container.reagents.remove_reagent_list(reagent_list)
	else
		container.reagents.remove_reagent(reagent_type, reagent_volume)

/datum/slapcraft_step/reagent/make_list_desc()
	if(reagent_list)
		var/string = ""
		var/first = TRUE
		for(var/r_id in reagent_list)
			if(!first)
				string += ", "
			var/datum/reagent/reagent_cast = r_id
			var/volume = reagent_list[r_id]
			string += "[volume]u. [lowertext(initial(reagent_cast.name))]"
			first = FALSE
		return string
	else
		var/datum/reagent/reagent_cast = reagent_type
		return "[reagent_volume]u. [lowertext(initial(reagent_cast.name))]"

/datum/slapcraft_step/reagent/proc/make_readable_reagent_string()
	var/list/reagent_types_to_describe = list()
	if(reagent_list)
		for(var/reagent_type in reagent_list)
			reagent_types_to_describe += reagent_type
	else
		reagent_types_to_describe += reagent_type
	var/string_so_far = ""
	var/i = 0
	var/first = TRUE
	for(var/reagent_type in reagent_types_to_describe)
		i++
		if(!first)
			if(i == reagent_types_to_describe.len)
				string_so_far += " and "
			else
				string_so_far += ", "
		var/datum/reagent/cast = reagent_type
		string_so_far += lowertext(initial(cast.name))
		first = FALSE
	readable_reagent_string = string_so_far

/datum/slapcraft_step/reagent/make_desc()
	return "Add some [readable_reagent_string] to the assembly"

/datum/slapcraft_step/reagent/make_finished_desc()
	return "Some [readable_reagent_string] has been added."

/datum/slapcraft_step/reagent/make_todo_desc()
	return "You could add some [readable_reagent_string] to the assembly"
