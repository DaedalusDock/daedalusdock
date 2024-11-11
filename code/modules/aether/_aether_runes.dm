// This file contains aether's runes. It's very similar to cult runes but different enough to warrant not touching cult code.
/obj/effect/aether_rune
	name = "strange rune"
	desc = "An odd collection of symbols drawn in chalk."

	icon = 'icons/effects/96x96.dmi'
	icon_state = "rune_large"
	layer = SIGIL_LAYER
	color = "#1f4d39"
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32

	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE

	var/active_color = "#4dffb5"

	/// Misc state tracking
	var/list/blackboard = list()

	/// How many extra people are needed to invoke the rune.
	var/required_helpers = 0
	/// A lazylist of mobs currently touching the rune.
	var/list/touching_rune

	var/list/invocation_phrases = list(
		"OMINOUS CHANTING" = 3 SECONDS,
		"MORE OMINOUS CHANTING" = 3 SECONDS,
		"AAAAAAAAAA" = 2 SECONDS,
	)

	var/invoking = RUNE_INVOKING_IDLE

/obj/effect/aether_rune/Destroy(force)
	touching_rune = null
	try_cancel_invoke(RUNE_FAIL_GRACEFUL)
	return ..()

/obj/effect/aether_rune/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(invoking == RUNE_INVOKING_ACTIVE)
		return

	if(user in touching_rune)
		return TRUE

	register_helper(user)
	visible_message(span_notice("[user] places their hand on [src]."))
	return TRUE

/obj/effect/aether_rune/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(.)
		return

	#warn todo: aether tome
	if(istype(weapon, /obj/item/book))
		if(invoking != RUNE_INVOKING_IDLE)
			return TRUE

		if(user in touching_rune)
			remove_helper(user)
		try_invoke(user, weapon)
		return TRUE

/obj/effect/aether_rune/proc/wipe_state()
	invoking = RUNE_INVOKING_IDLE
	remove_tome(blackboard[RUNE_BB_TOME])
	remove_invoker(blackboard[RUNE_BB_INVOKER])
	blackboard.Cut()

	color = initial(color)
	animate(src, transform = matrix()) // Interrupt the existing transform animation

/// Attempt to invoke the rune.
/obj/effect/aether_rune/proc/try_invoke(mob/living/user, obj/item/book/tome)
	pre_invoke(user, tome)

	if(!can_invoke())
		wipe_state()
		return FALSE

	. = TRUE
	spawn(-1)
		begin_invoke(user, tome)

/// Returns TRUE if the rune can be invoked.
/obj/effect/aether_rune/proc/can_invoke()
	if(invoking == RUNE_INVOKING_PENDING_CANCEL)
		return FALSE

	if(length(touching_rune) < required_helpers)
		return FALSE

	var/mob/living/user = blackboard[RUNE_BB_INVOKER]
	if(!user?.can_speak_vocal())
		return FALSE

	return TRUE

/// Called before any other step of invoking, sets up state.
/obj/effect/aether_rune/proc/pre_invoke(mob/living/user, obj/item/book/tome)
	set_invoker(user)
	set_tome(tome)

/// Begin invoking a rune.
/obj/effect/aether_rune/proc/begin_invoke()
	set waitfor = FALSE

	invoking = RUNE_INVOKING_ACTIVE
	SpinAnimation(3 SECONDS, clockwise = FALSE)
	color = active_color

	var/mob/living/user = blackboard[RUNE_BB_INVOKER]

	playsound(user, 'sound/magic/magic_block_mind.ogg', 50, TRUE)

	var/next_phrase_time = 1
	var/next_phrase_index = 1
	while(TRUE)
		if(!user?.can_speak_vocal())
			try_cancel_invoke(RUNE_FAIL_INVOKER_INCAP)

		if(invoking == RUNE_INVOKING_PENDING_CANCEL)
			fail_invoke(blackboard[RUNE_BB_CANCEL_REASON], blackboard[RUNE_BB_CANCEL_SOURCE])
			return

		if(next_phrase_time <= world.time)
			if(next_phrase_index > length(invocation_phrases))
				succeed_invoke()
				return

			var/phrase = invocation_phrases[next_phrase_index]
			user.say(phrase, language = /datum/language/common, ignore_spam = TRUE, forced = "miracle invocation")
			next_phrase_index++
			next_phrase_time = world.time + invocation_phrases[phrase]

		//stoplag(world.tick_lag)
		sleep(world.tick_lag)

