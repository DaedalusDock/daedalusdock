/datum/reagent/water
	name = "Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen."
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "water"
	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = "The father of all refreshments."
	shot_glass_icon_state = "shotglassclear"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS

	metabolization_rate = 2


/*
 * Water reaction to turf
 */

/datum/reagent/water/expose_turf(turf/open/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(!istype(exposed_turf))
		return

	if(reac_volume >= 5)
		exposed_turf.MakeSlippery(TURF_WET_WATER, 10 SECONDS, min(reac_volume*1.5 SECONDS, 60 SECONDS))

	for(var/mob/living/simple_animal/slime/exposed_slime in exposed_turf)
		exposed_slime.apply_water()

	qdel(exposed_turf.fire)
	if(exposed_turf.simulated)
		var/datum/gas_mixture/air = exposed_turf.return_air()
		var/adjust_temp = abs(air.temperature - exposed_temperature) / air.group_multiplier
		if(air.temperature > exposed_temperature)
			adjust_temp *= -1
		air.temperature = max(air.temperature + adjust_temp, TCMB)

/*
 * Water reaction to an object
 */

/datum/reagent/water/expose_obj(obj/exposed_obj, reac_volume, exposed_temperature)
	. = ..()
	exposed_obj.extinguish()
	exposed_obj.wash(CLEAN_TYPE_ACID)
	// Monkey cube
	if(istype(exposed_obj, /obj/item/food/monkeycube))
		var/obj/item/food/monkeycube/cube = exposed_obj
		cube.Expand()

	// Dehydrated carp
	else if(istype(exposed_obj, /obj/item/toy/plush/carpplushie/dehy_carp))
		var/obj/item/toy/plush/carpplushie/dehy_carp/dehy = exposed_obj
		dehy.Swell() // Makes a carp

	else if(istype(exposed_obj, /obj/item/stack/sheet/hairlesshide))
		var/obj/item/stack/sheet/hairlesshide/HH = exposed_obj
		new /obj/item/stack/sheet/wethide(get_turf(HH), HH.amount)
		qdel(HH)

/// How many wet stacks you get per units of water when it's applied by touch.
#define WATER_TO_WET_STACKS_FACTOR_TOUCH 0.5
/// How many wet stacks you get per unit of water when it's applied by vapor. Much less effective than by touch, of course.
#define WATER_TO_WET_STACKS_FACTOR_VAPOR 0.1
/*
 * Water reaction to a mob
 */
/datum/reagent/water/expose_mob(mob/living/exposed_mob, exposed_temperature, reac_volume, methods=TOUCH)
	. = ..()
	if(methods & TOUCH)
		exposed_mob.adjust_wet_stacks(reac_volume * WATER_TO_WET_STACKS_FACTOR_TOUCH) // Water makes you wet, at a 50% water-to-wet-stacks ratio. Which, in turn, gives you some mild protection from being set on fire!

		if(ishuman(exposed_mob))
			var/mob/living/carbon/human/H = exposed_mob
			var/obj/item/clothing/mask/cigarette/S = H.wear_mask
			if (istype(S) && S.lit)
				var/obj/item/clothing/C = H.head
				if (!istype(C) || !(C.flags_cover & HEADCOVERSMOUTH))
					S.extinguish()

	if(methods & VAPOR)
		exposed_mob.adjust_wet_stacks(reac_volume * WATER_TO_WET_STACKS_FACTOR_VAPOR) // Spraying someone with water with the hope to put them out is just simply too funny to me not to add it.

/datum/reagent/water/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(C.blood_volume)
		C.blood_volume += 0.05 * removed

#undef WATER_TO_WET_STACKS_FACTOR_TOUCH
#undef WATER_TO_WET_STACKS_FACTOR_VAPOR

///For weird backwards situations where water manages to get added to trays nutrients, as opposed to being snowflaked away like usual.
/datum/reagent/water/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray)
	if(chems.has_reagent(src.type, 1))
		mytray.adjust_waterlevel(round(chems.get_reagent_amount(src.type) * 1))
		//You don't belong in this world, monster!
		chems.remove_reagent(/datum/reagent/water, chems.get_reagent_amount(src.type))

