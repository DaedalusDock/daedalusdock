/datum/rpg_skill/forensics
	name = "Forensic Analysis"
	desc = "Reconstruct the past."

	parent_stat_type = /datum/rpg_stat/psyche

/datum/rpg_skill/forensics/get(mob/living/user, list/out_sources)
	. = ..()

	// Drunkeness adds to your forensics skill if you're buzzed, otherwise tanks it.
	var/datum/status_effect/inebriated/drunk/drunkness = user.has_status_effect(/datum/status_effect/inebriated/drunk)
	if(drunkness)
		var/drunk_effect = 0
		if(drunkness.drunk_value < 20)
			drunk_effect = 3
		else
			drunk_effect = min(ceil(drunkness.drunk_value / 5), 10) * -1
		. += drunk_effect
		out_sources?["Intoxicated"] = drunk_effect
