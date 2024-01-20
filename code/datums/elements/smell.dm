/datum/component/smell
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	///Smells with a higher intensity than the mob's last smell will be smelt instantly
	var/intensity = INTENSITY_NORMAL

	var/cooldown = 4 MINUTES
	//Scent, stank, stench, etc
	var/descriptor
	///The thing you actually smell
	var/scent
	///The radius of turfs to affect
	var/radius = 1

	/// Timer ID for qdeling ourself, if needed
	var/duration_timer

/datum/component/smell/Initialize(intensity, descriptor, scent, radius, duration)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.descriptor = descriptor
	src.scent = scent
	if(radius)
		src.radius = radius

	if(duration)
		duration_timer = QDEL_IN_STOPPABLE(src, duration)

	cooldown = (6 - intensity) MINUTES
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(qdelme))

/datum/component/smell/InheritComponent(datum/component/C, i_am_original, intensity, descriptor, scent, radius, duration)
	if(src.intensity < intensity)
		return

	src.intensity = intensity
	src.descriptor = descriptor
	src.scent = scent
	if(radius)
		src.radius = radius

	if(duration)
		if(duration_timer)
			deltimer(duration_timer)
		duration_timer = QDEL_IN_STOPPABLE(src, duration)

	cooldown = (6 - intensity) MINUTES

/datum/component/smell/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	deltimer(duration_timer)
	return ..()

/datum/component/smell/process()
	var/turf/T = get_turf(parent)
	if(!T?.unsafe_return_air()?.total_moles)
		return

	for(var/mob/living/L in (radius > 4) ? SSspatial_grid.orthogonal_range_search(T, RECURSIVE_CONTENTS_CLIENT_MOBS, radius) : range(radius, T))
		var/datum/component/smell/S = L.next_smell?.resolve()
		if(QDELETED(S) || S.intensity < intensity || get_dist(get_turf(L), get_turf(S.parent)) > S.radius)
			L.next_smell = WEAKREF(src)

/datum/component/smell/proc/print_to(mob/living/user)
	switch(intensity)
		if(1)
			if(issilicon(user))
				to_chat(user, span_notice("Your sensors detect trace amounts of [scent] in the air."))
			else
				to_chat(user, span_subtle("The subtle [descriptor] of [scent] tickles your nose..."))

		if(2)
			if(issilicon(user))
				to_chat(user, span_obviousnotice("Your sensors pick up the presence of [scent] in the air."))
			else
				to_chat(user, span_obviousnotice("The [descriptor] of [scent] fills the air."))
		if(3)
			if(issilicon(user))
				to_chat(user, span_warning("Your sensors pick up an intense concentration of [scent]."))
			else
				to_chat(user, span_warning("The unmistakable [descriptor] of [scent] bombards your nostrils."))
		if(4)
			if(issilicon(user))
				to_chat(user, span_alert("ALERT! Your sensors pick up an overwhelming concentration of [scent]."))
			else
				to_chat(user, span_alert("The overwhelming [descriptor] of [scent] assaults your senses. You stifle a gag."))


/datum/component/smell/proc/qdelme()
	SIGNAL_HANDLER
	qdel(src)


/// An object for placing smells in the world that aren't attached to a physical object
/obj/effect/abstract/smell_holder
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	invisibility = INVISIBILITY_MAXIMUM

	var/intensity
	var/descriptor
	var/scent
	var/radius
	var/duration

/obj/effect/abstract/smell_holder/Initialize(mapload, intensity, descriptor, scent, radius, duration)
	. = ..()
	if(!mapload && duration < 1)
		stack_trace("Something tried to spawn an infinite duration smell object outside of mapping, don't do this.")
		return INITIALIZE_HINT_QDEL

	AddComponent(\
		/datum/component/smell, \
		src.intensity || intensity, \
		src.descriptor || descriptor, \
		src.scent || scent, \
		src.radius || radius, \
	)

	if(duration)
		QDEL_IN(src, duration)

/obj/effect/abstract/smell_holder/detective_office
	intensity = INTENSITY_SUBTLE
	descriptor = SCENT_HAZE
	scent = "a time long since passed"
	radius = 2

	duration = 15 MINUTES
