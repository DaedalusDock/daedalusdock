/datum/reagent/drug/jet
	name = "Jet Inhalant"
	description = "A chemical used to induce a euphoric high derived from brahmin dung. Fast-acting, powerful, and highly addictive."
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 20
	addiction_types = (/datum/addiction/jet)

/datum/reagent/drug/jet/on_mob_add(mob/living/carbon/human/C)
	..()
	if(isliving(C))
		to_chat(C, "<span class='notice'>You feel an incredible high! You just absolutely love life in this moment!</span>")

/datum/reagent/drug/jet/on_mob_delete(mob/living/carbon/human/C)
	..()
	if(isliving(C))
		to_chat(C, "<span class='notice'>You come down from your high. The wild ride is unfortunately over...</span>")
		adjust_confusion(2 SECONDS)

/datum/reagent/drug/jet/affect_blood(mob/living/carbon/C)
	C.stamina.adjust(-20)
	C.set_drugginess_if_lower(20 SECONDS)
	if(!(C.mobility_flags && MOBILITY_MOVE) && prob(10))
		step(C, pick(GLOB.cardinals))
	if(prob(12))
		C.emote(pick("twitch","drool","moan","giggle"))
	..()

/datum/reagent/drug/jet/overdose_start(mob/living/C)
	to_chat(C, "<span class='userdanger'>You start tripping hard!</span>")

/datum/reagent/drug/jet/overdose_process(mob/living/C)
	if(C.hallucination < volume && prob(20))
		C.hallucination += 10
		C.adjustToxLoss(10, 0)
		C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60, updating_health = FALSE)
	..()

/datum/reagent/drug/turbo
	name = "Turbo Inhalant"
	description = "A chemical compound that, when inhaled, vastly increases the user's reflexes and slows their perception of time. Carries a risk of addiction and extreme nausea and toxin damage if overdosed."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 14
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	addiction_types = (/datum/addiction/turbo)

/datum/reagent/drug/turbo/on_mob_add(mob/C)
	..()
	ADD_TRAIT(C, TRAIT_IGNORESLOWDOWN, "[type]")

/datum/reagent/drug/turbo/on_mob_delete(mob/C)
	REMOVE_TRAIT(C, TRAIT_IGNORESLOWDOWN, "[type]")
	..()

/datum/reagent/drug/turbo/affect_blood(mob/living/carbon/C)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		to_chat(C, "<span class='notice'>[high_message]</span>")
	C.set_timed_status_effect(2 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	if(prob(5))
		C.emote(pick("twitch", "shiver"))
	..()
	. = TRUE

/datum/reagent/drug/turbo/overdose_process(mob/living/C)
	if(!(C.mobility_flags && MOBILITY_MOVE))
		for(var/i in 1 to 4)
			step(C, pick(GLOB.cardinals))
	if(prob(20))
		C.emote("laugh")
	if(prob(33))
		C.visible_message("<span class='danger'>[C]'s hands flip out and flail everywhere!</span>")
		C.drop_all_held_items()
	..()
	C.adjustToxLoss(2, 0)
	. = TRUE

/datum/reagent/drug/psycho
	name = "Psycho Fluid"
	description = "Makes the user hit harder and shrug off slight stuns, but causes slight brain damage and carries a risk of addiction."
	reagent_state = LIQUID
	color = "#FF0000"
	overdose_threshold = 15
	addiction_types = (/datum/addiction/psycho)
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage


/datum/reagent/drug/psycho/affect_blood(mob/living/carbon/C)
	var/high_message = pick("<br><font color='#FF0000'><b>FUCKING KILL!</b></font>", "<br><font color='#FF0000'><b>RAAAAR!</b></font>", "<br><font color='#FF0000'><b>BRING IT!</b></font>")
	if(prob(20))
		to_chat(C, "<span class='notice'>[high_message]</span>")
	C.AdjustStun(-25, 0)
	C.AdjustKnockdown(-25, 0)
	C.AdjustUnconscious(-25, 0)
	C.Stamina(-5, 0)
	C.set_timed_status_effect(2 SECONDS, /datum/status_effect/jitter)
	..()
	. = TRUE

/datum/reagent/drug/psycho/on_mob_add(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, "[type]")
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/drug/psycho/on_mob_delete(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, "[type]")
	if(rage)
		QDEL_NULL(rage)
	..()

/datum/reagent/drug/psycho/overdose_process(mob/living/carbon/human/C)
	C.hallucination += 20
	if(!(C.mobility_flags && MOBILITY_MOVE))
		for(var/i = 0, i < 8, i++)
			step(C, pick(GLOB.cardinals))
	if(prob(20))
		C.emote(pick("twitch","scream","laugh"))
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2, updating_health = FALSE)
	C.set_heartattack(TRUE)
	C.visible_message("<span class='userdanger'>[C] clutches at their chest as if their heart stopped!</span>")
	to_chat(C, "<span class='danger'>Your vision goes black and your heart stops beating as the amount of drugs in your system shut down your organs one by one. Say hello to Elvis in the afterlife. </span>")
	..()
	return TRUE

