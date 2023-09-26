/// An associative list of type:instance for grab datums
GLOBAL_LIST_EMPTY(all_grabstates)
/datum/grab
	abstract_type = /datum/grab
	var/icon
	var/icon_state

	var/type_name
	var/state_name
	var/fancy_desc

	/// The grab that this will upgrade to if it upgrades, null means no upgrade
	var/datum/grab/upgrab
	/// The grab that this will downgrade to if it downgrades, null means break grab on downgrade
	var/datum/grab/downgrab

	var/datum/time_counter						// For things that need to be timed

	// Whether or not the grabbed person can move out of the grab
	var/stop_move = FALSE
	/// Whether or not the grabbed person is forced to be standing
	var/force_stand = FALSE
	// Whether the person being grabbed is facing forwards or backwards.
	var/reverse_facing = FALSE
	/// Whether this grab state is strong enough to, as a changeling, absorb the person you're grabbing.
	var/can_absorb = FALSE
	/// Whether the person you're grabbing will shield you from bullets.
	var/shield_assailant = FALSE
	/// How much the grab increases point blank damage.
	var/point_blank_mult = 1
	/// Affects how much damage is being dealt using certain actions.
	var/damage_stage = 1
	/// If the grabbed person and the grabbing person are on the same tile.
	var/same_tile = FALSE
	/// If the grabber can carry the grabbed person up or down ladders.
	var/ladder_carry = FALSE
	/// If the grabber can throw the person grabbed.
	var/can_throw = FALSE
	/// If the grab needs to be downgraded when the grabber does stuff.
	var/downgrade_on_action = FALSE
	/// If the grab needs to be downgraded when the grabber moves.
	var/downgrade_on_move = FALSE
	/// If the grab is strong enough to be able to force someone to do something harmful to them.
	var/force_danger = FALSE
	/// If the grab acts like cuffs and prevents action from the victim.
	var/restrains = FALSE

	var/grab_slowdown = 7

	var/shift = 0

	var/success_up = "You upgrade the grab."
	var/success_down = "You downgrade the grab."

	var/fail_up = "You fail to upgrade the grab."
	var/fail_down = "You fail to downgrade the grab."

	var/upgrade_cooldown = 40
	var/action_cooldown = 40

	var/can_downgrade_on_resist = TRUE
	var/list/break_chance_table = list(100)
	var/breakability = 2

	var/can_grab_self = TRUE

	// The names of different intents for use in attack logs
	var/help_action = "help intent"
	var/disarm_action = "disarm intent"
	var/grab_action = "grab intent"
	var/harm_action = "harm intent"

/*
	These procs shouldn't be overriden in the children unless you know what you're doing with them; they handle important core functions.
	Even if you do override them, you should likely be using ..() if you want the behaviour to function properly. That is, of course,
	unless you're writing your own custom handling of things.
*/
/// Called during world/New to setup references.
/datum/grab/proc/refresh_updown()
	if(upgrab)
		upgrab = GLOB.all_grabstates[upgrab]

	if(downgrab)
		downgrab = GLOB.all_grabstates[upgrab]

/// Called by the grab item's setup() proc. May return FALSE to interrupt, otherwise the grab has succeeded.
/datum/grab/proc/setup(obj/item/hand_item/grab)
	SHOULD_CALL_PARENT(TRUE)
	return TRUE

// This is for the strings defined as datum variables. It takes them and swaps out keywords for relevent ones from the grab
// object involved.
/datum/grab/proc/string_process(obj/item/hand_item/grab/G, to_write, obj/item/used_item)
	to_write = replacetext(to_write, "rep_affecting", G.affecting)
	to_write = replacetext(to_write, "rep_assailant", G.assailant)
	if(used_item)
		to_write = replacetext(to_write, "rep_item", used_item)
	return to_write

/datum/grab/proc/upgrade(obj/item/hand_item/grab/G)
	if(!upgrab)
		return

	if (can_upgrade(G))
		upgrade_effect(G)
		log_combat(G.assailant, G.affecting, "tightens their grip on their victim to [upgrab.state_name]")
		return upgrab
	else
		to_chat(G.assailant, span_warning("[string_process(G, fail_up)]"))
		return

/datum/grab/proc/downgrade(obj/item/hand_item/grab/G)
	// Starts the process of letting go if there's no downgrade grab
	if(can_downgrade())
		downgrade_effect(G)
		return downgrab
	else
		to_chat(G.assailant, span_warning("[string_process(G, fail_down)]"))
		return

