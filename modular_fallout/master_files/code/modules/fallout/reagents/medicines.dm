/datum/reagent/medicine/stimpak
	name = "Stimpak Fluid"
	description = "Rapidly heals damage when injected. Deals minor toxin damage if ingested."
	reagent_state = LIQUID
	color = "#eb0000"
	taste_description = "grossness"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 35
	addiction_types = list(/datum/addiction/opiods = 10)

/datum/reagent/medicine/stimpak/affect_ingest(mob/living/carbon/C, removed)
	C.adjustToxLoss(3.75 * metabolization_rate, cause_of_death = "Stimpak Fluid poisoning")
	if(prob(5))
		to_chat(C, "<span class='warning'>You don't feel so good...</span>")
	return TRUE


/datum/reagent/medicine/stimpak/affect_blood(mob/living/carbon/C, removed)
	if(C.health < 0)					//Functions as epinephrine.
		C.adjustToxLoss(-0.5 * removed, 0)
		C.adjustBruteLoss(-0.5 * removed, 0)
		C.adjustFireLoss(-0.5 * removed, 0)
	if(C.oxyloss > 35)
		C.setOxyLoss(35, 0)
	if(C.losebreath >= 4)
		C.losebreath -= 2
	if(C.losebreath < 0)
		C.losebreath = 0
	C.stamina.adjust(-0.5 * removed)
	. = 1
	if(prob(20))
		C.AdjustAllImmobility(-20, 0)
		C.AdjustUnconscious(-20, 0)
	if(!C.reagents.has_reagent(/datum/reagent/medicine/healing_powder)) // We don't want these healing items to stack, so we only apply the healing if these chems aren't found.We only check for the less powerful chems, so the least powerful one always heals.
		C.adjustBruteLoss(-4 * removed, 0)
		C.adjustFireLoss(-4 * removed, 0)
		C.adjustToxLoss(-1 * removed, 0)
		C.AdjustStun(-5 * removed, 0)
		C.AdjustKnockdown(-5 * removed, 0)
		C.stamina.adjust(-2 * removed, 0)
		. = TRUE
	..()

/datum/reagent/medicine/stimpak/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(5, FALSE, cause_of_death = "Stimpak fluid overdose")
	C.adjustOxyLoss(8, FALSE, cause_of_death = "Stimpak fluid overdose")
	C.drowsyness += 2
	C.set_jitter_if_lower(3 SECONDS)
	..()
	. = TRUE

/datum/reagent/medicine/stimpak/imitation
	name = "Imitation Stimpak Fluid"
	description = "Rapidly heals damage when injected. A poor man's stimpak."
	reagent_state = LIQUID

/datum/reagent/medicine/stimpak/imitation/affect_blood(mob/living/carbon/C, removed)
	C.adjustBruteLoss(-2.5*removed)
	C.adjustFireLoss(-2.5*removed)
	C.AdjustKnockdown(-5*removed, 0)
	C.stamina.adjust(-2*removed)
	..()

/datum/reagent/medicine/stimpak/super_stimpak
	name = "super stim chemicals"

	description = "Chemicals found in pre-war stimpaks."
	reagent_state = LIQUID
	color = "#e50d0d"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 20

