/datum/antagonist/vampire
	name = "\improper Blood Plague Victim"
	roundend_category = "vampires"
	antagpanel_category = "Vampire"
	job_rank = ROLE_VAMPIRE
	antag_hud_name = "traitor"

	/// The thirst!
	var/datum/point_holder/thirst_level = 0
	var/thirst_stage = THIRST_STAGE_SATED

	var/datum/vampiric_thirst/stage_datum = null

/datum/antagonist/vampire/New()
	. = ..()
	thirst_level = new()
	thirst_level.add_points(THIRST_THRESHOLD_FULL)

/datum/antagonist/vampire/Destroy()
	QDEL_NULL(thirst_level)
	return ..()

/datum/antagonist/vampire/on_gain()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/datum/antagonist/vampire/on_removal()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/datum/antagonist/vampire/process(delta_time)
	var/mob/living/carbon/human/host = owner.current
	if(!istype(host))
		return

	if(host.stat == DEAD)
		return

	thirst_level.add_points(1)

	var/new_stage
	switch(thirst_level.has_points())
		if(THIRST_THRESHOLD_BLOODLUST to THIRST_THRESHOLD_SATED-1)
			new_stage = THIRST_STAGE_BLOODLUST

		if(THIRST_THRESHOLD_SATED to THIRST_THRESHOLD_HUNGERY-1)
			new_stage = THIRST_STAGE_SATED

		if(THIRST_THRESHOLD_HUNGERY to THIRST_THRESHOLD_STARVING-1)
			new_stage = THIRST_STAGE_HUNGRY

		if(THIRST_THRESHOLD_STARVING to THIRST_THRESHOLD_WASTING-1)
			new_stage = THIRST_STAGE_STARVING

		if(THIRST_THRESHOLD_WASTING to THIRST_THRESHOLD_DEAD-1)
			new_stage = THIRST_STAGE_WASTING

		if(THIRST_THRESHOLD_DEAD to INFINITY)
			death_by_thirst(host)
			return

	set_thirst_stage(new_stage)
	stage_datum.tick(src, host)

/// You died cuz you aint suckin' hard enough
/datum/antagonist/vampire/proc/death_by_thirst(mob/living/carbon/human/host)
	host.death(cause_of_death = "The Thirst")
	host.setBloodVolume(0)

	for(var/obj/item/organ/O as anything in host.processing_organs)
		if(O.organ_flags & ORGAN_SYNTHETIC)
			continue

		O.germ_level = INFECTION_LEVEL_THREE
		set_organ_dead(TRUE, "Necrosis")

	thirst_level.remove_points(INFINITY)

/// Setter for the thirst stage.
/datum/antagonist/vampire/proc/set_thirst_stage(new_stage)
	var/old_stage = thirst_stage
	thirst_stage = new_stage
	if(old_stage == thirst_stage)
		return null

	if(old_stage > thirst_stage)
		for(var/i in old_stage to thirst_stage+1 step -1)
			var/datum/vampiric_thirst/higher_stage = GLOB.vampiric_thirst_datums[i]
			higher_stage.on_regress(src, thirst_stage)
	else
		for(var/i in 1 to thirst_stage-1)
			var/datum/vampiric_thirst/higher_stage = GLOB.vampiric_thirst_datums[i]
			higher_stage.on_progress(src, thirst_stage)

	stage_datum = GLOB.vampiric_thirst_datums[thirst_stage]
	stage_datum.enter_stage(src)

	return old_stage
