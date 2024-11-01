/datum/rpg_skill/handicraft
	name = "Handicraft"
	desc = "Control and manipulate, with style."

	parent_stat_type = /datum/rpg_stat/kinesis

/datum/rpg_skill/handicraft/get(mob/living/user)
	. = ..()

	if(CHEM_EFFECT_MAGNITUDE(user, CE_STIMULANT))
		. -= 1

	if(user.is_blind())
		. -= 4
	else if(user.eye_blurry)
		. -= 1

	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user

	if(carbon_user.shock_stage > 30)
		. -= 2
	else if(carbon_user.shock_stage > 10)
		. -= 1