/datum/reagent/medicine/stimpak/super_stimpak/affect_blood(mob/living/carbon/C, removed)
	if(C.health < 0)					//Functions as epinephrine.
		C.adjustToxLoss(-0.5*removed, 0)
		C.adjustBruteLoss(-0.5*removed, 0)
		C.adjustFireLoss(-0.5*removed, 0)
	if(C.oxyloss > 35)
		C.setOxyLoss(35, 0)
	if(C.losebreath >= 4)
		C.losebreath -= 2
	if(C.losebreath < 0)
		C.losebreath = 0
	C.stamina.adjust(-0.5*removed, 0)
	. = 1
	if(prob(20))
		C.AdjustAllImmobility(-20, 0)
		C.AdjustUnconscious(-20, 0)
	if(!C.reagents.has_reagent(/datum/reagent/medicine/healing_powder/poultice) && !C.reagents.has_reagent(/datum/reagent/medicine/stimpak) && !C.reagents.has_reagent(/datum/reagent/medicine/healing_powder)) // We don't want these healing items to stack, so we only apply the healing if these chems aren't found. We only check for the less powerful chems, so the least powerful one always heals.
		C.adjustBruteLoss(-8*removed)
		C.adjustFireLoss(-8*removed)
		C.adjustToxLoss(-2*removed)
		C.AdjustStun(-10*removed, 0)
		C.AdjustKnockdown(-10*removed, 0)
		C.stamina.adjust(-4*removed)
		. = TRUE
	..()

/datum/reagent/medicine/super_stimpak/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(10, FALSE, cause_of_death = "Super-Stimpak fluid overdose")
	C.adjustOxyLoss(12, FALSE, cause_of_death = "Super-Stimpak fluid overdose")
	..()
	. = TRUE

/datum/reagent/medicine/longpork_stew
	name = "longpork stew"
	description = "A dish sworn by some to have unusual healing properties. To most it just tastes disgusting. What even is longpork anyways?..."
	reagent_state = LIQUID
	color =  "#915818"
	taste_description = "oily water, with bits of raw-tasting tender meat."
	metabolization_rate = 0.15 * REAGENTS_METABOLISM //slow, weak heal that lasts a while. Metabolizies much faster if you are not hurt.
	overdose_threshold = 50 //If you eat too much you get poisoned from all the human flesh you're eating
	var/longpork_hurting = 0
	var/longpork_lover_healing = -2

/datum/reagent/medicine/longpork_stew/affect_blood(mob/living/carbon/C, removed)
	var/is_longporklover = FALSE
	if(HAS_TRAIT(C, TRAIT_LONGPORKLOVER))
		is_longporklover = TRUE
	if(C.getBruteLoss() == 0 && C.getFireLoss() == 0)
		metabolization_rate = 3 * REAGENTS_METABOLISM //metabolizes much quicker if not injured
	var/longpork_heal_rate = (is_longporklover ? longpork_lover_healing : longpork_hurting) * removed
	if(!C.reagents.has_reagent(/datum/reagent/medicine/stimpak) && !C.reagents.has_reagent(/datum/reagent/medicine/healing_powder))
		C.adjustFireLoss(longpork_heal_rate)
		C.adjustBruteLoss(longpork_heal_rate)
		C.adjustToxLoss(is_longporklover ? 0 : 3)
		. = TRUE
		..()

/datum/reagent/medicine/longpork_stew/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(2, FALSE, cause_of_death = "Longpork stew overconsumption")
	..()
	. = TRUE

