/datum/grab/normal
	abstract_type = /datum/grab/normal

	help_action = "inspect"
	disarm_action = "pin"
	grab_action = "jointlock"
	harm_action = "dislocate"

	var/drop_headbutt = 1

/datum/grab/normal/setup(obj/item/hand_item/grab/G)
	if(!(. = ..()))
		return

	var/obj/item/bodypart/BP = G.get_targeted_bodypart()
	if(!BP)
		return

	if(G.affecting != G.assailant)
		G.assailant.visible_message(span_warning("[G.assailant] has grabbed [G.affecting]'s [BP.plaintext_zone]!"))
	else
		G.assailant.visible_message(span_notice("[G.assailant] has grabbed [G.assailant.p_their()] [BP.plaintext_zone]!"))

/datum/grab/normal/on_hit_help(obj/item/hand_item/grab/G, atom/A)

	var/obj/item/bodypart/BP = G.get_targeted_bodypart()
	if(!BP || (A && A != G.get_affecting_mob()))
		return FALSE
	return BP.inspect(G.assailant)

/datum/grab/normal/on_hit_disarm(obj/item/hand_item/grab/G, atom/A)

	var/mob/living/affecting = G.get_affecting_mob()
	var/mob/living/assailant = G.assailant
	if(affecting && A && A == affecting)
		if(affecting.body_position == LYING_DOWN)
			to_chat(assailant, span_warning("They're already on the ground."))
			return FALSE

		affecting.visible_message(span_danger("\The [assailant] is trying to pin \the [affecting] to the ground!"))

		if(do_after(assailant, affecting, action_cooldown - 1, DO_PUBLIC, display = image('icons/hud/do_after.dmi', "harm")))
			G.action_used()
			affecting.visible_message(span_danger("\The [assailant] pins \the [affecting] to the ground!"))
			affecting.Paralyze(1 SECOND) // This can only be performed with an aggressive grab, which ensures that once someone is knocked down, they stay down.
			affecting.move_from_pull(G.assailant, get_turf(G.assailant))
			return TRUE

		affecting.visible_message(span_warning("\The [assailant] fails to pin \the [affecting] to the ground."))
	return FALSE

