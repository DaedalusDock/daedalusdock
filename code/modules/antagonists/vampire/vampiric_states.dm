/datum/vampire_state
	var/datum/antagonist/vampire/parent

	/// The minimum stage for this datum to be active.
	var/min_stage
	/// Actions to grant while this stage is active.
	var/list/actions_to_grant

/datum/vampire_state/New(datum/antagonist/vampire/_parent)
	parent = _parent

	for(var/datum/action/action as anything in actions_to_grant)
		actions_to_grant -= action
		action = new action

/datum/vampire_state/Destroy(force, ...)
	parent.state_datums -= src
	parent = null
	QDEL_LIST(actions_to_grant)
	return ..()

/// If this stage can be active.
/datum/vampire_state/proc/can_be_active()
	return parent.thirst_stage >= min_stage

/datum/vampire_state/proc/enter_state(mob/living/carbon/human/host)
	SHOULD_CALL_PARENT(TRUE)
	apply_effects(host)

/// Called when a vampire past this stage is regressing.
/datum/vampire_state/proc/exit_state(mob/living/carbon/human/host)
	SHOULD_CALL_PARENT(TRUE)
	remove_effects(host)

/// Called every second this state is active.
/datum/vampire_state/proc/tick(mob/living/carbon/human/host)
	return

/// Apply persistent effects to the mob.
/datum/vampire_state/proc/apply_effects(mob/living/carbon/human/host)
	SHOULD_CALL_PARENT(TRUE)

	for(var/datum/action/action as anything in actions_to_grant)
		action.Grant(host)

/// Remove persistent effects from the mob.
/datum/vampire_state/proc/remove_effects(mob/living/carbon/human/host)
	SHOULD_CALL_PARENT(TRUE)

	for(var/datum/action/action as anything in actions_to_grant)
		action.Remove(host)

/datum/vampire_state/bloodlust

// Bloodlust is only active at this stage
/datum/vampire_state/bloodlust/can_be_active()
	return parent.thirst_stage == THIRST_STAGE_BLOODLUST

/datum/vampire_state/sated
	min_stage = THIRST_STAGE_SATED

/datum/vampire_state/hungry
	min_stage = THIRST_STAGE_HUNGRY

/datum/vampire_state/starving
	min_stage = THIRST_STAGE_WASTING

/datum/vampire_state/wasting
	min_stage = THIRST_STAGE_WASTING