/datum/reagent/drug/buffout
	name = "Buffout Powder"
	description = "A powerful steroid which increases the user's strength and endurance."
	color = "#FF9900"
	reagent_state = SOLID
	overdose_threshold = 20
	addiction_types = (/datum/addiction/buffout)
	metabolization_rate = 1.25 * REAGENTS_METABOLISM
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/drug/buffout/on_mob_add(mob/living/carbon/human/C)
	..()
	if(isliving(C))
		to_chat(C, "<span class='notice'>You feel stronger, and like you're able to endure more.</span>")
		ADD_TRAIT(C, TRAIT_BUFFOUT_BUFF, "buffout")
		ADD_TRAIT(C, TRAIT_PERFECT_ATTACKER, "buffout")
		C.maxHealth += 25
		C.health += 25

/datum/reagent/drug/buffout/on_mob_delete(mob/living/carbon/human/C)
	..()
	if(isliving(C))
		to_chat(C, "<span class='notice'>You feel weaker.</span>")
		REMOVE_TRAIT(C, TRAIT_BUFFOUT_BUFF, "buffout")
		REMOVE_TRAIT(C, TRAIT_PERFECT_ATTACKER, "buffout")
		C.maxHealth -= 25
		C.health -= 25

/datum/reagent/drug/buffout/affect_blood(mob/living/carbon/C)
	C.AdjustStun(-10, 0)
	C.AdjustKnockdown(-10, 0)
	..()
	. = TRUE

/datum/reagent/drug/buffout/overdose_process(mob/living/carbon/human/C)
	if(iscarbon(C))
		var/mob/living/carbon/M = C
		rage = new()
		M.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)
	var/datum/pathogen/D = new /datum/pathogen/heart_failure
	C.try_contract_pathogen(D)
	if(prob(33))
		C.visible_message("<span class='danger'>[C]'s muscles spasm, making them drop what they were holding!</span>")
		C.drop_all_held_items()
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2, updating_health = FALSE)
	..()

/datum/reagent/toxin/FEV_solution
	name = "Unstable FEV solution"
	description = "An incredibly lethal strain of the Forced Evolutionary Virus. Consume at your own risk."
	color = "#00FF00"
	toxpwr = 0
	overdose_threshold = 18 // So, someone drinking 20 units will FOR SURE get overdosed
	taste_description = "horrific agony"
	taste_mult = 0.9

/datum/reagent/toxin/FEV_solution/expose_mob(mob/living/carbon/M, method=TOUCH, reac_volume)
	if(!..())
		return
	if(!M.has_dna())
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	var/datum/pathogen/D = new /datum/pathogen/fev
	C.try_contract_pathogen(D)
//		M.easy_randmut(NEGATIVE + MINOR_NEGATIVE, sequence = FALSE)
//		M.updateappearance()
//		M.domutcheck()
	..()
