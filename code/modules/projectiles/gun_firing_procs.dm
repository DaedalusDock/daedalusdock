#define DUALWIELD_PENALTY_EXTRA_MULTIPLIER 1.4

/**
 * The defacto proc for "mob is trying to shoot the gun". Checks if they are able to, and a few other things.
 *
 * Arguments:
 * * target - The thing being shot at.
 * * user - The mob firing the gun.
 * * proximity - TRUE if user.Adjacent(target)
 * * params - Click parameters.
 */
/obj/item/gun/proc/try_fire_gun(atom/target, mob/living/user, proximity, params)
	if(QDELETED(target) || !target.x)
		return

	// We're shooting, don't queue up another burst.
	if(firing_burst)
		return

	if(SEND_SIGNAL(src, COMSIG_GUN_TRY_FIRE, user, target, proximity, params) & COMPONENT_CANCEL_GUN_FIRE)
		return

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			try_fire_akimbo(arglist(args))
			return

	if(proximity) //It's adjacent, is the user, or is on the user's person
		if(!ismob(target) || user.combat_mode) //melee attack
			return

		if(target == user)
			if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
				handle_suicide(user, target, params)
			return

		if(target in user.get_all_contents()) //can't shoot stuff inside us.
			return

	// * AT THIS POINT, WE ARE ABLE TO PULL THE TRIGGER * //
	if(!can_fire()) //Just because you can pull the trigger doesn't mean it can shoot.
		shoot_with_empty_chamber(user)
		try_fire_akimbo(arglist(args))
		return

	if(check_botched(user, target))
		try_fire_akimbo(arglist(args))
		return

	var/bonus_spread = 0
	if(istype(user))
		for(var/obj/item/gun/gun in user.held_items)
			if(gun == src || (gun.gun_flags & NO_AKIMBO))
				continue

			if(gun.can_trigger_gun(user, akimbo_usage = TRUE))
				bonus_spread += dual_wield_spread

	. = do_fire_gun(target, user, TRUE, params, null, bonus_spread)

	try_fire_akimbo(arglist(args))

/// Called by try_fire_gun() to attempt to fire offhand guns.
/obj/item/gun/proc/try_fire_akimbo(atom/target, mob/living/user, proximity, params)
	PRIVATE_PROC(TRUE)
	if(!ishuman(user) || !user.combat_mode)
		return

	var/bonus_spread = 0
	var/loop_counter = 0

	var/mob/living/carbon/human/H = user
	for(var/obj/item/gun/gun in H.held_items)
		if(gun == src || (gun.gun_flags & NO_AKIMBO))
			continue

		if(gun.can_trigger_gun(user, akimbo_usage = TRUE))
			bonus_spread += dual_wield_spread
			loop_counter++
			addtimer(CALLBACK(gun, TYPE_PROC_REF(/obj/item/gun, do_fire_gun), target, user, TRUE, params, null, bonus_spread), loop_counter)
/**
 * Called before the weapon is fired, before the projectile is created.
 *
 * Arguments:
 * * target - The thing being shot at.
 * * user - The mob firing the gun.
 */
/obj/item/gun/proc/before_firing(atom/target, mob/user)
	return

/**
 * Called after the weapon has successfully fired it's chambered round, and before update_chamber()
 *
 * Arguments:
 * * user - The mob firing the gun.
 * * pointblank - Is this a pointblank shot?
 * * pbtarget - If this is a pointblank shot, what is the target?
 * * message - If TRUE, will give chat feedback.
 */
