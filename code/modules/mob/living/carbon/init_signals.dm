//Called on /mob/living/carbon/Initialize(mapload), for the carbon mobs to register relevant signals.
/mob/living/carbon/register_init_signals()
	. = ..()

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_NOBREATH), PROC_REF(on_nobreath_trait_gain))
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_NOMETABOLISM), PROC_REF(on_nometabolism_trait_gain))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_SOFT_CRITICAL_CONDITION), PROC_REF(on_softcrit_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_SOFT_CRITICAL_CONDITION), PROC_REF(on_softcrit_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_NO_ADDICTION), PROC_REF(on_noaddiction_trait_gain))

/**
 * On gain of TRAIT_NOBREATH
 *
 * This will clear all alerts and moods related to breathing.
 */
/mob/living/carbon/proc/on_nobreath_trait_gain(datum/source)
	SIGNAL_HANDLER

	failed_last_breath = FALSE

	clear_alert(ALERT_TOO_MUCH_OXYGEN)
	clear_alert(ALERT_NOT_ENOUGH_OXYGEN)

	clear_alert(ALERT_TOO_MUCH_PLASMA)
	clear_alert(ALERT_NOT_ENOUGH_PLASMA)

	clear_alert(ALERT_TOO_MUCH_NITRO)
	clear_alert(ALERT_NOT_ENOUGH_NITRO)

	clear_alert(ALERT_TOO_MUCH_CO2)
	clear_alert(ALERT_NOT_ENOUGH_CO2)

/**
 * On gain of TRAIT_NOMETABOLISM
 *
 * This will clear all moods related to addictions and stop metabolization.
 */
/mob/living/carbon/proc/on_nometabolism_trait_gain(datum/source)
	SIGNAL_HANDLER
	for(var/addiction_type in subtypesof(/datum/addiction))
		mind?.remove_addiction_points(addiction_type, MAX_ADDICTION_POINTS) //Remove the addiction!

	reagents.end_metabolization(keep_liverless = TRUE)

/**
 * On gain of TRAIT_NO_ADDICTION
 *
 * This will remove all addictions.
 */
/mob/living/carbon/proc/on_noaddiction_trait_gain(datum/source)
	SIGNAL_HANDLER
	for(var/addiction_type in subtypesof(/datum/addiction))
		mind?.remove_addiction_points(addiction_type, MAX_ADDICTION_POINTS)

/mob/living/carbon/proc/on_softcrit_gain(datum/source)
	SIGNAL_HANDLER

	ADD_TRAIT(src, TRAIT_NO_SPRINT, STAT_TRAIT)
	stamina.add_max_modifier("softcrit", -100)
	stamina.add_regen_modifier("softcrit", -5)
	stamina.process()
	throw_alert(ALERT_SOFTCRIT, /atom/movable/screen/alert/softcrit)
	add_movespeed_modifier(/datum/movespeed_modifier/carbon_softcrit)

/mob/living/carbon/proc/on_softcrit_loss(datum/source)
	SIGNAL_HANDLER

	REMOVE_TRAIT(src, TRAIT_NO_SPRINT, STAT_TRAIT)
	stamina.remove_regen_modifier("softcrit")
	stamina.remove_max_modifier("softcrit")
	clear_alert(ALERT_SOFTCRIT)
	remove_movespeed_modifier(/datum/movespeed_modifier/carbon_softcrit)
