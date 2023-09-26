/obj/item/hand_item/grab
	name = "grab"
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM | NOBLUDGEON

	/// The initiator of the grab
	var/mob/living/assailant = null
	/// The thing being grabbed
	var/atom/movable/affecting = null

	/// The grab datum currently being used
	var/datum/grab/current_grab

	/// world.time of the last action
	var/last_action
	/// world.time of the last upgrade
	var/last_upgrade
	/// Indicates if the current grab has special interactions applied to the target organ (eyes and mouth at time of writing)
	var/special_target_functional = TRUE
	/// Used to avoid stacking interactions that sleep during /decl/grab/proc/on_hit_foo() (ie. do_after() is used)
	var/is_currently_resolving_hit = FALSE
	/// Records a specific bodypart that was targetted by this grab.
	var/target_zone
	/// Used by struggle grab datum to keep track of state.
	var/done_struggle = FALSE
/*
	This section is for overrides of existing procs.
*/
/obj/item/hand_item/grab/Initialize(mapload, atom/movable/target, datum/grab/grab_type)
	. = ..()
	current_grab = GLOB.all_grabstates[grab_type]

	assailant = loc
	if(!istype(assailant))
		return INITIALIZE_HINT_QDEL

	affecting = target
	if(!istype(affecting))
		return INITIALIZE_HINT_QDEL
	target_zone = assailant.zone_selected

	if(!can_grab())
		return INITIALIZE_HINT_QDEL
	if(!setup())
		return INITIALIZE_HINT_QDEL

	var/obj/item/bodypart/BP = get_targeted_bodypart()
	if(BP)
		name = "[initial(name)] ([BP.plaintext_zone])"
		RegisterSignal(affecting, COMSIG_CARBON_REMOVED_LIMB, PROC_REF(on_limb_loss))

	RegisterSignal(affecting, COMSIG_PARENT_QDELETING, PROC_REF(target_del))

	RegisterSignal(assailant, COMSIG_MOB_SELECTED_ZONE_SET, PROC_REF(on_target_change))
	RegisterSignal(assailant, COMSIG_MOVABLE_MOVED, PROC_REF(relay_user_move))

/obj/item/hand_item/grab/Destroy()
	assailant = null
	affecting = null
	return ..()

/obj/item/hand_item/grab/examine(mob/user)
	. = ..()
	var/mob/living/L = get_affecting_mob()
	var/obj/item/bodypart/BP = get_targeted_bodypart()
	if(L && BP)
		to_chat(user, "A grab on \the [L]'s [BP.plaintext_zone].")

/obj/item/hand_item/grab/update_icon_state()
	. = ..()
	if(current_grab.icon_state)
		icon_state = current_grab.icon_state

/obj/item/hand_item/grab/process()
	current_grab.process(src)

/obj/item/hand_item/grab/attack_self(mob/user)
	if (!assailant)
		return

	if(assailant.combat_mode)
		upgrade()
	else
		downgrade()


/obj/item/hand_item/grab/pre_attack(atom/A, mob/living/user, params)
	// End workaround
	if (QDELETED(src) || !assailant || !current_grab)
		return TRUE
	if(A.attack_grab(src, params) || current_grab.hit_with_grab(src, A, params)) //If there is no use_grab override or if it returns FALSE; then will behave according to intent.
		return TRUE
	return ..()

/obj/item/hand_item/grab/Destroy()
	if(affecting)
		reset_position()
		affecting.grabbed_by -= src
		affecting.reset_plane_and_layer()
		affecting = null
	assailant = null
	return ..()

/*
	This section is for newly defined useful procs.
*/

/obj/item/hand_item/grab/proc/on_target_change(datum/source, old_sel, new_sel)
	SIGNAL_HANDLER

	if(src != assailant.get_active_held_item())
		return // Note that because of this condition, there's no guarantee that target_zone = old_sel
	if(target_zone == new_sel)
		return

	var/old_zone = target_zone
	target_zone = new_sel
	var/obj/item/bodypart/BP = get_targeted_bodypart()

	if (!BP)
		to_chat(assailant, span_warning("You fail to grab \the [affecting] there as they do not have that bodypart!"))
		return

	name = "[initial(name)] ([BP.plaintext_zone])"
	to_chat(assailant, span_notice("You are now holding \the [affecting] by \the [BP.plaintext_zone]."))

	if(!isbodypart(get_targeted_bodypart()))
		current_grab.let_go(src)
		return
	current_grab.on_target_change(src, old_zone, target_zone)