/*
/datum/reagent/medicine/berserker_powder
	name = "berserker powder"
	description = "a combination of psychadelic mushrooms and tribal drugs used by the legion. Induces a trancelike state, allowing them much greater pain resistance. Extremely dangerous, even for those who are trained to use it. It's a really bad idea to use this if you're not initiated in the rites of the berserker. Even if you are, taking it for too long causes extreme symptoms when the trance ends."
	reagent_state = SOLID
	color =  "#7f7add"
	taste_description = "heaven."
	metabolization_rate = 0.7 * REAGENTS_METABOLISM
	overdose_threshold = 30 //hard to OD on, besides if you use too much it kills you when it wears off

/datum/reagent/medicine/berserker_powder/affect_blood(mob/living/carbon/C, removed)
	if(HAS_TRAIT(C, TRAIT_BERSERKER))
		C.AdjustStun(-2*removed, 0)
		C.AdjustKnockdown(-5*removed, 0)
		C.AdjustUnconscious(-2*removed, 0)
		C.stamina.adjust(-2*removed, 0)
	else
		C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 8)
		C.adjustToxLoss(5*removed)
		C.adjustOxyLoss(5*removed)
	..()
	. = TRUE
/datum/reagent/medicine/berserker_powder/on_mob_add(mob/living/carbon/human/C)
	..()
	if(isliving(C))
		to_chat(C, "<span class='notice'>The veil breaks, and the heavens spill out! The spirits of Mars float down from the heavens, and the deafining beat of the holy legion's wardrums fills your ears. Their ethereal forms are guiding you in battle!</span>")
		C.maxHealth += 20
		C.health += 20
		ADD_TRAIT(C, TRAIT_IGNOREDAMAGESLOWDOWN, "[type]")

/datum/reagent/medicine/berserker_powder/on_mob_delete(mob/living/carbon/human/C)
	if(isliving(C))
		to_chat(C, "<span class='notice'>The veil comes back, blocking out the heavenly visions. You breathe a sigh of relief...</span>")
		C.maxHealth -= 20
		C.health -= 20
		REMOVE_TRAIT(C, TRAIT_IGNOREDAMAGESLOWDOWN, "[type]")

	switch(current_cycle)
		if(1 to 30)
			C.confused += 10
			C.blur_eyes(20)
			to_chat(C, "<span class='notice'>Your head is pounding. You feel like screaming. The visions beckon you to go further, to split the veil forever and cross over. You know you shouldn't. </span>")
		if(30 to 55)
			C.confused +=20
			C.blur_eyes(30)
			C.losebreath += 8
			C.set_disgust(12)
			C.stamina.adjust(30*removed)
			to_chat(C, "<span class='danger'>Your stomach churns, you vomit, and the blurring of your vision doesn't go away. The visions beckon you further, you're so close.... </span>")
		if(55 to INFINITY)
			C.confused +=40
			C.blur_eyes(30)
			C.losebreath += 10
			C.set_disgust(25)
			C.stamina.adjust(40*removed)
			C.vomit(30, 1, 1, 5, 0, 0, 0, 60)
			C.Jitter(1000)
			C.playsound_local(C, 'sound/effects/singlebeat.ogg', 100, 0)
			C.set_heartattack(TRUE)
			to_chat(C, "<span class='userdanger'>The sky splits in half, rays of golden light piercing down towards you. Mars reaches out of the sky above, the holy aura causing you to fall to your knees. He beckoning you to heaven, and you take his hand. Your whole body begins to seize up as you go in a glorious rapture. </span>")

/datum/reagent/medicine/berserker/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(5*removed)
	..()
	. = TRUE
*/
/datum/reagent/medicine/bitter_drink
	name = "bitter drink"
	description = "An herbal healing concoction which enables wounded soldiers and travelers to tend to their wounds without stopping during journeys."
	reagent_state = LIQUID
	color ="#A9FBFB"
	taste_description = "bitterness"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM //in between powder/stimpaks and poultice/superstims?
	overdose_threshold = 31
	var/heal_factor = -3 //Subtractive multiplier if you do not have the perk.

/datum/reagent/medicine/bitter_drink/affect_blood(mob/living/carbon/C, removed)
	if(C.health < 0)					//Functions as epinephrine.
		C.adjustToxLoss(-0.5 * removed, 0)
		C.adjustBruteLoss(-0.5 * removed, 0)
		C.adjustFireLoss(-0.5 * removed, 0)
	if(C.oxyloss > 35)
		C.setOxyLoss(35, 0)
	if(C.losebreath >= 4)
		C.losebreath -= 2
	if(C.losebreath < 0)
		C.losebreath = 0
	C.stamina.adjust(-0.5 * removed, 0)
	. = 1
	if(!C.reagents.has_reagent(/datum/reagent/medicine/healing_powder)) // We don't want these healing items to stack, so we only apply the healing if these chems aren't found.We only check for the less powerful chems, so the least powerful one always heals.
		C.adjustBruteLoss(-3 * removed, 0)
		C.adjustFireLoss(-3 * removed, 0)
		C.adjustToxLoss(-1 * removed, 0)
		C.stamina.adjust(0.5 * removed, 0)
		. = TRUE
	..()

