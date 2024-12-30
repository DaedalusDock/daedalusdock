/datum/pathogen/revblight
	name = "Unnatural Wasting"
	max_stages = 5
	stage_prob = 5
	spread_flags = PATHOGEN_SPREAD_NON_CONTAGIOUS
	cure_text = "Holy water or extensive rest."
	spread_text = "A burst of unholy energy"
	cures = list(/datum/reagent/water/holywater)
	cure_chance = 30 //higher chance to cure, because revenants are assholes
	agent = "Unholy Forces"
	viable_mobtypes = list(/mob/living/carbon/human)
	pathogen_flags = PATHOGEN_CURABLE
	severity = PATHOGEN_SEVERITY_HARMFUL
	var/stagedamage = 0 //Highest stage reached.
	var/finalstage = 0 //Because we're spawning off the cure in the final stage, we need to check if we've done the final stage's effects.

/datum/pathogen/revblight/force_cure(add_resistance = TRUE)
	if(affected_mob)
		affected_mob.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#1d2953")
		if(affected_mob.dna && affected_mob.dna.species)
			affected_mob.set_haircolor(null, override = TRUE)
		to_chat(affected_mob, span_notice("You feel better."))
	..()


/datum/pathogen/revblight/on_process(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	if(!finalstage)
		if(affected_mob.body_position == LYING_DOWN && DT_PROB(3 * stage, delta_time))
			force_cure()
			return FALSE
		if(DT_PROB(1.5 * stage, delta_time))
			to_chat(affected_mob, span_revennotice("You suddenly feel [pick("sick and tired", "disoriented", "tired and confused", "nauseated", "faint", "dizzy")]..."))
			affected_mob.adjust_timed_status_effect(8 SECONDS, /datum/status_effect/confusion)
			affected_mob.stamina.adjust(-20)
			new /obj/effect/temp_visual/revenant(affected_mob.loc)
		if(stagedamage < stage)
			stagedamage++
			affected_mob.adjustToxLoss(1 * stage * delta_time, FALSE, cause_of_death = "Wasted away") //should, normally, do about 30 toxin damage.
			new /obj/effect/temp_visual/revenant(affected_mob.loc)
		if(DT_PROB(25, delta_time))
			affected_mob.stamina.adjust(-stage)

	switch(stage)
		if(2)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("pale")
		if(3)
			if(DT_PROB(5, delta_time))
				affected_mob.emote(pick("pale","shiver"))
		if(4)
			if(DT_PROB(7.5, delta_time))
				affected_mob.emote(pick("pale","shiver","cries"))
		if(5)
			if(!finalstage)
				finalstage = TRUE
				to_chat(affected_mob, span_revenbignotice("You feel like [pick("nothing's worth it anymore", "nobody ever needed your help", "nothing you did mattered", "everything you tried to do was worthless")]."))
				affected_mob.stamina.adjust(-22.5 * delta_time)
				new /obj/effect/temp_visual/revenant(affected_mob.loc)
				if(affected_mob.dna && affected_mob.dna.species)
					affected_mob.set_haircolor("#1d2953", override = TRUE)
				affected_mob.visible_message(span_warning("[affected_mob] looks terrifyingly gaunt..."), span_revennotice("You suddenly feel like your skin is <i>wrong</i>..."))
				affected_mob.add_atom_colour("#1d2953", TEMPORARY_COLOUR_PRIORITY)
				addtimer(CALLBACK(src, PROC_REF(force_cure)), 10 SECONDS)
