
/mob/living/proc/run_armor_check(def_zone = null, attack_flag = BLUNT, absorb_text = null, soften_text = null, armor_penetration, penetrated_text, silent=FALSE, weak_against_armor = null)
	var/our_armor = getarmor(def_zone, attack_flag)

	if(our_armor <= 0)
		return our_armor

	if(weak_against_armor)
		our_armor *= weak_against_armor

	var/armor_after_penetration = max(0, our_armor - armor_penetration)
	if(silent)
		return armor_after_penetration

	if(armor_after_penetration == 0)
		if(penetrated_text)
			to_chat(src, span_userdanger("[penetrated_text]"))
		else
			to_chat(src, span_userdanger("Your armor was penetrated."))

	else if(our_armor >= 100)
		if(absorb_text)
			to_chat(src, span_notice("[absorb_text]"))
		else
			to_chat(src, span_notice("Your armor absorbs the [armor_flag_to_strike_string(attack_flag)]."))

	else
		if(soften_text)
			to_chat(src, span_notice("[soften_text]"))
		else
			to_chat(src, span_notice("Your armor softens the [armor_flag_to_strike_string(attack_flag)]."))

	return our_armor

/mob/living/proc/getarmor(def_zone, type)
	return 0

//this returns the mob's protection against eye damage (number between -1 and 2) from bright lights
/mob/living/proc/get_eye_protection()
	return 0

//this returns the mob's protection against ear damage (0:no protection; 1: some ear protection; 2: has no ears)
/mob/living/proc/get_ear_protection()
	var/turf/current_turf = get_turf(src)
	var/datum/gas_mixture/environment = current_turf.unsafe_return_air()
	var/pressure = environment ? environment.returnPressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE) //space is empty
		return 1
	return 0

/mob/living/proc/is_mouth_covered(head_only = 0, mask_only = 0)
	return FALSE

/mob/living/proc/is_eyes_covered(check_glasses = 1, check_head = 1, check_mask = 1)
	return FALSE
/mob/living/proc/is_pepper_proof(check_head = TRUE, check_mask = TRUE)
	return FALSE
/mob/living/proc/on_hit(obj/projectile/P)
	return BULLET_ACT_HIT

/mob/living/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	. = ..()
	if(!P.nodamage && (. != BULLET_ACT_BLOCK))
		var/attack_direction = get_dir(P.starting, src)
		// we need a second, silent armor check to actually know how much to reduce damage taken, as opposed to
		// on [/atom/proc/bullet_act] where it's just to pass it to the projectile's on_hit().
		var/armor_check = check_projectile_armor(def_zone, P, is_silent = TRUE)

		var/modifier = 1
		if(LAZYLEN(grabbed_by))
			for(var/obj/item/hand_item/grab/G in grabbed_by)
				modifier = max(G.current_grab.point_blank_mult, modifier)
		var/damage = P.damage * modifier

		apply_damage(damage, P.damage_type, def_zone, armor_check, sharpness = P.sharpness, attack_direction = attack_direction)
		apply_effects(P.stun, P.knockdown, P.unconscious, P.slur, P.stutter, P.eyeblur, P.drowsy, armor_check, P.stamina, P.jitter, P.paralyze, P.immobilize)
		if(P.disorient_length)
			var/stamina = P.disorient_damage * ((100-armor_check)/100)
			Disorient(P.disorient_length, stamina, paralyze = P.disorient_status_length)
		if(P.dismemberment)
			check_projectile_dismemberment(P, def_zone)
	return . ? BULLET_ACT_HIT : BULLET_ACT_BLOCK

/mob/living/check_projectile_armor(def_zone, obj/projectile/impacting_projectile, is_silent)
	return run_armor_check(def_zone, impacting_projectile.armor_flag, "","",impacting_projectile.armor_penetration, "", is_silent, impacting_projectile.weak_against_armor)

/mob/living/proc/check_projectile_dismemberment(obj/projectile/P, def_zone)
	return 0

