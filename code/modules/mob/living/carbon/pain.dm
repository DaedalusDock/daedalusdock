/mob/living
	var/list/pain_cooldowns = list()

/mob/living/carbon
	/// Traumatic Shock, an integer that increases every life tick according to how much pain the mob is in.
	var/traumatic_shock_stage

/mob/living/carbon/getPain()
	. = 0
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		. += BP.getPain()

	. -= CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)

	return round(max(0, .), 1)

/mob/living/carbon/adjustPain(amount, updating_health = TRUE)
	if(((status_flags & GODMODE)))
		return FALSE
	return apply_pain(amount, updating_health = updating_health)

/mob/living/proc/flash_pain(severity = PAIN_SMALL)
	return

/mob/living/carbon/flash_pain(severity = PAIN_SMALL)
	if(!client || client.prefs?.read_preference(/datum/preference/toggle/disable_pain_flash))
		return

	flick(severity, hud_used?.screen_objects[HUDKEY_MOB_PAIN])

/mob/living/carbon/apply_pain(amount, def_zone, message, ignore_cd, updating_health = TRUE)
	if((status_flags & GODMODE) || HAS_TRAIT(src, TRAIT_NO_PAINSHOCK))
		return FALSE

	if(amount == 0)
		return

	if(amount > 0)
		amount -= CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3
		if(amount <= 0)
			return

	var/is_healing = amount < 0
	var/obj/item/bodypart/BP

	if(!def_zone) // Distribute to all bodyparts evenly if no bodypart
		var/list/not_full = bodyparts.Copy()
		var/list/parts = not_full.Copy()
		var/sign = is_healing ? -1 : 1
		var/amount_to_apply = round(abs(amount)/2, DAMAGE_PRECISION)
		var/amount_remaining = amount_to_apply
		while(amount_remaining > 0 && length(not_full))
			if(!length(parts))
				parts += not_full

			var/pain_per_part = round(amount_remaining/length(parts), DAMAGE_PRECISION)
			BP = pick(parts)
			parts -= BP

			var/used = BP.adjustPain(pain_per_part * sign)
			if(!used)
				not_full -= BP
				continue

			amount_remaining -= abs(used)
		. = (amount_to_apply - amount_remaining) * sign
	else
		if(isbodypart(def_zone))
			BP = def_zone

		BP ||= get_bodypart(def_zone, TRUE)
		if(!BP)
			return

		. = BP.adjustPain(amount)


	if(. && !is_healing)
		notify_pain(amount, message, ignore_cd)

	if(updating_health && .)
		update_health_hud()

/// Flashes the pain overlay and provides a chat message.
/mob/living/carbon/proc/notify_pain(amount, message, ignore_cd)
	if(stat != CONSCIOUS)
		return

	var/class = pain_class(amount)
	switch(class)
		if(PAIN_CLASS_AGONIZING)
			flash_pain(PAIN_LARGE)
			shake_camera(src, 3, 4)
		if(PAIN_CLASS_MEDIUM)
			flash_pain(PAIN_MEDIUM)
			shake_camera(src, 1, 2)
		if(PAIN_CLASS_LOW)
			flash_pain(PAIN_SMALL)

	if(message)
		pain_message(message, amount, ignore_cd)

/mob/living/carbon/proc/pain_message(message, amount, ignore_cd)
	set waitfor = FALSE
	if(amount <= 0 || (stat != CONSCIOUS) || HAS_TRAIT(src, TRAIT_FAKEDEATH))
		return FALSE

	var/pain_class = pain_class(amount)
	var/cooldown_class = "[pain_class]-nonlife"
	. = COOLDOWN_FINISHED(src, pain_cooldowns[cooldown_class])
	if(!ignore_cd && !.)
		return FALSE

	if(message)
		switch(pain_class)
			if(PAIN_CLASS_AGONIZING)
				to_chat(src, span_danger(span_big(message)))
			if(PAIN_CLASS_MEDIUM)
				to_chat(src, span_danger(message))
			if(PAIN_CLASS_LOW)
				to_chat(src, span_danger(message))
			else
				to_chat(src, span_warning(message))

	if(.)
		switch(pain_class)
			if(PAIN_CLASS_AGONIZING)
				COOLDOWN_START(src, pain_cooldowns[cooldown_class], 20 SECONDS)
			if(PAIN_CLASS_MEDIUM)
				COOLDOWN_START(src, pain_cooldowns[cooldown_class], 40 SECONDS)
			if(PAIN_CLASS_LOW)
				COOLDOWN_START(src, pain_cooldowns[cooldown_class], 60 SECONDS)
			else
				COOLDOWN_START(src, pain_cooldowns[cooldown_class], 120 SECONDS)

	return TRUE

