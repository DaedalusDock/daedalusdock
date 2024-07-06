
/mob/living/carbon/human/Stun(amount, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/Knockdown(amount, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/Paralyze(amount, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Immobilize(amount, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Unconscious(amount, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src,amount)
	if(HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
		amount *= (rand(125, 130) * 0.01)
	return ..()

/mob/living/carbon/human/Sleeping(amount)
	if(HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
		amount *= (rand(125, 130) * 0.01)
	return ..()

/mob/living/carbon/human/cure_husk(list/sources)
	. = ..()
	if(.)
		update_body_parts()

/mob/living/carbon/human/become_husk(source)
	if(istype(dna.species, /datum/species/skeleton)) //skeletons shouldn't be husks.
		cure_husk()
		return
	. = ..()
	if(.)
		update_body_parts()

/mob/living/carbon/human/fakedeath(source, silent)
	. = ..()
	for(var/mob/living/L in viewers(src, world.view) - src)
		if(L.is_blind() || L.stat != CONSCIOUS || !L.client)
			continue

		var/datum/roll_result/result = L.stat_roll(6, /datum/rpg_skill/willpower)
		switch(result.outcome)
			if(FAILURE, CRIT_FAILURE)
				if(L.apply_status_effect(/datum/status_effect/skill_mod/witness_death))
					to_chat(L, result.create_tooltip("For but a moment, there is nothing. Nothing but the gnawing realisation of what you have just witnessed."))
