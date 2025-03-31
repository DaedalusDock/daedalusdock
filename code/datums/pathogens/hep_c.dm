/datum/pathogen/hep_c
	name = "Hepatitis C"
	desc = "A dangerous viral infection that causes serious organ damage if left unchecked."
	max_stages = 3
	spread_text = "Blood"
	cure_text = "Omnizine"
	cures = list(/datum/reagent/medicine/omnizine)
	agent = "Hepatitis C Virus"
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = PATHOGEN_SEVERITY_DANGEROUS
	infectable_biotypes = MOB_ORGANIC

	stage_prob = 0.2

/datum/pathogen/hep_c/on_process(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/affected_human = affected_mob
	if(DT_PROB(2, delta_time))
		affected_human.adjustToxLoss(0.4, cause_of_death = "Hepatitis C")
	if(DT_PROB(1, delta_time))
		to_chat(affected_human, span_warning(pick(affected_human.dna.species.heat_discomfort_strings)))

	if(stage < 2)
		return

	if(DT_PROB(0.5, delta_time))
		affected_human.vomit(20, affected_human.nutrition == 0, TRUE)

	if(!affected_human.has_status_effect(/datum/status_effect/confusion) && DT_PROB(1, delta_time))
		to_chat(affected_human, span_warning("You feel dazed."))
		affected_human.adjust_confusion_up_to(15 SECONDS, 15 SECONDS)

	if(!affected_human.has_status_effect(/datum/status_effect/speech/slurring/generic) && DT_PROB(1, delta_time))
		affected_human.adjust_timed_status_effect(10 SECONDS, /datum/status_effect/speech/slurring/generic)

	if(stage < 3)
		return

	affected_human.adjustToxLoss(3.6, cause_of_death = "Hepatitis C")
