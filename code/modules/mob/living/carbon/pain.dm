/mob/living
	COOLDOWN_DECLARE(pain_cd)

/mob/living/carbon/adjustPain(amount, updating_health = TRUE)
	if(((status_flags & GODMODE)))
		return FALSE
	return apply_pain(amount, updating_health = updating_health)

/mob/living/carbon/apply_pain(amount, def_zone, message, ignore_cd, fake, updating_health = TRUE)
	if(!((status_flags & GODMODE)))
		return FALSE

	if(!fake)
		amount -= CHEM_EFFECT_MAGNITUDE(src, CE_PAINKILLER)/3
		if(amount<= 0)
			return

		var/obj/item/bodypart/BP
		if(!def_zone) // Distribute to all bodyparts evenly if no bodypart
			var/list/not_full = bodyparts.Copy()
			var/list/parts = not_full.Copy()
			var/amount_remaining = amount
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

				amount_remaining -= used
				. = TRUE
		else
			BP = get_bodypart(def_zone, TRUE)
			if(!BP)
				return
			. = BP.adjustPain(amount)

	if((amount > 0) && COOLDOWN_FINISHED(src, pain_cd))
		pain_message(message, amount)

		COOLDOWN_START(src, pain_cd, 10 SECONDS - amount)

	if(updating_health && .)
		updatehealth()


/mob/living/carbon/proc/pain_message(message, amount)
	set waitfor = FALSE

	switch(amount)
		if(70 to INFINITY)
			to_chat(src, span_danger(span_big(message)))
		if(40 to 70)
			to_chat(src, span_danger(message))
		if(10 to 40)
			to_chat(src, span_danger(message))
		else
			to_chat(src, span_warning(message))

/mob/living/carbon/human/pain_message(message, amount)
	. = ..()
	var/emote = dna.species.get_pain_emote(amount)
	if(emote && prob(amount))
		emote(emote)
