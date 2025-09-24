/datum/status_effect/buckled_to_bed
	id = "buckledtobed"
	alert_type = null

	duration = -1

	var/trying_to_sleep = FALSE
	COOLDOWN_DECLARE(try_wakeup_cooldown)

/datum/status_effect/buckled_to_bed/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_CARBON_HELP_ACT, PROC_REF(on_shaken))
	RegisterSignal(owner, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_change))
	update_alerts()

/datum/status_effect/buckled_to_bed/on_remove()
	. = ..()
	owner.clear_alert("sleepytime")
	owner.clear_alert("endsleepytime")
	UnregisterSignal(owner, list(COMSIG_CARBON_HELP_ACT, COMSIG_MOB_STATCHANGE))

/datum/status_effect/buckled_to_bed/proc/update_alerts()
	if(owner.stat == DEAD)
		owner.clear_alert("sleepytime")
		owner.clear_alert("endsleepytime")
		return

	if(owner.IsSleeping())
		owner.clear_alert("sleepytime")
		linked_alert = owner.throw_alert("endsleepytime", /atom/movable/screen/alert/status_effect/sleepy_time/end)
	else
		owner.clear_alert("endsleepytime")
		linked_alert = owner.throw_alert("sleepytime", /atom/movable/screen/alert/status_effect/sleepy_time)

	linked_alert.attached_effect = src

/datum/status_effect/buckled_to_bed/tick(delta_time, times_fired)
	if(trying_to_sleep)
		owner.Sleeping(2 SECONDS)

/datum/status_effect/buckled_to_bed/proc/toggle_sleep_intent()
	if(trying_to_sleep && owner.IsSleeping() && !COOLDOWN_FINISHED(src, try_wakeup_cooldown))
		to_chat(owner, span_warning("You can not wake up yet."))
		return

	trying_to_sleep = !trying_to_sleep

	if(trying_to_sleep)
		to_chat(owner, span_notice("You are now trying to sleep."))
		COOLDOWN_START(src, try_wakeup_cooldown, 10 SECONDS)
	else
		to_chat(owner, span_notice("You are no longer trying to sleep."))

/datum/status_effect/buckled_to_bed/proc/on_shaken(datum/source, mob/living/shaker)
	SIGNAL_HANDLER
	trying_to_sleep = FALSE

/datum/status_effect/buckled_to_bed/proc/on_stat_change()
	SIGNAL_HANDLER
	spawn(0) // The status effect is mid "on_apply" at this point
		update_alerts()
