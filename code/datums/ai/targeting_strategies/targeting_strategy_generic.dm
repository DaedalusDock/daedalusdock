/datum/targeting_strategy/generic
	/// When we do our basic faction check, do we look for exact faction matches?
	var/check_factions_exactly = FALSE
	/// Whether we care for seeing the target or not
	var/ignore_sight = FALSE
	/// Blackboard key containing the minimum stat of a living mob to target
	var/minimum_stat_key = BB_TARGET_MINIMUM_STAT
	/// Whether or not we stop attacking incapacitated targets
	var/stop_attack_on_incap = FALSE

	/// If this blackboard key is TRUE, makes us only target wounded mobs
	var/target_wounded_key

/datum/targeting_strategy/generic/can_attack(mob/living/pawn, atom/the_target, vision_range)
	var/datum/ai_controller/basic_controller/our_controller = pawn.ai_controller

	if(isnull(our_controller))
		return FALSE

	if(isturf(the_target) || isnull(the_target)) // bail out on invalids
		return FALSE

	if(isobj(the_target.loc))
		var/obj/container = the_target.loc
		if(container.resistance_flags & INDESTRUCTIBLE)
			return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/target_mob = the_target
		if(pawn.loc == the_target)
			return FALSE // We've either been eaten or are shapeshifted, let's assume the latter because we're still alive
		if(target_mob.status_flags & GODMODE)
			return FALSE

	if (vision_range && get_dist(pawn, the_target) > vision_range)
		return FALSE

	if(!ignore_sight && !can_see(pawn, the_target, vision_range)) //Target has moved behind cover and we have lost line of sight to it
		return FALSE

	if(pawn.see_invisible < the_target.invisibility) //Target's invisible to us, forget it
		return FALSE

	if(!isturf(pawn.loc))
		return FALSE
	if(isturf(the_target.loc) && pawn.z != the_target.z) // z check will always fail if target is in a mech or pawn is shapeshifted or jaunting
		return FALSE

	if(isliving(the_target)) //Targeting vs living mobs
		return should_attack_mob(pawn, our_controller, the_target)

	if(ismecha(the_target)) //Targeting vs mechas
		var/obj/vehicle/sealed/mecha/M = the_target
		for(var/occupant in M.occupants)
			if(can_attack(pawn, occupant)) //Can we attack any of the occupants?
				return TRUE

	if(istype(the_target, /obj/machinery/porta_turret)) //Cringe turret! kill it!
		var/obj/machinery/porta_turret/P = the_target
		if(P.in_faction(pawn)) //Don't attack if the turret is in the same faction
			return FALSE
		if(P.has_cover && !P.raised) //Don't attack invincible turrets
			return FALSE
		if(P.machine_stat & BROKEN) //Or turrets that are already broken
			return FALSE
		return TRUE

	return FALSE

/datum/targeting_strategy/generic/proc/should_attack_mob(mob/living/pawn, datum/ai_controller/our_controller, mob/living/living_target)
	if(faction_check(our_controller, pawn, living_target))
		return FALSE

	if(living_target.stat > our_controller.blackboard[minimum_stat_key])
		return FALSE

	if(target_wounded_key && our_controller.blackboard[target_wounded_key] && living_target.health == living_target.maxHealth)
		return FALSE

	if(stop_attack_on_incap && HAS_TRAIT(living_target, TRAIT_INCAPACITATED))
		return FALSE

	return TRUE

/// Returns true if the mob and target share factions
/datum/targeting_strategy/generic/proc/faction_check(datum/ai_controller/controller, mob/living/pawn, mob/living/the_target)
	if (controller.blackboard[BB_ALWAYS_IGNORE_FACTION] || controller.blackboard[BB_TEMPORARILY_IGNORE_FACTION])
		return FALSE
	return pawn.faction_check_atom(the_target, exact_match = check_factions_exactly)

/datum/targeting_strategy/generic/monkey
	stop_attack_on_incap = TRUE

/datum/targeting_strategy/generic/monkey/faction_check(datum/ai_controller/controller, mob/living/pawn, mob/living/the_target)
	if(controller.blackboard[BB_MONKEY_ENEMIES][the_target])
		return FALSE
	return ..()
