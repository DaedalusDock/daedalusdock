/datum/rpg_skill/skirmish
	name = "Skirmish"
	desc = "The thrill of hand-to-hand combat."

	parent_stat_type = /datum/rpg_stat/soma

/datum/rpg_skill/skirmish/get(mob/living/user, list/out_sources)
	. = ..()
	if(CHEM_EFFECT_MAGNITUDE(user, CE_STIMULANT))
		. += 1
		out_sources?["Stimulants"] = 1

	if(user.incapacitated())
		. -= 10 //lol fucked
		out_sources?["Incapacitated"] = -10

	if(user.is_blind())
		. -= -4
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

	var/obj/item/organ/brain/brain = carbon_user.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain && (brain.damage >= (brain.maxHealth * brain.low_threshold)))
		. -= 3
		out_sources?["Brain damage"] = -3

	// Drunkeness removes between 1 and 5 points.
	var/datum/status_effect/inebriated/drunk/drunkness = user.has_status_effect(/datum/status_effect/inebriated/drunk)
	if(drunkness)
		var/drunk_effect = min(ceil(drunkness.drunk_value / 20), 5) * -1
		. += drunk_effect
		out_sources?["Intoxicated"] = drunk_effect