/// Finish invoking a rune.
/obj/effect/aether_rune/proc/succeed_invoke()
	playsound(src, 'sound/magic/voidblink.ogg', 50, TRUE)
	invoke_success_visual_effect()
	wipe_state()

/// Called when invocation fails.
/obj/effect/aether_rune/proc/fail_invoke(failure_reason = RUNE_FAIL_GRACEFUL, failure_source)
	invoking = RUNE_INVOKING_IDLE
	wipe_state()

/// Cancel the invocation if it wasn't cancelled already.
/obj/effect/aether_rune/proc/try_cancel_invoke(reason, source)
	if(invoking == RUNE_INVOKING_IDLE)
		return

	if((reason != RUNE_FAIL_GRACEFUL) && (invoking == RUNE_INVOKING_PENDING_CANCEL))
		return

	invoking = RUNE_INVOKING_PENDING_CANCEL
	blackboard[RUNE_BB_CANCEL_REASON] = reason
	blackboard[RUNE_BB_CANCEL_SOURCE] = source

/// Visual effect when the rune is successfully invoked.
/obj/effect/aether_rune/proc/invoke_success_visual_effect()
	var/obj/effect/abstract/effect = new()
	effect.appearance = appearance
	effect.plane = GAME_PLANE
	effect.layer = FLY_LAYER
	effect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	effect.pixel_x = 0
	effect.pixel_y = 0

	vis_contents += effect

	animate(effect, transform = matrix(2, MATRIX_SCALE), time = 0.2 SECONDS, easing = SINE_EASING|EASE_IN)
	animate(effect, alpha = 0, time = 0.2 SECONDS, flags = ANIMATION_PARALLEL)

	QDEL_IN(effect, 0.2 SECONDS)

/// Registers a mob as attempting to invoke this rune.
/obj/effect/aether_rune/proc/register_helper(mob/living/L)
	RegisterSignal(L, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED)), PROC_REF(helper_cant_help_no_more))
	RegisterSignal(L, COMSIG_MOB_STATCHANGE, PROC_REF(helper_stat_change))
	RegisterSignal(L, COMSIG_ATOM_DIR_CHANGE, PROC_REF(helper_dir_change))
	RegisterSignal(L, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_CARBON_REMOVED_LIMB), PROC_REF(check_helper_hands))
	LAZYADD(touching_rune, L)

/// Removes a helper.
/obj/effect/aether_rune/proc/remove_helper(mob/living/L)
	LAZYREMOVE(touching_rune, L)
	UnregisterSignal(
		L,
		list(
			COMSIG_CARBON_REMOVED_LIMB,
			COMSIG_MOB_EQUIPPED_ITEM,
			COMSIG_ATOM_DIR_CHANGE,
			COMSIG_MOVABLE_MOVED,
			COMSIG_PARENT_QDELETING,
			SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
			COMSIG_MOB_STATCHANGE
		)
	)

/// Set the tome in the blackboard
/obj/effect/aether_rune/proc/set_tome(obj/item/tome)
	blackboard[RUNE_BB_TOME] = tome
	RegisterSignal(tome, list(COMSIG_ITEM_DROPPED, COMSIG_PARENT_QDELETING), PROC_REF(tome_dropped))

/obj/effect/aether_rune/proc/remove_tome(obj/item/I)
	if(!I)
		return

	UnregisterSignal(I, list(COMSIG_ITEM_DROPPED, COMSIG_PARENT_QDELETING))