/mob/living/carbon/human/pain_message(message, amount, ignore_cd)
	. = ..()
	if(!.)
		return

	var/probability = 0

	switch(pain_class(amount))
		if(PAIN_CLASS_AGONIZING)
			probability = 100
		if(PAIN_CLASS_MEDIUM)
			probability = 70

	if(prob(probability))
		pain_emote(amount)

/// Perform a pain response emote, amount is the amount of pain they are in. See pain defines for easy numbers.
/mob/living/carbon/proc/pain_emote(amount = PAIN_AMT_LOW, bypass_cd)
	if(!COOLDOWN_FINISHED(src, pain_cooldowns["emote"]) && !bypass_cd)
		return

	var/emote = dna.species.get_pain_emote(amount)
	if(!emote)
		return

	COOLDOWN_START(src, pain_cooldowns["emote"], 15 SECONDS)
	if(findtext(emote, "me ", 1, 4))
		manual_emote(copytext(emote, 4))
	else
		emote(emote)

#define SHOCK_STRING_MINOR \
	pick("It hurts...",\
		"Uaaaghhhh...",\
		"Agh..."\
	)

#define SHOCK_STRING_MAJOR \
	pick("The pain is excruciating!",\
		"Please, just end the pain!",\
		"I can't feel anything!"\
	)

