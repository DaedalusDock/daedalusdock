/datum/reagent/ichor
	name = "Ichor"
	description = "The blood of gods."
	color = "#ffe346"
	taste_description = "vomit"
	taste_mult = 2
	harmful = TRUE

/datum/reagent/ichor/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(2 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/tincture
	abstract_type = /datum/reagent/tincture
	name = "Tincture"
	ingest_met = 1

/datum/reagent/tincture/proc/get_effectiveness_mod()
	var/potency = data?["potency"]
	if(isnull(potency))
		return 0.2

	return round(potency / POTENCY_SCALE_AT_100, 0.1)

/datum/reagent/tincture/woundseal
	name = "Woundseal"
	description = "An herbal tincture for mending wounds."
	color = "#310505"
	taste_description = "sickly sweetness"
	taste_mult = 2

/datum/reagent/tincture/woundseal/affect_ingest(mob/living/carbon/C, removed)
	var/effectiveness = get_effectiveness_mod()
	C.adjustBloodVolume(-0.5 * effectiveness * removed)
	. = C.adjustBruteLoss(-2 * effectiveness * removed, updating_health = FALSE)
	return ..() || .

/datum/reagent/tincture/burnboil
	name = "Burnboil"
	description = "An herbal tincture for mending wounds."
	color = "#494617"
	taste_description = "tartness"
	taste_mult = 2

/datum/reagent/tincture/burnboil/affect_ingest(mob/living/carbon/C, removed)
	var/effectiveness = get_effectiveness_mod()
	C.adjustToxLoss(0.4 * effectiveness * removed)
	. = C.adjustFireLoss(-3 * effectiveness * removed, updating_health = FALSE)
	return ..() || .

/datum/reagent/tincture/siphroot
	name = "Siphroa"
	description = "An herbal tincture for restoring blood."
	color = "#2c041b"
	taste_description = "a horrible sourness"
	taste_mult = 2

/datum/reagent/tincture/siphroot/affect_ingest(mob/living/carbon/C, removed)
	var/effectiveness = get_effectiveness_mod()
	C.adjustBloodVolumeUpTo(2 * effectiveness * removed, BLOOD_VOLUME_NORMAL + 100)
	C.adjustToxLoss(1 * effectiveness * removed, updating_health = FALSE)
	return ..()

/datum/reagent/tincture/calomel
	name = "Gutclean"
	description = "An herbal tincture for expelling fluid from the body."
	color = "#13042c"
	taste_description = "thousands of microscopic blades"
	taste_mult = 2

/datum/reagent/tincture/calomel/affect_ingest(mob/living/carbon/C, removed)
	C.adjustToxLoss(0.2 * removed)
	purge_others(C.bloodstream, 3 * removed)

	var/datum/reagents/ingested = C.get_ingested_reagents()
	if(ingested)
		purge_others(ingested, 3 * removed)

	if(prob(12))
		C.vomit(8, blood = (C.nutrition == 0))

	return ..()
