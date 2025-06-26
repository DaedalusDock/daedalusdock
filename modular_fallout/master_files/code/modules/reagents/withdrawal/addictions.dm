// MENTATS

/datum/reagent/medicine/mentat/addiction_act_stage1(mob/living/M)
	if(prob(33))
		C.Jitter(2)
	..()

/datum/reagent/medicine/mentat/addiction_act_stage2(mob/living/M)
	if(prob(33))
		. = TRUE
		C.Dizzy(3)
		C.Jitter(3)
	..()

/datum/reagent/medicine/mentat/addiction_act_stage3(mob/living/M)
	if(prob(33))
		C.adjustToxLoss(1*removed)
//		C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2)
//		. = TRUE
		C.Dizzy(4)
		C.Jitter(4)
	..()

/datum/reagent/medicine/mentat/addiction_act_stage4(mob/living/M)
	if(prob(33))
		C.drop_all_held_items()
		C.adjustToxLoss(2*removed)
//		C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 4)
//		. = TRUE
		C.Dizzy(5)
		C.Jitter(5)
	..()

// MED-X

/datum/reagent/medicine/medx/addiction_act_stage1(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.Jitter(2)
	..()

/datum/reagent/medicine/medx/addiction_act_stage2(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.adjustToxLoss(1*REAGENTS_EFFECT_MULTIPLIER)
		. = TRUE
		M.Dizzy(3)
		M.Jitter(3)
	..()

/datum/reagent/medicine/medx/addiction_act_stage3(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.adjustToxLoss(2*REAGENTS_EFFECT_MULTIPLIER)
		. = TRUE
		M.Dizzy(4)
		M.Jitter(4)
	..()

/datum/reagent/medicine/medx/addiction_act_stage4(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.adjustToxLoss(3*REAGENTS_EFFECT_MULTIPLIER)
		. = TRUE
		M.Dizzy(5)
		M.Jitter(5)
	..()