/mob/living/carbon/proc/handle_shock(delta_time)
	if(status_flags & GODMODE)
		return

	if(HAS_TRAIT(src, TRAIT_FAKEDEATH))
		return

	if(HAS_TRAIT(src, TRAIT_NO_PAINSHOCK))
		traumatic_shock_stage = 0
		return

	// If our heart has stopped, INSTANTLY enter shock tier 4
	var/heart_attack_gaming = undergoing_cardiac_arrest()
	if(heart_attack_gaming)
		traumatic_shock_stage = max(traumatic_shock_stage + 1, SHOCK_TIER_4 + 1)

	var/pain = getPain()
	var/overall_pain_class = pain_class(pain)

	var/previous_traumatic_shock_stage = traumatic_shock_stage
	var/went_up_in_stage = FALSE

	// Pain mood adjustment
	switch(overall_pain_class)
		if(PAIN_CLASS_AGONIZING)
			mob_mood.add_mood_event("pain", /datum/mood_event/pain_four)
		if(PAIN_CLASS_MEDIUM)
			mob_mood.add_mood_event("pain", /datum/mood_event/pain_three)
		if(PAIN_CLASS_LOW)
			mob_mood.add_mood_event("pain", /datum/mood_event/pain_two)
		if(PAIN_CLASS_NEGLIGIBLE)
			mob_mood.add_mood_event("pain", /datum/mood_event/pain_one)
		if(PAIN_CLASS_NONE)
			mob_mood.clear_mood_event("pain")

	if(pain >= max(SHOCK_MIN_PAIN_TO_BEGIN, traumatic_shock_stage * 0.8))
		// A chance to fight through the pain.
		if((traumatic_shock_stage >= SHOCK_TIER_3) && stat == CONSCIOUS && !heart_attack_gaming && stats.cooldown_finished("shrug_off_pain"))
			var/datum/roll_result/result = stat_roll(12, /datum/rpg_skill/knuckle_down)
			switch(result.outcome)
				if(CRIT_SUCCESS)
					to_chat(src, result.create_tooltip("You won't give in now. Stay in the fight."))
					traumatic_shock_stage = max(traumatic_shock_stage - 15, 0)
					stats.set_cooldown("shrug_off_pain", 180 SECONDS)
					return

				if(SUCCESS)
					traumatic_shock_stage = max(traumatic_shock_stage - 5, 0)
					to_chat(src, result.create_tooltip("Not here, not now."))
					stats.set_cooldown("shrug_off_pain", 180 SECONDS)
					return

				if(FAILURE)
					stats.set_cooldown("shrug_off_pain", 30 SECONDS)
					// Do not return

				if(CRIT_FAILURE)
					traumatic_shock_stage = min(traumatic_shock_stage + 1, SHOCK_MAXIMUM)
					to_chat(src, result.create_tooltip("I'm going to die here."))
					stats.set_cooldown("shrug_off_pain", 60 SECONDS)
					// Do not return

		if(traumatic_shock_stage == 0)
			throw_alert("traumatic shock", /atom/movable/screen/alert/shock)
		traumatic_shock_stage = min(traumatic_shock_stage + 1, SHOCK_MAXIMUM)
		went_up_in_stage = traumatic_shock_stage > previous_traumatic_shock_stage

	else if(!heart_attack_gaming)
		traumatic_shock_stage = min(traumatic_shock_stage, SHOCK_MAXIMUM)
		var/recovery = 2
		if(pain < 0.25 * traumatic_shock_stage)
			recovery = 4
		else if(pain < 0.5 * traumatic_shock_stage)
			recovery = 3

		// ~25% chance at base to recover twice as fast..
		if(stat_roll(13, /datum/rpg_skill/knuckle_down).outcome >= SUCCESS)
			recovery *= 2

		traumatic_shock_stage = max(traumatic_shock_stage - recovery, 0)
		if(traumatic_shock_stage == 0)
			clear_alert("traumatic shock")
		return

	if(stat)
		return

	var/message = ""
	// Handle only-on-entering effects.
	if(went_up_in_stage)
		switch(traumatic_shock_stage)
			if(SHOCK_TIER_1)
				message = SHOCK_STRING_MINOR

			if(SHOCK_TIER_2)
				message = SHOCK_STRING_MINOR
				if(stat == CONSCIOUS && getorganslot(ORGAN_SLOT_EYES))
					manual_emote("is having trouble keeping [p_their()] eyes open.")

			if(SHOCK_TIER_3)
				message = SHOCK_STRING_MINOR

			if(SHOCK_TIER_4)
				message = SHOCK_STRING_MAJOR
				if(body_position == STANDING_UP && stat == CONSCIOUS && !buckled)
					manual_emote("stumbles over [p_them()]self.")

			if(SHOCK_TIER_5)
				if(!HAS_TRAIT(src, TRAIT_NOBREATH))
					message = "I cannot breathe!"
					losebreath_gasp()

	// Shock 1: Only has a message.

	// Shock 2: 1% chance (per second) to get 10 seconds of blur + stutter. The first time this occurs, an emote will occur.
	// Shock 2 additionally causes a faster heartrate. See heart.dm
	if(traumatic_shock_stage >= SHOCK_TIER_2 && ((traumatic_shock_stage == SHOCK_TIER_2 && went_up_in_stage) || DT_PROB(1, delta_time)))
		blur_eyes(5)
		set_timed_status_effect(10 SECONDS, /datum/status_effect/speech/stutter, only_if_higher = TRUE)

	// Shock 3: 10% chance (per second) for 5 seconds of stuttering.
	if(traumatic_shock_stage >= SHOCK_TIER_3 && ((traumatic_shock_stage == SHOCK_TIER_3 && went_up_in_stage) || DT_PROB(10, delta_time)))
		set_timed_status_effect(5 SECONDS, /datum/status_effect/speech/stutter, only_if_higher = TRUE)

	// Shocks 4 only occurs whilst standing.
	if(body_position == STANDING_UP && stat == CONSCIOUS && !buckled)
		// Shock 4: 5% chance (per second) to stumble, 100% if just entered.
		if(traumatic_shock_stage >= SHOCK_TIER_4 && ((traumatic_shock_stage == SHOCK_TIER_4 && went_up_in_stage) || DT_PROB(5, delta_time)))
			Knockdown(2 SECONDS)

	// Shock 5: 8% chance (per second) to miss a breath.
	// Shock 5 additionally causes a faster heartrate. See heart.dm
	// The math on this one gets really weird really quickly. Carbons breathe every 4 life ticks (8 seconds).
	// So every 1 missed breath has an "impact" of 8 seconds. Except not really, because in the event of a missed breath,
	// a mob will breathe instantly the neck life tick. So losebreath is decremented every 2 seconds, not every 8 seconds.
	if(!HAS_TRAIT(src, TRAIT_NOBREATH) && traumatic_shock_stage >= SHOCK_TIER_5 && ((traumatic_shock_stage == SHOCK_TIER_5 && went_up_in_stage) || DT_PROB(8, delta_time)))
		if(losebreath < 2) // We don't want this stacking ON TOP OF the asystole death spiral.
			losebreath++

	// Shock 6: 1% chance (per second) to black out for 10 seconds (if conscious), 100% if just entered.
	if(stat == CONSCIOUS && traumatic_shock_stage >= SHOCK_TIER_6 && ((traumatic_shock_stage == SHOCK_TIER_6 && went_up_in_stage) || DT_PROB(1, delta_time)))
		pain_message("You black out.", traumatic_shock_stage - CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3, TRUE)
		Unconscious(10 SECONDS)
		return // We'll be generous

	// Shock 7: Permanently unconscious.
	if(traumatic_shock_stage >= SHOCK_TIER_7)
		if(went_up_in_stage)
			visible_message("<b>[src]</b> falls limp.")
		Unconscious(20 SECONDS)

	if(message)
		pain_message(message, traumatic_shock_stage - CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3, TRUE)

