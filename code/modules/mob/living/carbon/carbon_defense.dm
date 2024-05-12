#define SHAKE_ANIMATION_OFFSET 4

/mob/living/carbon/get_eye_protection()
	. = ..()
	if(HAS_TRAIT_NOT_FROM(src, TRAIT_BLIND, list(UNCONSCIOUS_TRAIT, HYPNOCHAIR_TRAIT)))
		return INFINITY //For all my homies that can not see in the world
	var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
	if(!E)
		return INFINITY //Can't get flashed without eyes
	else
		. += E.flash_protect
	if(isclothing(head)) //Adds head protection
		. += head.flash_protect
	if(isclothing(glasses)) //Glasses
		. += glasses.flash_protect
	if(isclothing(wear_mask)) //Mask
		. += wear_mask.flash_protect

/mob/living/carbon/get_ear_protection()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_DEAF))
		return INFINITY //For all my homies that can not hear in the world
	var/obj/item/organ/ears/E = getorganslot(ORGAN_SLOT_EARS)
	if(!E)
		return INFINITY
	else
		. += E.bang_protect

/mob/living/carbon/is_mouth_covered(head_only = FALSE, mask_only = FALSE)
	if( (!mask_only && head && (head.flags_cover & HEADCOVERSMOUTH)) || (!head_only && wear_mask && (wear_mask.flags_cover & MASKCOVERSMOUTH)) )
		return TRUE

/mob/living/carbon/is_eyes_covered(check_glasses = TRUE, check_head = TRUE, check_mask = TRUE)
	if(check_head && head && (head.flags_cover & HEADCOVERSEYES))
		return head
	if(check_mask && wear_mask && (wear_mask.flags_cover & MASKCOVERSEYES))
		return wear_mask
	if(check_glasses && glasses && (glasses.flags_cover & GLASSESCOVERSEYES))
		return glasses

/mob/living/carbon/is_pepper_proof(check_head = TRUE, check_mask = TRUE)
	if(check_head &&(head?.flags_cover & PEPPERPROOF))
		return head
	if(check_mask &&(wear_mask?.flags_cover & PEPPERPROOF))
		return wear_mask

/mob/living/carbon/check_projectile_dismemberment(obj/projectile/P, def_zone)
	var/obj/item/bodypart/affecting = get_bodypart(def_zone)
	if(affecting && affecting.dismemberable && affecting.get_damage() >= (affecting.max_damage - P.dismemberment))
		affecting.dismember(P.damtype)

/mob/living/carbon/proc/can_catch_item(skip_throw_mode_check)
	. = FALSE
	if(!skip_throw_mode_check && !throw_mode)
		return
	if(get_active_held_item())
		return
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	return TRUE

/mob/living/carbon/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(!skipcatch && can_catch_item() && istype(AM, /obj/item) && !HAS_TRAIT(AM, TRAIT_UNCATCHABLE) && isturf(AM.loc))
		var/obj/item/I = AM
		I.attack_hand(src)
		if(get_active_held_item() == I) //if our attack_hand() picks up the item...
			visible_message(span_warning("[src] catches [I]!"), \
							span_userdanger("You catch [I] in mid-air!"))
			throw_mode_off(THROW_MODE_TOGGLE)
			return TRUE
	return ..()


