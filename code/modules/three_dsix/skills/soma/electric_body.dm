/** ----- THE BODY ELECTRIC -----
 * Similar to "Inland Empire" and "Electro-chemistry".
 * How well you understand your own body and it's current goings-on.
 * Can also be for connecting with others or connecting with DRUGS.
**/
/datum/rpg_skill/electric_body
	name = "The Body Electric"
	desc = "The flesh is a vessel for electric connections."

	parent_stat_type = /datum/rpg_stat/soma

/datum/rpg_skill/electric_body/get(mob/living/user, list/out_sources)
	. = ..()

	// Drunkeness adds between 1 and 3 based on how fucked you are.
	var/datum/status_effect/inebriated/drunk/drunkness = user.has_status_effect(/datum/status_effect/inebriated/drunk)
	if(drunkness)
		var/drunk_effect = min(ceil(drunkness.drunk_value / 3), 3)
		. += drunk_effect
		out_sources?["Hammered"] = drunk_effect
