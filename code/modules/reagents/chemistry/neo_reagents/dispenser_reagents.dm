/datum/reagent/acetone
	name = "Acetone"
	description = "A colorless liquid solvent used in chemical synthesis."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#808080"
	metabolization_rate = 0.04
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/acetone/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(removed * 3, FALSE)
	return TRUE

/datum/reagent/acetone/expose_obj(obj/exposed_obj, reac_volume, exposed_temperature)
	. = ..()
	if(istype(exposed_obj, /obj/item/paper))
		var/obj/item/paper/paperaffected = exposed_obj
		paperaffected.clearpaper()
		to_chat(usr, span_notice("The solution dissolves the ink on the paper."))
		return

/datum/reagent/aluminium
	name = "Aluminium"
	taste_description = "metal"
	taste_mult = 1.1
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#a8a8a8"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/ammonia
	name = "Ammonia"
	taste_description = "mordant"
	taste_mult = 2
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = LIQUID
	color = "#404030"
	metabolization_rate = 0.1
	overdose_threshold = 5
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/ammonia/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(removed * 1.5, FALSE)
	return TRUE

/datum/reagent/ammonia/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(0.5, FALSE)
	return TRUE

/datum/reagent/carbon
	name = "Carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#1c1300"
	ingest_met = 2
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/carbon/affect_ingest(mob/living/carbon/C, removed)
	. = ..()
	var/datum/reagents/ingested = C.get_ingested_reagents()
	if (ingested && length(ingested.reagent_list) > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (length(ingested.reagent_list) - 1)
		for(var/datum/reagent/R in ingested.reagent_list)
			if(R == src)
				continue
			ingested.remove_reagent(R.type, removed * effect)

/datum/reagent/carbon/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, exposed_turf)
	if (!dirtoverlay)
		dirtoverlay = new/obj/effect/decal/cleanable/dirt(exposed_turf)
		dirtoverlay.alpha = reac_volume * 30
	else
		dirtoverlay.alpha = min(dirtoverlay.alpha + reac_volume * 30, 255)

/datum/reagent/copper
	name = "Copper"
	description = "A highly ductile metal."
	taste_description = "copper"
	color = "#6e3b08"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/hydrazine
	name = "Hydrazine"
	description = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate forC."
	taste_description = "sweet tasting metal"
	reagent_state = LIQUID
	color = "#808080"
	metabolization_rate = 0.04
	touch_met = 5
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/hydrazine/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(4 * removed, FALSE)
	return TRUE

/datum/reagent/hydrazine/affect_touch(mob/living/carbon/C, removed) // Hydrazine is both toxic and flammable.
	C.adjust_fire_stacks(removed / 12)
	C.adjustToxLoss(0.2 * removed, FALSE)
	return TRUE

/datum/reagent/hydrazine/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	//new /obj/effect/decal/cleanable/liquid_fuel(T, volume)

/datum/reagent/iron
	name = "Iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#353535"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/iron/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.blood_volume = max(C.blood_volume + (2 * removed), BLOOD_VOLUME_MAX_LETHAL)

/datum/reagent/lithium
	name = "Lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#808080"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/lithium/affect_blood(mob/living/carbon/C, removed)
	if(!isspaceturf(C.loc))
		step(C, GLOB.cardinals)

	if(prob(5))
		spawn(-1)
			C.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = LIQUID
	color = "#484848"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/mercury/affect_blood(mob/living/carbon/C, removed)
	if(!isspaceturf(C.loc))
		step(C, pick(GLOB.cardinals))
	if(prob(5))
		spawn(-1)
			C.emote(pick("twitch", "drool", "moan"))
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.1 * removed)

/datum/reagent/phosphorus
	name = "Phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = SOLID
	color = "#832828"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/potassium
	name = "Potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = SOLID
	color = "#a0a0a0"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/potassium/affect_blood(mob/living/carbon/C, removed)
	if(volume > 10)
		APPLY_CHEM_EFFECT(C, CE_PULSE, 2)
	else if(volume > 3)
		APPLY_CHEM_EFFECT(C, CE_PULSE, 1)

/datum/reagent/radium
	name = "Radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_description = "the color blue, and regret"
	reagent_state = SOLID
	color = "#c7c7c7"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/radium/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(10 * removed, FALSE)
	return TRUE

/datum/reagent/radium/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(reac_volume >= 3)
		if(!isspaceturf(exposed_turf))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, exposed_turf)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(exposed_turf)
			return

/datum/reagent/toxin/acid
	name = "Sulphuric Acid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#db5008"
	metabolization_rate = 0.4
	touch_met = 50 // It's acid!
	var/acidpwr = 10
	var/meltdose = 20 // How much is needed to melt
	var/max_damage = 40
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/toxin/acid/affect_blood(mob/living/carbon/C, removed)
	C.adjustFireLoss(removed * acidpwr, FALSE)
	return TRUE

/datum/reagent/toxin/acid/affect_touch(mob/living/carbon/C, removed) // This is the most interesting
	C.acid_act(acidpwr, removed)

/datum/reagent/toxin/acid/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	reac_volume = round(reac_volume,0.1)
	if(methods & INGEST)
		exposed_mob.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr))
		return
	if(methods & INJECT)
		exposed_mob.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr))
		return
	exposed_mob.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(ismob(exposed_obj.loc)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	exposed_obj.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if (!istype(exposed_turf))
		return
	reac_volume = round(reac_volume,0.1)
	exposed_turf.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	description = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#808080"
	toxpwr = 3
	meltdose = 8
	max_damage = 30
	value = DISPENSER_REAGENT_VALUE * 2

/datum/reagent/silicon
	name = "Silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#a8a8a8"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/sodium
	name = "Sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	reagent_state = SOLID
	color = "#808080"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/sulfur
	name = "Sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = SOLID
	color = "#bf8c00"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/tungsten
	name = "Tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	reagent_state = SOLID
	color = "#dcdcdc"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/oxygen
	name = "Oxygen"
	description = "A colorless, odorless gas. Grows on trees but is still pretty valuable."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0 // oderless and tasteless
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/oxygen/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(isopenturf(exposed_turf))
		exposed_turf.atmos_spawn_air(GAS_OXYGEN, reac_volume/20, exposed_temperature || T20C)

