/// Status effects are used to apply temporary or permanent effects to mobs.
/// This file contains their code, plus code for applying and removing them.
/datum/status_effect
	/// The ID of the effect. ID is used in adding and removing effects to check for duplicates, among other things.
	var/id = "effect"
	/// When set initially / in on_creation, this is how long the status effect lasts in deciseconds.
	/// While processing, this becomes the world.time when the status effect will expire.
	/// -1 = infinite duration.
	var/duration = STATUS_EFFECT_PERMANENT
	/// The maximum duration this status effect can be.
	/// -1 = No limit
	var/max_duration = STATUS_EFFECT_PERMANENT
	/// This is how long between [proc/tick] calls in deciseconds.
	/// This has to be a multiple of the [var/wait] of the subsystem this status effect is running on, which is based on [var/processing_speed].
	/// Putting STATUS_EFFECT_NO_TICK here will stop [proc/tick] calls, and if [var/duration] is STATUS_EFFECT_PERMANENT, it stops processing entirely.
	/// Putting STATUS_EFFECT_AUTO_TICK here will make every subsystem tick call [proc/tick], making the tick interval depend entirely on [var/processing_speed]
	var/tick_interval = 1 SECONDS
	/// The time until the next [proc/tick] call, gets set to [var/tick_interval] after every [proc/tick] call and decrements on every [proc/process] call.
	var/time_until_next_tick

	/// The mob affected by the status effect.
	var/mob/living/owner
	/// How many of the effect can be on one mob, and/or what happens when you try to add a duplicate.
	var/status_type = STATUS_EFFECT_UNIQUE
	/// If TRUE, we call [proc/on_remove] when owner is deleted. Otherwise, we call [proc/be_replaced].
	var/on_remove_on_mob_delete = FALSE
	/// The typepath to the alert thrown by the status effect when created.
	/// Status effect "name"s and "description"s are shown to the owner here.
	var/alert_type = /atom/movable/screen/alert/status_effect
	/// The alert itself, created in [proc/on_creation] (if alert_type is specified).
	var/atom/movable/screen/alert/status_effect/linked_alert
	/// Used to define if the status effect should be using SSfastprocess or SSprocessing
	var/processing_speed = STATUS_EFFECT_FAST_PROCESS

/datum/status_effect/New(list/arguments)
	on_creation(arglist(arguments))

/// Called from New() with any supplied status effect arguments.
/// Not guaranteed to exist by the end.
/// Returning FALSE from on_apply will stop on_creation and self-delete the effect.
/datum/status_effect/proc/on_creation(mob/living/new_owner, ...)
	if(new_owner)
		owner = new_owner
	if(QDELETED(owner) || !on_apply())
		qdel(src)
		return
	if(owner)
		LAZYADD(owner.status_effects, src)

	if(duration == INFINITY)
		// we will optionally allow INFINITY, because i imagine it'll be convenient in some places,
		// but we'll still set it to -1 / STATUS_EFFECT_PERMANENT for proper unified handling
		duration = STATUS_EFFECT_PERMANENT

	if(tick_interval != STATUS_EFFECT_NO_TICK)
		time_until_next_tick = tick_interval

	if(alert_type)
		var/atom/movable/screen/alert/status_effect/new_alert = owner.throw_alert(id, alert_type)
		new_alert.attached_effect = src //so the alert can reference us, if it needs to
		linked_alert = new_alert //so we can reference the alert, if we need to

	if(duration != STATUS_EFFECT_PERMANENT || tick_interval != STATUS_EFFECT_NO_TICK) //don't process if we don't care
		switch(processing_speed)
			if(STATUS_EFFECT_FAST_PROCESS)
				START_PROCESSING(SSfastprocess, src)
			if(STATUS_EFFECT_NORMAL_PROCESS)
				START_PROCESSING(SSprocessing, src)
			if(STATUS_EFFECT_PRIORITY)
				START_PROCESSING(SSpriority_effects, src)

	SEND_SIGNAL(owner, COMSIG_LIVING_STATUS_APPLIED, src)
	return TRUE

