GLOBAL_DATUM_INIT(dream_controller, /datum/dream_controller, new)

/datum/dream_controller
	var/list/all_dreams_weighted = list()
	var/list/dreams_by_class_weighted = list()

/datum/dream_controller/New()
	for(var/datum/dream/dream_type as anything in subtypesof(/datum/dream))
		if(isabstract(dream_type))
			continue

		var/datum/dream/dream_instance = new dream_type
		all_dreams_weighted[dream_instance] = dream_instance.weight

		if(isnull(dreams_by_class_weighted[dream_instance.dream_class]))
			dreams_by_class_weighted[dream_instance.dream_class] = list()

		dreams_by_class_weighted[dream_instance.dream_class][dream_instance] = dream_instance.weight

/datum/dream_controller/proc/get_dreams(dream_class) as /list
	RETURN_TYPE(/list)
	return dreams_by_class_weighted[dream_class]

/**
 * Contains all the behavior needed to play a kind of dream.
 * All dream types get randomly selected from based on weight when an appropriate mobs dreams.
 */
/datum/dream
	abstract_type = /datum/dream

	var/dream_flags = NONE

	/// Controls who can roll this dream.
	var/dream_class = DREAM_CLASS_GENERIC

	/// The relative chance this dream will be randomly selected
	var/weight = 1000

	/// Causes the mob to sleep long enough for the dream to finish if begun
	var/sleep_until_finished = FALSE

	var/dream_cooldown = 10 SECONDS

/**
 * Called when beginning a new dream for the dreamer.
 * Gives back a list of dream events. Events can be text or callbacks that return text.
 * The associated value is the delay FOLLOWING the message at that index, in deciseconds.
 */
/datum/dream/proc/GenerateDream(mob/living/carbon/dreamer)
	RETURN_TYPE(/list)
	return list()

/**
 * Called when the dream starts.
 */
/datum/dream/proc/OnDreamStart(mob/living/carbon/dreamer)
	SHOULD_CALL_PARENT(TRUE)
	ADD_TRAIT(dreamer.mind, TRAIT_DREAMING, DREAMING_SOURCE)

/**
 * Called when the dream ends or is interrupted.
 */
/datum/dream/proc/OnDreamEnd(mob/living/carbon/dreamer, cut_short = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	REMOVE_TRAIT(dreamer.mind, TRAIT_DREAMING, DREAMING_SOURCE)
	COOLDOWN_START(dreamer.mind, dream_cooldown, dream_cooldown)

	if(!cut_short || (dream_flags & DREAM_CUT_SHORT_IS_COMPLETE))
		LAZYOR(dreamer.mind.finished_dream_types, type)

/**
 * Called by dream_sequence to wrap a message in any effects.
 */
/datum/dream/proc/WrapMessage(mob/living/carbon/dreamer, message)
	return span_notice("<i>... [message] ...</i>")

/datum/dream/proc/BeginDreaming(mob/living/carbon/dreamer)
	set waitfor = FALSE

	var/list/fragments = GenerateDream(dreamer)
	OnDreamStart(dreamer)
	DreamLoop(dreamer, dreamer.mind, fragments)

/**
 * Displays the passed list of dream fragments to a sleeping carbon.
 *
 * Displays the first string of the passed dream fragments, then either ends the dream sequence
 * or performs a callback on itself depending on if there are any remaining dream fragments to display.
 *
 * Arguments:
 * * dreamer - The mob we're looping on.
 * * dreamer_mind - The mind that is dreaming.
 * * dream_fragments - A list of strings, in the order they will be displayed.
 */

/datum/dream/proc/DreamLoop(mob/living/carbon/dreamer, datum/mind/dreamer_mind, list/dream_fragments)
	if(dreamer.stat != UNCONSCIOUS || QDELETED(dreamer) || (dreamer.mind != dreamer_mind))
		OnDreamEnd(dreamer, TRUE)
		return

	var/next_message = dream_fragments[1]
	var/next_wait = dream_fragments[next_message]
	dream_fragments.Cut(1,2)

	if(istype(next_message, /datum/callback))
		var/datum/callback/something_happens = next_message
		next_message = something_happens.Invoke(dreamer)

	to_chat(dreamer, WrapMessage(dreamer, next_message))

	// Dream's over.
	if(!LAZYLEN(dream_fragments))
		OnDreamEnd(dreamer)
		return

	if(sleep_until_finished)
		dreamer.Sleeping(next_wait + 1 SECOND)

	addtimer(CALLBACK(src, PROC_REF(DreamLoop), dreamer, dreamer_mind,dream_fragments), next_wait)