/obj/item/proc/get_volume_by_throwforce_and_or_w_class()
		if(throwforce && w_class)
				return clamp((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
		else if(w_class)
				return clamp(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
		else
				return 0

/mob/living/proc/set_combat_mode(new_mode, silent = TRUE)
	if(combat_mode == new_mode)
		return

	SEND_SIGNAL(src, COMSIG_LIVING_TOGGLE_COMBAT_MODE, new_mode)
	. = combat_mode
	combat_mode = new_mode

	if(combat_mode)
		stats?.set_skill_modifier(4, /datum/rpg_skill/skirmish, SKILL_SOURCE_COMBAT_MODE)
	else
		stats?.remove_skill_modifier(/datum/rpg_skill/skirmish, SKILL_SOURCE_COMBAT_MODE)

	if(hud_used?.action_intent)
		hud_used.action_intent.update_appearance()

	if(silent || !(client?.prefs.toggles & SOUND_COMBATMODE))
		return

	if(combat_mode)
		SEND_SOUND(src, sound('sound/misc/ui_togglecombat.ogg', volume = 25)) //Sound from interbay!
	else
		SEND_SOUND(src, sound('sound/misc/ui_toggleoffcombat.ogg', volume = 25)) //Slightly modified version of the above

/mob/living/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(!isitem(AM))
		// Filled with made up numbers for non-items.
		if(check_block(AM, 30, "\the [AM.name]", THROWN_PROJECTILE_ATTACK, 0, BRUTE))
			hitpush = FALSE
			skipcatch = TRUE
			blocked = TRUE
		else
			playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1) //Item sounds are handled in the item itself
			if(!istype(AM, /obj/machinery/vending) && !iscarbon(AM)) //Vendors have special interactions, while carbon mobs already generate visible messages!
				visible_message(span_danger("[src] is hit by [AM]!"))
		log_combat(AM, src, "hit ")
		return ..()

	var/obj/item/thrown_item = AM
	if(IS_WEAKREF_OF(src, thrown_item.thrownby)) //No throwing stuff at yourself to trigger hit reactions
		return ..()

	var/zone = ran_zone(BODY_ZONE_CHEST, 65)//Hits a random part of the body, geared towards the chest
	var/nosell_hit = SEND_SIGNAL(thrown_item, COMSIG_MOVABLE_IMPACT_ZONE, src, zone, throwingdatum) // TODO: find a better way to handle hitpush and skipcatch for humans
	if(nosell_hit)
		skipcatch = TRUE
		hitpush = FALSE

	if(blocked)
		return TRUE

	var/mob/thrown_by = thrown_item.thrownby?.resolve()
	if(thrown_by)
		log_combat(thrown_by, src, "threw and hit", thrown_item)

	if(nosell_hit)
		return ..()

	visible_message(
		span_danger("[src] is hit by [thrown_item]!"),
		span_userdanger("You're hit by [thrown_item]!")
	)

	if(!thrown_item.throwforce)
		return

	var/attack_flag = thrown_item.get_attack_flag()
	var/armor = run_armor_check(
		def_zone = zone,
		attack_flag = attack_flag,
		absorb_text = "Your armor has protected your [parse_zone(zone)].",
		soften_text = "Your armor has softened the [armor_flag_to_strike_string(attack_flag)] to your [parse_zone(zone)].",
		armor_penetration = thrown_item.armor_penetration,
		penetrated_text = "",
		silent = FALSE,
		weak_against_armor = thrown_item.weak_against_armor
	)

	apply_damage(thrown_item.throwforce, thrown_item.damtype, zone, armor, sharpness = thrown_item.sharpness)

	if(QDELETED(src)) //Damage can delete the mob.
		return

	if(body_position == LYING_DOWN) // physics says it's significantly harder to push someone by constantly chucking random furniture at them if they are down on the floor.
		hitpush = FALSE
	return ..()

/mob/living/fire_act(exposed_temperature, exposed_volume, turf/adjacent)
	. = ..()
	adjust_fire_stacks(3)
	ignite_mob()

/mob/living/attack_slime(mob/living/simple_animal/slime/M)
	if(M.buckled)
		if(M in buckled_mobs)
			M.Feedstop()
		return // can't attack while eating!

	if(HAS_TRAIT(src, TRAIT_PACIFISM))
		to_chat(M, span_warning("You don't want to hurt anyone!"))
		return FALSE

	if(check_block(M, M.melee_damage_upper, "[M]'s glomp", MELEE_ATTACK, M.armor_penetration, M.melee_damage_type))
		return FALSE

	if (stat != DEAD)
		log_combat(M, src, "attacked")
		M.do_attack_animation(src)
		visible_message(span_danger("\The [M.name] glomps [src]!"), \
						span_userdanger("\The [M.name] glomps you!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, M)
		to_chat(M, span_danger("You glomp [src]!"))
		return TRUE

	return FALSE

/mob/living/attack_basic_mob(mob/living/basic/user, list/modifiers)
	if(user.melee_damage_upper == 0)
		if(user != src)
			visible_message(span_notice("\The [user] [user.friendly_verb_continuous] [src]!"), \
							span_notice("\The [user] [user.friendly_verb_continuous] you!"), null, COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_notice("You [user.friendly_verb_simple] [src]!"))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to hurt anyone!"))
		return FALSE

	if(user.attack_sound)
		playsound(loc, user.attack_sound, 50, TRUE, TRUE)
	user.do_attack_animation(src)
	visible_message(span_danger("\The [user] [user.attack_verb_continuous] [src]!"), \
					span_userdanger("\The [user] [user.attack_verb_continuous] you!"), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You [user.attack_verb_simple] [src]!"))
	log_combat(user, src, "attacked")
	return TRUE

/mob/living/attack_animal(mob/living/simple_animal/user, list/modifiers)
	. = ..()
	user.face_atom(src)
	if(user.melee_damage_upper == 0)
		if(user != src)
			visible_message(
				span_notice("\The [user] [user.friendly_verb_continuous] [src]!"),
				span_notice("\The [user] [user.friendly_verb_continuous] you!"),
				null,
				COMBAT_MESSAGE_RANGE,
				user
			)
			to_chat(user, span_notice("You [user.friendly_verb_simple] [src]!"))
		return FALSE

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to hurt anyone!"))
		return FALSE

	var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
	if(check_block(src, user.melee_damage_upper, "[user]'s glomp", MELEE_ATTACK, user.armor_penetration, user.melee_damage_type))
		return FALSE

	if(user.attack_sound)
		playsound(src, user.attack_sound, 50, TRUE, TRUE)


	user.do_attack_animation(src)

	var/dam_zone = dismembering_strike(user, pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	if(!dam_zone) //Dismemberment successful
		return FALSE

	var/armor_block = run_armor_check(user.zone_selected, BLUNT, armor_penetration = user.armor_penetration)

	to_chat(user, span_danger("You [user.attack_verb_simple] [src]!"))
	log_combat(user, src, "attacked")
	var/damage_done = apply_damage(
		damage = damage,
		damagetype = user.melee_damage_type,
		def_zone = user.zone_selected,
		blocked = armor_block,
		sharpness = user.sharpness,
		attack_direction = get_dir(user, src),
	)
	return damage_done

/mob/living/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return TRUE

	var/martial_result = user.apply_martial_art(src, modifiers)
	if (martial_result != MARTIAL_ATTACK_INVALID)
		return martial_result

	return FALSE

/mob/living/attack_paw(mob/living/carbon/human/user, list/modifiers)
	if(isturf(loc) && istype(loc.loc, /area/misc/start))
		to_chat(user, "No attacking people at spawn, you jackass.")
		return FALSE

	var/martial_result = user.apply_martial_art(src, modifiers)
	if (martial_result != MARTIAL_ATTACK_INVALID)
		return martial_result

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if (user != src)
			user.disarm(src)
			return TRUE

	if (!user.combat_mode)
		return FALSE

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to hurt anyone!"))
		return FALSE

	if(user.is_muzzled() || user.is_mouth_covered(FALSE, TRUE))
		to_chat(user, span_warning("You can't bite with your mouth covered!"))
		return FALSE

	if(check_block(user, 1, "[user]'s bite", UNARMED_ATTACK, 0, BRUTE))
		return FALSE

	user.do_attack_animation(src, ATTACK_EFFECT_BITE)

	if (HAS_TRAIT(user, TRAIT_PERFECT_ATTACKER) || prob(75))
		log_combat(user, src, "attacked")
		playsound(loc, 'sound/weapons/bite.ogg', 50, TRUE, -1)
		visible_message(
			span_danger("[user.name] bites [src]!"),
			null,
			span_hear("You hear a chomp!"),
			COMBAT_MESSAGE_RANGE,
			user
		)
		return TRUE

	else
		visible_message(
			span_danger("[user.name]'s bite misses [src]!"),
			null,
			span_hear("You hear the sound of jaws snapping shut!"),
			COMBAT_MESSAGE_RANGE,
			user
		)
		to_chat(user, span_warning("Your bite misses [src]!"))

	return FALSE

/mob/living/attack_larva(mob/living/carbon/alien/larva/L)
	if(L.combat_mode)
		if(HAS_TRAIT(L, TRAIT_PACIFISM))
			to_chat(L, span_warning("You don't want to hurt anyone!"))
			return

		L.do_attack_animation(src)
		if(prob(90))
			log_combat(L, src, "attacked")
			visible_message(span_danger("[L.name] bites [src]!"), \
							span_userdanger("[L.name] bites you!"), span_hear("You hear a chomp!"), COMBAT_MESSAGE_RANGE, L)
			to_chat(L, span_danger("You bite [src]!"))
			playsound(loc, 'sound/weapons/bite.ogg', 50, TRUE, -1)
			return TRUE
		else
			visible_message(span_danger("[L.name]'s bite misses [src]!"), \
							span_danger("You avoid [L.name]'s bite!"), span_hear("You hear the sound of jaws snapping shut!"), COMBAT_MESSAGE_RANGE, L)
			to_chat(L, span_warning("Your bite misses [src]!"))
	else
		visible_message(span_notice("[L.name] rubs its head against [src]."), \
						span_notice("[L.name] rubs its head against you."), null, null, L)
		to_chat(L, span_notice("You rub your head against [src]."))
		return FALSE
	return FALSE

/mob/living/attack_alien(mob/living/carbon/alien/humanoid/user, list/modifiers)
	SEND_SIGNAL(src, COMSIG_MOB_ATTACK_ALIEN, user, modifiers)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(check_block(user, 0, "[user]'s tackle", MELEE_ATTACK, 0, BRUTE))
			return FALSE
		user.do_attack_animation(src, ATTACK_EFFECT_DISARM)
		return TRUE

	if(user.combat_mode)
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			to_chat(user, span_warning("You don't want to hurt anyone!"))
			return FALSE

		if(check_block(user, user.melee_damage_upper, "[user]'s slash", MELEE_ATTACK, 0, BRUTE))
			return FALSE

		user.do_attack_animation(src)
		return TRUE

	else
		visible_message(span_notice("[user] caresses [src] with its scythe-like arm."), \
						span_notice("[user] caresses you with its scythe-like arm."), null, null, user)
		to_chat(user, span_notice("You caress [src] with your scythe-like arm."))
		return FALSE

/mob/living/attack_hulk(mob/living/carbon/human/user)
	..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to hurt [src]!"))
		return FALSE
	return TRUE

/mob/living/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return FALSE
	return ..()

/mob/living/acid_act(acidpwr, acid_volume, affect_clothing = TRUE, affect_body = TRUE)
	take_bodypart_damage(acidpwr * min(1, acid_volume * 0.1))
	return TRUE

///As the name suggests, this should be called to apply electric shocks.
/mob/living/proc/electrocute_act(shock_damage, siemens_coeff = 1, flags = SHOCK_HANDS, stun_multiplier = 1)
	SEND_SIGNAL(src, COMSIG_LIVING_ELECTROCUTE_ACT, shock_damage, siemens_coeff, flags)
	shock_damage *= siemens_coeff
	if((flags & SHOCK_USE_AVG_SIEMENS) && HAS_TRAIT(src, TRAIT_TESLA_SHOCKIMMUNE))
		return FALSE

	if(HAS_TRAIT(src, TRAIT_SHOCKIMMUNE))
		return FALSE

	if(shock_damage < 1)
		return FALSE

	if(!(flags & SHOCK_ILLUSION))
		adjustFireLoss(shock_damage)
	else
		stamina.adjust(-shock_damage)

	return shock_damage

/mob/living/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/obj/O in contents)
		O.emp_act(severity)

///Logs, gibs and returns point values of whatever mob is unfortunate enough to get eaten.
/mob/living/singularity_act()
	investigate_log("([key_name(src)]) has been consumed by the singularity.", INVESTIGATE_ENGINE) //Oh that's where the clown ended up!
	gib()
	return 20

/mob/living/narsie_act()
	if(status_flags & GODMODE || QDELETED(src))
		return

	if(GLOB.cult_narsie && GLOB.cult_narsie.souls_needed[src])
		GLOB.cult_narsie.souls_needed -= src
		GLOB.cult_narsie.souls += 1
		if((GLOB.cult_narsie.souls == GLOB.cult_narsie.soul_goal) && (GLOB.cult_narsie.resolved == FALSE))
			GLOB.cult_narsie.resolved = TRUE
			sound_to_playing_players('sound/machines/alarm.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper), 1), 120)
			addtimer(CALLBACK(SSticker, TYPE_PROC_REF(/datum/controller/subsystem/ticker, end_round)), 270)
	if(client)
		makeNewConstruct(/mob/living/simple_animal/hostile/construct/harvester, src, cultoverride = TRUE)
	else
		switch(rand(1, 4))
			if(1)
				new /mob/living/simple_animal/hostile/construct/juggernaut/hostile(get_turf(src))
			if(2)
				new /mob/living/simple_animal/hostile/construct/wraith/hostile(get_turf(src))
			if(3)
				new /mob/living/simple_animal/hostile/construct/artificer/hostile(get_turf(src))
			if(4)
				new /mob/living/simple_animal/hostile/construct/proteon/hostile(get_turf(src))
	spawn_dust()
	gib()
	return TRUE

//called when the mob receives a bright flash
/mob/living/proc/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash, length = 2.5 SECONDS)
	if(HAS_TRAIT(src, TRAIT_NOFLASH))
		return FALSE
	if(get_eye_protection() >= intensity)
		return FALSE
	if(is_blind() && !(override_blindness_check || affect_silicon))
		return FALSE

	// this forces any kind of flash (namely normal and static) to use a black screen for photosensitive players
	// it absolutely isn't an ideal solution since sudden flashes to black can apparently still trigger epilepsy, but byond apparently doesn't let you freeze screens
	// and this is apparently at least less likely to trigger issues than a full white/static flash
	if(client?.prefs?.read_preference(/datum/preference/toggle/darkened_flash))
		type = /atom/movable/screen/fullscreen/flash/black

	overlay_fullscreen("flash", type)
	addtimer(CALLBACK(src, PROC_REF(clear_fullscreen), "flash", length), length)
	return TRUE

//called when the mob receives a loud bang
/mob/living/proc/soundbang_act()
	return FALSE

//to damage the clothes worn by a mob
/mob/living/proc/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	return


/mob/living/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect, fov_effect = TRUE, do_hurt = TRUE)
	if(!used_item)
		used_item = get_active_held_item()
	..()

/**
 * Does a slap animation on an atom
 *
 * Uses do_attack_animation to animate the attacker attacking
 * then draws a hand moving across the top half of the target(where a mobs head would usually be) to look like a slap
 * Arguments:
 * * atom/A - atom being slapped
 */
/mob/living/proc/do_slap_animation(atom/slapped)
	do_attack_animation(slapped, no_effect=TRUE)
	var/image/gloveimg = image('icons/effects/effects.dmi', slapped, "slapglove", slapped.layer + 0.1)
	gloveimg.pixel_y = 10 // should line up with head
	gloveimg.pixel_x = 10
	flick_overlay(gloveimg, GLOB.clients, 10)

	// And animate the attack!
	animate(gloveimg, alpha = 175, transform = matrix() * 0.75, pixel_x = 0, pixel_y = 10, pixel_z = 0, time = 3)
	animate(time = 1)
	animate(alpha = 0, time = 3, easing = CIRCULAR_EASING|EASE_OUT)

/** Handles exposing a mob to reagents.
 *
 * If the methods include INGEST the mob tastes the reagents.
 * If the methods include VAPOR it incorporates permiability protection.
 */
/mob/living/expose_reagents(list/reagents, datum/reagents/source, methods=TOUCH, volume_modifier=1, show_message=TRUE, exposed_temperature)
	. = ..()
	if(. & COMPONENT_NO_EXPOSE_REAGENTS)
		return

	if(!reagents)
		return

	if(methods & INGEST)
		taste(source)

	var/touch_protection = (methods & VAPOR) ? get_permeability_protection() : 0
	SEND_SIGNAL(source, COMSIG_REAGENTS_EXPOSE_MOB, src, reagents, methods, volume_modifier, show_message, touch_protection)
	for(var/datum/reagent/R as anything in reagents)
		. |= R.expose_mob(src, reagents[R], exposed_temperature, source, methods, show_message, touch_protection, source)

/// See if an attack is blocked by an item or effect. Returns TRUE if it is.
/mob/living/proc/check_block(atom/hit_by, damage, attack_text = "the attack", attack_type = MELEE_ATTACK, armor_penetration = 0, damage_type = BRUTE)
	if(SEND_SIGNAL(src, COMSIG_LIVING_CHECK_BLOCK, hit_by, damage, attack_text, attack_type, armor_penetration) & SUCCESSFUL_BLOCK)
		return TRUE

	return FALSE