/datum/grab/normal/on_hit_grab(obj/item/hand_item/grab/G, atom/A)
	var/mob/living/affecting = G.get_affecting_mob()
	if(!affecting || (A && A != affecting))
		return FALSE

	var/mob/living/assailant = G.assailant
	if(!assailant)
		return FALSE

	var/obj/item/bodypart/BP = G.get_targeted_bodypart()
	if(!BP)
		to_chat(assailant, span_warning("\The [affecting] is missing that body part!"))
		return FALSE

	assailant.visible_message(span_danger("\The [assailant] begins to [pick("bend", "twist")] \the [affecting]'s [BP.plaintext_zone] into a jointlock!"))
	if(do_after(assailant, affecting, action_cooldown - 1, DO_PUBLIC, display = image('icons/hud/do_after.dmi', "harm")))
		G.action_used()
		BP.jointlock(assailant)
		assailant.visible_message(span_danger("\The [affecting]'s [BP.plaintext_zone] is twisted!"))
		playsound(assailant.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return TRUE

	affecting.visible_message(span_warning("\The [assailant] fails to jointlock \the [affecting]'s [BP.plaintext_zone]."))
	return FALSE

/datum/grab/normal/on_hit_harm(obj/item/hand_item/grab/G, atom/A)
	var/mob/living/carbon/affecting = G.get_affecting_mob()
	if(!istype(affecting) || (A && A != affecting))
		return FALSE

	var/mob/living/assailant = G.assailant
	if(!assailant)
		return FALSE

	var/obj/item/bodypart/BP = G.get_targeted_bodypart()
	if(!BP)
		to_chat(assailant, span_warning("\The [affecting] is missing that body part!"))
		return  FALSE

	if(BP.bodypart_flags & BP_DISLOCATED)
		assailant.visible_message(span_notice("\The [assailant] begins to place [affecting]'s [BP.joint_name] back in it's socket."))
		if(do_after(assailant, affecting, action_cooldown - 1, DO_PUBLIC))
			G.action_used()
			BP.set_dislocated(FALSE)
			assailant.visible_message(span_warning("\The [affecting]'s [BP.joint_name] pops back into place!"))
			affecting.pain_message("AAAHHHHAAGGHHHH", 50, TRUE)
		return TRUE

	if(BP.can_be_dislocated())
		assailant.visible_message(span_danger("\The [assailant] begins to dislocate \the [affecting]'s [BP.joint_name]!"))
		if(do_after(assailant, affecting, action_cooldown - 1, DO_PUBLIC))
			G.action_used()
			BP.set_dislocated(TRUE)
			assailant.visible_message(span_danger("\The [affecting]'s [BP.joint_name] [pick("gives way","caves in","collapses")]!"))
			playsound(assailant.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			return TRUE

		affecting.visible_message(span_warning("\The [assailant] fails to dislocate \the [affecting]'s [BP.joint_name]."))
		return FALSE

	if(BP.can_be_dislocated())
		to_chat(assailant, span_warning("\The [affecting]'s [BP.joint_name] is already dislocated!"))
	else
		to_chat(assailant, span_warning("You can't dislocate \the [affecting]'s [BP.joint_name]!"))
	return FALSE

/datum/grab/normal/resolve_openhand_attack(obj/item/hand_item/grab/G)
	if(!G.assailant.combat_mode || G.assailant == G.affecting)
		return FALSE
	if(G.target_zone == BODY_ZONE_HEAD)
		if(G.assailant.zone_selected == BODY_ZONE_PRECISE_EYES)
			if(attack_eye(G))
				return TRUE
		else
			if(headbutt(G))
				if(drop_headbutt)
					let_go()
				return TRUE
	return FALSE

/datum/grab/normal/proc/attack_eye(obj/item/hand_item/grab/G)
	var/mob/living/carbon/human/target = G.get_affecting_mob()
	var/mob/living/carbon/human/attacker = G.assailant
	if(!istype(target) || !istype(attacker))
		return TRUE

	if(target.is_eyes_covered())
		to_chat(attacker, "<span class='danger'>You're going to need to remove the eye covering first.</span>")
		return TRUE

	var/obj/item/organ/eyes/E = target.getorganslot(ORGAN_SLOT_EYES)
	if(!E)
		to_chat(attacker, "<span class='danger'>You cannot locate any eyes on [target]!</span>")
		return TRUE

	log_combat(attacker, target, "attacked the eyes of (grab)")

	if(E)
		E.applyOrganDamage(rand(3,4))
		attacker.visible_message(span_danger("\The [attacker] jams [G.p_their()] fingers into \the [target]'s [E.name]!"))
		if(!(E.organ_flags & ORGAN_SYNTHETIC))
			to_chat(target, span_danger("You experience immense pain as fingers are jammed into your [E.name]!"))
		else
			to_chat(target, span_danger("You experience fingers being jammed into your [E.name]."))
	else
		attacker.visible_message(span_danger("\The [attacker] attempts to press [G.p_their()] fingers into \the [target]'s [E.name], but [target.p_they()] doesn't have any!"))
	return TRUE

/datum/grab/normal/proc/headbutt(obj/item/hand_item/grab/G)
	var/mob/living/carbon/human/target = G.get_affecting_mob()
	var/mob/living/carbon/human/attacker = G.assailant
	if(!istype(target) || !istype(attacker))
		return

	if(target.body_position == LYING_DOWN)
		return

	var/damage = 20
	var/obj/item/clothing/hat = attacker.head
	var/sharpness
	if(istype(hat))
		damage += hat.force * 3
		sharpness = hat.sharpness

	if(sharpness & SHARP_POINTY)
		if(istype(hat))
			attacker.visible_message(span_danger("\The <b>[attacker]</b> gores \the <b>[target]</b> with \the [hat]!"))
		else
			attacker.visible_message(span_danger("\The <b>[attacker]</b> gores \the <b>[target]</b>!"))
	else
		attacker.visible_message(span_danger("\The <b>[attacker]</b> thrusts [attacker.p_their()] head into \the <b>[target]</b>'s skull!"))

	var/armor = target.run_armor_check(BODY_ZONE_HEAD, BLUNT)
	target.apply_damage(damage, BRUTE, BODY_ZONE_HEAD, armor, sharpness = sharpness)
	attacker.apply_damage(10, BRUTE, BODY_ZONE_HEAD)

	if(armor < 0.5 && target.can_head_trauma_ko() && prob(damage))
		target.Unconscious(20 SECONDS)
		target.visible_message(span_danger("\The [target] collapses, now fast asleep."))

	playsound(attacker.loc, "swing_hit", 25, 1, -1)
	log_combat(attacker, target, "headbutted")
	return 1

// Handles special targeting like eyes and mouth being covered.
/datum/grab/normal/special_bodyzone_effects(obj/item/hand_item/grab/G)
	. = ..()
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(istype(affecting_mob) && G.special_target_functional)
		switch(G.target_zone)
			if(BODY_ZONE_PRECISE_MOUTH)
				ADD_TRAIT(affecting_mob, TRAIT_MUTE, REF(G))
			if(BODY_ZONE_PRECISE_EYES)
				ADD_TRAIT(affecting_mob, TRAIT_BLIND, REF(G))

/datum/grab/normal/remove_bodyzone_effects(obj/item/hand_item/grab/G)
	. = ..()
	REMOVE_TRAIT(G.affecting, TRAIT_MUTE, REF(G))
	REMOVE_TRAIT(G.affecting, TRAIT_BLIND, REF(G))

// Handles when they change targeted areas and something is supposed to happen.
/datum/grab/normal/special_bodyzone_change(obj/item/hand_item/grab/G, old_zone, new_zone)
	old_zone = parse_zone(old_zone)
	if((old_zone != BODY_ZONE_HEAD && old_zone != BODY_ZONE_CHEST) || !G.get_affecting_mob())
		return
	switch(new_zone)
		if(BODY_ZONE_PRECISE_MOUTH)
			G.assailant.visible_message("<span class='warning'>\The [G.assailant] covers [G.affecting]'s mouth!</span>")
		if(BODY_ZONE_PRECISE_EYES)
			G.assailant.visible_message("<span class='warning'>\The [G.assailant] covers [G.affecting]'s eyes!</span>")

/datum/grab/normal/check_special_target(obj/item/hand_item/grab/G)
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(!istype(affecting_mob))
		return FALSE
	switch(G.target_zone)
		if(BODY_ZONE_PRECISE_MOUTH)
			if(!affecting_mob.has_mouth())
				to_chat(G.assailant, "<span class='danger'>You cannot locate a mouth on [G.affecting]!</span>")
				return FALSE
		if(BODY_ZONE_PRECISE_EYES)
			if(!affecting_mob.getorganslot(ORGAN_SLOT_EYES))
				to_chat(G.assailant, "<span class='danger'>You cannot locate any eyes on [G.affecting]!</span>")
				return FALSE
	return TRUE

/datum/grab/normal/resolve_item_attack(obj/item/hand_item/grab/G, mob/living/carbon/human/user, obj/item/I)
	switch(G.target_zone)
		if(BODY_ZONE_HEAD)
			return attack_throat(G, I, user)
		else
			return attack_tendons(G, I, user, G.target_zone)

/datum/grab/normal/proc/attack_throat(obj/item/hand_item/grab/G, obj/item/W, mob/living/user)
	var/mob/living/carbon/affecting = G.get_affecting_mob()
	if(!istype(affecting))
		return
	if(!user.combat_mode)
		return FALSE // Not trying to hurt them.

	if(!(W.sharpness & SHARP_EDGED) || !W.force || W.damtype != BRUTE)
		return FALSE //unsuitable weapon

	if(DOING_INTERACTION(user, "throat slit"))
		return FALSE

	user.visible_message("<span class='danger'>\The [user] begins to slit [affecting]'s throat with \the [W]!</span>")

	user.changeNext_move(CLICK_CD_MELEE)
	if(!do_after(user, affecting, 2 SECONDS, DO_PUBLIC, extra_checks = CALLBACK(G, TYPE_PROC_REF(/obj/item/hand_item/grab, is_grabbing), affecting), interaction_key = "throat slit", display = W))
		return FALSE

	if(!(G && G.affecting == affecting)) //check that we still have a grab
		return FALSE

	var/armor

	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	for(var/obj/item/clothing/equipped in affecting.get_equipped_items())
		if((equipped.body_parts_covered & HEAD) && (equipped.clothing_flags & STOPSPRESSUREDAMAGE))
			armor = affecting.run_armor_check(BODY_ZONE_HEAD, BLUNT, silent = TRUE)
			break

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*1.5, 20)
		affecting.apply_damage(damage, BRUTE, BODY_ZONE_HEAD, armor, sharpness = W.sharpness)
		total_damage += damage

	if(total_damage)
		user.visible_message("<span class='danger'>\The [user] slit [affecting]'s throat open with \the [W]!</span>")
		affecting.apply_status_effect(/datum/status_effect/neck_slice)
		if(W.hitsound)
			playsound(affecting.loc, W.hitsound, 50, 1, -1)

	COOLDOWN_START(G, action_cd, action_cooldown)

	log_combat(user, affecting, "slit throat (grab)")
	return 1

/datum/grab/normal/proc/attack_tendons(obj/item/hand_item/grab/G, obj/item/W, mob/living/user, target_zone)
	var/mob/living/affecting = G.get_affecting_mob()
	if(!affecting)
		return
	if(!user.combat_mode)
		return FALSE // Not trying to hurt them.

	if(!(W.sharpness & SHARP_EDGED) || !W.force || W.damtype != BRUTE)
		return FALSE //unsuitable weapon

	var/obj/item/bodypart/BP = G.get_targeted_bodypart()
	if(!BP || !(BP.check_tendon() == CHECKTENDON_OK))
		return FALSE

	if(DOING_INTERACTION(user, "slice tendon"))
		return FALSE

	user.visible_message(span_danger("\The [user] begins to cut \the [affecting]'s [BP.tendon_name] with \the [W]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	user.changeNext_move(CLICK_CD_MELEE)

	if(!do_after(user, affecting, 2 SECONDS, DO_PUBLIC, extra_checks = CALLBACK(G, TYPE_PROC_REF(/obj/item/hand_item/grab, is_grabbing), affecting), interaction_key = "slice tendon", display = W))
		return FALSE

	if(!BP || !BP.set_sever_tendon(TRUE))
		return FALSE

	user.visible_message(span_danger("\The [user] cut \the [affecting]'s [BP.tendon_name] with \the [W]!"))

	if(W.hitsound)
		playsound(affecting.loc, W.hitsound, 50, 1, -1)

	COOLDOWN_START(G, action_cd, action_cooldown)

	log_combat(user, affecting, "hamstrung (grab)")
	return TRUE

/datum/grab/normal/enter_as_down(obj/item/hand_item/grab/G, silent)
	. = ..()
	G.assailant.visible_message(
		span_warning("<b>[G.assailant]</b> loosens their grip on [G.affecting]."),
	)

/datum/grab/normal/add_context(list/context, obj/item/held_item, mob/living/user, atom/movable/target)
	. = ..()
	if(held_item?.sharpness & SHARP_EDGED)
		var/obj/item/hand_item/grab/G = user.is_grabbing(target)
		switch(G.target_zone)
			if(BODY_ZONE_HEAD)
				context[SCREENTIP_CONTEXT_LMB] = "Slice neck"
			else
				context[SCREENTIP_CONTEXT_LMB] = "Attack tendons"
