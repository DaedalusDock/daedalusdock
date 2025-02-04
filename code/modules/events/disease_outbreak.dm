/datum/round_event_control/disease_outbreak
	name = "Disease Outbreak"
	typepath = /datum/round_event/disease_outbreak
	max_occurrences = 1
	min_players = 25
	weight = 5

/datum/round_event/disease_outbreak
	announceWhen = 15

	var/virus_type

	var/max_severity = 3


/datum/round_event/disease_outbreak/announce(fake)
	priority_announce("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", sound_type = ANNOUNCER_OUTBREAK7)

/datum/round_event/disease_outbreak/setup()
	announceWhen = rand(15, 30)


/datum/round_event/disease_outbreak/start()
	var/advanced_virus = FALSE
	max_severity = 3 + max(FLOOR2((world.time - control.earliest_start)/6000, 1),0) //3 symptoms at 20 minutes, plus 1 per 10 minutes
	if(!virus_type && prob(20 + (10 * max_severity)))
		advanced_virus = TRUE

	if(!virus_type && !advanced_virus)
		virus_type = pick(/datum/pathogen/advance/flu, /datum/pathogen/advance/cold, /datum/pathogen/brainrot, /datum/pathogen/magnitis)

	for(var/mob/living/carbon/human/H in shuffle(GLOB.alive_mob_list))
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(!is_station_level(T.z))
			continue
		if(!H.client)
			continue
		if(H.stat == DEAD)
			continue
		if(HAS_TRAIT(H, TRAIT_VIRUSIMMUNE)) //Don't pick someone who's virus immune, only for it to not do anything.
			continue
		var/foundAlready = FALSE // don't infect someone that already has a disease
		for(var/thing in H.diseases)
			foundAlready = TRUE
			break
		if(foundAlready)
			continue

		var/datum/pathogen/D
		if(!advanced_virus)
			D = new virus_type()
		else
			D = new /datum/pathogen/advance/random(max_severity, max_severity)

		D.affected_mob_is_only_carrier = TRUE
		H.try_contract_pathogen(D, FALSE, TRUE)

		if(advanced_virus)
			var/datum/pathogen/advance/A = D
			var/list/name_symptoms = list() //for feedback
			for(var/datum/symptom/S in A.symptoms)
				name_symptoms += S.name
			message_admins("An event has triggered a random advanced virus outbreak on [ADMIN_LOOKUPFLW(H)]! It has these symptoms: [english_list(name_symptoms)]")
			log_game("An event has triggered a random advanced virus outbreak on [key_name(H)]! It has these symptoms: [english_list(name_symptoms)]")
		break
