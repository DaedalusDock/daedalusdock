GLOBAL_LIST_INIT(vampiric_thirst_datums, list(
	new /datum/vampiric_thirst/bloodthirst,
	new /datum/vampiric_thirst/sated,
	new /datum/vampiric_thirst/hungery,
	new /datum/vampiric_thirst/starving,
	new /datum/vampiric_thirst/wasting,
))

/datum/vampiric_thirst


/// Called when this is becoming the vampire's current stage.
/datum/vampiric_thirst/proc/enter_stage(datum/antagonist/vampire/antag_datum)
	return

/// Called when a vampire past this stage is going further.
/datum/vampiric_thirst/proc/on_progress(datum/antagonist/vampire/antag_datum, new_thirst_stage)
	return

/// Called when a vampire past this stage is regressing.
/datum/vampiric_thirst/proc/on_regress(datum/antagonist/vampire/antag_datum, new_thirst_stage)
	return

/datum/vampiric_thirst/proc/tick(datum/antagonist/vampire/antag_datum, mob/living/carbon/human/host)
	return

/datum/vampiric_thirst/bloodthirst

/datum/vampiric_thirst/sated

/datum/vampiric_thirst/hungery

/datum/vampiric_thirst/starving

/datum/vampiric_thirst/wasting
