#define DREAMING_SOURCE "dreaming_source"

/**
 * Begins the dreaming process on a sleeping carbon.
 *
 * Only one dream sequence can be active at a time.
 */

/mob/living/carbon/proc/try_dream(dream_type)
	if(HAS_TRAIT(src, TRAIT_DREAMING) || HAS_TRAIT(src, TRAIT_CANNOT_DREAM))
		return

	if(!has_status_effect(/datum/status_effect/incapacitating/sleeping))
		return

	dream_type = locate(dream_type) in GLOB.all_dreams_weighted
	if(dream_type)
		do_dream(dream_type)
		return TRUE

	if(!COOLDOWN_FINISHED(src, dream_cooldown))
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
	if(isipc(src))
		return null

	// if(mind?.assigned_role?.title == JOB_DETECTIVE)
	// 	return /datum/dream/detective_nightmare

	return pick_weight(GLOB.generic_dreams_weighted)

/mob/living/carbon/proc/do_dream(datum/dream/chosen_dream)
	chosen_dream.BeginDreaming(src)

/**
 * Displays the passed list of dream fragments to a sleeping carbon.
 *
 * Displays the first string of the passed dream fragments, then either ends the dream sequence
 * or performs a callback on itself depending on if there are any remaining dream fragments to display.
 *
 * Arguments:
 * * dream_fragments - A list of strings, in the order they will be displayed.
 * * current_dream - The dream datum used for the current dream
 */

/mob/living/carbon/proc/dream_sequence(list/dream_fragments, datum/dream/current_dream)
	PRIVATE_PROC(TRUE)

	if(stat != UNCONSCIOUS)
		REMOVE_TRAIT(src, TRAIT_DREAMING, DREAMING_SOURCE)
		current_dream.OnDreamEnd(src)
		return

	var/next_message = dream_fragments[1]
	dream_fragments.Cut(1,2)

	if(istype(next_message, /datum/callback))
		var/datum/callback/something_happens = next_message
		next_message = something_happens.Invoke(src)

	to_chat(src, current_dream.WrapMessage(src, next_message))

	if(LAZYLEN(dream_fragments))
		var/next_wait = current_dream.GetFragmentDelay(src)
		if(current_dream.sleep_until_finished)
			AdjustSleeping(next_wait)

		addtimer(CALLBACK(src, PROC_REF(dream_sequence), dream_fragments, current_dream), next_wait)

	else
		REMOVE_TRAIT(src, TRAIT_DREAMING, DREAMING_SOURCE)
		current_dream.OnDreamEnd(src)

#undef DREAMING_SOURCE