/obj/item/hand_item/grab/proc/on_limb_loss(mob/victim, obj/item/bodypart/lost)
	SIGNAL_HANDLER

	if(affecting != victim)
		stack_trace("A grab switched affecting targets without properly re-registering for dismemberment updates.")
		return
	var/obj/item/bodypart/BP = get_targeted_bodypart()
	if(!istype(BP))
		current_grab.let_go(src)
		return // Sanity check in case the lost organ was improperly removed elsewhere in the code.
	if(lost != BP)
		return
	current_grab.let_go(src)

/obj/item/hand_item/grab/proc/can_grab()
	if(!assailant.Adjacent(affecting))
		return FALSE

	if(assailant.anchored || affecting.anchored)
		return FALSE

	if(assailant.get_active_hand())
		to_chat(assailant, span_warning("You can't grab someone if your hand is full."))
		return FALSE

	if(length(assailant.grabbed_by))
		to_chat(assailant, span_warning("You can't grab someone if you're being grabbed."))
		return FALSE

	var/obj/item/bodypart/BP = get_targeted_bodypart()
	if(!istype(BP))
		to_chat(assailant, span_warning("\The [affecting] is missing that body part!"))
		return FALSE

	if(assailant == affecting)
		if(!current_grab.can_grab_self)	//let's not nab ourselves
			to_chat(assailant, span_warning("You can't grab yourself!"))
			return FALSE

		var/active_hand = assailant.get_active_hand()
		if(BP == active_hand)
			to_chat(assailant, span_warning("You can't grab your own [BP.plaintext_zone] with itself!"))
			return FALSE

	for(var/obj/item/hand_item/grab/G in affecting.grabbed_by)
		if(G.assailant == assailant && G.target_zone == target_zone)
			var/obj/item/bodypart/targeted = G.get_targeted_bodypart()
			to_chat(assailant, span_warning("You already grabbed [affecting]'s [targeted.plaintext_zone]."))
			return FALSE
	return TRUE

