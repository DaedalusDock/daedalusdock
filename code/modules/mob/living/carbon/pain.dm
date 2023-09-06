/mob/living
	COOLDOWN_DECLARE(pain_cd)

/mob/living/carbon/var/shock_stage

/mob/living/carbon/getPain()
	. = 0
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		. += BP.getPain()

	. -= CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)

	if(stat == UNCONSCIOUS)
		. *= 0.6

	return max(0, .)

/mob/living/carbon/adjustPain(amount, updating_health = TRUE)
	if(((status_flags & GODMODE)))
		return FALSE
	return apply_pain(amount, updating_health = updating_health)

/mob/living/carbon/apply_pain(amount, def_zone, message, ignore_cd, updating_health = TRUE)
	if((status_flags & GODMODE))
		return FALSE

	amount -= CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3
	if(amount <= 0)
		return

	var/obj/item/bodypart/BP
	if(!def_zone) // Distribute to all bodyparts evenly if no bodypart
		var/list/not_full = bodyparts.Copy()
		var/list/parts = not_full.Copy()
		var/amount_remaining = round(amount/2)
		while(amount_remaining > 0 && length(not_full))
			if(!length(parts))
				parts += not_full

			var/pain_per_part = round(amount_remaining/length(parts), DAMAGE_PRECISION)
			BP = pick(parts)
			parts -= BP

			var/used = BP.adjustPain(pain_per_part)
			if(!used)
				not_full -= BP
				continue

			amount_remaining -= abs(used)
			. = TRUE
	else
		BP = get_bodypart(def_zone, TRUE)
		if(!BP)
			return
		. = BP.adjustPain(amount)


	if((amount > 0))
		flash_pain(min(round(8*amount)+55, 255))
		pain_message(message, amount, ignore_cd)

	if(updating_health && .)
		updatehealth()

/mob/proc/flash_pain(target)
	if(hud_used?.pain)
		animate(hud_used.pain, alpha = target, time = 15, easing = ELASTIC_EASING)
		animate(hud_used.pain = 0, time = 20)

/mob/living/carbon/proc/pain_message(message, amount, ignore_cd)
	set waitfor = FALSE
	if(!amount)
		return FALSE

	. = COOLDOWN_FINISHED(src, pain_cd)
	if(!ignore_cd && !.)
		return FALSE

	if(message)
		switch(amount)
			if(70 to INFINITY)
				to_chat(src, span_danger(span_big(message)))
			if(40 to 70)
				to_chat(src, span_danger(message))
			if(10 to 40)
				to_chat(src, span_danger(message))
			else
				to_chat(src, span_warning(message))

	if(.)
		COOLDOWN_START(src, pain_cd, 15 SECONDS - amount)

	return TRUE

/mob/living/carbon/human/pain_message(message, amount, ignore_cd)
	. = ..()
	if(!.)
		return
	var/emote = dna.species.get_pain_emote(amount)
	if(emote && prob(amount))
		emote(emote)

#define PAIN_STRING \
	pick("The pain is excruciating!",\
		"Please, just end the pain!",\
		"Your whole body is going numb!"\
	)

