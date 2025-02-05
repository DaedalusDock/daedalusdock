// This file contains aether's runes. It's very similar to cult runes but different enough to warrant not touching cult code.
/obj/effect/aether_rune
	name = "strange sigil"
	desc = "An odd collection of symbols drawn in chalk."

	icon = 'icons/effects/aether_runes.dmi'
	icon_state = "rune_revival"

	layer = SIGIL_LAYER
	color = "#1f4d39"
	pixel_w = -32 //So the big ol' 96x96 sprite shows up right
	pixel_z = -32

	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE

	/// Used to build the appearance.
	var/rune_type = "revival"

	var/active_color = "#4dffb5"

	/// Misc state tracking
	var/list/blackboard = list()

	/// How much blood the miracle needs.
	var/required_blood_amt = 30
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

	var/obj/effect/abstract/particle_holder/particle_holder
	/// Outer ring inside our vis_contents, to be animated seperately.
	var/obj/effect/abstract/outer_ring

/obj/effect/aether_rune/Initialize(mapload)
	. = ..()
	particle_holder = new(src, /particles/rune)
	particle_holder.appearance_flags |= RESET_COLOR | RESET_TRANSFORM
	particle_holder.pixel_w = 32
	particle_holder.pixel_z = 32
	particle_holder.particles.spawning = 0

	icon_state = "rune_[rune_type]"

	outer_ring = new()
	outer_ring.icon_state = "sigil_[rune_type]"
	outer_ring.appearance_flags |= RESET_TRANSFORM
	outer_ring.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ICON
	add_viscontents(outer_ring)

/obj/effect/aether_rune/Destroy(force)
	touching_rune = null
	try_cancel_invoke(RUNE_FAIL_GRACEFUL)
	QDEL_NULL(outer_ring)
	QDEL_NULL(particle_holder)
	return ..()

/obj/effect/aether_rune/CheckReachableAdjacency(atom/movable/reacher, obj/item/tool)
	. = ..()
	if(.)
		return TRUE

	var/list/touchable_turfs = RANGE_TURFS(1,reacher) & RANGE_TURFS(1, src)
	for(var/turf/open/T in touchable_turfs)
		if(T.IsReachableBy(reacher))
			return TRUE

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

	if(istype(weapon, /obj/item/aether_tome))
		if(invoking != RUNE_INVOKING_IDLE)
			return TRUE

		if(user in touching_rune)
			remove_helper(user)
		try_invoke(user, weapon)
		return TRUE

/obj/effect/aether_rune/proc/wipe_state()
	SHOULD_CALL_PARENT(TRUE)

	invoking = RUNE_INVOKING_IDLE

	// Clear signals
	remove_tome(blackboard[RUNE_BB_TOME])
	remove_invoker(blackboard[RUNE_BB_INVOKER])
	var/mob/mob_target = blackboard[RUNE_BB_TARGET_MOB]
	if(mob_target)
		unregister_target_mob(mob_target)

	// Remove blood container signals.
	unregister_item(blackboard[RUNE_BB_BLOOD_CONTAINER])

	blackboard.Cut()

	stop_invoke_animation()

/// Attempt to invoke the rune.
/obj/effect/aether_rune/proc/try_invoke(mob/living/user, obj/item/aether_tome/tome)
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

	if(!blackboard[RUNE_BB_TARGET_MOB])
		return FALSE

	if(required_blood_amt && !blackboard[RUNE_BB_BLOOD_CONTAINER])
		return FALSE

	var/mob/living/user = blackboard[RUNE_BB_INVOKER]
	if(!user?.can_speak_vocal())
		return FALSE

	return TRUE

/// Called before any other step of invoking, sets up state.
/obj/effect/aether_rune/proc/pre_invoke(mob/living/user, obj/item/aether_tome/tome)
	SHOULD_CALL_PARENT(TRUE)

	set_invoker(user)
	set_tome(tome)

	var/target_mob = find_target_mob()
	if(target_mob)
		blackboard[RUNE_BB_TARGET_MOB] = target_mob
		register_target_mob(target_mob)

	for(var/obj/item/reagent_containers/reagent_container in orange(1, src))
		if(!reagent_container.is_open_container())
			continue

		if(reagent_container.reagents.has_reagent(/datum/reagent/blood, required_blood_amt))
			blackboard[RUNE_BB_BLOOD_CONTAINER] = reagent_container
			register_item(reagent_container)
			break

/// Begin invoking a rune.
/obj/effect/aether_rune/proc/begin_invoke()
	set waitfor = FALSE

	invoking = RUNE_INVOKING_ACTIVE

	visible_message(span_statsgood("[src] erupts with an eerie glow, and begins to spin."))
	var/mob/living/user = blackboard[RUNE_BB_INVOKER]

	playsound(user, 'sound/magic/magic_block_mind.ogg', 50, TRUE)

	var/time = 0
	for(var/phrase in invocation_phrases)
		time += invocation_phrases[phrase]

	start_invoke_animation(time)

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
				succeed_invoke(blackboard[RUNE_BB_TARGET_MOB])
				return

			var/phrase = invocation_phrases[next_phrase_index]
			user.say(phrase, language = /datum/language/common, ignore_spam = TRUE, forced = "miracle invocation")
			next_phrase_index++
			#ifndef UNIT_TESTS
			next_phrase_time = world.time + invocation_phrases[phrase]
			#endif

		//stoplag(world.tick_lag)
		sleep(world.tick_lag)

