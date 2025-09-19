/datum/status_effect/food/healthy

/datum/status_effect/food/healthy/on_apply()
	. = ..()
	to_chat(owner, span_notice("You feel healthier."))

/datum/status_effect/food/healthy/on_remove()
	. = ..()
	to_chat(owner, span_notice("You no longer feel healthier."))


// Good for organs!
/datum/status_effect/food/healthy/organs
	id = "healthyorgans"

/datum/status_effect/food/healthy/organs/tick(delta_time, times_fired)
	. = ..()
	owner.adjustToxLoss(-1)

// Good for blood!
/datum/status_effect/food/healthy/blood
	id = "healthyblood"

/datum/status_effect/food/healthy/blood/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_CARBON_CHEM_EFFECT_REFRESH, PROC_REF(apply_chem_effect))

/datum/status_effect/food/healthy/blood/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_CARBON_CHEM_EFFECT_REFRESH)

/datum/status_effect/food/healthy/blood/proc/apply_chem_effect(mob/living/carbon/carbo)
	SIGNAL_HANDLER
	APPLY_CHEM_EFFECT(carbo, CE_ANTITOX, 1)