/datum/grab/proc/let_go(obj/item/hand_item/grab/G)
	if (G)
		let_go_effect(G)
		qdel(G)

/datum/grab/proc/on_target_change(obj/item/hand_item/grab/G, old_zone, new_zone)
	G.special_target_functional = check_special_target(G)
	if(G.special_target_functional)
		special_target_change(G, old_zone, new_zone)
		special_target_effect(G)

/datum/grab/process(obj/item/hand_item/grab/G)
	special_target_effect(G)
	process_effect(G)

/datum/grab/proc/throw_held(obj/item/hand_item/grab/G)
	if(G.assailant == G.affecting)
		return

	var/mob/living/carbon/human/affecting = G.affecting

	if(can_throw)
		. = affecting
		var/mob/thrower = G.loc

		animate(affecting, pixel_x = 0, pixel_y = 0, 4, 1)
		qdel(G)

		// check if we're grabbing with our inactive hand
		G = thrower.get_inactive_hand()
		if(!istype(G))	return
		qdel(G)
		return

/datum/grab/proc/hit_with_grab(obj/item/hand_item/grab/G, atom/target, params)
	if(downgrade_on_action)
		G.downgrade()

	if(!G.check_action_cooldown() || G.is_currently_resolving_hit)
		to_chat(G.assailant, span_warning("You must wait before you can do that."))
		return FALSE

	G.is_currently_resolving_hit = TRUE
	var/combat_mode = G.assailant.combat_mode
	if(params[RIGHT_CLICK])
		if(on_hit_disarm(G))
			. = disarm_action || TRUE

	else if(params[CTRL_CLICK])
		if(on_hit_grab(G))
			. = grab_action || TRUE


	else if(combat_mode)
		if(on_hit_harm(G))
			. = harm_action || TRUE
	else
		if(on_hit_help(G))
			. = help_action || TRUE

	if(QDELETED(src))
		return

	G.is_currently_resolving_hit = FALSE

	if(!.)
		return

	G.action_used()
	if(G.assailant)
		G.assailant.changeNext_move(CLICK_CD_MELEE)
		if(istext(.) && G.affecting)
			make_log(G, "used [.] on")

	if(downgrade_on_action)
		G.downgrade()

/datum/grab/proc/make_log(obj/item/hand_item/grab/G, action)
	log_combat(G.assailant, G.affecting, "[action]s their victim")