/datum/reagent/medicine/bitter_drink/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(1, FALSE, cause_of_death = "bitter drink overdose")
	C.adjustOxyLoss(2, FALSE, cause_of_death = "bitter drink overdose")
	..()
	. = TRUE

/datum/reagent/medicine/healing_powder
	name = "healing powder"
	description = "A healing powder derived from a mix of ground broc flowers and xander roots. Consumed orally, and produces a euphoric high."
	reagent_state = SOLID
	color = "#A9FBFB"
	taste_description = "bitterness"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	var/heal_factor = -1.5 //Subtractive multiplier if you do not have the perk.
	var/heal_factor_perk = -2.5 //Multiplier if you have the right perk.

//	C.hallucination = max(C.hallucination, is_tribal ? 0 : 5)

/datum/reagent/medicine/stimpak/affect_blood(mob/living/carbon/C, removed)
	if(!C.reagents.has_reagent(/datum/reagent/medicine/stimpak)) // We don't want these healing items to stack, so we only apply the healing if these chems aren't found.We only check for the less powerful chems, so the least powerful one always heals.
		C.adjustBruteLoss(-1.5 * removed, 0)
		C.adjustFireLoss(-1.5 * removed, 0)
		C.adjustToxLoss(-1.5 * removed, 0)
		C.stamina.adjust(-0.5 * removed, 0)
		. = TRUE
	..()

/datum/reagent/medicine/healing_powder/expose_mob(mob/living/C, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(C) && C.stat != DEAD)
		if(method in list(INGEST, VAPOR, INJECT))
			C.adjustToxLoss(3*reac_volume) //also increased from 0.5, reduced from 6
			if(show_message)
				to_chat(C, "<span class='warning'>You don't feel so good...</span>")
	..()

/datum/reagent/medicine/healing_powder/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(2, FALSE, cause_of_death = "healing powder overdose")
	C.adjustOxyLoss(4, FALSE, cause_of_death = "healing powder overdose")
	..()
	. = TRUE

/datum/reagent/medicine/healing_powder/poultice
	name = "healing poultice"
	description = "Restores limb condition and heals rapidly."
	color = "#C8A5DC"
	overdose_threshold = 20
	heal_factor = -2
	heal_factor_perk = -4

/datum/reagent/medicine/radx // current radiation system needs some work, so just copy potas iodine for now
	name = "Rad-X"

	description = "Reduces massive amounts of radiation and some toxin damage."
	reagent_state = LIQUID
	color = "#ff6100"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/radx/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_HALT_RADIATION_EFFECTS, CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/radx/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_HALT_RADIATION_EFFECTS, CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/radx/affect_blood(mob/living/carbon/C, removed)
	if (HAS_TRAIT(C, TRAIT_IRRADIATED))
		C.adjustToxLoss(-0.5 * removed)

#warn please re-do this in the future

/datum/reagent/medicine/radaway
	name = "Radaway"

	description = "A potent anti-toxin drug."
	reagent_state = LIQUID
	color = "#ff7200"
	metabolization_rate = 2 * REAGENTS_METABOLISM

/datum/reagent/medicine/radaway/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_HALT_RADIATION_EFFECTS, CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/radaway/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_HALT_RADIATION_EFFECTS, CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/radaway/affect_blood(mob/living/carbon/C, removed)
	if (HAS_TRAIT(C, TRAIT_IRRADIATED))
		C.adjustToxLoss(-3 * removed)

/datum/reagent/medicine/medx
	name = "Med-X"

	description = "Med-X is a potent painkiller, allowing users to withstand high amounts of pain and continue functioning. Addictive. Prolonged presence in the body can cause seizures and organ damage."
	reagent_state = LIQUID
	color = "#6D6374"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 16
	addiction_types = list(/datum/addiction/opiods = 10)

