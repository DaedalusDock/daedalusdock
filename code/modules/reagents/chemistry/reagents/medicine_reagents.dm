

//////////////////////////////////////////////////////////////////////////////////////////
					// MEDICINE REAGENTS
//////////////////////////////////////////////////////////////////////////////////////

// where all the reagents related to medicine go.

/datum/reagent/medicine
	taste_description = "bitterness"
	flags = IGNORE_MOB_SIZE
	abstract_type = /datum/reagent/medicine

/datum/reagent/medicine/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	description = "It's magic. We don't have to explain it."
	color = "#E0BB00" //golden for the gods
	taste_description = "badmins"
	chemical_flags = REAGENT_DEAD_PROCESS
	metabolization_rate = 1

// The best stuff there is. For testing/debugging.
/datum/reagent/medicine/adminordrazine/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.adjust_waterlevel(round(chems.get_reagent_amount(type) * 1))
		mytray.adjust_plant_health(round(chems.get_reagent_amount(type) * 1))
		mytray.adjust_pestlevel(-rand(1,5))
		mytray.adjust_weedlevel(-rand(1,5))
	if(chems.has_reagent(type, 3))
		switch(rand(100))
			if(66  to 100)
				mytray.mutatespecie()
			if(33 to 65)
				mytray.mutateweed()
			if(1   to 32)
				mytray.mutatepest(user)
			else if(prob(20))
				mytray.visible_message(span_warning("Nothing happens..."))

/datum/reagent/medicine/adminordrazine/affect_blood(mob/living/carbon/C, removed)
	C.heal_bodypart_damage(2 * removed, 2 * removed, FALSE)
	C.adjustToxLoss(-2 * removed, FALSE, TRUE)
	C.setOxyLoss(0, 0)
	C.setCloneLoss(0, 0)

	C.set_blurriness(0)
	C.set_blindness(0)
	C.SetKnockdown(0)
	C.SetStun(0)
	C.SetUnconscious(0)
	C.SetParalyzed(0)
	C.SetImmobilized(0)
	C.remove_status_effect(/datum/status_effect/confusion)
	C.SetSleeping(0)

	C.silent = FALSE
	C.remove_status_effect(/datum/status_effect/dizziness)
	C.disgust = 0
	C.drowsyness = 0
	// Remove all speech related status effects
	for(var/effect in typesof(/datum/status_effect/speech))
		C.remove_status_effect(effect)
	C.remove_status_effect(/datum/status_effect/jitter)
	C.hallucination = 0
	REMOVE_TRAITS_NOT_IN(C, list(SPECIES_TRAIT, ROUNDSTART_TRAIT, ORGAN_TRAIT))
	C.reagents.remove_all_type(/datum/reagent/toxin, 2 * removed, FALSE, TRUE)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.blood_volume = BLOOD_VOLUME_NORMAL

	C.cure_all_traumas(TRAUMA_RESILIENCE_MAGIC)
	for(var/obj/item/organ/organ as anything in C.processing_organs)
		organ.setOrganDamage(0)
	for(var/thing in C.diseases)
		var/datum/disease/D = thing
		if(D.severity == DISEASE_SEVERITY_POSITIVE)
			continue
		D.cure()
	..()
	. = TRUE

/datum/reagent/medicine/adminordrazine/quantum_heal
	name = "Quantum Medicine"
	description = "Rare and experimental particles, that apparently swap the user's body with one from an alternate dimension where it's completely healthy."
	taste_description = "science"

/* General medicine */

/datum/reagent/medicine/inaprovaline
	name = "Inaprovaline"
	description = "Inaprovaline is a multipurpose neurostimulant and cardioregulator. Commonly used to slow bleeding and stabilize patients."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00bfff"
	overdose_threshold = 60
	metabolization_rate = 0.1
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.5

/datum/reagent/medicine/inaprovaline/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	APPLY_CHEM_EFFECT(C, CE_STABLE, 1)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 10)

/datum/reagent/medicine/inaprovaline/overdose_start(mob/living/carbon/C)
	C.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/inaprovaline)

/datum/reagent/medicine/inaprovaline/overdose_end(mob/living/carbon/C)
	C.remove_movespeed_modifier(/datum/movespeed_modifier/inaprovaline)

