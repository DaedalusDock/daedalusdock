/// This steps can check sufficient weapon variables, such as sharpness or force
/datum/slapcraft_step/attack
	abstract_type = /datum/slapcraft_step/attack
	insert_item = FALSE
	check_types = FALSE
	check_if_mob_can_drop_item = FALSE

	list_desc = "sharp implement"
	/// Sharpness flags needed to perform.
	var/require_sharpness = NONE
	/// If we want exactly this bitfield, not "has any"
	var/require_exact = FALSE
	/// Required force of the item.
	var/force = 0

/datum/slapcraft_step/attack/can_perform(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly, list/error_list = list())
	. = ..()

	if(require_sharpness || require_exact)
		if(require_exact)
			if(!(require_sharpness == item.sharpness))
				error_list += sharpness_error(item)
				. = FALSE

		else if(!(require_sharpness & item.sharpness))
			error_list += sharpness_error(item)
			. =  FALSE

	if(item.force < force)
		error_list += "[item] is not strong enough."
		. = FALSE

/datum/slapcraft_step/attack/play_perform_sound(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	// Sharpness was required, so play a slicing sound
	if(require_sharpness)
		playsound(assembly, 'sound/weapons/slice.ogg', 50, TRUE, -1)
	// Else, play an attack sound if there is one.
	else if (item.hitsound)
		playsound(assembly, item.hitsound, 50, TRUE, -1)

/datum/slapcraft_step/attack/proc/sharpness_error(obj/item/item)
	switch(require_sharpness)
		if(SHARP_EDGED)
			return "[item] does not have a sharp edge."
		if(SHARP_POINTY)
			return "[item] does not have a sharp point."
		if(SHARP_POINTY|SHARP_EDGED)
			return "[item] does not have a sharp point and sharp edge."
		else
			return "[item] is not blunt."

/datum/slapcraft_step/attack/sharp
	require_sharpness = SHARP_EDGED

/datum/slapcraft_step/attack/bludgeon
	list_desc = "blunt object"

	require_sharpness = NONE
	require_exact = TRUE

/datum/slapcraft_step/attack/sharp/chop
	perform_time = 0.7 SECONDS
	desc = "Chop the log into planks."
	todo_desc = "You could chop logs in to planks..."

	finish_msg = "You finish chopping down the log into planks."
	start_msg = "%USER% begins chopping the log."
	start_msg_self = "You begin chopping the log with the sharp tool."
	finish_msg = "%USER% chops down the log into planks."
	finish_msg_self = "You chop the log into planks."