/datum/status_effect/Destroy()
	switch(processing_speed)
		if(STATUS_EFFECT_FAST_PROCESS)
			STOP_PROCESSING(SSfastprocess, src)
		if (STATUS_EFFECT_NORMAL_PROCESS)
			STOP_PROCESSING(SSprocessing, src)
		if(STATUS_EFFECT_PRIORITY)
			STOP_PROCESSING(SSpriority_effects, src)

	if(owner)
		linked_alert = null
		owner.clear_alert(id)
		LAZYREMOVE(owner.status_effects, src)
		on_remove()
		SEND_SIGNAL(owner, COMSIG_LIVING_STATUS_REMOVED, src)
		owner = null
	return ..()

// Status effect process. Handles adjusting its duration and ticks.
// If you're adding processed effects, put them in [proc/tick]
// instead of extending / overriding the process() proc.
/datum/status_effect/process(seconds_per_tick)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(QDELETED(owner))
		qdel(src)
		return

	if (duration != STATUS_EFFECT_PERMANENT)
		duration = max(0, duration - (seconds_per_tick SECONDS)) // doing it first means its more up to date for ticks to read

	if (tick_interval != STATUS_EFFECT_NO_TICK)
		time_until_next_tick = max(0, time_until_next_tick - (seconds_per_tick SECONDS)) // same here

	if(tick_interval == STATUS_EFFECT_AUTO_TICK)
		tick(seconds_per_tick)
	else if(tick_interval != STATUS_EFFECT_NO_TICK && time_until_next_tick <= 0)
		time_until_next_tick = tick_interval // same here as well
		tick(tick_interval / 10)

	if(QDELING(src))
		return // tick deleted us, no need to continue

	if(duration != STATUS_EFFECT_PERMANENT)
		if(duration <= 0)
			qdel(src)
			return

/// Called whenever the effect is applied in on_created
/// Returning FALSE will cause it to delete itself during creation instead.
/datum/status_effect/proc/on_apply()
	return TRUE

/// Gets and formats examine text associated with our status effect.
/// Return 'null' to have no examine text appear (default behavior).
/datum/status_effect/proc/get_examine_text()
	return null

/// Called every tick from process().
/datum/status_effect/proc/tick(delta_time, times_fired)
	return

/// Called whenever the buff expires or is removed (qdeleted)
/// Note that at the point this is called, it is out of the
/// owner's status_effects list, but owner is not yet null
/datum/status_effect/proc/on_remove()
	return

/// Called instead of on_remove when a status effect
/// of status_type STATUS_EFFECT_REPLACE is replaced by itself,
/// or when a status effect with on_remove_on_mob_delete
/// set to FALSE has its mob deleted
/datum/status_effect/proc/be_replaced()
	linked_alert = null
	owner.clear_alert(id)
	LAZYREMOVE(owner.status_effects, src)
	owner = null
	qdel(src)

/// Called before being fully removed (before on_remove)
/// Returning FALSE will cancel removal
/datum/status_effect/proc/before_remove()
	return TRUE

/// Called when a status effect of status_type STATUS_EFFECT_REFRESH
/// has its duration refreshed in apply_status_effect - is passed New() args
/datum/status_effect/proc/refresh(mob/living/parent, effect_path, ...)
	duration = initial(duration)

/// Called when a status effect of status_type STATUS_EFFECT_EXTEND
/// has its duration extended in apply_status_effect - is passed New() args
/datum/status_effect/proc/extend(mob/living/parent, effect_path, ...)
	var/original_duration = initial(duration)
	if(original_duration == -1)
		return
	duration += original_duration

/// Adds nextmove modifier multiplicatively to the owner while applied
/datum/status_effect/proc/nextmove_modifier()
	return 1

/// Adds nextmove adjustment additiviely to the owner while applied
/datum/status_effect/proc/nextmove_adjust()
	return 0

/// Removes [seconds] of duration from the status effect.
/// Returns whether or not the status effect was qdeleted due to running out of duration.
/datum/status_effect/proc/remove_duration(seconds)
	if(duration == STATUS_EFFECT_PERMANENT) // Infinite duration
		return FALSE

	duration -= (seconds SECONDS)
	if(duration <= 0)
		qdel(src)
		return TRUE

	return FALSE

/// Alert base type for status effect alerts
/atom/movable/screen/alert/status_effect
	name = "Curse of Mundanity"
	desc = "You don't feel any different..."
	/// The status effect we're linked to
	var/datum/status_effect/attached_effect

/atom/movable/screen/alert/status_effect/Destroy()
	attached_effect = null //Don't keep a ref now
	return ..()
