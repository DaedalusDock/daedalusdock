
/mob/living/carbon/__get_skill(skill)
	. = 0
	switch(skill)
		if(SKILL_MELEE_COMBAT)
			if(getPain() > 100)
				. -= 2
			if(shock_stage > 30)
				. -= 2
			else if(shock_stage > 10)
				. -= 1
			return .
