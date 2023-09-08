///Prevent a thing from being qdeleted. For ashwalkers, primarily.
/datum/objective/protect_object
	name = "protect object"
	var/datum/weakref/protect_target
	var/protection_target_gone = FALSE

/datum/objective/protect_object/proc/set_target(obj/O)
	if(protect_target)
		var/obj/real_target = protect_target.resolve()
		UnregisterSignal(real_target, COMSIG_PARENT_QDELETING)
		protection_target_gone = FALSE
	protect_target = WEAKREF(O)
	RegisterSignal(O, COMSIG_PARENT_QDELETING, PROC_REF(object_destroyed))
	update_explanation_text()

/datum/objective/protect_object/update_explanation_text()
	. = ..()
	if(protect_target)
		explanation_text = "Protect \the [protect_target.resolve()] at all costs."
	else
		explanation_text = "Free objective."

/datum/objective/protect_object/check_completion()
	return protection_target_gone

/datum/objective/protect_object/proc/object_destroyed()
	protection_target_gone = TRUE
	protect_target = null
