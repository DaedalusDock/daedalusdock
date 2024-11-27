/datum/pathogen/gbs
	name = "GBS"
	max_stages = 4
	spread_text = "On contact"
	spread_flags = PATHOGEN_SPREAD_BLOOD | PATHOGEN_SPREAD_CONTACT_SKIN | PATHOGEN_SPREAD_CONTACT_FLUIDS
	cure_text = "Synaptizine & Sulfur"
	cures = list(/datum/reagent/medicine/synaptizine,/datum/reagent/sulfur)
	cure_chance = 7.5 //higher chance to cure, since two reagents are required
	agent = "Gravitokinetic Bipotential SADS+"
	viable_mobtypes = list(/mob/living/carbon/human)
	contraction_chance_modifier = 1
	severity = PATHOGEN_SEVERITY_BIOHAZARD

/datum/pathogen/gbs/on_process(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("cough")
		if(3)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("gasp")
			if(DT_PROB(5, delta_time))
				affected_mob.apply_pain(10, BODY_ZONE_CHEST, "Your body aches with pain!")
		if(4)
			to_chat(affected_mob, span_userdanger("Your body feels as if it's trying to rip itself apart!"))
			if(DT_PROB(30, delta_time))
				affected_mob.gib()
				return FALSE