/datum/reagent/medicine/inaprovaline/overdose_process(mob/living/carbon/C)
	if(prob(5))
		C.set_slurring_if_lower(10 SECONDS)
	if(prob(2))
		C.adjust = max(C.drowsyness, 5)

/datum/reagent/medicine/bicaridine
	name = "Bicaridine"
	description = "Bicaridine is a fast-acting medication to treat physical trauma."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#bf0000"
	overdose_threshold = 30
	scannable = 1
	value = 4.9

/datum/reagent/medicine/bicaridine/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.heal_overall_damage(6 * removed, updating_health = FALSE)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 10)
	return TRUE

/datum/reagent/medicine/bicaridine/overdose_process(mob/living/M)
	APPLY_CHEM_EFFECT(M, CE_BLOCKAGE, (15 + volume - overdose_threshold)/100)
	var/mob/living/carbon/human/H = M
	for(var/obj/item/bodypart/E as anything in H.bodyparts)
		if((E.bodypart_flags & ORGAN_ARTERY_CUT) && prob(2))
			E.bodypart_flags &= ~ORGAN_ARTERY_CUT

/datum/reagent/medicine/kelotane
	name = "Kelotane"
	description = "Kelotane is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffa800"
	overdose_threshold = 30
	scannable = 1
	value = 2.9

/datum/reagent/medicine/kelotane/affect_blood(mob/living/carbon/C, removed)
	C.heal_overall_damage(0, 6 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/medicine/dermaline
	name = "Dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#ff8000"
	overdose_threshold = 15
	scannable = 1
	value = 3.9

/datum/reagent/medicine/dermaline/affect_blood(mob/living/carbon/C, removed)
	C.heal_overall_damage(0, 12 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/medicine/dylovene
	name = "Dylovene"
	description = "Dylovene is a broad-spectrum antitoxin used to neutralize poisons before they can do significant harC."
	taste_description = "a roll of gauze"
	reagent_state = LIQUID
	color = "#00a000"
	scannable = 1
	value = 2.1

	var/remove_generic = 1
	var/list/remove_toxins = list(
		/datum/reagent/toxin/zombiepowder
	)

/datum/reagent/medicine/dylovene/affect_blood(mob/living/carbon/C, removed)
	if(remove_generic)
		C.drowsyness = max(0, C.drowsyness - 6 * removed)
		//C.adjust_hallucination(-9 * removed)
		APPLY_CHEM_EFFECT_UP_TO(C, CE_ANTITOX, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = C.get_ingested_reagents()
	for(var/datum/reagent/R in ingested.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			ingested.remove_reagent(R.type, removing)
			return
	for(var/datum/reagent/R in C.reagents.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			C.reagents.remove_reagent(R.type, removing)
			return

/datum/reagent/medicine/dexalin
	name = "Dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080ff"
	overdose_threshold = 30
	scannable = 1
	value = 2.4

/datum/reagent/medicine/dexalin/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_OXYGENATED, 1)
	holder.remove_reagent(/datum/reagent/medicine/lexorin, 2 * removed)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0040ff"
	overdose_threshold =15
	scannable = 1
	value = 3.7

/datum/reagent/dexalinp/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_OXYGENATED, 2)
	holder.remove_reagent(/datum/reagent/lexorin, 3 * removed)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#8040ff"
	scannable = 1
	value = 6

/datum/reagent/tricordrazine/affect_blood(mob/living/carbon/C, removed)
	M.heal_overall_damage(3 * removed, 3 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#8080ff"
	metabolization_rate = 0.1
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.9

/datum/reagent/cryoxadone/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_CRYO, 1)
	if(!(M.bodytemperature < 170))
		return

	M.adjustCloneLoss(-100 * removed, FALSE)
	APPLY_CHEM_EFFECT(C, CE_OXYGENATED, 1)
	M.heal_overall_damage(30 * removed, 30 * removed, updating_health = FALSE)
	APPLY_CHEM_EFFECT(C, CE_PULSE, -2)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I as anything in H.processing_organs)
			if(!(I.status & ORGAN_ROBOTIC))
				I.applyOrganDamage(-20*removed)
	return TRUE


/datum/reagent/clonexadone
	name = "Clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#80bfff"
	metabolization_rate = 0.1
	scannable = 1
	heating_products = list(/datum/reagent/cryoxadone, /datum/reagent/sodium)
	heating_point = 50 CELSIUS
	heating_message = "turns back to sludge."
	value = 5.5

/datum/reagent/clonexadone/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-300 * removed, FALSE)
		APPLY_CHEM_EFFECT(C, CE_OXYGENATED, 2)
		M.heal_organ_damage(50 * removed, 50 * removed, updating_health = FALSE)
		APPLY_CHEM_EFFECT(C, CE_PULSE, -2)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/I as anything in H.processing_organs)
				if(!(I.status & ORGAN_ROBOTIC))
					I.applyOrganDamage(-30*removed)
		return TRUE