/obj/item/gun/proc/after_firing(mob/living/user, pointblank = FALSE, atom/pbtarget = null, message = 1)
	// Shake the user's camera if it wasn't telekinesis
	if(recoil && !tk_firing(user))
		var/real_recoil = recoil
		if(!wielded)
			real_recoil = unwielded_recoil

		shake_camera(user, real_recoil + 1, real_recoil)

	//BANG BANG BANG
	play_fire_sound()

	if(suppressed)
		message = FALSE

	if(tk_firing(user))
		if(message)
			visible_message(
				span_danger("[src] fires itself[pointblank ? " point blank at [pbtarget]!" : "!"]"),
				blind_message = span_hear("You hear a gunshot!"),
				vision_distance = COMBAT_MESSAGE_RANGE
			)

	else if(pointblank)
		if(message)
			user.visible_message(
				span_danger("[user] fires [src] point blank at [pbtarget]!"),
				span_danger("You fire [src] point blank at [pbtarget]!"),
				span_hear("You hear a gunshot!"),
				COMBAT_MESSAGE_RANGE,
				pbtarget
			)
			to_chat(pbtarget, span_userdanger("[user] fires [src] point blank at you!"))

		/// Apply pointblank knockback to the target
		if(pb_knockback > 0 && ismob(pbtarget))
			var/mob/PBT = pbtarget
			var/atom/throw_target = get_edge_target_turf(PBT, user.dir)
			PBT.throw_at(throw_target, pb_knockback, 2)

	else if(!tk_firing(user))
		if(message)
			user.visible_message(
					span_danger("[user] fires [src]!"),
					blind_message = span_hear("You hear a gunshot!"),
					vision_distance = COMBAT_MESSAGE_RANGE,
					ignored_mobs = user
			)

	if(smoking_gun)
		var/x_component = sin(get_angle(user, pbtarget)) * 40
		var/y_component = cos(get_angle(user, pbtarget)) * 40
		var/obj/effect/abstract/particle_holder/gun_smoke = new(get_turf(src), /particles/firing_smoke)
		gun_smoke.particles.velocity = list(x_component, y_component)
		addtimer(VARSET_CALLBACK(gun_smoke.particles, count, 0), 5)
		addtimer(VARSET_CALLBACK(gun_smoke.particles, drift, 0), 3)
		QDEL_IN(gun_smoke, 0.6 SECONDS)

/**
 * Called when there was an attempt to fire the gun, but the chamber was empty.
 *
 * Arguments:
 * * user - The mob firing the gun.
 */
/obj/item/gun/proc/shoot_with_empty_chamber(mob/living/user)
	dry_fire_feedback(user)

/**
 * Called by shoot_with_empty_chamber().
 *
 * Arguments:
 * * user - The mob firing the gun.
 */
/obj/item/gun/proc/dry_fire_feedback(mob/living/user)
	PROTECTED_PROC(TRUE)

	visible_message(span_warning("*click*"), vision_distance = COMBAT_MESSAGE_RANGE)
	playsound(src, dry_fire_sound, 30, TRUE)

/**
 * Called by do_fire_gun if the rounds per burst is greater than 1.
 *
 * Arguments:
 * * user - The mob firing the gun.
 * * target - The thing being shot.
 * * message - Provide chat feedback
 * * params - ???
 * * zone_override - ???
 * * sprd - Bullet spread. This is immediately overwritten so I don't know why it's here.
 * * randomized_gun_spread - Calculated by do_fire_gun()
 * * randomized_bonus_spread - Calculated by do_fire_gun()
 * * rand_spr - Seriously, what the fuck?
 * * iteration - What step in the burst we are in.
 */
/obj/item/gun/proc/do_fire_in_burst(mob/living/user, atom/target, message = TRUE, params=null, zone_override = "", sprd = 0, randomized_gun_spread = 0, randomized_bonus_spread = 0, rand_spr = 0, iteration = 0)
	if(!user || !firing_burst)
		firing_burst = FALSE
		return FALSE

	if(!chambered?.loaded_projectile)
		shoot_with_empty_chamber(user)
		firing_burst = FALSE
		return FALSE

	if(randomspread)
		sprd = round((rand(0, 1) - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread))
	else //Smart spread
		sprd = round((((rand_spr/burst_size) * iteration) - (0.5 + (rand_spr * 0.25))) * (randomized_gun_spread + randomized_bonus_spread))

	before_firing(target,user)

	if(!chambered.fire_casing(target, user, params, ,suppressed, zone_override, sprd, src))
		shoot_with_empty_chamber(user)
		firing_burst = FALSE
		return FALSE

	after_firing(user, get_dist(user, target) <= 1, target, message)

	// The burst is over
	if (iteration >= burst_size)
		firing_burst = FALSE

	update_chamber()
	return TRUE

/**
 * The proc for firing the gun. This won't perform any non-gun checks. Returns TRUE if a round was fired.
 *
 * Arguments:
 * * user - The mob firing the gun.
 * * pointblank - Is this a pointblank shot?
 * * pbtarget - If this is a pointblank shot, what is the target?
 * * message - If TRUE, will give chat feedback.
 */
