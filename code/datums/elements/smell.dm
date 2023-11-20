/datum/component/smell
	///Smells with a higher intensity than the mob's last smell will be smelt instantly
	var/intensity = 2

	var/cooldown = 4 MINUTES
	//Scent, stank, stench, etc
	var/descriptor
	///The thing you actually smell
	var/scent
	///The radius of turfs to affect
	var/radius = 1

/datum/component/smell/Initialize(descriptor, scent, radius, duration)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.descriptor = descriptor
	src.scent = scent
	if(radius)
		src.radius = radius

	if(duration)
		QDEL_IN(src, duration)

	START_PROCESSING(SSprocessing, src)

/datum/component/smell/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/smell/process()
	var/turf/T = get_turf(parent:drop_location())
	if(!T?.unsafe_return_air()?.total_moles)
		return

	for(var/mob/living/L as mob in range(radius, parent))
		try_print_to(L)

/datum/component/smell/proc/try_print_to(mob/living/user)
	if(!user.can_smell(intensity))
		return
	if(issilicon(user))
		to_chat(user, span_notice("Your sensors pick up the presence of [scent] in the air."))
	else
		to_chat(user, span_notice("The [descriptor] of [scent] fills the air."))

	user.last_smell_intensity = intensity
	COOLDOWN_START(user, smell_time, cooldown)

/datum/component/smell/subtle
	cooldown = 5 MINUTES
	intensity = 1

/datum/component/smell/subtle/try_print_to(mob/living/user)
	if(!user.can_smell(intensity))
		return
	if(issilicon(user))
		to_chat(user, span_notice("Your sensors detect trace amounts of [scent] in the air."))
	else
		to_chat(user, span_subtle("The subtle [descriptor] of [scent] tickles your nose..."))

	user.last_smell_intensity = intensity
	COOLDOWN_START(user, smell_time, cooldown)

/datum/component/smell/strong
	cooldown = 3 MINUTES
	intensity = 3

/datum/component/smell/strong/try_print_to(mob/living/user)
	if(!user.can_smell(intensity))
		return
	if(issilicon(user))
		to_chat(user, span_warning("Your sensors pick up an intense concentration of [scent]."))
	else
		to_chat(user, span_warning("The unmistakable [descriptor] of [scent] bombards your nostrils."))

	user.last_smell_intensity = intensity
	COOLDOWN_START(user, smell_time, cooldown)

/datum/component/smell/overpowering
	cooldown = 2 MINUTES
	intensity = 4

/datum/component/smell/overpowering/try_print_to(mob/living/user)
	if(!user.can_smell(intensity))
		return
	if(issilicon(user))
		to_chat(user, span_warning("ALERT! Your sensors pick up an overwhelming concentration of [scent]."))
	else
		to_chat(user, span_warning("The overwhelming [descriptor] of [scent] assaults your senses. You stifle a gag."))

	user.last_smell_intensity = intensity
	COOLDOWN_START(user, smell_time, cooldown)
