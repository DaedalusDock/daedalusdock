/datum/action/cooldown/flock/cage_mob
	name = "Ping"
	desc = "Request attention from other elements of the flock."
	button_icon_state = "ping"
	cooldown_time = 5 SECONDS
	click_to_activate = TRUE

	var/obj/effect/abstract/flock_conversion/turf_effect

/datum/action/cooldown/flock/cage_mob/New(Target)
	. = ..()
	turf_effect = new(null)

/datum/action/cooldown/flock/cage_mob/Destroy()
	QDEL_NULL(turf_effect)
	return ..()

/datum/action/cooldown/flock/cage_mob/is_valid_target(atom/cast_on)
	return ishuman(cast_on)

/datum/action/cooldown/flock/cage_mob/Activate(atom/target)
	var/mob/living/simple_animal/flock/bird = owner
	var/turf/T = get_turf(target)
	ADD_TRAIT(bird, TRAIT_AI_PAUSED, ref(src))

	owner.visible_message(
		span_notice("<b>[owner]</b> begins forming a cuboid structure around <b>[target]</b>."),
		blind_message = span_hear("You hear strange building noises."),
	)

	T.add_viscontents(turf_effect)
	if(iswallturf(T))
		turf_effect.icon_state = "spawn-wall-loop"
		flick("spawn-wall", turf_effect)

	. = TRUE
	playsound(owner, 'goon/sounds/flockmind/flockdrone_convert.ogg', 30, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
	if(!do_after(owner, target, 4.5 SECONDS, DO_PUBLIC, interaction_key = "flock_cage"))
		. = FALSE

	REMOVE_TRAIT(bird, TRAIT_AI_PAUSED, ref(src))
	T.remove_viscontents(turf_effect)
	if(!.)
		return

	var/obj/structure/flock/cage/cage = new(T, bird.flock)
	cage.cage_mob(target)
	..()
