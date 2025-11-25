/datum/rpg_stat/psyche
	name = "Psyche"
	desc = ""

	value = STATS_BASELINE_VALUE
	sound = 'sound/three_dsix/psyche.ogg'

/datum/rpg_stat/psyche/get(mob/living/user, list/out_sources)
	. = ..()
	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user

	var/obj/item/organ/brain/brain = carbon_user.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain && (brain.damage >= (brain.maxHealth * brain.low_threshold)))
		. -= 4
		out_sources?["Brain damage"] = -4

	// Drunkeness adds to your psyche stat if you're buzzed, otherwise tanks it.
	var/datum/status_effect/inebriated/drunk/drunkness = user.has_status_effect(/datum/status_effect/inebriated/drunk)
	if(drunkness)
		var/drunk_effect = 0
		if(drunkness.drunk_value < 20)
			drunk_effect = 3
		else
			drunk_effect = min(ceil(drunkness.drunk_value / 5), 10) * -1
		. += drunk_effect
		out_sources?["Intoxicated"] = drunk_effect