/mob/living/carbon/attacked_by(obj/item/I, mob/living/user)
	var/obj/item/bodypart/affecting
	if(user == src)
		affecting = get_bodypart(deprecise_zone(user.zone_selected)) //we're self-mutilating! yay!
	else
		var/zone_hit_chance = 80
		if(body_position == LYING_DOWN) // half as likely to hit a different zone if they're on the ground
			zone_hit_chance += 10
		affecting = get_bodypart(ran_zone(user.zone_selected, zone_hit_chance))
	if(!affecting) //missing limb? we select the first bodypart (you can never have zero, because of chest)
		affecting = bodyparts[1]

	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)
	send_item_attack_message(I, user, affecting.plaintext_zone, affecting)
	if(I.stamina_damage)
		stamina.adjust(-1 * (I.stamina_damage * (prob(I.stamina_critical_chance) ? I.stamina_critical_modifier : 1)))

	if(I.force)
		var/attack_direction = get_dir(user, src)

		apply_damage(I.force, I.damtype, affecting, sharpness = I.sharpness, attack_direction = attack_direction)

		if(I.damtype == BRUTE && IS_ORGANIC_LIMB(affecting))
			if(prob(33))
				I.add_mob_blood(src)
				var/turf/location = get_turf(src)
				add_splatter_floor(location)

				if(get_dist(user, src) <= 1) //people with TK won't get smeared with blood
					user.add_mob_blood(src)

				if(affecting.body_zone == BODY_ZONE_HEAD)
					if(wear_mask)
						wear_mask.add_mob_blood(src)
						update_worn_mask()

					if(wear_neck)
						wear_neck.add_mob_blood(src)
						update_worn_neck()

					if(head)
						head.add_mob_blood(src)
						update_worn_head()

		return TRUE //successful attack

/mob/living/carbon/send_item_attack_message(obj/item/I, mob/living/user, hit_area, obj/item/bodypart/hit_bodypart)
	if(!I.force && !length(I.attack_verb_simple) && !length(I.attack_verb_continuous))
		return
	var/message_verb_continuous = length(I.attack_verb_continuous) ? "[pick(I.attack_verb_continuous)]" : "attacks"

	var/message_hit_area = ""
	if(hit_area)
		message_hit_area = " in the [hit_area]"
	var/attack_message = "<b>[src]</b> [message_verb_continuous][message_hit_area] with [I]!"
	if(user in viewers(src, null))
		attack_message = "<b>[user]</b> [message_verb_continuous] <b>[src]</b>[message_hit_area] with [I]!"
	if(user == src)
		attack_message = "<b>[user]</b> [message_verb_continuous] [user.p_them()]self[message_hit_area] with [I]!"
	user.visible_message(
		span_danger(attack_message),
		span_danger(attack_message),
		null,
		COMBAT_MESSAGE_RANGE,
		user
	)
	return TRUE


/mob/living/carbon/attack_drone(mob/living/simple_animal/drone/user)
	return //so we don't call the carbon's attack_hand().

