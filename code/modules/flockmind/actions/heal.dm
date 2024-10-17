/datum/action/cooldown/flock/flock_heal
	name = "Repair"
	click_to_activate = TRUE

/datum/action/cooldown/flock/flock_heal/Activate(atom/target)
	if(isflockmob(target))
		var/mob/living/simple_animal/flock/bird = target
		ADD_TRAIT(bird, TRAIT_AI_PAUSED, ref(owner))
		if(!do_after(owner, target, 1 SECOND, DO_PUBLIC, interaction_key = "flock_repair"))
			REMOVE_TRAIT(bird, TRAIT_AI_PAUSED, ref(owner))
			return FALSE
		REMOVE_TRAIT(bird, TRAIT_AI_PAUSED, ref(owner))
		bird.heal_overall_damage(10, 10)
	..()
	return TRUE
