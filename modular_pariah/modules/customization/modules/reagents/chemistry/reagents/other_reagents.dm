// Catnip
/datum/reagent/pax/catnip
	name = "Catnip"
	taste_description = "grass"
	description = "A colourless liquid that makes people more peaceful and felines happier."
	metabolization_rate = 1.75 * REAGENTS_METABOLISM

/datum/reagent/pax/catnip/on_mob_life(mob/living/carbon/M)
	if(prob(20))
		M.emote("nya")
	if(prob(20))
		to_chat(M, span_notice("[pick("Headpats feel nice.", "The feeling of a hairball...", "Backrubs would be nice.", "Mew")]"))
	..()