//ATTACK HAND IGNORING PARENT RETURN VALUE
/mob/living/carbon/attack_hand(mob/living/carbon/human/user, list/modifiers)

	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		. = TRUE
	for(var/thing in diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			user.ContactContractDisease(D)

	for(var/thing in user.diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			ContactContractDisease(D)

	return . || FALSE


/mob/living/carbon/attack_paw(mob/living/carbon/human/user, list/modifiers)

	if(try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if((D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN) && prob(85))
				user.ContactContractDisease(D)

	for(var/thing in user.diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			ContactContractDisease(D)

	if(!user.combat_mode)
		help_shake_act(user)
		return FALSE

	if(..()) //successful monkey bite.
		for(var/thing in user.diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & (DISEASE_SPREAD_SPECIAL | DISEASE_SPREAD_NON_CONTAGIOUS))
				continue
			ForceContractDisease(D)
		return TRUE


/mob/living/carbon/attack_slime(mob/living/simple_animal/slime/M)
	if(..()) //successful slime attack
		if(M.powerlevel > 0)
			var/stunprob = M.powerlevel * 7 + 10  // 17 at level 1, 80 at level 10
			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				visible_message(span_danger("The [M.name] shocks [src]!"), \
				span_userdanger("The [M.name] shocks you!"))

				do_sparks(5, TRUE, src)
				var/power = M.powerlevel + rand(0,3)
				Paralyze(power * 2 SECONDS)
				set_timed_status_effect(power * 2 SECONDS, /datum/status_effect/speech/stutter, only_if_higher = TRUE)
				if (prob(stunprob) && M.powerlevel >= 8)
					adjustFireLoss(M.powerlevel * rand(6,10))
					updatehealth()
		return 1

/mob/living/carbon/proc/dismembering_strike(mob/living/attacker, dam_zone)
	if(!attacker.limb_destroyer)
		return dam_zone
	var/obj/item/bodypart/affecting
	if(dam_zone && attacker.client)
		affecting = get_bodypart(ran_zone(dam_zone))
	else
		var/list/things_to_ruin = shuffle(bodyparts.Copy())
		for(var/B in things_to_ruin)
			var/obj/item/bodypart/bodypart = B
			if(bodypart.body_zone == BODY_ZONE_HEAD || bodypart.body_zone == BODY_ZONE_CHEST)
				continue
			if(!affecting || ((affecting.get_damage() / affecting.max_damage) < (bodypart.get_damage() / bodypart.max_damage)))
				affecting = bodypart
	if(affecting)
		dam_zone = affecting.body_zone
		if(affecting.get_damage() >= affecting.max_damage)
			affecting.dismember()
			return null
		return affecting.body_zone
	return dam_zone

/**
 * Attempt to disarm the target mob.
 * Will shove the target mob back, and drop them if they're in front of something dense
 * or another carbon.
*/
/mob/living/carbon/proc/disarm(mob/living/carbon/target)
	///Consume stamina to disarm
	src.stamina_swing(STAMINA_DISARM_COST)

	do_attack_animation(target, ATTACK_EFFECT_DISARM)
	playsound(target, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)

	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.add_fingerprint_on_clothing_or_self(src, BODY_ZONE_CHEST)

	SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, src, zone_selected)

	var/list/holding = list(target.get_active_held_item() = 60, target.get_inactive_held_item() = 30)

	var/roll = stat_roll(11, STRENGTH, SKILL_MELEE_COMBAT, target.gurps_stats.get_skill(SKILL_MELEE_COMBAT))

	//Handle unintended consequences
	for(var/obj/item/I in holding)
		var/hurt_prob = holding[I]
		if(prob(hurt_prob) && I.on_disarm_attempt(target, src))
			return

	if(roll == CRIT_SUCCESS)
		var/shove_dir = get_dir(loc, target.loc)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)
		var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied

		var/directional_blocked = FALSE
		var/can_hit_something = !target.buckled

		//Are we hitting anything? or
		if(!target.Move(target_shove_turf, shove_dir))
			shove_blocked = TRUE

		if(!can_hit_something)
			//Don't hit people through windows, ok?
			if(!directional_blocked && SEND_SIGNAL(target_shove_turf, COMSIG_CARBON_DISARM_COLLIDE, src, target, shove_blocked) & COMSIG_CARBON_SHOVE_HANDLED)
				return

		target.Knockdown(SHOVE_KNOCKDOWN_SOLID)
		target.visible_message(
			span_danger("<b>[name]</b> shoves <b>[target.name]</b>, knocking [target.p_them()] down!"),
			span_userdanger("You're knocked down from a shove by [name]!"),
			span_hear("You hear aggressive shuffling followed by a loud thud!"),
			COMBAT_MESSAGE_RANGE,
		)
		log_combat(src, target, "shoved", "knocking them down")
		target.release_all_grabs()
		return

	if(target.IsKnockdown()) //KICK HIM IN THE NUTS //That is harm intent.
		target.apply_damage(STAMINA_DISARM_DMG * 4, STAMINA, BODY_ZONE_CHEST)
		target.visible_message(
			span_danger("<b>[name]</b> kicks <b>[target.name]</b> in [target.p_their()] chest, knocking the wind out of them!"),
			span_danger("<b>[name]</b> kicks <b>[target.name]</b> in [target.p_their()] chest, knocking the wind out of them!"),
			span_hear("You hear aggressive shuffling followed by a loud thud!"),
			COMBAT_MESSAGE_RANGE,
			//src
		)

		log_combat(src, target, "kicks", addition = "dealing stam/oxy damage")
		return

	target.visible_message(
		span_danger("<b>[name]</b> shoves <b>[target.name]</b>!"),
		null,
		span_hear("You hear aggressive shuffling!"),
		COMBAT_MESSAGE_RANGE,
	)

	var/append_message = ""

	if(roll >= SUCCESS && length(target.held_items))
		var/list/dropped = list()
		for(var/obj/item/I in target.held_items)
			if(target.dropItemToGround(I))
				target.visible_message(
					span_warning("<b>[target]</b> loses [target.p_their()] grip on [I]."),
					null,
					null,
					COMBAT_MESSAGE_RANGE
				)
				dropped += I
		append_message = "causing them to drop [length(dropped) ? english_list(dropped) : "nothing"]"

	log_combat(src, target, "shoved", addition = append_message)

/mob/living/carbon/proc/clear_shove_slowdown()
	remove_movespeed_modifier(/datum/movespeed_modifier/shove)
	var/active_item = get_active_held_item()
	if(is_type_in_typecache(active_item, GLOB.shove_disarming_types))
		visible_message(span_warning("[name] regains their grip on \the [active_item]!"), span_warning("You regain your grip on \the [active_item]"), null, COMBAT_MESSAGE_RANGE)

/mob/living/carbon/blob_act(obj/structure/blob/B)
	if (stat == DEAD)
		return
	else
		show_message(span_userdanger("The blob attacks!"))
		adjustBruteLoss(10)

/mob/living/carbon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/obj/item/organ/organ as anything in processing_organs)
		organ.emp_act(severity)

///Adds to the parent by also adding functionality to propagate shocks through pulling and doing some fluff effects.
/mob/living/carbon/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	. = ..()
	if(!.)
		return
	//Propagation through pulling, fireman carry
	if(!(flags & SHOCK_ILLUSION))
		if(undergoing_cardiac_arrest() && resuscitate())
			log_health(src, "Heart restarted due to elecrocution.")

		var/list/shocking_queue = list()
		shocking_queue += get_all_grabbed_movables()
		shocking_queue -= source

		if(iscarbon(buckled) && source != buckled)
			shocking_queue += buckled
		for(var/mob/living/carbon/carried in buckled_mobs)
			if(source != carried)
				shocking_queue += carried
		//Found our victims, now lets shock them all
		for(var/victim in shocking_queue)
			var/mob/living/carbon/C = victim
			C.electrocute_act(shock_damage*0.75, src, 1, flags)
	//Stun
	var/should_stun = (!(flags & SHOCK_TESLA) || siemens_coeff > 0.5) && !(flags & SHOCK_NOSTUN)
	if(should_stun)
		Paralyze(40)
	//Jitter and other fluff.
	do_jitter_animation(300)
	adjust_timed_status_effect(20 SECONDS, /datum/status_effect/jitter)
	adjust_timed_status_effect(4 SECONDS, /datum/status_effect/speech/stutter)
	addtimer(CALLBACK(src, PROC_REF(secondary_shock), should_stun), 2 SECONDS)
	return shock_damage

///Called slightly after electrocute act to apply a secondary stun.
/mob/living/carbon/proc/secondary_shock(should_stun)
	if(should_stun)
		Paralyze(60)

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/helper)
	if(on_fire)
		to_chat(helper, span_warning("You can't put [p_them()] out with just your bare hands!"))
		return

	if(SEND_SIGNAL(src, COMSIG_CARBON_PRE_HELP_ACT, helper) & COMPONENT_BLOCK_HELP_ACT)
		return

	if(helper == src)
		check_self_for_injuries()
		return

	if(body_position == LYING_DOWN)
		if(buckled)
			to_chat(helper, span_warning("You need to unbuckle [src] first to do that!"))
			return
		helper.visible_message(span_notice("[helper] shakes [src] trying to get [p_them()] up!"), \
						null, span_hear("You hear the rustling of clothes."), DEFAULT_MESSAGE_RANGE, list(helper, src))
		to_chat(helper, span_notice("You shake [src] trying to pick [p_them()] up!"))
		to_chat(src, span_notice("[helper] shakes you to get you up!"))
	else if(deprecise_zone(helper.zone_selected) == BODY_ZONE_HEAD && get_bodypart(BODY_ZONE_HEAD)) //Headpats!
		helper.visible_message(span_notice("[helper] gives [src] a pat on the head to make [p_them()] feel better!"), \
					null, span_hear("You hear a soft patter."), DEFAULT_MESSAGE_RANGE, list(helper, src))
		to_chat(helper, span_notice("You give [src] a pat on the head to make [p_them()] feel better!"))
		to_chat(src, span_notice("[helper] gives you a pat on the head to make you feel better! "))

		if(HAS_TRAIT(src, TRAIT_BADTOUCH))
			to_chat(helper, span_warning("[src] looks visibly upset as you pat [p_them()] on the head."))

	else if ((helper.zone_selected == BODY_ZONE_PRECISE_GROIN) && !isnull(src.getorgan(/obj/item/organ/tail)))
		helper.visible_message(span_notice("[helper] pulls on [src]'s tail!"), \
					null, span_hear("You hear a soft patter."), DEFAULT_MESSAGE_RANGE, list(helper, src))
		to_chat(helper, span_notice("You pull on [src]'s tail!"))
		to_chat(src, span_notice("[helper] pulls on your tail!"))
		if(HAS_TRAIT(src, TRAIT_BADTOUCH)) //How dare they!
			to_chat(helper, span_warning("[src] makes a grumbling noise as you pull on [p_their()] tail."))

	else
		helper.visible_message(span_notice("[helper] hugs [src] to make [p_them()] feel better!"), \
					null, span_hear("You hear the rustling of clothes."), DEFAULT_MESSAGE_RANGE, list(helper, src))
		to_chat(helper, span_notice("You hug [src] to make [p_them()] feel better!"))
		to_chat(src, span_notice("[helper] hugs you to make you feel better!"))

		// Warm them up with hugs
		share_bodytemperature(helper)

		// Let people know if they hugged someone really warm or really cold
		if(helper.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
			to_chat(src, span_warning("It feels like [helper] is over heating as [helper.p_they()] hug[helper.p_s()] you."))
		else if(helper.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
			to_chat(src, span_warning("It feels like [helper] is freezing as [helper.p_they()] hug[helper.p_s()] you."))

		if(bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
			to_chat(helper, span_warning("It feels like [src] is over heating as you hug [p_them()]."))
		else if(bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
			to_chat(helper, span_warning("It feels like [src] is freezing as you hug [p_them()]."))

		if(HAS_TRAIT(src, TRAIT_BADTOUCH))
			to_chat(helper, span_warning("[src] looks visibly upset as you hug [p_them()]."))

	SEND_SIGNAL(src, COMSIG_CARBON_HELP_ACT, helper)
	SEND_SIGNAL(helper, COMSIG_CARBON_HELPED, src)

	adjust_status_effects_on_shake_up()
	set_resting(FALSE)
	if(body_position != STANDING_UP && !resting && !buckled && !HAS_TRAIT(src, TRAIT_FLOORED))
		get_up(TRUE)

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)

	// Shake animation
	if (incapacitated())
		var/direction = prob(50) ? -1 : 1
		animate(src, pixel_x = pixel_x + SHAKE_ANIMATION_OFFSET * direction, time = 1, easing = QUAD_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)
		animate(pixel_x = pixel_x - (SHAKE_ANIMATION_OFFSET * 2 * direction), time = 1)
		animate(pixel_x = pixel_x + SHAKE_ANIMATION_OFFSET * direction, time = 1, easing = QUAD_EASING | EASE_IN)

/// Check ourselves to see if we've got any shrapnel, return true if we do. This is a much simpler version of what humans do, we only indicate we're checking ourselves if there's actually shrapnel
/mob/living/carbon/proc/check_self_for_injuries()
	if(stat >= UNCONSCIOUS)
		return

	var/embeds = FALSE
	for(var/X in bodyparts)
		var/obj/item/bodypart/LB = X
		for(var/obj/item/I in LB.embedded_objects)
			if(!embeds)
				embeds = TRUE
				// this way, we only visibly try to examine ourselves if we have something embedded, otherwise we'll still hug ourselves :)
				visible_message(span_notice("[src] examines [p_them()]self."), \
					span_notice("You check yourself for shrapnel."))
			if(I.isEmbedHarmless())
				to_chat(src, "\t <a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] stuck to your [LB.name]!</a>")
			else
				to_chat(src, "\t <a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] embedded in your [LB.name]!</a>")

	return embeds


/mob/living/carbon/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash, length = 25)
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(!eyes) //can't flash what can't see!
		return

	. = ..()

	var/damage = intensity - get_eye_protection()
	if(.) // we've been flashed
		if(visual)
			return

		if (damage == 1)
			to_chat(src, span_warning("Your eyes sting a little."))
			if(prob(40))
				eyes.applyOrganDamage(1)

		else if (damage == 2)
			to_chat(src, span_warning("Your eyes burn."))
			eyes.applyOrganDamage(rand(4, 6))

		else if( damage >= 3)
			to_chat(src, span_warning("Your eyes itch and burn severely!"))
			eyes.applyOrganDamage(rand(12, 16))

		if(eyes.damage > 10)
			blind_eyes(damage)
			blur_eyes(damage * rand(3, 6))

			if(eyes.damage > 20)
				if(prob(eyes.damage - 20))
					if(!HAS_TRAIT(src, TRAIT_NEARSIGHT))
						to_chat(src, span_warning("Your eyes start to burn badly!"))
					become_nearsighted(EYE_DAMAGE)

				else if(prob(eyes.damage - 25))
					if(!is_blind())
						to_chat(src, span_warning("You can't see anything!"))
					eyes.applyOrganDamage(eyes.maxHealth)

			else
				to_chat(src, span_warning("Your eyes are really starting to hurt. This can't be good for you!"))
		return 1
	else if(damage == 0) // just enough protection
		if(prob(20))
			to_chat(src, span_notice("Something bright flashes in the corner of your vision!"))


/mob/living/carbon/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	var/list/reflist = list(intensity) // Need to wrap this in a list so we can pass a reference
	SEND_SIGNAL(src, COMSIG_CARBON_SOUNDBANG, reflist)
	intensity = reflist[1]
	var/ear_safety = get_ear_protection()
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	var/effect_amount = intensity - ear_safety
	if(effect_amount > 0)
		if(stun_pwr)
			Paralyze((stun_pwr*effect_amount)*0.1)
			Knockdown(stun_pwr*effect_amount)

		if(ears && (deafen_pwr || damage_pwr))
			var/ear_damage = damage_pwr * effect_amount
			var/deaf = deafen_pwr * effect_amount
			ears.adjustEarDamage(ear_damage,deaf)

			if(ears.damage >= 15)
				to_chat(src, span_warning("Your ears start to ring badly!"))
				if(prob(ears.damage - 5))
					to_chat(src, span_userdanger("You can't hear anything!"))
					// Makes you deaf, enough that you need a proper source of healing, it won't self heal
					// you need earmuffs, inacusiate, or replacement
					ears.setOrganDamage(ears.maxHealth)
			else if(ears.damage >= 5)
				to_chat(src, span_warning("Your ears start to ring!"))
			SEND_SOUND(src, sound('sound/weapons/flash_ring.ogg',0,1,0,250))
		return effect_amount //how soundbanged we are


/mob/living/carbon/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5 //0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		var/obj/item/clothing/hit_clothes
		if(wear_mask)
			hit_clothes = wear_mask
		if(wear_neck)
			hit_clothes = wear_neck
		if(head)
			hit_clothes = head
		if(hit_clothes)
			hit_clothes.take_damage(damage_amount, damage_type, damage_flag, 0)

/mob/living/carbon/can_hear(ignore_stat)
	. = FALSE
	var/has_deaf_trait = ignore_stat ? HAS_TRAIT_NOT_FROM(src, TRAIT_DEAF, STAT_TRAIT) : HAS_TRAIT(src, TRAIT_DEAF)

	if(HAS_TRAIT(src, TRAIT_NOEARS) && !has_deaf_trait)
		return TRUE

	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	if(ears && !has_deaf_trait)
		. = TRUE

/mob/living/carbon/proc/get_interaction_efficiency(zone)
	var/obj/item/bodypart/limb = get_bodypart(zone)
	if(!limb)
		return

/mob/living/carbon/get_organic_health()
	. = health
	for (var/_limb in bodyparts)
		var/obj/item/bodypart/limb = _limb
		if (!IS_ORGANIC_LIMB(limb))
			. += (limb.brute_dam) + (limb.burn_dam)
