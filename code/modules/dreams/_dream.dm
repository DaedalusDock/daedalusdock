//-------------------------
// DREAM DATUMS

#define DREAMING_SOURCE "dreaming"

GLOBAL_LIST_EMPTY(generic_dreams_weighted)
GLOBAL_LIST_EMPTY(all_dreams_weighted)

/proc/init_dreams()
	for(var/datum/dream/dream_type as anything in subtypesof(/datum/dream))
		if(isabstract(dream_type))
			continue

		var/datum/dream/dream = new dream_type
		GLOB.all_dreams_weighted[dream] = initial(dream_type.weight)

		if(!initial(dream_type.is_generic))
			continue

		GLOB.generic_dreams_weighted[dream] = initial(dream_type.weight)

/**
 * Contains all the behavior needed to play a kind of dream.
 * All dream types get randomly selected from based on weight when an appropriate mobs dreams.
 */
/datum/dream
	abstract_type = /datum/dream
	/// The relative chance this dream will be randomly selected
	var/weight = 0

	/// Causes the mob to sleep long enough for the dream to finish if begun
	var/sleep_until_finished = FALSE

	/// If this dream can be rolled by anyone
	var/is_generic = TRUE

	var/dream_cooldown = 10 SECONDS

/**
 * Called when beginning a new dream for the dreamer.
 * Gives back a list of dream events. Events can be text or callbacks that return text.
 */
/datum/dream/proc/GenerateDream(mob/living/carbon/dreamer)
	RETURN_TYPE(/list)
	return list()

/**
 * Called when the dream starts.
 */
/datum/dream/proc/OnDreamStart(mob/living/carbon/dreamer)
	SHOULD_CALL_PARENT(TRUE)
	ADD_TRAIT(dreamer, TRAIT_DREAMING, DREAMING_SOURCE)

/**
 * Called when the dream ends or is interrupted.
 */
/datum/dream/proc/OnDreamEnd(mob/living/carbon/dreamer)
	SHOULD_CALL_PARENT(TRUE)

	REMOVE_TRAIT(dreamer, TRAIT_DREAMING, DREAMING_SOURCE)
	COOLDOWN_START(dreamer, dream_cooldown, dream_cooldown)

/**
 * Called by dream_sequence to wrap a message in any effects.
 */
/datum/dream/proc/WrapMessage(mob/living/carbon/dreamer, message)
	return span_notice("<i>... [message] ...</i>")

/**
 * Called by dream_sequence to get the delay value between each fragment.
 */
/datum/dream/proc/GetFragmentDelay(mob/living/carbon/dreamer)
	return rand(1 SECOND, 3 SECONDS)

/datum/dream/proc/BeginDreaming(mob/living/carbon/dreamer)
	set waitfor = FALSE

	var/list/fragments = GenerateDream(dreamer)
	OnDreamStart(dreamer)
	DreamLoop(dreamer, fragments)

/**
 * The core dream loop, powered by callbacks.
 */
/datum/dream/proc/DreamLoop(mob/living/carbon/dreamer, list/dream_fragments)
	if(dreamer.stat != UNCONSCIOUS || QDELETED(dreamer))
		OnDreamEnd(dreamer)
		return

	var/next_message = dream_fragments[1]
	dream_fragments.Cut(1,2)

	if(istype(next_message, /datum/callback))
		var/datum/callback/something_happens = next_message
		next_message = something_happens.Invoke(dreamer)

	to_chat(dreamer, WrapMessage(dreamer, next_message))

	// Dream's over.
	if(!LAZYLEN(dream_fragments))
		OnDreamEnd(dreamer)
		return

	var/next_wait = GetFragmentDelay(dreamer)
	if(sleep_until_finished)
		dreamer.AdjustSleeping(next_wait)

	addtimer(CALLBACK(src, PROC_REF(DreamLoop), dreamer, dream_fragments), next_wait)


#undef DREAMING_SOURCE