/mob/living/carbon/proc/handle_shock()
	if(status_flags & GODMODE)
		return

	if(HAS_TRAIT(src, TRAIT_FAKEDEATH))
		return

	var/heart_attack_gaming = undergoing_cardiac_arrest()
	if(heart_attack_gaming)
		shock_stage = max(shock_stage + 1, SHOCK_TIER_4 + 1)

	var/pain = getPain()
	if(pain >= max(SHOCK_MIN_PAIN_TO_BEGIN, shock_stage * 0.8))
		shock_stage = min(shock_stage + 1, SHOCK_MAXIMUM)

	else if(!heart_attack_gaming)
		shock_stage = min(shock_stage, SHOCK_MAXIMUM)
		var/recovery = 1
		if(pain < 0.5 * shock_stage)
			recovery = 3
		else if(pain < 0.25 * shock_stage)
			recovery = 2

		shock_stage = max(shock_stage - recovery, 0)
		return

	if(stat)
		return

	if(shock_stage == SHOCK_TIER_1)
		pain_message(PAIN_STRING, 10 - CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3)

	if(shock_stage >= SHOCK_TIER_2)
		if(shock_stage == SHOCK_TIER_2 && organs_by_slot[ORGAN_SLOT_EYES])
			visible_message("<b>[src]</b> is having trouble keeping [p_their()] eyes open.")
		if(prob(30))
			blur_eyes(3)
			set_timed_status_effect(10 SECONDS, /datum/status_effect/speech/stutter, only_if_higher = TRUE)

	if(shock_stage == SHOCK_TIER_3)
		pain_message(PAIN_STRING, shock_stage - CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3)

	if(shock_stage >= SHOCK_TIER_4 && prob(2))
		pain_message(PAIN_STRING, shock_stage - CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3)
		Knockdown(2 SECONDS)

	if(shock_stage >= SHOCK_TIER_5 && prob(5))
		pain_message(PAIN_STRING, shock_stage - CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3)
		Knockdown(2 SECONDS)

	if(shock_stage >= SHOCK_TIER_6)
		if (prob(2))
			pain_message(pick("You black out!", "You feel like you could die any moment now!", "You're about to lose consciousness!"), shock_stage - CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3)
			Unconscious(10 SECONDS)

	if(shock_stage >= SHOCK_TIER_7)
		if(shock_stage == SHOCK_TIER_7)
			visible_message("<b>[src]</b> falls limp!")
		Knockdown(40 SECONDS)

#undef PAIN_STRING

/mob/living/carbon/proc/handle_pain()
	if(stat)
		return

	if(!(life_ticks % 5) && getPain() >= maxHealth)
		if(HAS_TRAIT(src, TRAIT_FAKEDEATH))
			return
		else
			visible_message(
				"<b>[src]</b> slumps over, too weak to continue fighting...",
				span_warning("The pain is too severe for you to keep going...")
			)
		Sleeping(10 SECONDS)
		return

	if(!COOLDOWN_FINISHED(src, pain_cd) && !prob(5))
		return

	var/highest_damage
	var/obj/item/bodypart/damaged_part
	for(var/obj/item/bodypart/loop as anything in bodyparts)
		if(loop.bodypart_flags & BP_NO_PAIN)
			continue

		var/dam = loop.get_damage()
		if(dam && dam > highest_damage && (highest_damage == 0 || prob(70)))
			damaged_part = loop
			highest_damage = dam

	if(damaged_part && CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER) < highest_damage)
		if(highest_damage > PAIN_THRESHOLD_REDUCE_PARALYSIS)
			AdjustSleeping(-(highest_damage / 5) SECONDS)
		if(highest_damage > PAIN_THRESHOLD_DROP_ITEM && prob(highest_damage / 5))
			dropItemToGround(get_active_held_item())

		var/burning = damaged_part.burn_dam > damaged_part.brute_dam
		var/msg
		switch(highest_damage)
			if(1 to 25)
				msg =  "Your [damaged_part.plaintext_zone] [burning ? "burns" : "hurts"]."
			if(25 to 90)
				msg = "Your [damaged_part.plaintext_zone] [burning ? "burns" : "hurts"] badly!"
			if(90 to INFINITY)
				msg = "OH GOD! Your [damaged_part.plaintext_zone] is [burning ? "on fire" : "hurting terribly"]!"

		pain_message(msg, highest_damage)


	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/I as anything in organs)
		if(prob(1) && (!(I.organ_flags & (ORGAN_SYNTHETIC|ORGAN_DEAD)) && I.damage > 5))
			var/obj/item/bodypart/parent = I.ownerlimb
			var/pain = 10
			var/message = "You feel a dull pain in your [parent.plaintext_zone]"
			if(I.damage > I.low_threshold)
				pain = 25
				message = "You feel a pain in your [parent.plaintext_zone]"
			if(I.damage > (I.high_threshold * I.maxHealth))
				pain = 50
				message = "You feel a sharp pain in your [parent.plaintext_zone]"
			pain_message(message, pain)
