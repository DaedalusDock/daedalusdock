/// This step requires to input a reagent container, possibly with some reagent inside, or with some volume specifications.
/datum/slapcraft_step/reagent_container
	abstract_type = /datum/slapcraft_step/reagent_container
	insert_item = TRUE
	item_types = list(/obj/item/reagent_containers)
	/// Type of the reagent needed.
	var/reagent_type
	/// Volume of the reagent needed.
	var/reagent_volume
	/// Instead of just one reagent type you can input a list to be used instead for the checks.
	var/list/reagent_list
	/// The amount of container volume we require if any.
	var/container_volume
	/// The maximum volume of the container, if any.
	var/maximum_volume
	/// Amount of free volume we require if any.
	var/free_volume
	/// Whether we need an open container to do this.
	var/needs_open_container = TRUE
	/// If defined, it's the minimum required temperature for the step to work.
	var/temperature_min
	/// If defined it's the maximum required temperature for the step to work.
	var/temperature_max

/datum/slapcraft_step/reagent_container/can_perform(mob/living/user, obj/item/item)
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
	else if (reagent_type)
		if(!container.reagents.has_reagent(reagent_type, reagent_volume))
			return FALSE
	if(!isnull(container_volume) && container.reagents.maximum_volume < container_volume)
		return FALSE
	if(!isnull(maximum_volume) && container.reagents.maximum_volume > maximum_volume)
		return FALSE
	if(!isnull(free_volume) && (container.reagents.maximum_volume - container.reagents.total_volume) < free_volume)
		return FALSE
	return TRUE

/datum/slapcraft_step/reagent_container/make_list_desc()
	. = ..()
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
		. += string
	else if(reagent_type)
		var/datum/reagent/reagent_cast = reagent_type
		. += " - [reagent_volume]u. [lowertext(initial(reagent_cast.name))]"
