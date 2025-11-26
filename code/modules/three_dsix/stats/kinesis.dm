/datum/rpg_stat/kinesis
	name = "Kinesis"
	desc = ""

	value = STATS_BASELINE_VALUE
	sound = 'sound/three_dsix/kinesis.ogg'
	color = "#caa53d"

/datum/rpg_stat/kinesis/get(mob/living/user, list/out_sources)
	. = ..()
	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user

	var/obj/item/organ/brain/brain = carbon_user.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain && (brain.damage >= (brain.maxHealth * brain.low_threshold)))
		. -= 4
		out_sources?["Brain damage"] = -4

	// Drunkeness removes between 1 and 5 points.
	var/datum/status_effect/inebriated/drunk/drunkness = user.has_status_effect(/datum/status_effect/inebriated/drunk)
	if(drunkness)
		var/drunk_effect = min(ceil(drunkness.drunk_value / 20), 5) * -1
		. += drunk_effect
		out_sources?["Intoxicated"] = drunk_effect
