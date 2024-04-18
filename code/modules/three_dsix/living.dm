/// Some things are too annoying to make into event-based skills, so we can just check them here.
/mob/living/proc/__get_skill(skill)
	. = 0
	switch(skill)
		if(SKILL_MELEE_COMBAT)
			if(CHEM_EFFECT_MAGNITUDE(src, CE_STIMULANT))
				. += 1
			if(incapacitated())
				. -= 10 //lol fucked
			if(has_status_effect(/datum/status_effect/confusion))
				. -= -1
			if(IsKnockdown())
				. -= -2
			if(eye_blurry)
				. -= -1
			if(is_blind())
				. -= -4
			if(HAS_TRAIT(src, TRAIT_CLUMSY))
				. -= -1
			return .

	return
