/datum/pathogen/fev
	name = "Forced Evolutionary Virus"
	desc = "A dangerous viral infection that actually doesn't cause the victim to evolve."
	max_stages = 3
	spread_text = "Blood"
	cure_text = "Omnizine"
	cures = list(/datum/reagent/medicine/omnizine)
	agent = "FEV Virus"
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = PATHOGEN_SEVERITY_DANGEROUS
	infectable_biotypes = MOB_ORGANIC

	stage_prob = 0.2

/datum/pathogen/fev/on_process(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/affected_human = affected_mob
	if(DT_PROB(2, delta_time))
		affected_human.adjustToxLoss(1, cause_of_death = "FEV")
	if(DT_PROB(1, delta_time))
		to_chat(affected_human, span_warning(pick(affected_human.dna.species.heat_discomfort_strings)))

	if(DT_PROB(2, delta_time))
		affected_human.adjustOrganLoss(ORGAN_SLOT_KIDNEYS, 15)
		affected_human.adjustOrganLoss(ORGAN_SLOT_HEART, 15)
		affected_human.adjustOrganLoss(ORGAN_SLOT_LUNGS, 15)
		affected_human.adjustOrganLoss(ORGAN_SLOT_LIVER, 15)

	if(DT_PROB(2.5, delta_time))
		affected_human.adjustCloneLoss(1.5, FALSE)

	if(stage < 2)
		return

	if(DT_PROB(0.5, delta_time))
		affected_human.vomit(20, affected_human.nutrition == 0, TRUE)

	if(!affected_human.has_status_effect(/datum/status_effect/confusion) && DT_PROB(1, delta_time))
		to_chat(affected_human, span_warning("You feel dazed."))
		affected_human.adjust_confusion_up_to(15 SECONDS, 15 SECONDS)

	if(!affected_human.has_status_effect(/datum/status_effect/speech/slurring/generic) && DT_PROB(1, delta_time))
		affected_human.adjust_timed_status_effect(10 SECONDS, /datum/status_effect/speech/slurring/generic)

	if(DT_PROB(2, delta_time))
		affected_human.adjustOrganLoss(ORGAN_SLOT_KIDNEYS, 30)
		affected_human.adjustOrganLoss(ORGAN_SLOT_HEART, 30)
		affected_human.adjustOrganLoss(ORGAN_SLOT_LUNGS, 30)
		affected_human.adjustOrganLoss(ORGAN_SLOT_LIVER, 30)

	if(DT_PROB(5, delta_time))
		affected_human.adjustCloneLoss(3, FALSE)

	if(stage < 3)
		return

	affected_human.adjustToxLoss(3.6, cause_of_death = "FEV")

	if(DT_PROB(2, delta_time))
		affected_human.adjustOrganLoss(ORGAN_SLOT_KIDNEYS, 50)
		affected_human.adjustOrganLoss(ORGAN_SLOT_HEART, 50)
		affected_human.adjustOrganLoss(ORGAN_SLOT_LUNGS, 50)
		affected_human.adjustOrganLoss(ORGAN_SLOT_LIVER, 50)

	if(DT_PROB(5, delta_time))
		affected_human.adjustCloneLoss(5, FALSE)
