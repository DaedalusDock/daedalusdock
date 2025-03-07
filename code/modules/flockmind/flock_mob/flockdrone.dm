/mob/living/simple_animal/flock/drone
	ai_controller = /datum/ai_controller/flock/drone

	compute_provided = FLOCK_COMPUTE_COST_DRONE
	var/flock_phasing = FALSE
	/// A mob possessing this mob.
	var/mob/camera/flock/controlled_by

/mob/living/simple_animal/flock/drone/Initialize(mapload, join_flock)
	. = ..()
	flock?.stat_drones_made++

	ADD_TRAIT(src, TRAIT_IMPORTANT_SPEAKER, INNATE_TRAIT)

	AddComponent(/datum/component/flock_protection, FALSE, TRUE, FALSE, FALSE)
	set_real_name(flock_realname(FLOCK_TYPE_DRONE))
	name = flock_name(FLOCK_TYPE_DRONE)

	if(stat == CONSCIOUS)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), pick(GLOB.flockdrone_created_phrases), null, null, null, null, null, "flock spawn")

	var/datum/action/cooldown/flock/flock_heal/repair = new
	repair.Grant(src)

/mob/living/simple_animal/flock/drone/Destroy()
	release_control()
	QDEL_NULL(resources)
	return ..()

/mob/living/simple_animal/flock/drone/death(gibbed, cause_of_death)
	stop_flockphase()
	say(pick(GLOB.flockdrone_death_phrases))
	if(flock)
		flock_talk(null, "Connection to drone [real_name] lost.", flock)
	return ..()

/mob/living/simple_animal/flock/drone/Life(delta_time, times_fired)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_FLOCKPHASE))
		resources.remove_points(1)
		if(!resources.has_points(1))
			stop_flockphase()

/mob/living/simple_animal/flock/drone/get_flock_data()
	var/list/data = ..()
	var/current_behavior_name

	if(controlled_by)
		data["task"] = "controlled"
		data["controller_ref"] = REF(controlled_by)

	else if((ai_controller.ai_status == AI_ON) && length(ai_controller.current_behaviors))
		var/datum/ai_behavior/flock/current_task = ai_controller.current_behaviors[1]
		if(istype(current_task))
			current_behavior_name = current_task.name

	data["task"] = current_behavior_name || "hibernating"
	return data

/mob/living/simple_animal/flock/drone/proc/start_flockphase()
	if(HAS_TRAIT(src, TRAIT_FLOCKPHASE))
		return FALSE

	playsound(src, 'goon/sounds/flockmind/flockdrone_floorrun.ogg', 30, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	ADD_TRAIT(src, TRAIT_FLOCKPHASE, INNATE_TRAIT)
	pass_flags_self |= LETPASSTHROW | PASSFLOCK

	current_size = 0

	set_density(FALSE)
	release_all_grabs()
	add_movespeed_modifier(/datum/movespeed_modifier/flockphase)

	var/list/color_matrix = list(1,0,0, 0,1,0, 0,0,1, 0.15,0.77,0.66)
	var/matrix/shrink = matrix().Scale(0)
	animate(src, color = color_matrix, transform = shrink, time = 0.5 SECONDS, easing = SINE_EASING)
	return TRUE

/mob/living/simple_animal/flock/drone/proc/stop_flockphase()
	if(!HAS_TRAIT(src, TRAIT_FLOCKPHASE))
		return FALSE


	playsound(src, 'goon/sounds/flockmind/flockdrone_floorrun.ogg', 30, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	REMOVE_TRAIT(src, TRAIT_FLOCKPHASE, INNATE_TRAIT)
	pass_flags_self &= ~(LETPASSTHROW | PASSFLOCK)
	current_size = initial_size
	set_density(TRUE)
	remove_movespeed_modifier(/datum/movespeed_modifier/flockphase)

	animate(src, color = null, transform = null, time = 0.5 SECONDS, easing = SINE_EASING)

	if(!isturf(loc))
		return

	if(istype(loc, /turf/open/floor/flock))
		var/turf/open/floor/flock/flockfloor = loc
		flockfloor.turn_off()

	var/turf/turfloc = loc
	if(turfloc.can_flock_occupy(src))
		return

	for(var/turf/T in get_adjacent_open_turfs(src))
		if(!T.can_flock_occupy(src))
			forceMove(T)
			break

/mob/living/simple_animal/flock/drone/proc/can_flockphase()
	if(length(grabbed_by))
		return FALSE

	if(!resources.has_points())
		return FALSE

	return TRUE

/mob/living/simple_animal/flock/drone/proc/flockphase_tax()
	if(!HAS_TRAIT(src, TRAIT_FLOCKPHASE))
		return FALSE

	resources.remove_points(1)
	if(!resources.has_points())
		stop_flockphase()
		return FALSE
	return TRUE

/mob/living/simple_animal/flock/drone/proc/take_control(mob/camera/flock/master_bird)
	if(HAS_TRAIT_FROM(src, TRAIT_AI_DISABLE_PLANNING, FLOCK_CONTROLLED_BY_OVERMIND_SOURCE))
		to_chat(master_bird, span_alert("This drone is recieving a sentient-level instruction."))
		return FALSE

	if(controlled_by)
		to_chat(master_bird, span_alert("This drone is already under another partition's command."))
		return FALSE

	stop_flockphase()

	controlled_by = master_bird
	controlled_by.controlling_bird = src

	if(controlled_by.mind)
		controlled_by.mind.transfer_to(src)
	else
		key = controlled_by.key

	if(isflocktrace(controlled_by))
		flock.add_notice(src, FLOCK_NOTICE_FLOCKTRACE_CONTROL)
	else
		flock.add_notice(src, FLOCK_NOTICE_FLOCKMIND_CONTROL)

	to_chat(src, "<span class='flocksay'><b>\[SYSTEM: Control of drone [real_name] established.\]</b></span>")
	return TRUE

/mob/living/simple_animal/flock/drone/proc/release_control()
	if(isnull(controlled_by))
		return

	var/mob/camera/flock/master_bird = controlled_by
	master_bird = null

	if(flock)
		flock.remove_notice(src, FLOCK_NOTICE_FLOCKMIND_CONTROL)
		flock.remove_notice(src, FLOCK_NOTICE_FLOCKTRACE_CONTROL)

	if(isnull(master_bird) && ckey)
		if(flock)
			master_bird = new /mob/camera/flock/trace(src, flock)
		else
			ghostize(FALSE)

	if(!master_bird)
		return

	master_bird.forceMove(get_turf(src))
	if(mind)
		mind.transfer_to(master_bird)

	flock_talk(null, "Control of [real_name] surrendered.", flock)

/mob/living/simple_animal/flock/drone/proc/split_into_bits()
	ai_controller.PauseAi(3 SECONDS)
	say("\[System notification: drone diffracting.\]", forced = "flock diffract")
	emote("scream")
	flock?.free_unit(src)

	var/turf/T = get_turf(src)
	for(var/i in 1 to 3)
		var/mob/living/simple_animal/flock/bit/bitty_bird = new(T, flock)
		bitty_bird.i_just_split(T)

	var/list/new_color = list(1,0,0, 0,1,0, 0,0,1, 0.15,0.77,0.66)
	color = null
	animate(src, color=new_color, alpha = 0, time = 0.5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(finish_splitting)), 0.5 SECONDS)

/mob/living/simple_animal/flock/drone/proc/finish_splitting()
	qdel(src)
