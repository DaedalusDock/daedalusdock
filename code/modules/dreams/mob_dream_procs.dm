/**
 * Begins the dreaming process on a sleeping carbon.
 *
 * Only one dream sequence can be active at a time.
 */

/mob/living/carbon/proc/try_dream(dream_type)
	if(!mind || HAS_TRAIT(mind, TRAIT_DREAMING) || HAS_TRAIT(src, TRAIT_CANNOT_DREAM))
		return

	if(!has_status_effect(/datum/status_effect/incapacitating/sleeping))
		return

	dream_type = locate(dream_type) in GLOB.all_dreams_weighted
	if(dream_type)
		do_dream(dream_type)
		return TRUE

	if(!COOLDOWN_FINISHED(mind, dream_cooldown))
		return FALSE

	dream_type = get_random_dream()

	if(dream_type)
		do_dream(dream_type)
		return TRUE
	return FALSE

/**
 * Generates a dream sequence to be displayed to the sleeper.
 *
 * Generates the "dream" to display to the sleeper. A dream consists of a subject, a verb, and (most of the time) an object, displayed in sequence to the sleeper.
 * Dreams are generated as a list of strings stored inside dream_fragments, which is passed to and displayed in dream_sequence().
 * Bedsheets on the sleeper will provide a custom subject for the dream, pulled from the dream_messages on each bedsheet.
 */
/mob/living/carbon/proc/get_random_dream()
	// Do robots dream of robotic sheep? -- No.
	if(!mind || isipc(src))
		return null

	var/list/dream_pool
	var/datum/dream/dream
	if(mind?.assigned_role?.title == JOB_DETECTIVE)
		dream_pool = GLOB.detective_dreams_weighted.Copy()

	else
		dream_pool = GLOB.generic_dreams_weighted.Copy()

	while(length(dream_pool))
		dream = pick_weight(dream_pool)
		dream_pool -= dream

		if(!(dream.dream_flags & DREAM_ONCE_PER_ROUND) || !(dream.type in mind.finished_dream_types))
			return dream

/mob/living/carbon/proc/do_dream(datum/dream/chosen_dream)
	chosen_dream.BeginDreaming(src)
