///Datum for simple mobs to define what they can attack,
///Global, just like ai_behaviors
/datum/targeting_strategy

///Returns true or false depending on if the target can be attacked by the mob
/datum/targeting_strategy/proc/can_attack(mob/living/living_mob, atom/target, vision_range)
	return

///Returns something the target might be hiding inside of
/datum/targeting_strategy/proc/find_hidden_mobs(mob/living/living_mob, atom/target)
	var/atom/target_hiding_location
	var/static/list/hiding_spots
	if(isnull(hiding_spots))
		hiding_spots = typecacheof(list(
			/obj/structure/closet,
			/obj/machinery/disposal,
			/obj/machinery/sleeper,
			/obj/machinery/bodyscanner,
		))

	if(is_type_in_typecache(target.loc, hiding_spots))
		target_hiding_location = target.loc
	return target_hiding_location
