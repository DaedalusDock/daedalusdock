/** ----- FINE MOTOR -----
 * Your Disco "Hand-Eye Coordination".
 * Fine Motor is all about using your hands for precision actions, even up to firing a gun.
**/
/datum/rpg_skill/fine_motor
	name = "Fine Motor"
	desc = "Surgery or sabotage, your hands are steady."

	parent_stat_type = /datum/rpg_stat/soma

/datum/rpg_skill/fine_motor/get(mob/living/user, list/out_sources)
	. = ..()

	if(CHEM_EFFECT_MAGNITUDE(user, CE_STIMULANT))
		. -= 1
		out_sources?["Stimulants"] = -1

	if(user.is_blind())
		. -= 4
		out_sources?["Blind"] = -4

	else if(user.eye_blurry)
		. -= 1
		out_sources?["Blurred vision"] = -1

	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user

	if(carbon_user.getPain() > 100)
		. -= 2
		out_sources?["In pain"] = -2

	if(carbon_user.shock_stage > 30)
		. -= 2
		out_sources?["In shock"] = -2

	else if(carbon_user.shock_stage > 10)
		. -= 1
		out_sources?["In shock"] = -1

	// Drunkeness removes between 1 and 10 based on how fucked you are.
	var/datum/status_effect/inebriated/drunk/drunkness = user.has_status_effect(/datum/status_effect/inebriated/drunk)
	if(drunkness)
		var/drunk_effect = min(ceil(drunkness.drunk_value / 5), 10) * -1
		. += drunk_effect
		out_sources?["Intoxicated"] = drunk_effect