/obj/item/gun/proc/do_fire_gun(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	// We're on cooldown.
	if(fire_lockout)
		return

	if(user)
		SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src, target, params, zone_override)
		add_fingerprint(user)

	SEND_SIGNAL(src, COMSIG_GUN_FIRED, user, target, params, zone_override)


	//Vary by at least this much
	var/base_bonus_spread = 0
	var/sprd = 0
	var/randomized_gun_spread = 0
	var/rand_spr = rand()
	if(user && HAS_TRAIT(user, TRAIT_POOR_AIM)) //Nice job hotshot
		bonus_spread += 35
		base_bonus_spread += 10

	if(spread)
		randomized_gun_spread =	rand(0,spread)

	if(ismob(user) && !wielded && unwielded_spread_bonus)
		randomized_gun_spread += unwielded_spread_bonus

	var/randomized_bonus_spread = rand(base_bonus_spread, bonus_spread)

	// The fire delay after any modifiers
	var/modified_delay = fire_delay
	if(user && HAS_TRAIT(user, TRAIT_DOUBLE_TAP))
		modified_delay = ROUND_UP(fire_delay * 0.5)

	// If this is a burst gun, pawn it off to another behemoth proc.
	if(burst_size > 1)
		firing_burst = TRUE
		for(var/i in 1 to burst_size)
			addtimer(CALLBACK(src, PROC_REF(do_fire_in_burst), user, target, message, params, zone_override, sprd, randomized_gun_spread, randomized_bonus_spread, rand_spr, i), modified_delay * (i - 1))
	else
		if(!chambered)
			shoot_with_empty_chamber(user)
			return

		sprd = round((rand(0, 1) - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread))

		// The actual firing procs (FUCKING FINALLY AMIRITE LADS???)
		before_firing(target,user)
		if(!chambered.fire_casing(target, user, params, , suppressed, zone_override, sprd, src))
			shoot_with_empty_chamber(user)
			return

		// Post-fire things
		after_firing(user, get_dist(user, target) <= 1, target, message)
		update_chamber()

		// Make it so we can't fire as fast as the mob can click
		fire_lockout = TRUE
		addtimer(CALLBACK(src, PROC_REF(ready_to_fire)), modified_delay)

	if(istype(user))
		user.update_held_items()

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE

/// Called when the gun is ready to fire again
/obj/item/gun/proc/ready_to_fire()
	SHOULD_CALL_PARENT(TRUE)
	fire_lockout = FALSE

/obj/item/gun/proc/check_botched(mob/living/user, atom/target)
	if(!clumsy_check || !istype(user) || !HAS_TRAIT(user, TRAIT_CLUMSY) || !prob(40))
		return FALSE

	var/target_zone = user.get_random_valid_zone(blacklisted_parts = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), even_weights = TRUE, bypass_warning = TRUE)
	if(!target_zone)
		return

	user.visible_message(span_danger("[user] shoots [user.p_them()]self in the [parse_zone(target_zone)] with [src]!"))

	do_fire_gun(user, user, FALSE, null, target_zone)
	SEND_SIGNAL(user, COMSIG_MOB_CLUMSY_SHOOT_FOOT)

	if(!tk_firing(user) && !HAS_TRAIT(src, TRAIT_NODROP))
		user.dropItemToGround(src)
	return TRUE

/**
 * Called after the weapon has successfully fired it's chambered round.
 *
 * Arguments:
 * * empty_chamber - Whether or not the chamber is currently empty.
 * * from_firing - If this was called as apart of the gun firing.
 * * chamber_next_round - Whether or not the next round should be chambered.
 */
/obj/item/gun/proc/update_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	SHOULD_NOT_OVERRIDE(TRUE) // You probably want do_chamber_update()!

	do_chamber_update(empty_chamber, from_firing, chamber_next_round)
	after_chambering(from_firing)
	update_appearance()
	SEND_SIGNAL(src, COMSIG_GUN_CHAMBER_PROCESSED)

/**
 * Called after the weapon has successfully fired it's chambered round
 *
 * Arguments:
 * * empty_chamber - Whether or not the chamber is currently empty.
 * * from_firing - If this was called as apart of the gun firing.
 * * chamber_next_round - Whether or not the next round should be chambered.
 */
/obj/item/gun/proc/do_chamber_update(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	PROTECTED_PROC(TRUE)
	return

/// Called after a successful shot and update_chamber()
/obj/item/gun/proc/after_chambering(from_firing)
	return

#undef DUALWIELD_PENALTY_EXTRA_MULTIPLIER