/datum/reagent/medicine/medx/on_mob_add(mob/living/carbon/human/C)
	..()
	if(isliving(C))
		to_chat(C, "<span class='notice'>You feel tougher, able to shrug off pain more easily.</span>")
		C.maxHealth += 100
		C.health += 100
		ADD_TRAIT(C, TRAIT_IGNOREDAMAGESLOWDOWN, "[type]")

/datum/reagent/medicine/medx/on_mob_delete(mob/living/carbon/human/C)
	if(isliving(C))
		to_chat(C, "<span class='notice'>You feel as vulnerable to pain as a normal person.</span>")
		C.maxHealth -= 100
		C.health -= 100
		REMOVE_TRAIT(C, TRAIT_IGNOREDAMAGESLOWDOWN, "[type]")
	switch(current_cycle)
		if(1 to 25)
			C.adjust_timed_status_effect(10 SECONDS, /datum/status_effect/confusion, max_duration = 10 SECONDS)
			C.blur_eyes(20)
			to_chat(C, "<span class='notice'>Your head is pounding. Med-X is hard on the body. </span>")
		if(26 to 50)
			C.adjust_timed_status_effect(20 SECONDS, /datum/status_effect/confusion, max_duration = 20 SECONDS)
			C.blur_eyes(30)
			C.losebreath += 8
//			C.adjust_eye_damage(6)
			C.set_disgust(12)
			C.stamina.adjust(30)
			to_chat(C, "<span class='danger'>Your stomach churns, your eyes cloud and you're pretty sure you just popped a lung. You shouldn't take so much med-X at once. </span>")
		if(51 to INFINITY)
			C.adjust_timed_status_effect(40 SECONDS, /datum/status_effect/confusion, max_duration = 40 SECONDS)
			C.blur_eyes(30)
			C.losebreath += 10
//			C.adjust_eye_damage(12)
			C.set_disgust(25)
			C.stamina.adjust(40)
			C.vomit(30, 1, 1, 5, 0, 0, 0, 60)
			C.set_jitter_if_lower(20 SECONDS)
			C.playsound_local(C, 'sound/effects/singlebeat.ogg', 100, 0)
			C.visible_message("<span class='userdanger'>[C] clutches their stomach and vomits violently onto the ground, bloody froth covering their lips!</span>")
			to_chat(C, "<span class='userdanger'>You throw up everything you've eaten in the past week and some blood to boot. You're pretty sure your heart just stopped for a second, too. </span>")
		if(101 to INFINITY)
			C.adjust_eye_damage(30)
			C.Unconscious(400)
			C.set_jitter_if_lower(100 SECONDS)
			C.set_heartattack(TRUE)
			C.visible_message("<span class='userdanger'>[C] clutches at their chest as if their heart stopped!</span>")
			to_chat(C, "<span class='danger'>Your vision goes black and your heart stops beating as the amount of drugs in your system shut down your organs one by one. Say hello to Elvis in the afterlife. </span>")
	..()

/datum/reagent/medicine/medx/affect_blood(mob/living/carbon/C, removed)
	C.AdjustStun(-30*removed, 0)
	C.AdjustKnockdown(-30*removed, 0)
	C.AdjustUnconscious(-30*removed, 0)
	C.stamina.adjust(-5*removed, 0)
	..()
	. = TRUE

/datum/reagent/medicine/medx/overdose_process(mob/living/carbon/human/C)
	C.set_blurriness(30)
	C.Unconscious(400)
	C.set_jitter_if_lower(60 SECONDS)
	C.set_heartattack(TRUE)
	C.drop_all_held_items()
	C.set_dizzy_if_lower(20 SECONDS)
	C.visible_message("<span class='userdanger'>[C] clutches at their chest as if their heart stopped!</span>")
	if(prob(10))
		to_chat(C, "<span class='danger'>Your vision goes black and your heart stops beating as the amount of drugs in your system shut down your organs one by one. Say hello to Elvis in the afterlife. </span>")
	..()