#undef SHOCK_STRING_MINOR
#undef SHOCK_STRING_MAJOR

/mob/living/carbon/proc/handle_pain(delta_time)
	if(stat == DEAD)
		return

	var/pain = getPain()
	var/painkiller = CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)
	/// Brain health scales the pain passout modifier with an importance of 80%
	var/brain_health_factor = 1 + ((maxHealth - getBrainLoss()) / maxHealth - 1) * 0.8
	/// Blood circulation scales the pain passout modifier with an importance of 40%
	var/blood_circulation_factor = 1 + (get_blood_circulation() / 100 - 1) * 0.4

	var/pain_passout = min(PAIN_AMT_PASSOUT * brain_health_factor * blood_circulation_factor, PAIN_AMT_PASSOUT)

	if(pain > max((pain_passout * 0.075), 10))
		var/slowdown = min(pain * (PAIN_MAX_SLOWDOWN / pain_passout), PAIN_MAX_SLOWDOWN)
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/pain, TRUE, slowdown)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/pain)

	if(pain >= pain_passout)
		if(!stat && !HAS_TRAIT(src, TRAIT_FAKEDEATH))
			visible_message(
				span_danger("<b>[src]</b> slumps over, too weak to continue fighting..."),
				span_danger("You give into the pain.")
			)
			log_health(src, "Passed out due to excessive pain: [pain] | Threshold: [pain_passout]")
		Unconscious(10 SECONDS)
		return

	if(stat != CONSCIOUS)
		return

	var/highest_bp_pain = 0
	var/obj/item/bodypart/damaged_part
	for(var/obj/item/bodypart/loop as anything in bodyparts)
		if(loop.bodypart_flags & BP_NO_PAIN)
			continue

		var/bp_pain = loop.getPain()
		if(bp_pain > highest_bp_pain || (highest_bp_pain == bp_pain && prob(50)))
			damaged_part = loop
			highest_bp_pain = bp_pain

	if(damaged_part && painkiller < highest_bp_pain)
		if(highest_bp_pain > PAIN_THRESHOLD_REDUCE_SLEEP)
			AdjustSleeping(-(highest_bp_pain / 5) SECONDS)

		if(highest_bp_pain > PAIN_THRESHOLD_DROP_ITEM && COOLDOWN_FINISHED(src, pain_cooldowns["drop_item"]))
			pain_drop_item(highest_bp_pain)

		var/burning = damaged_part.burn_dam > damaged_part.brute_dam
		var/msg
		var/highest_bp_pain_class = pain_class(highest_bp_pain)

		if(COOLDOWN_FINISHED(src, pain_cooldowns[highest_bp_pain_class]))
			switch(highest_bp_pain_class)
				if(PAIN_CLASS_AGONIZING)
					COOLDOWN_START(src, pain_cooldowns[highest_bp_pain_class], 20 SECONDS)
					msg = "OH GOD! Your [damaged_part.plaintext_zone] is [burning ? "on fire" : "hurting terribly"]!"

				if(PAIN_CLASS_MEDIUM)
					COOLDOWN_START(src, pain_cooldowns[highest_bp_pain_class], 40 SECONDS)
					msg = "Your [damaged_part.plaintext_zone] [burning ? "burns" : "hurts"] badly."

				if(PAIN_CLASS_LOW)
					msg = "Your [damaged_part.plaintext_zone] [burning ? "burns" : "hurts"]."
					COOLDOWN_START(src, pain_cooldowns[highest_bp_pain_class], 60 SECONDS)

			if(msg)
				notify_pain(highest_bp_pain, msg, TRUE)


	// Damage to internal organs hurts a lot.
	var/list/organ_pain_zones
	for(var/obj/item/organ/I as anything in organs)
		if(istype(I, /obj/item/organ/brain))
			continue

		if(!I.is_causing_pain())
			continue

		var/obj/item/bodypart/parent = I.ownerlimb
		if(!parent || (parent.bodypart_flags & BP_NO_PAIN))
			continue

		LAZYINITLIST(organ_pain_zones)

		if(I.damage > (I.high_threshold * I.maxHealth))
			organ_pain_zones[parent] += 40
		else if(I.damage > (I.low_threshold * I.maxHealth))
			organ_pain_zones[parent] += 25
		else
			organ_pain_zones[parent] += 10


	for(var/obj/item/bodypart/painful_part as anything in organ_pain_zones)
		var/organ_pain_applied = organ_pain_zones[painful_part]
		var/message
		switch(organ_pain_applied)
			if(0 to 10)
				message = "You feel a dull pain in your [painful_part.plaintext_zone]"
			if(11 to 44)
				message = "You feel a pain in your [painful_part.plaintext_zone]"
			else
				message = "You feel a sharp pain in your [painful_part.plaintext_zone]"

		apply_pain(organ_pain_applied, painful_part, message, TRUE, updating_health = FALSE)

	if(prob(1))
		var/systemic_organ_failure = getToxLoss()
		switch(systemic_organ_failure)
			if(5 to 17)
				pain_message("Your body stings slightly.", 1, TRUE)
			if(17 to 35)
				pain_message("Your body stings.", PAIN_AMT_LOW, TRUE)
			if(35 to 60)
				pain_message("Your body stings strongly.", PAIN_AMT_MEDIUM, TRUE)
			if(60 to 100)
				pain_message("Your whole body hurts badly.", PAIN_AMT_MEDIUM, TRUE)
			if(100 to INFINITY)
				pain_message("Your body aches all over, it's driving you mad.", PAIN_AMT_AGONIZING, TRUE)

	update_health_hud()