/obj/effect/aether_rune/proc/set_invoker(mob/user)
	blackboard[RUNE_BB_INVOKER] = user
	RegisterSignal(user, list(COMSIG_MOB_STATCHANGE, SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED), COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(invoker_interrupted))
	RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(invoker_dir_change))
	RegisterSignal(user, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_CARBON_REMOVED_LIMB), PROC_REF(check_invoker_hands))

/obj/effect/aether_rune/proc/remove_invoker(user)
	if(!user)
		return

	UnregisterSignal(
		user,
		list(
			COMSIG_MOB_EQUIPPED_ITEM,
			COMSIG_CARBON_REMOVED_LIMB,
			COMSIG_ATOM_DIR_CHANGE,
			COMSIG_MOB_STATCHANGE,
			SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
			COMSIG_MOVABLE_MOVED,
			COMSIG_PARENT_QDELETING
		)
	)

/obj/effect/aether_rune/proc/invoker_interrupted(datum/source)
	SIGNAL_HANDLER

	remove_invoker(blackboard[RUNE_BB_INVOKER])
	if(QDELETED(source))
		try_cancel_invoke(RUNE_FAIL_GRACEFUL)
	else
		try_cancel_invoke(RUNE_FAIL_INVOKER_INCAP, source)

/// Removes a helper for being knocked out or killed
/obj/effect/aether_rune/proc/invoker_dir_change(datum/source, dir, newdir)
	SIGNAL_HANDLER

	if(newdir == dir)
		return

	remove_invoker(blackboard[RUNE_BB_INVOKER])
	try_cancel_invoke(RUNE_FAIL_HELPER_REMOVED_HAND, source)

/obj/effect/aether_rune/proc/check_invoker_hands(datum/source)
	SIGNAL_HANDLER

	var/mob/living/L = source
	if(!L.get_empty_held_index())
		remove_invoker(blackboard[RUNE_BB_INVOKER])
		try_cancel_invoke(RUNE_FAIL_INVOKER_INCAP, source)

/// Removes a helper for moving or being deleted, or becoming incapacitated.
/obj/effect/aether_rune/proc/helper_cant_help_no_more(datum/source)
	SIGNAL_HANDLER

	remove_helper(source)
	var/mob/living/L = source
	if(QDELETED(L))
		try_cancel_invoke(RUNE_FAIL_GRACEFUL)
		return

	L.visible_message(
		span_warning("[L] removes [L.p_their()] hand from [src]."),
	)

	try_cancel_invoke(RUNE_FAIL_HELPER_REMOVED_HAND, source)


/// Removes a helper for being knocked out or killed
/obj/effect/aether_rune/proc/helper_stat_change(datum/source)
	SIGNAL_HANDLER

	remove_helper(source)
	try_cancel_invoke(RUNE_FAIL_HELPER_REMOVED_HAND, source)

/// Removes a helper for being knocked out or killed
/obj/effect/aether_rune/proc/helper_dir_change(datum/source, dir, newdir)
	SIGNAL_HANDLER

	if(newdir == dir)
		return

	remove_helper(source)
	var/mob/living/L = source
	L.visible_message(
		span_warning("[L] removes [L.p_their()] hand from [src]."),
	)
	try_cancel_invoke(RUNE_FAIL_HELPER_REMOVED_HAND, source)

/obj/effect/aether_rune/proc/check_helper_hands(datum/source)
	SIGNAL_HANDLER

	var/mob/living/L = source
	if(!L.get_empty_held_index())
		remove_helper(source)
		try_cancel_invoke(RUNE_FAIL_HELPER_REMOVED_HAND, source)

/// Handles the tome being moved
/obj/effect/aether_rune/proc/tome_dropped(datum/source)
	SIGNAL_HANDLER

	try_cancel_invoke(RUNE_FAIL_TOME_GONE, source)

