//Apparently on TG, N2O fluid doesn't make you giggle, so this is almost an exact copy.
/datum/reagent/nitrous_oxide/xenon
	name = "Xenon"
	description = "A nontoxic gas used as a general anaesthetic."
	reagent_state = GAS
	metabolization_rate = 0.3 * REAGENTS_METABOLISM
	color = "#808080"
	taste_description = "sweetness"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/carbon_monoxide
	name = "Carbon Monoxide"
	description = "A dangerous carbon comubstion byproduct."
	taste_description = "stale air"
	color = "#808080"
	metabolization_rate = 0.3 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/carbon_monoxide/affect_blood(mob/living/carbon/M, removed)
	. = ..()
	var/warning_message
	var/warning_prob = 10
	if(volume >= 3)
		warning_message = pick("extremely dizzy","short of breath","faint","confused")
		warning_prob = 15
		M.adjustOxyLoss(rand(10,20), FALSE)
		. = TRUE
		M.throw_alert(ALERT_TOO_MUCH_CO2, /atom/movable/screen/alert/too_much_co2, override = TRUE)
	else if(volume >= 1.5)
		warning_message = pick("dizzy","short of breath","faint","momentarily confused")
		M.throw_alert(ALERT_TOO_MUCH_CO2, /atom/movable/screen/alert/too_much_co2, override = TRUE)
		M.adjustOxyLoss(rand(3,5), FALSE)
		. = TRUE
	else if(volume >= 0.25)
		warning_message = pick("a little dizzy","short of breath")
		warning_prob = 10
	if(warning_message && prob(warning_prob))
		to_chat(M, "<span class='warning'>You feel [warning_message].</span>")

/datum/reagent/carbon_monoxide/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.clear_alert(ALERT_TOO_MUCH_CO2, clear_override = TRUE)

/datum/reagent/toxin/boron
	name = "Boron"
	description = "A chemical that is highly valued for its potential in fusion energy."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#837e79"
	toxpwr = 7

/datum/reagent/toxin/radon
	name = "Radon"
	description = "A chemical that causes acute lung tumors to develop."
	taste_description = null
	reagent_state = LIQUID
	toxpwr = 2
	taste_mult = 0

/datum/reagent/toxin/radon/affect_blood(mob/living/carbon/M, removed)
	. = ..()
	var/obj/item/organ/lungs/lungs = M.getorganslot(ORGAN_SLOT_LUNGS)
	if(isnull(lungs))
		return

	lungs.applyOrganDamage(2 * removed, updating_health = FALSE)
	return TRUE
