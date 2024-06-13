/datum/rpg_skill/skirmish
	name = "Skirmish"
	desc = "The thrill of hand-to-hand combat."

	parent_stat_type = /datum/rpg_stat/soma

/datum/rpg_skill/skirmish/get(mob/living/user)
	. = ..()
	if(CHEM_EFFECT_MAGNITUDE(user, CE_STIMULANT))
		. += 1
	if(user.incapacitated())
		. -= 10 //lol fucked
	if(user.has_status_effect(/datum/status_effect/confusion))
		. -= -1
	if(user.IsKnockdown())
		. -= -2
	if(user.eye_blurry)
		. -= -1
	if(user.is_blind())
		. -= -4
	if(HAS_TRAIT(user, TRAIT_CLUMSY))
		. -= -1

	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user

	if(carbon_user.getPain() > 100)
		. -= 2

	if(carbon_user.shock_stage > 30)
		. -= 2
	else if(carbon_user.shock_stage > 10)
		. -= 1