/* Painkillers */

/datum/reagent/paracetamol
	name = "Paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "sickness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose_threshold =60
	reagent_state = LIQUID
	scannable = 1
	metabolization_rate = 0.02
	flags = IGNORE_MOB_SIZE
	value = 3.3

/datum/reagent/paracetamol/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 35)

/datum/reagent/paracetamol/overdose_process(mob/living/carbon/C)
	APPLY_CHEM_EFFECT(C, CE_TOXIN, 1)
	C.set_timed_status_effect(4 SECONDS, /datum/status_effect/drugginess, only_if_higher = TRUE)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 10)

/datum/reagent/tramadol
	name = "Tramadol"
	description = "A simple, yet effective painkiller. Don't mix with alcohol."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#cb68fc"
	overdose_threshold =30
	scannable = 1
	metabolization_rate = 0.05
	ingest_met = 0.02
	flags = IGNORE_MOB_SIZE
	value = 3.1
	var/pain_power = 80 //magnitide of painkilling effect
	var/effective_dose = 0.5 //how many units it need to process to reach max power

/datum/reagent/tramadol/affect_blood(mob/living/carbon/C, removed)
	var/effectiveness = 1

	if(volume < effective_dose)
		effectiveness = volume/effective_dose

	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, pain_power * effectiveness)

	if(full_volume > overdose)
		C.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/tramadol)
		C.set_slurring_if_lower(60 SECONDS)
		if(prob(1))
			M.Knockdown(2 SECONDS)
			M.drowsyness = max(M.drowsyness, 5)

	else if(full_volume > 0.75 * overdose)
		C.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/tramadol)
		if(prob(5))
			C.set_slurring_if_lower(40 SECONDS)

	else if(full_volume > 0.5 * overdose)
		C.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/tramadol)
		if(prob(1))
			C.set_slurring_if_lower(20 SECONDS)

	else
		C.remove_movespeed_modifier(/datum/movespeed_modifier/tramadol)

	var/boozed = isboozed(M)
	if(boozed)
		APPLY_CHEM_EFFECT(C, CE_ALCOHOL_TOXIC, 1)
		APPLY_CHEM_EFFECT(C, CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard

/datum/reagent/tramadol/on_mob_end_metabolize(mob/living/L)
	C.remove_movespeed_modifier(/datum/movespeed_modifier/tramadol)

/datum/reagent/tramadol/overdose_process(mob/living/carbon/C)
	M.hallucination(120, 30)
	C.set_timed_status_effect(20 SECONDS, /datum/status_effect/drugginess, only_if_higher = TRUE)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, pain_power*0.5) //extra painkilling for extra trouble
	APPLY_CHEM_EFFECT(C, CE_BREATHLOSS, 0.6) //Have trouble breathing, need more air
	if(isboozed(M))
		APPLY_CHEM_EFFECT(C, CE_BREATHLOSS, 0.2) //Don't drink and OD on opiates folks

/datum/reagent/tramadol/proc/isboozed(mob/living/carbon/C)
	. = 0
	var/datum/reagents/ingested = C.get_ingested_reagents()
	if(!ingested)
		return
	var/list/pool = C.reagents.reagent_list | ingested.reagent_list
	for(var/datum/reagent/ethanol/booze in pool)
		if(M.volume < 2) //let them experience false security at first
			continue
		. = 1
		if(booze.strength < 40) //liquor stuff hits harder
			return 2

/datum/reagent/tramadol/oxycodone
	name = "Oxycodone"
	description = "An effective and very addictive painkiller. Don't mix with alcohol."
	taste_description = "bitterness"
	color = "#800080"
	scannable = 1
	overdose_threshold =20
	pain_power = 200
	effective_dose = 2

