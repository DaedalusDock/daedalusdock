
///Gun has no moving bolt mechanism, it cannot be racked. Also dumps the entire contents when emptied instead of a magazine.
///  Example: Break action shotguns, revolvers
/datum/gun_bolt/no_bolt

/datum/gun_bolt/no_bolt/pre_rack(mob/user)
	return TRUE // There's nothing to rack, it's boltless.

/datum/gun_bolt/no_bolt/loaded_ammo()
	if (isnull(parent.chambered))
		parent.chamber_round()

/datum/gun_bolt/no_bolt/unload(mob/user)
	. = TRUE // No matter what happens we're cancelling the call
	if(!parent.wielded && !user.get_empty_held_index())
		to_chat(user, span_warning("You need a free hand to do that!"))
		return

	parent.chambered = null
	var/num_unloaded = 0

	for(var/obj/item/ammo_casing/CB in parent.get_ammo_list(FALSE, TRUE))
		CB.forceMove(parent.drop_location())
		CB.bounce_away(FALSE, NONE)
		num_unloaded++
		var/turf/T = get_turf(parent.drop_location())
		if(T && is_station_level(T.z))
			SSblackbox.record_feedback("tally", "station_mess_created", 1, CB.name)

	if (num_unloaded)
		to_chat(user, span_notice("You unload [num_unloaded] [parent.cartridge_wording]\s from [parent]."))
		playsound(parent, parent.eject_sound, parent.eject_sound_volume, parent.eject_sound_vary)
		parent.update_appearance()
	else
		to_chat(user, span_warning("[parent] is empty!"))
