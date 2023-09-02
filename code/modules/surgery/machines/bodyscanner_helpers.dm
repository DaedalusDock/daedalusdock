/mob/living/carbon/human/proc/get_bodyscanner_data()
	RETURN_TYPE(/list)

	. = list()

	.["name"] = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE)) ? "Unknown" : name
	.["age"] = age
	.["time"] = stationtime2text("hh:mm")

	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(!B)
		.["brain_activity"] = -1
	else
		.["brain_activity"] = (B.maxHealth - B.damage) / B.maxHealth * 100


	.["blood_volume"] = blood_volume
	.["blood_volume_max"] = BLOOD_VOLUME_NORMAL
	.["blood_type"] = dna.blood_type
	.["temperature"] = round(bodytemperature, 0.1)
	.["dna"] = dna.unique_enzymes
	.["brute"] = getBruteLoss()
	.["burn"] = getFireLoss()
	.["toxin"] = getToxLoss()
	.["oxygen"] = getOxyLoss()
	.["genetic"] = getCloneLoss()
	.["radiation"] = HAS_TRAIT(src, TRAIT_IRRADIATED)
	.["husked"]  = HAS_TRAIT(src, TRAIT_HUSK)
	.["dna_ruined"] = HAS_TRAIT(src, TRAIT_BADDNA)
	.["cardiac_arrest"] = undergoing_cardiac_arrest()
	.["reagents"] = list()
	if(reagents.total_volume)
		for(var/datum/reagent/R in reagents.reagent_list)
			var/list/reagent = list()
			reagent["name"] = R.name
			reagent["quantity"] = round(R.volume, 1)
			reagent["visible"] = !(R.chemical_flags & REAGENT_INVISIBLE)
			reagent["overdosed"] = R.overdosed
			.["reagents"] += list(reagent)

	.["bodyparts"] = list()

	var/list/bodyparts = sort_list(src.bodyparts, GLOBAL_PROC_REF(cmp_bodyparts_display_order))
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		var/list/part = list()
		part["name"] = BP.plaintext_zone
		part["is_stump"] = BP.is_stump
		part["brute_ratio"] = BP.brute_ratio
		part["burn_ratio"] = BP.burn_ratio
		part["limb_flags"] = BP.bodypart_flags
		part["brute_dam"] = BP.brute_dam
		part["burn_dam"] = BP.burn_dam
		part["scan_results"] = BP.get_scan_results(TRUE)
		.["bodyparts"] += list(part)

	.["organs"] = list()

	for(var/obj/item/organ/O as anything in processing_organs)
		var/list/org = list()
		org["name"] = O.name
		org["damage_percent"] = O.damage / O.maxHealth * 100
		org["scan_results"] = O.get_scan_results(TRUE)

		.["organs"] += list(org)

	.["nearsight"] = HAS_TRAIT_FROM(src, TRAIT_NEARSIGHT, QUIRK_TRAIT) || HAS_TRAIT_FROM(src, TRAIT_NEARSIGHT, GENETIC_MUTATION)
	.["blind"] = HAS_TRAIT(src, TRAIT_BLIND)
	.["genetic_instability"] = !!GetComponent(/datum/component/genetic_damage)

/obj/machinery/bodyscanner_console/proc/get_severity(amount, tag = FALSE)
	if(!amount)
		return "none"

	if(amount > 50)
		if(tag)
			. = span_bad("severe")
		else
			. = "severe"
	else if(amount > 25)
		if(tag)
			. = span_bad("significant")
		else
			. = "significant"
	else if(amount > 10)
		if(tag)
			. = span_average("moderate")
		else
			. = "moderate"
	else
		if (tag)
			. = span_mild("minor")
		else
			. = "minor"
