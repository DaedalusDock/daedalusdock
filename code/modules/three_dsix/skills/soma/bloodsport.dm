/** ----- BLOODSPORT -----
 * Melee combat. Real simple this one is.
**/
/datum/rpg_skill/bloodsport
	name = "Bloodsport"
	desc = "Fists, pipes, chairs, your brushes for the canvas of violence."

	parent_stat_type = /datum/rpg_stat/soma

/datum/rpg_skill/bloodsport/get(mob/living/user, list/out_sources)
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