/// Finish invoking a rune.
/obj/effect/aether_rune/proc/succeed_invoke(mob/living/carbon/human/target_mob)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/obj/item/reagent_containers/blood_bottle = blackboard[RUNE_BB_BLOOD_CONTAINER]
	blood_bottle?.reagents.remove_reagent(/datum/reagent/blood, required_blood_amt)

	playsound(src, 'sound/magic/voidblink.ogg', 50, TRUE)
	visible_message(span_statsbad("[src] stops moving, and dulls in color."))
	invoke_success_visual_effect()
	wipe_state()

/// Called when invocation fails.
/obj/effect/aether_rune/proc/fail_invoke(failure_reason = RUNE_FAIL_GRACEFUL, failure_source)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

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

/// Does what it says on the tin
/obj/effect/aether_rune/proc/start_invoke_animation(time)
	color = active_color
	particle_holder.particles.spawning = initial(particle_holder.particles.spawning)

	var/mutable_appearance/src_emissive = emissive_appearance(icon, icon_state, alpha = 100)
	add_overlay(src_emissive)

	var/mutable_appearance/ring_emissive = emissive_appearance(icon, outer_ring.icon_state, alpha = 100)
	outer_ring.add_overlay(ring_emissive)

	SpinAnimation(time, clockwise = FALSE)
	outer_ring.SpinAnimation(round(time / 2, 0.1), clockwise = TRUE)

/// Does what it says on the tin
/obj/effect/aether_rune/proc/stop_invoke_animation()
	color = initial(color)
	particle_holder.particles.spawning = 0

	cut_overlays()
	outer_ring.cut_overlays()

	animate(src, transform = matrix()) // Interrupt the existing transform animation
	animate(outer_ring, transform = matrix())

/// Visual effect when the rune is successfully invoked.
/obj/effect/aether_rune/proc/invoke_success_visual_effect()
	var/obj/effect/abstract/effect = new()
	effect.appearance = appearance
	effect.plane = GAME_PLANE
	effect.layer = FLY_LAYER
	effect.appearance_flags |= RESET_COLOR
	effect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	effect.pixel_w = 0
	effect.pixel_z = 0

	add_viscontents(effect)

	animate(effect, transform = matrix(4, MATRIX_SCALE), time = 0.4 SECONDS, easing = SINE_EASING|EASE_IN)
	animate(effect, alpha = 0, time = 0.4 SECONDS, flags = ANIMATION_PARALLEL)

	QDEL_IN(effect, 0.4 SECONDS)

/// Gets a mob that is in the center of the rune.
/obj/effect/aether_rune/proc/find_target_mob()
	var/mob/living/carbon/human/H = locate() in loc
	if(isnull(H))
		return null

	if(H.body_position != LYING_DOWN)
		return null

	if(isipc(H))
		return null

	return H

/// Registers a target, overridable if you override get_target().
/obj/effect/aether_rune/proc/register_target_mob(mob/living/carbon/human/target)
	RegisterSignal(target, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(target_moved_or_deleted))
	RegisterSignal(target, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(target_stand_up))

/// Clear the target's signals
/obj/effect/aether_rune/proc/unregister_target_mob(target)
	UnregisterSignal(target, list(COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

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
	RegisterSignal(tome, list(COMSIG_ITEM_UNEQUIPPED, COMSIG_PARENT_QDELETING), PROC_REF(tome_dropped))

/obj/effect/aether_rune/proc/remove_tome(obj/item/I)
	if(!I)
		return

	UnregisterSignal(I, list(COMSIG_ITEM_UNEQUIPPED, COMSIG_PARENT_QDELETING))

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
	try_cancel_invoke(RUNE_FAIL_INVOKER_INCAP, source)

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
		L.visible_message(
			span_warning("[L] removes [L.p_their()] hand from [src]."),
		)
		remove_helper(source)
		try_cancel_invoke(RUNE_FAIL_HELPER_REMOVED_HAND, source)

/// Handles the tome being moved
/obj/effect/aether_rune/proc/tome_dropped(datum/source)
	SIGNAL_HANDLER

	try_cancel_invoke(RUNE_FAIL_TOME_GONE, source)


/// Handle the target being moved.
/obj/effect/aether_rune/proc/target_moved_or_deleted(datum/source)
	SIGNAL_HANDLER

	var/mob/target = source
	if(QDELETED(target))
		try_cancel_invoke(RUNE_FAIL_GRACEFUL)
		return

	if(target.loc != loc)
		try_cancel_invoke(RUNE_FAIL_TARGET_MOB_MOVED, target)

/obj/effect/aether_rune/proc/target_stand_up(datum/source)
	SIGNAL_HANDLER

	try_cancel_invoke(RUNE_FAIL_TARGET_STOOD_UP, source)

/obj/effect/aether_rune/proc/register_item(obj/item/I)
	RegisterSignal(I, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(item_moved_or_deleted))

/obj/effect/aether_rune/proc/unregister_item(obj/item/I)
	if(isnull(I))
		return
	UnregisterSignal(I, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))

/obj/effect/aether_rune/proc/item_moved_or_deleted(datum/source)
	SIGNAL_HANDLER

	var/obj/item/I = source
	if(QDELETED(I))
		try_cancel_invoke(RUNE_FAIL_GRACEFUL)
		return

	if(!isturf(I.loc) || get_dist(src, I) > 1)
		try_cancel_invoke(RUNE_FAIL_TARGET_ITEM_OUT_OF_RUNE, I)
