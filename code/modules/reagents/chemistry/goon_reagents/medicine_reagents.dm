/datum/reagent/medicine/antihol
	name = "Antihol"
	description = "Purges alcoholic substance from the patient's body and eliminates its side effects."
	color = "#00B4C8"
	taste_description = "raw egg"

/datum/reagent/medicine/antihol/affect_blood(mob/living/carbon/C, removed)
	C.remove_status_effect(/datum/status_effect/dizziness)
	C.set_drowsyness(0)
	C.remove_status_effect(/datum/status_effect/speech/slurring/drunk)
	C.remove_status_effect(/datum/status_effect/confusion)
	holder.remove_all_type(/datum/reagent/consumable/ethanol, 3 * removed, FALSE, TRUE)
	var/obj/item/organ/stomach = C.getorganslot(ORGAN_SLOT_STOMACH)
	if(stomach)
		stomach.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 3 * removed, FALSE, TRUE)
	C.adjustToxLoss(-0.2 * removed, 0)
	C.adjust_drunk_effect(-10 * removed)
	. = TRUE

/datum/reagent/medicine/strange_reagent
	name = "Strange Reagent"
	description = "A miracle drug capable of bringing the dead back to life. Works topically unless anotamically complex, in which case works orally. Only works if the target has less than 200 total brute and burn damage and hasn't been husked and requires more reagent depending on damage inflicted. Causes damage to the living."
	reagent_state = LIQUID
	color = "#A0E85E"
	metabolization_rate = 0.25
	taste_description = "magnets"
	harmful = TRUE

// FEED ME SEYMOUR
/datum/reagent/medicine/strange_reagent/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.spawnplant()

/datum/reagent/medicine/strange_reagent/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	if(exposed_mob.stat != DEAD)
		return ..()
	if(exposed_mob.suiciding) //they are never coming back
		exposed_mob.visible_message(span_warning("[exposed_mob]'s body does not react..."))
		return
	if(iscarbon(exposed_mob) && !(methods & INGEST)) //simplemobs can still be splashed
		return ..()
	var/amount_to_revive = round((exposed_mob.getBruteLoss()+exposed_mob.getFireLoss())/20)
	if(exposed_mob.getBruteLoss()+exposed_mob.getFireLoss() >= 200 || HAS_TRAIT(exposed_mob, TRAIT_HUSK) || reac_volume < amount_to_revive) //body will die from brute+burn on revive or you haven't provided enough to revive.
		exposed_mob.visible_message(span_warning("[exposed_mob]'s body convulses a bit, and then falls still once more."))
		exposed_mob.do_jitter_animation(10)
		return
	exposed_mob.visible_message(span_warning("[exposed_mob]'s body starts convulsing!"))
	exposed_mob.notify_ghost_revival("Your body is being revived with Strange Reagent!")
	exposed_mob.do_jitter_animation(10)
	var/excess_healing = 5*(reac_volume-amount_to_revive) //excess reagent will heal blood and organs across the board
	addtimer(CALLBACK(exposed_mob, TYPE_PROC_REF(/mob/living/carbon, do_jitter_animation), 10), 40) //jitter immediately, then again after 4 and 8 seconds
	addtimer(CALLBACK(exposed_mob, TYPE_PROC_REF(/mob/living/carbon, do_jitter_animation), 10), 80)
	addtimer(CALLBACK(exposed_mob, TYPE_PROC_REF(/mob/living, revive), FALSE, FALSE, excess_healing), 79)
	return ..()

/datum/reagent/medicine/strange_reagent/affect_blood(mob/living/carbon/C, removed)
	var/damage_at_random = rand(0, 250)/100 //0 to 2.5
	C.adjustBruteLoss(damage_at_random * removed, FALSE)
	C.adjustFireLoss(damage_at_random * removed, FALSE)
	. = TRUE

/datum/reagent/medicine/strange_reagent/affect_touch(mob/living/carbon/C, removed)
	holder.del_reagent(type)
