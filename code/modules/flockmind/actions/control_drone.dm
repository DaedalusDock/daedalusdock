/datum/action/cooldown/flock/control_drone
	name = "Control Drone"
	button_icon_state = "ping"
	cooldown_time = 0
	click_to_activate = TRUE
	unset_after_click = FALSE
	click_cd_override = 0

	var/mob/living/simple_animal/flock/drone/selected_bird

/datum/action/cooldown/flock/control_drone/Remove(mob/removed_from)
	. = ..()
	free_drone()

/datum/action/cooldown/flock/control_drone/is_valid_target(atom/cast_on)
	if(selected_bird)
		return get_turf(cast_on)

	if(!isflockdrone(cast_on))
		return FALSE

	var/mob/living/simple_animal/flock/drone/bird = cast_on
	if(HAS_TRAIT_FROM(bird, TRAIT_AI_DISABLE_PLANNING, FLOCK_CONTROLLED_BY_OVERMIND_SOURCE))
		return FALSE

	if(bird.controlled_by)
		return FALSE
	return TRUE

/datum/action/cooldown/flock/control_drone/Activate(atom/target)
	. = ..()
	if(isnull(selected_bird))
		bind_drone(target)
		return TRUE

	selected_bird.ai_controller.CancelActions()

	if(isturf(target))
		var/turf/T = target
		if(isflockturf(T))
			selected_bird.ai_controller.queue_behavior(/datum/ai_behavior/flock/rally, target)
			pointer_helper(selected_bird, target, 2 SECONDS)
			selected_bird.say("instruction confirmed: rally at location")
			free_drone(TRUE)
			unset_click_ability(owner, performing_task = TRUE)
			return TRUE

		if(T.can_flock_convert())
			selected_bird.ai_controller.queue_behavior(/datum/ai_behavior/flock/find_conversion_target, target)
			pointer_helper(selected_bird, target, 2 SECONDS)
			unset_click_ability(owner, performing_task = TRUE)
			return TRUE

/datum/action/cooldown/flock/control_drone/unset_click_ability(mob/on_who, refund_cooldown, performing_task = TRUE)
	. = ..()
	free_drone(performing_task)

/datum/action/cooldown/flock/control_drone/proc/pointer_helper(atom/from, atom/towards, duration)
	var/mob/camera/flock/overmind/ghost_bird = owner
	var/image/pointer = pointer_image_to(from, towards)

	animate(pointer, time = 2 SECONDS, alpha = 0)
	ghost_bird.flock.add_ping_image(ghost_bird.client, pointer, 2 SECONDS)

/datum/action/cooldown/flock/control_drone/proc/bind_drone(mob/living/simple_animal/flock/drone/bird)
	selected_bird = bird
	RegisterSignal(bird, COMSIG_PARENT_QDELETING, PROC_REF(drone_gone))
	ADD_TRAIT(bird, TRAIT_AI_DISABLE_PLANNING, FLOCK_CONTROLLED_BY_OVERMIND_SOURCE)
	bird.ai_controller.CancelActions()
	bird.say("suspending automated subroutines pending sentient-level instruction", forced = "overmind taking control")
	bird.AddComponent(/datum/component/flock_ping/selected)

/datum/action/cooldown/flock/control_drone/proc/free_drone(performing_task = TRUE)
	if(!selected_bird)
		return

	if(!QDELETED(selected_bird) && !performing_task)
		spawn(-1)
			selected_bird.say("Sentient-level instruction suspended, resuming automated subroutines.", forced = "overmind control ended")

	UnregisterSignal(selected_bird, COMSIG_PARENT_QDELETING)
	REMOVE_TRAIT(selected_bird, TRAIT_AI_DISABLE_PLANNING, FLOCK_CONTROLLED_BY_OVERMIND_SOURCE)

	qdel(selected_bird.GetComponent(/datum/component/flock_ping/selected))
	selected_bird = null
	unset_click_ability(owner)

/datum/action/cooldown/flock/control_drone/proc/drone_gone(datum/source)
	SIGNAL_HANDLER

	free_drone()


