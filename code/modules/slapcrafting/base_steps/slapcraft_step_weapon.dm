/// This steps can check sufficient weapon variables, such as sharpness or force
/datum/slapcraft_step/attack
	abstract_type = /datum/slapcraft_step/attack
	insert_item = FALSE
	check_types = FALSE
	check_if_mob_can_drop_item = FALSE

	list_desc = "sharp implement"
	/// Sharpness flags needed to perform.
	var/require_sharpness = NONE
	/// Required force of the item.
	var/force = 0

/datum/slapcraft_step/attack/can_perform(mob/living/user, obj/item/item)
	. = ..()
	if(!.)
		return

	if(require_sharpness && !(item.sharpness & require_sharpness))
		return FALSE
	if(item.force < force)
		return FALSE
	return TRUE

/datum/slapcraft_step/attack/play_perform_sound(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	// Sharpness was required, so play a slicing sound
	if(require_sharpness)
		playsound(assembly, 'sound/weapons/slice.ogg', 50, TRUE, -1)
	// Else, play an attack sound if there is one.
	else if (item.hitsound)
		playsound(assembly, item.hitsound, 50, TRUE, -1)

/datum/slapcraft_step/attack/sharp
	require_sharpness = SHARP_EDGED