/datum/reagent/medicine/mentat
	name = "Mentat Powder"

	description = "A powerful drug that heals and increases the perception and intelligence of the user."
	color = "#C8A5DC"
	reagent_state = SOLID
	overdose_threshold = 25
	addiction_types = list(/datum/addiction/opiods = 10)

#warn to-do: add unique addiction datums

/datum/reagent/medicine/mentat/affect_blood(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-3*removed)
	var/obj/item/organ/eyes/eyes = C.getorganslot(ORGAN_SLOT_EYES)
	if (!eyes)
		return
	if(C.getOrganLoss(ORGAN_SLOT_BRAIN) == 0)
		C.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
/*	if(HAS_TRAIT(C, TRAIT_BLIND, TRAIT_GENERIC))
		if(prob(20))
			to_chat(C, "<span class='warning'>Your vision slowly returns...</span>")
			C.cure_blind(EYE_DAMAGE)
			C.cure_nearsighted(EYE_DAMAGE)
			C.blur_eyes(35)
	else if(HAS_TRAIT(C, TRAIT_NEARSIGHT, TRAIT_GENERIC))
		to_chat(C, "<span class='warning'>The blackness in your peripheral vision fades.</span>")
		C.cure_nearsighted(EYE_DAMAGE)
		C.blur_eyes(10)*/
	else if(C.eye_blind || C.eye_blurry)
		C.set_blindness(0)
		C.set_blurriness(0)
		to_chat(C, "<span class='warning'>Your vision slowly returns to normal...</span>")
//	else if(eyes.eye_damage > 0)
//		C.adjust_eye_damage(-1)
//	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2)
	if (prob(5))
		to_chat(C, "<span class='notice'>You feel way more intelligent!</span>")
	..()
	. = TRUE

/datum/reagent/medicine/mentat/overdose_process(mob/living/carbon/C)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15)
	if(prob(33))
		C.set_dizzy_if_lower(5 SECONDS)
		C.set_jitter_if_lower(10 SECONDS)
	..()

/datum/reagent/medicine/fixer
	name = "Fixer Powder"

	description = "Treats addictions while also purging other chemicals from the body. Side effects include nausea."
	reagent_state = SOLID
	color = "#C8A5DC"

/datum/reagent/medicine/fixer/affect_blood(mob/living/carbon/C, removed)
//	for(var/datum/reagent/R in C.reagents.reagent_list)
//		if(R != src)
//			C.reagents.remove_reagent(R.id,2)
	for(var/datum/reagent/R in C.reagents.addiction_list)
		C.reagents.addiction_list.Remove(R)
		to_chat(C, "<span class='notice'>You feel like you've gotten over your need for [R.name].</span>")
	C.adjust_timed_status_effect(4 SECONDS, /datum/status_effect/confusion, max_duration = 4 SECONDS)
	if(ishuman(C) && prob(5))
		var/mob/living/carbon/human/H = C
		H.vomit(10)
	..()
	. = TRUE

/datum/reagent/medicine/gaia
	name = "Gaia Extract"

	description = "Liquid extracted from a gaia branch. Provides a slow but reliable healing effect"
	reagent_state = LIQUID
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "deliciousness"
	overdose_threshold = 30
	color = "##DBCE18"

/datum/reagent/medicine/gaia/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(-0.75*removed, 0)
	C.adjustOxyLoss(-0.75*removed, 0)
	C.adjustBruteLoss(-0.75*removed, 0)
	C.adjustFireLoss(-0.75*removed, 0)
	..()

/datum/reagent/medicine/gaia/overdose_start(mob/living/carbon/C)
	metabolization_rate = 15 * REAGENTS_METABOLISM
	..()
