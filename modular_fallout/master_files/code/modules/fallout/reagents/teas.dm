//fallout teas

/datum/reagent/consumable/tea/agavetea
	name = "Agave Tea"
	description = "A soothing herbal rememedy steeped from the Agave Plant. Inhibits increased healing of burns and sores."
	color = "#FFFF91"
	nutriment_factor = 0
	taste_description = "bitterness"
	glass_icon_state = "tea"
	glass_name = "Agave Tea"
	glass_desc = "A soothing herbal rememedy steeped from the Agave Plant. Inhibits increased healing of burns and sores."

/datum/reagent/consumable/tea/agavetea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustFireLoss(-3*removed, 0)
	C.nutrition = max(C.nutrition - 3, 0)
	C.remove_status_effect(/datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-1)
	C.adjust_timed_status_effect(-2 SECONDS * removed, /datum/status_effect/jitter)
	C.AdjustSleeping(-20, FALSE)
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1, 0)
	C.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/tea/broctea
	name = "Broc Tea"
	description = "A soothing herbal rememedy steeped from the Broc Flower. Increases the clearance and flow of airways."
	color = "#FF6347"
	nutriment_factor = 0
	taste_description = "bitterness"
	glass_icon_state = "tea"
	glass_name = "Broc Tea"
	glass_desc = "A soothing herbal rememedy steeped from the Broc Flower. Increases the clearance and flow of airways."

/datum/reagent/consumable/tea/broctea/affect_ingest(mob/living/carbon/C, removed)
	C.adjustOxyLoss(-4*removed, 0)
	C.nutrition = max(C.nutrition - 3, 0)
	C.adjust_timed_status_effect(-2 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-1)
	C.adjust_timed_status_effect(-3 SECONDS * removed, /datum/status_effect/jitter)
	C.AdjustSleeping(-20, FALSE)
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1, 0)
	C.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/tea/coyotetea
	name = "Coyote Tea"
	description = "A smokey herbal rememedy steeped from coyote tobacco stems. Natural caffeines keep the drinker alert and awake while numbing the senses."
	color = "#008000"
	nutriment_factor = 0
	taste_description = "smoke"
	glass_icon_state = "coyotetea"
	glass_name = "Coyote Tea"
	glass_desc = "A smokey herbal rememedy steeped from coyote tobacco stems. Natural caffeines keep the drinker alert and awake while numbing the senses."

/datum/reagent/consumable/tea/coyotetea/affect_ingest(mob/living/carbon/C, removed)
	if(prob(10))
		var/smoke_message = pick("You feel relaxed.", "You feel calmed.","You feel alert.","You feel rugged.")
		to_chat(C, "<span class='notice'>[smoke_message]</span>")
	C.AdjustStun(-40, 0)
	C.AdjustKnockdown(-40, 0)
	C.AdjustUnconscious(-40, 0)
	C.stamina.adjust(2 * removed, 0)
	C.adjust_timed_status_effect(-2 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-1)
	C.adjust_timed_status_effect(-3 SECONDS * removed, /datum/status_effect/jitter)
	C.AdjustSleeping(-20, FALSE)
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1, 0)
	C.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/tea/feratea
	name = "Barrel Tea"
	description = "A sour and dry rememedy steeped from barrel cactus fruit. Detoxifies the user through natural filteration and dehydration."
	color = "#FF6347"
	nutriment_factor = 0
	taste_description = "bitterness"
	glass_icon_state = "tea"
	glass_name = "Barrel Tea"
	glass_desc = "A sour and dry rememedy steeped from barrel cactus fruit. Detoxifies the user through natural filteration and dehydration."

/datum/reagent/consumable/tea/feratea/affect_ingest(mob/living/carbon/C, removed)
	if(prob(80))
		C.adjust_timed_status_effect(-2 SECONDS * removed, /datum/status_effect/dizziness)
		C.remove_status_effect(/datum/status_effect/jitter)
	for(var/datum/reagent/R in C.reagents.reagent_list)
		if(R != src)
			C.reagents.remove_reagent(R.type,2.5)
	if(C.health > 20)
		C.adjustToxLoss(-3*removed, 0)
		. = TRUE
//	C.radiation += 0.1
#warn fix this!
	C.adjust_timed_status_effect(-2 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-1)
	C.adjust_timed_status_effect(-3 SECONDS * removed, /datum/status_effect/jitter)
	C.AdjustSleeping(-20, FALSE)
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1, 0)
	C.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/tea/pricklytea
	name = "Prickly Tea"
	description = "A sweet and fruitfel rememedy steeped from barrel cactus fruit. Keeps you on edge."
	color = "#FF6347"
	nutriment_factor = 0
	taste_description = "sweetness"
	glass_icon_state = "cafe_latte"
	glass_name = "Prickly Tea"
	glass_desc = "A sour and dry rememedy steeped from barrel cactus fruit. Keeps you on edge."

/datum/reagent/consumable/tea/pricklytea/affect_ingest(mob/living/carbon/C, removed)
	if(prob(33))
		C.adjust_timed_status_effect(2 SECONDS * removed, /datum/status_effect/dizziness)
		C.apply_status_effect(/datum/status_effect/jitter)
	..()
	C.adjust_timed_status_effect(-2 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-1)
	C.adjust_timed_status_effect(-3 SECONDS * removed, /datum/status_effect/jitter)
	C.AdjustSleeping(-20, FALSE)
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1, 0)
	C.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	..()
	. = TRUE

/datum/reagent/consumable/tea/xandertea
	name = "Xander Tea"
	description = "A engaging herbal rememedy steeped from blitzed Xander root. Detoxifies and replenishes the bodies blood supply."
	color = "#FF6347"
	nutriment_factor = 0
	taste_description = "earthy"
	glass_icon_state = "coffee"
	glass_name = "Xander Tea"
	glass_desc = "A engaging herbal rememedy steeped from blitzed Xander root. Detoxifies and replenishes the bodies blood supply."

/datum/reagent/consumable/tea/xandertea/affect_ingest(mob/living/carbon/C, removed)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.blood_volume = min(BLOOD_VOLUME_NORMAL, C.blood_volume + 3)
	C.adjustToxLoss(-4*removed, 0)
	C.adjust_timed_status_effect(-2 SECONDS * removed, /datum/status_effect/dizziness)
	C.drowsyness = max(0,C.drowsyness-1)
	C.adjust_timed_status_effect(-3 SECONDS * removed, /datum/status_effect/jitter)
	C.AdjustSleeping(-20, FALSE)
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1, 0)
	C.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	..()
	. = TRUE
