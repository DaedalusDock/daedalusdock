/datum/addiction/process_addiction(mob/living/carbon/affected_carbon, delta_time, times_fired)
	.=..()

	var/current_addiction_cycle = LAZYACCESS(affected_carbon.mind.active_addictions, type) //If this is null, we're not addicted
	var/withdrawal_stage

	switch(current_addiction_cycle)
		if(WITHDRAWAL_STAGE1_START_CYCLE to WITHDRAWAL_STAGE1_END_CYCLE)
			withdrawal_stage = 1
		if(WITHDRAWAL_STAGE2_START_CYCLE to WITHDRAWAL_STAGE2_END_CYCLE)
			withdrawal_stage = 2
		if(WITHDRAWAL_STAGE3_START_CYCLE to WITHDRAWAL_STAGE3_END_CYCLE)
			withdrawal_stage = 3
		if(WITHDRAWAL_STATE_4_START_CYCLE to INFINITY)
		else
			withdrawal_stage = 0

	switch(current_addiction_cycle)
		if(WITHDRAWAL_STAGE1_START_CYCLE)
			withdrawal_enters_stage_1(affected_carbon)
		if(WITHDRAWAL_STAGE2_START_CYCLE)
			withdrawal_enters_stage_2(affected_carbon)
		if(WITHDRAWAL_STAGE3_START_CYCLE)
			withdrawal_enters_stage_3(affected_carbon)
		if(WITHDRAWAL_STAGE3_START_CYCLE)
			withdrawal_enters_stage_4(affected_carbon)

	///One cycle is 2 seconds
	switch(withdrawal_stage)
		if(1)
			withdrawal_stage_1_process(affected_carbon, delta_time)
		if(2)
			withdrawal_stage_2_process(affected_carbon, delta_time)
		if(3)
			withdrawal_stage_3_process(affected_carbon, delta_time)
		if(4)
			withdrawal_stage_4_process(affected_carbon, delta_time)

	LAZYADDASSOC(affected_carbon.mind.active_addictions, type, 1 * delta_time) //Next cycle!

/datum/addiction/proc/withdrawal_enters_stage_4(mob/living/carbon/affected_carbon)

/// Called when addiction is in stage 4 every process
/datum/addiction/proc/withdrawal_stage_4_process(mob/living/carbon/affected_carbon, delta_time)
	if(DT_PROB(20, delta_time))
		to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[4]]"))
