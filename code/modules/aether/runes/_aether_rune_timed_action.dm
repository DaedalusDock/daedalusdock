/datum/timed_action/aether_rune
	var/obj/effect/aether_rune/parent_rune
	var/duration = 0

	var/phrase_time = 0
	var/phrase_index = 1

/datum/timed_action/aether_rune/New(_user, _targets, _time, _progress, _timed_action_flags, _extra_checks, image/_display)
	parent_rune = _user
	duration = 0
	for(var/phrase in parent_rune.invocation_phrases)
		duration += parent_rune.invocation_phrases[phrase]

	_time = duration
	. = ..()

/datum/timed_action/aether_rune/Destroy(force, ...)
	parent_rune.timed_action = null
	parent_rune = null
	return ..()

/datum/timed_action/aether_rune/wait()
	parent_rune.start_invoke_animation(duration)
	return ..()

/datum/timed_action/aether_rune/on_process()
	. = ..()

	var/mob/living/user = parent_rune.blackboard[RUNE_BB_INVOKER]

	if(!user?.can_speak_vocal())
		parent_rune.try_cancel_invoke(RUNE_FAIL_INVOKER_INCAP)
		return FALSE

	if(phrase_time <= world.time && phrase_index <= length(parent_rune.invocation_phrases))
		var/phrase = parent_rune.invocation_phrases[phrase_index]

		user.say(phrase, language = /datum/language/common, ignore_spam = TRUE, forced = "miracle invocation")

		phrase_time = world.time + parent_rune.invocation_phrases[phrase]
		phrase_index++

/datum/timed_action/aether_rune/on_cancel()
	parent_rune.fail_invoke(parent_rune.blackboard[RUNE_BB_CANCEL_REASON], parent_rune.blackboard[RUNE_BB_CANCEL_SOURCE])

/datum/timed_action/aether_rune/on_success()
	parent_rune.succeed_invoke(parent_rune.blackboard[RUNE_BB_TARGET_MOB])