/// Called by handle_pain() to consider dropping an item based on Willpower.
/mob/living/carbon/proc/pain_drop_item(pain_amt)
	// For every 30 points of pain above the threshold, the roll is modified by -1
	var/roll_modifier = floor(max(0, pain_amt - PAIN_THRESHOLD_DROP_ITEM) / -50)
	/// ~17% chance to fail baseline.
	var/datum/roll_result/result = stat_roll(8, /datum/rpg_skill/knuckle_down, roll_modifier)

	var/obj/item/held_item = get_active_held_item()

	switch(result.outcome)
		if(CRIT_FAILURE)
			COOLDOWN_START(src, pain_cooldowns["drop_item"], 20 SECONDS)
			if(!length(held_items))
				return

			result.do_skill_sound(src)
			to_chat(src, result.create_tooltip("A streak of pain shoots throughout your whole body."))
			drop_all_held_items()
			visible_message(span_warning("<b>[src]</b>'s body spasms, and [p_they()] drop[p_s()] what [p_they()] [p_were()] holding."), ignored_mobs = list(src))

		if(FAILURE)
			COOLDOWN_START(src, pain_cooldowns["drop_item"], 20 SECONDS)
			if(!held_item || !dropItemToGround(held_item))
				return

			result.do_skill_sound(src)
			var/side = IS_RIGHT_INDEX(active_hand_index) ? "right" : "left"
			to_chat(src, result.create_tooltip("A bolt of pain shoots through your [side] hand."))
			visible_message(span_warning("<b>[src]</b>'s [side] arm twitches, dropping [held_item]."), ignored_mobs = list(src))

		if(SUCCESS)
			COOLDOWN_START(src, pain_cooldowns["drop_item"], 20 SECONDS)

		if(CRIT_SUCCESS)
			COOLDOWN_START(src, pain_cooldowns["drop_item"], 120 SECONDS)
			if(!held_item)
				return

			result.do_skill_sound(src)
			to_chat(src, result.create_tooltip("Hold on. Grip your [held_item.name] tightly."))

/// Converts a pain value to a "class" of pain.
/proc/pain_class(pain_amt)
	switch(ceil(pain_amt))
		if(0)
			return PAIN_CLASS_NONE

		if(1 to PAIN_AMT_LOW-1)
			return PAIN_CLASS_NEGLIGIBLE

		if(PAIN_AMT_LOW to PAIN_AMT_MEDIUM-1)
			return PAIN_CLASS_LOW

		if(PAIN_AMT_MEDIUM to PAIN_AMT_AGONIZING-1)
			return PAIN_CLASS_MEDIUM

		if(PAIN_AMT_AGONIZING to INFINITY)
			return PAIN_CLASS_AGONIZING
