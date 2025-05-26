/datum/directive/church
	name = "Mandatory Church Service"
	desc = "The local Chaplain must hold a service for all colonists to attend."

	severity = DIRECTIVE_SEVERITY_MED
	enact_delay = 8 MINUTES

	reward = 1000

	var/duration = 8 MINUTES
	var/end_time

/datum/directive/church/can_roll()
	. = ..()
	if(!.)
		return

	. = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != CONSCIOUS)
			continue

		if(!H.client || H.client?.is_afk())
			continue

		if(istype(H.mind?.assigned_role, /datum/job/chaplain))
			return TRUE

/datum/directive/church/start()
	. = ..()
	end_time = world.time + enact_delay + duration

/datum/directive/church/check_completion()
	if(world.time >= end_time)
		return DIRECTIVE_SUCCESS

	return ..()

/datum/directive/church/get_announce_start_text()
	return "All colonists must attend the next church service."

/datum/directive/church/get_announce_end_text(successful)
	return "Mandatory church service has concluded."