/datum/reagent/water/holywater
	name = "Holy Water"
	description = "Water blessed by some deity."
	color = "#E0E8EF" // rgb: 224, 232, 239
	glass_icon_state = "glass_clear"
	glass_name = "glass of holy water"
	glass_desc = "A glass of holy water."
	self_consuming = TRUE //divine intervention won't be limited by the lack of a liver
	ph = 7.5 //God is alkaline
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS

	// Holy water. Mostly the same as water, it also heals the plant a little with the power of the spirits. Also ALSO increases instability.
/datum/reagent/water/holywater/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray)
	if(chems.has_reagent(type, 1))
		mytray.adjust_waterlevel(round(chems.get_reagent_amount(type) * 1))
		mytray.adjust_plant_health(round(chems.get_reagent_amount(type) * 0.1))
		if(myseed)
			myseed.adjust_instability(round(chems.get_reagent_amount(type) * 0.15))

/datum/reagent/water/holywater/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_HOLY, type)

/datum/reagent/water/holywater/on_mob_add(mob/living/L, amount)
	. = ..()
	if(data)
		data["misc"] = 0

/datum/reagent/water/holywater/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_HOLY, type)
	..()

/datum/reagent/water/holywater/expose_mob(mob/living/exposed_mob, exposed_temperature, reac_volume, methods=TOUCH)
	. = ..()
	if(IS_CULTIST(exposed_mob))
		to_chat(exposed_mob, span_userdanger("A vile holiness begins to spread its shining tendrils through your mind, purging the Geometer of Blood's influence!"))

/datum/reagent/water/holywater/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(!data)
		data = list("misc" = 0)

	data["misc"] += 1 SECONDS * removed
	C.adjust_timed_status_effect(1 SECONDS * removed, /datum/status_effect/jitter, max_duration = 20 SECONDS)
	if(IS_CULTIST(M))
		for(var/datum/action/innate/cult/blood_magic/BM in C.actions)
			to_chat(M, span_cultlarge("Your blood rites falter as holy water scours your body!"))
			for(var/datum/action/innate/cult/blood_spell/BS in BC.spells)
				qdel(BS)
	if(data["misc"] >= (10 SECONDS))
		C.adjust_timed_status_effect(1 SECONDS * removed, /datum/status_effect/speech/stutter, max_duration = 20 SECONDS)
		C.set_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)
		if(IS_CULTIST(M) && prob(5))
			C.say(pick("Av'te Nar'Sie","Pa'lid Mors","INO INO ORA ANA","SAT ANA!","Daim'niodeis Arc'iai Le'eones","R'ge Na'sie","Diabo us Vo'iscum","Eld' Mon Nobis"), forced = "holy water")
			if(prob(10))
				C.visible_message(span_danger("[M] starts having a seizure!"), span_userdanger("You have a seizure!"))
				C.Unconscious(12 SECONDS)
				to_chat(M, "<span class='cultlarge'>[pick("Your blood is your bond - you are nothing without it", "Do not forget your place", \
				"All that power, and you still fail?", "If you cannot scour this poison, I shall scour your meager life!")].</span>")

	if(data["misc"] >= (30 SECONDS))
		if(IS_CULTIST(M))
			C.mind.remove_antag_datum(/datum/antagonist/cult)
			C.Unconscious(10 SECONDS)
		C.remove_status_effect(/datum/status_effect/jitter)
		C.remove_status_effect(/datum/status_effect/speech/stutter)
		holder.remove_reagent(type, volume) // maybe this is a little too perfect and a max() cap on the statuses would be better??
		return
	#warn TEST HOLYWATER

/datum/reagent/water/holywater/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(reac_volume >= 10)
		for(var/obj/effect/rune/R in exposed_turf)
			qdel(R)
		exposed_turf.Bless()

/datum/reagent/water/hollowwater
	name = "Hollow Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen, but it looks kinda hollow."
	color = "#88878777"
	taste_description = "emptyiness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
