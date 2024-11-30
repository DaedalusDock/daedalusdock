/datum/round_event_control/heart_attack
	name = "Random Heart Attack"
	typepath = /datum/round_event/heart_attack
	weight = 15
	max_occurrences = 3
	min_players = 15 // To avoid shafting lowpop

/datum/round_event/heart_attack/start()
	var/list/heart_attack_contestants = list()
	for(var/mob/living/carbon/human/victim in shuffle(GLOB.player_list))
		if(victim.stat != CONSCIOUS || !victim.can_heartattack() || victim.has_status_effect(/datum/status_effect/exercised) || (/datum/pathogen/heart_failure in victim.diseases) || victim.undergoing_cardiac_arrest())
			continue
		if(!(victim.mind.assigned_role.job_flags & JOB_CREW_MEMBER))//only crewmembers can get one, a bit unfair for some ghost roles and it wastes the event
			continue
		if(victim.satiety <= -60) //Multiple junk food items recently
			heart_attack_contestants[victim] = 3
		else
			heart_attack_contestants[victim] = 1

	if(LAZYLEN(heart_attack_contestants))
		var/mob/living/carbon/human/winner = pick_weight(heart_attack_contestants)
		var/datum/pathogen/D = new /datum/pathogen/heart_failure()
		winner.try_contract_pathogen(D, FALSE, TRUE)
		announce_to_ghosts(winner)