/datum/reagent/deletrathol
	name = "Deletrathol"
	description = "An effective painkiller that causes confusion."
	taste_description = "confusion"
	color = "#800080"
	reagent_state = LIQUID
	overdose_threshold =15
	scannable = 1
	metabolization_rate = 0.02

/datum/reagent/deletrathol/on_mob_metabolize(mob/living/L)
	L.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/deletrathol)

/datum/reagent/deletrathol/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/deletrathol)

/datum/reagent/deletrathol/affect_blood(mob/living/carbon/human/H, removed)
	H.add_chemical_effect(CE_PAINKILLER, 80)
	//H.make_dizzy(2)
	if(prob(75))
		H.drowsyness++
	if(prob(25))
		H.adjust_confusion(2 SECONDS)

/datum/reagent/deletrathol/overdose_process(mob/living/carbon/C)
	C.set_timed_status_effect(4 SECONDS, /datum/status_effect/drugginess, only_if_higher = TRUE)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 10)

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	description = "Synaptizine is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99ccff"
	metabolization_rate = 0.01
	overdose_threshold = 5
	scannable = 1
	value = 4.6

/datum/reagent/synaptizine/affect_blood(mob/living/carbon/C, removed)
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent(/datum/reagent/drugs/mindbreaker, 5)
	M.adjust_hallucination(-10)
	APPLY_CHEM_EFFECT(C, CE_MIND, 2)
	M.adjustToxLoss(5 * removed, updating_health = FALSE) // It used to be incredibly deadly due to an oversight. Not anymore!
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 20)
	APPLY_CHEM_EFFECT(C, CE_STIMULANT, 10)
	return TRUE

/datum/reagent/dylovene/venaxilin
	name = "Venaxilin"
	description = "Venixalin is a strong, specialised antivenom for dealing with advanced toxins and venoms."
	taste_description = "overpowering sweetness"
	color = "#dadd98"
	scannable = 1
	metabolization_rate = 0.4
	remove_generic = 0
	remove_toxins = list(
		/datum/reagent/toxin/venom,
		/datum/reagent/toxin/carpotoxin
	)

/datum/reagent/alkysine
	name = "Alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a injury. Can aid in healing brain tissue."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffff66"
	metabolization_rate = 0.05
	overdose_threshold =30
	scannable = 1
	value = 5.9

/datum/reagent/alkysine/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 10)
	APPLY_CHEM_EFFECT(C, CE_BRAIN_REGEN, 1)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.adjust_confusion(2 SECONDS)
		H.drowsyness++

/datum/reagent/imidazoline
	name = "Imidazoline"
	description = "Heals eye damage"
	taste_description = "dull toxin"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose_threshold =30
	scannable = 1
	value = 4.2

/datum/reagent/imidazoline/affect_blood(mob/living/carbon/C, removed)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.eye_blind = max(M.eye_blind - 5, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES)
		if(istype(E) && E.damage > 0)
			E.damage = max(E.damage - 5 * removed, 0)

/datum/reagent/peridaxon
	name = "Peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561ec3"
	metabolization_rate = 0.1
	overdose_threshold =10
	scannable = 1
	value = 6

/datum/reagent/peridaxon/affect_blood(mob/living/carbon/C, removed)
	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = C
	for(var/obj/item/organ/I in H.processing_organs)
		if(!(I.status & ORGAN_ROBOTIC))
			if(I.organ_tag == BP_BRAIN)
				// if we have located an organic brain, apply side effects
				H.adjust_confusion(2 SECONDS)
				H.drowsyness++
				// peridaxon only heals minor brain damage
				if(I.damage >= I.min_bruised_damage)
					continue
			I.applyOrganDamage(-3 * removed)

/datum/reagent/hyperzine
	name = "Hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#ff3300"
	metabolization_rate = 0.03
	overdose_threshold =15
	value = 3.9

/datum/reagent/hyperzine/affect_blood(mob/living/carbon/C, removed)
	if(prob(5))
		spawn(-1)
			C.emote(pick("twitch", "blink_r", "shiver"))
	APPLY_CHEM_EFFECT(C, CE_SPEEDBOOST, 1)
	APPLY_CHEM_EFFECT(C, CE_PULSE, 3)
	APPLY_CHEM_EFFECT(C, CE_STIMULANT, 4)
