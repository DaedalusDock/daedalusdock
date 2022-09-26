/datum/stamina_container
	///Daddy?
	var/mob/living/parent
	///The maximum amount of stamina this container has
	var/maximum = 0
	///How much stamina we have right now
	var/current = 0
	///The amount of stamina gained per second
	var/regen_rate = 10
	///The difference between current and maximum stamina
	var/loss = 0
	var/loss_as_percent = 0
	///Are we regenerating right now?
	var/is_regenerating = TRUE
	///In this many ticks, resume regenerating
	var/resume_in = 0

/datum/stamina_container/New(maximum = STAMINA_MAX, regen_rate = STAMINA_REGEN)
	src.maximum = maximum
	src.regen_rate = regen_rate
	START_PROCESSING(SSstamina, src)

/datum/stamina_container/Destroy()
	STOP_PROCESSING(SSstamina, src)
	parent.stamina = null
	parent = null
	return ..()

/datum/stamina_container/proc/update(delta_time)

	if(is_regenerating)
		current = max(current + (regen_rate*delta_time))
	else if(delta_time)
		resume_in -= 1 * (delta_time SECONDS)
	loss = maximum - current
	loss_as_percent = current / maximum

	parent.on_stamina_update()

///Pause stamina regeneration for some period of time. Does not support doing this from multiple sources at once because I do not do that and I will add it later if I want to.
/datum/stamina_container/proc/pause(time)
	is_regenerating = FALSE

///Stops stamina regeneration entirely until manually resumed.
/datum/stamina_container/proc/stop()
	is_regenerating = FALSE

///Resume stamina processing
/datum/stamina_container/proc/resume()
	is_regenerating = TRUE

///Adjust stamina by an amount.
/datum/stamina_container/proc/adjust(amt as num, forced)
	if(!amt)
		return
	///Our parent might want to fuck with these numbers
	var/modify = parent.pre_stamina_change(current + amt, forced)

	current = clamp(modify, 0, maximum)