/datum/grab/proc/adjust_position(obj/item/hand_item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant
	var/adir = get_dir(assailant, affecting)

	if(same_tile)
		affecting.forceMove(assailant.loc)
		adir = assailant.dir
		affecting.setDir(assailant.dir)

	switch(adir)
		if(NORTH)
			animate(affecting, pixel_x = 0, pixel_y =-shift, 5, 1, LINEAR_EASING)
			G.draw_affecting_under()
		if(SOUTH)
			animate(affecting, pixel_x = 0, pixel_y = shift, 5, 1, LINEAR_EASING)
			G.draw_affecting_over()
		if(WEST)
			animate(affecting, pixel_x = shift, pixel_y = 0, 5, 1, LINEAR_EASING)
			G.draw_affecting_under()
		if(EAST)
			animate(affecting, pixel_x =-shift, pixel_y = 0, 5, 1, LINEAR_EASING)
			G.draw_affecting_under()

	affecting.reset_plane_and_layer()

/datum/grab/proc/reset_position(obj/item/hand_item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting

	if(!affecting.buckled)
		animate(affecting, pixel_x = 0, pixel_y = 0, 4, 1, LINEAR_EASING)
	affecting.reset_plane_and_layer()

// This is called whenever the assailant moves.
/datum/grab/proc/assailant_moved(obj/item/hand_item/grab/G)
	adjust_position(G)
	moved_effect(G)
	if(downgrade_on_move)
		G.downgrade()

/*
	Override these procs to set how the grab state will work. Some of them are best
	overriden in the parent of the grab set (for example, the behaviour for on_hit_intent(var/obj/item/hand_item/grab/G)
	procs is determined in /datum/grab/normal and then inherited by each intent).
*/

// What happens when you upgrade from one grab state to the next.
/datum/grab/proc/upgrade_effect(obj/item/hand_item/grab/G)

// Conditions to see if upgrading is possible
/datum/grab/proc/can_upgrade(obj/item/hand_item/grab/G)
	return 1

// What happens when you downgrade from one grab state to the next.
/datum/grab/proc/downgrade_effect(obj/item/hand_item/grab/G)

// Conditions to see if downgrading is possible
/datum/grab/proc/can_downgrade(obj/item/hand_item/grab/G)
	return 1

// What happens when you let go of someone by either dropping the grab
// or by downgrading from the lowest grab state.
/datum/grab/proc/let_go_effect(obj/item/hand_item/grab/G)

// What happens each tic when process is called.
/datum/grab/proc/process_effect(obj/item/hand_item/grab/G)

// Handles special targeting like eyes and mouth being covered.
/datum/grab/proc/special_target_effect(obj/item/hand_item/grab/G)

// Handles when they change targeted areas and something is supposed to happen.
/datum/grab/proc/special_target_change(obj/item/hand_item/grab/G, diff_zone)

// Checks if the special target works on the grabbed humanoid.
/datum/grab/proc/check_special_target(obj/item/hand_item/grab/G)

// What happens when you hit the grabbed person with the grab on help intent.
/datum/grab/proc/on_hit_help(obj/item/hand_item/grab/G)
	return FALSE

// What happens when you hit the grabbed person with the grab on disarm intent.
/datum/grab/proc/on_hit_disarm(obj/item/hand_item/grab/G)
	return FALSE

// What happens when you hit the grabbed person with the grab on grab intent.
/datum/grab/proc/on_hit_grab(obj/item/hand_item/grab/G)
	return FALSE

// What happens when you hit the grabbed person with the grab on harm intent.
/datum/grab/proc/on_hit_harm(obj/item/hand_item/grab/G)
	return FALSE

// What happens when you hit the grabbed person with an open hand and you want it
// to do some special snowflake action based on some other factor such as
// intent.
/datum/grab/proc/resolve_openhand_attack(obj/item/hand_item/grab/G)
	return FALSE

// Used when you want an effect to happen when the grab enters this state as an upgrade
/datum/grab/proc/enter_as_up(obj/item/hand_item/grab/G)

/datum/grab/proc/item_attack(obj/item/hand_item/grab/G, obj/item)

/datum/grab/proc/resolve_item_attack(obj/item/hand_item/grab/G, mob/living/carbon/human/user, obj/item/I, target_zone)
	return FALSE

/datum/grab/proc/handle_resist(obj/item/hand_item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if(affecting.incapacitated())
		to_chat(G.affecting, span_warning("You can't resist in your current state!"))
		return

	var/break_strength = breakability + size_difference(affecting, assailant)
	var/affecting_shock = affecting.getPain()
	var/assailant_shock = assailant.getPain()

	// Target modifiers
	if(affecting.incapacitated())
		break_strength--
	if(affecting.has_status_effect(/datum/status_effect/confusion))
		break_strength--
	if(affecting.eye_blind || HAS_TRAIT(affecting, TRAIT_BLIND))
		break_strength--
	if(affecting.eye_blurry)
		break_strength--
	if(affecting_shock >= 10)
		break_strength--
	if(affecting_shock >= 30)
		break_strength--
	if(affecting_shock >= 50)
		break_strength--

	// User modifiers
	if(assailant.has_status_effect(/datum/status_effect/confusion))
		break_strength++
	if(assailant.eye_blind || HAS_TRAIT(assailant, TRAIT_BLIND))
		break_strength++
	if(assailant.eye_blurry)
		break_strength++
	if(assailant_shock >= 10)
		break_strength++
	if(assailant_shock >= 30)
		break_strength++
	if(assailant_shock >= 50)
		break_strength++

	if(break_strength < 1)
		to_chat(G.affecting, span_warning("You try to break free but feel that unless something changes, you'll never escape!"))
		return

	var/break_chance = break_chance_table[clamp(break_strength, 1, length(break_chance_table))]

	if (assailant.incapacitated())
		let_go(G)

	if(prob(break_chance))
		if(can_downgrade_on_resist && !prob((break_chance+100)/2))
			affecting.visible_message(span_danger("[affecting] has loosened [assailant]'s grip!"))
			G.downgrade()
			return
		else
			affecting.visible_message(span_danger("[affecting] has broken free of [assailant]'s grip!"))
			let_go(G)

/datum/grab/proc/size_difference(mob/living/A, mob/living/B)
	return mob_size_difference(A.mob_size, B.mob_size)

/datum/grab/proc/moved_effect(obj/item/hand_item/grab/G)
	return