// This will run from Initialize, after can_grab and other checks have succeeded. Must call parent; returning FALSE means failure and qdels the grab.
/obj/item/hand_item/grab/proc/setup()
	if(!assailant.put_in_active_hand(src))
		return FALSE // This should succeed as we checked the hand, but if not we abort here.
	if(!current_grab.setup(src))
		return FALSE
	affecting.grabbed_by += src // This is how we handle affecting being deleted.

	adjust_position()
	action_used()

	assailant.do_attack_animation(affecting)

	playsound(affecting.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	update_appearance()
	return TRUE

// Returns the bodypart of the grabbed person that the grabber is targeting
/obj/item/hand_item/grab/proc/get_targeted_bodypart()
	var/mob/living/L = get_affecting_mob()
	return (L?.get_bodypart(target_zone))

/obj/item/hand_item/grab/proc/resolve_item_attack(mob/living/M, obj/item/I, target_zone)
	if((M && ishuman(M)) && I)
		return current_grab.resolve_item_attack(src, M, I, target_zone)
	else
		return 0

/obj/item/hand_item/grab/proc/action_used()
	last_action = world.time
	leave_forensic_traces()

/obj/item/hand_item/grab/proc/check_action_cooldown()
	return (world.time >= last_action + current_grab.action_cooldown)

/obj/item/hand_item/grab/proc/check_upgrade_cooldown()
	return (world.time >= last_upgrade + current_grab.upgrade_cooldown)

/obj/item/hand_item/grab/proc/leave_forensic_traces()
	if (!affecting)
		return
	var/mob/living/carbon/carbo = get_affecting_mob()
	if(istype(carbo))
		var/obj/item/clothing/C = carbo.get_item_covering_zone(target_zone)
		if(istype(C))
			C.add_fingerprint(assailant)
			return

	affecting.add_fingerprint(assailant) //If no clothing; add fingerprint to mob proper.

/obj/item/hand_item/grab/proc/upgrade(bypass_cooldown = FALSE)
	if(!check_upgrade_cooldown() && !bypass_cooldown)
		to_chat(assailant, span_warning("It's too soon to upgrade."))
		return

	var/datum/grab/upgrab = current_grab.upgrade(src)
	if(upgrab)
		current_grab = upgrab
		last_upgrade = world.time
		adjust_position()
		update_appearance()
		leave_forensic_traces()
		current_grab.enter_as_up(src)

/obj/item/hand_item/grab/proc/downgrade()
	var/datum/grab/downgrab = current_grab.downgrade(src)
	if(downgrab)
		current_grab = downgrab
		update_appearance()

/obj/item/hand_item/grab/proc/draw_affecting_over()
	affecting.plane = assailant.plane
	affecting.layer = assailant.layer + 0.01

/obj/item/hand_item/grab/proc/draw_affecting_under()
	affecting.plane = assailant.plane
	affecting.layer = assailant.layer - 0.01


/obj/item/hand_item/grab/proc/throw_held()
	return current_grab.throw_held(src)

/obj/item/hand_item/grab/proc/handle_resist()
	current_grab.handle_resist(src)

/obj/item/hand_item/grab/proc/adjust_position(force = 0)
	if(force)	affecting.forceMove(assailant.loc)

	if(!assailant || !affecting || !assailant.Adjacent(affecting))
		qdel(src)
		return 0
	else
		current_grab.adjust_position(src)

/obj/item/hand_item/grab/proc/reset_position()
	current_grab.reset_position(src)

/obj/item/hand_item/grab/proc/has_hold_on_bodypart(obj/item/bodypart/BP)
	if (!BP)
		return FALSE

	if (get_targeted_bodypart() == BP)
		return TRUE

	return FALSE

/obj/item/hand_item/grab/proc/get_affecting_mob()
	RETURN_TYPE(/mob/living)
	if(isobj(affecting))
		return affecting.buckled_mobs?[1]

	if(isliving(affecting))
		return affecting
/// Primarily used for do_after() callbacks, checks if the grab item is still holding onto something
/obj/item/hand_item/grab/proc/is_grabbing(atom/movable/AM)
	return affecting == AM
/*
 * This section is for component signal relays/hooks
*/

/// Relay when the assailant moves to the grab datum
/obj/item/hand_item/grab/proc/relay_user_move(datum/source)
	SIGNAL_HANDLER
	current_grab.assailant_moved(src)

/// Target deleted, ABORT
/obj/item/hand_item/grab/proc/target_del(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/*
	This section is for the simple procs used to return things from current_grab.
*/
/obj/item/hand_item/grab/proc/stop_move()
	return current_grab.stop_move

/obj/item/hand_item/grab/proc/force_stand()
	return current_grab.force_stand

/obj/item/hand_item/grab/attackby(obj/W, mob/user)
	if(user == assailant)
		current_grab.item_attack(src, W)

/obj/item/hand_item/grab/proc/can_absorb()
	return current_grab.can_absorb

/obj/item/hand_item/grab/proc/assailant_reverse_facing()
	return current_grab.reverse_facing

/obj/item/hand_item/grab/proc/shield_assailant()
	return current_grab.shield_assailant

/obj/item/hand_item/grab/proc/point_blank_mult()
	return current_grab.point_blank_mult

/obj/item/hand_item/grab/proc/damage_stage()
	return current_grab.damage_stage

/obj/item/hand_item/grab/proc/force_danger()
	return current_grab.force_danger

/obj/item/hand_item/grab/proc/grab_slowdown()
	return current_grab.grab_slowdown

/obj/item/hand_item/grab/proc/ladder_carry()
	return current_grab.ladder_carry

/obj/item/hand_item/grab/proc/assailant_moved()
	current_grab.assailant_moved(src)

/obj/item/hand_item/grab/proc/restrains()
	return current_grab.restrains

/obj/item/hand_item/grab/proc/resolve_openhand_attack()
	return current_grab.resolve_openhand_attack(src)
