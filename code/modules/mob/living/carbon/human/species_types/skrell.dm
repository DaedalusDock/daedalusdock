/datum/species/skrell
	name = "\improper Skrell"
	id = SPECIES_SKRELL
	say_mod = "warbles"
	default_color = "42F58D"
	species_traits = list(MUTCOLORS, HAIRCOLOR, EYECOLOR, LIPS, HAS_FLESH, HAS_BONE, BODY_RESIZABLE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_CAN_STRIP, TRAIT_LIGHT_DRINKER)
	liked_food = VEGETABLES | FRUIT
	disliked_food = GROSS | MEAT | RAW | DAIRY
	toxic_food = TOXIC | SEAFOOD
	payday_modifier = 0.95
	job_outfit_type = SPECIES_HUMAN
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/skrell
	exotic_bloodtype = "S"

	species_eye_path = 'icons/mob/species/skrell/eyes.dmi'

	mutantbrain = /obj/item/organ/brain/skrell
	mutanteyes = /obj/item/organ/eyes/skrell
	mutantlungs = /obj/item/organ/lungs/skrell
	mutantheart = /obj/item/organ/heart/skrell
	mutantliver = /obj/item/organ/liver/skrell
	mutanttongue = /obj/item/organ/tongue/skrell

	cosmetic_organs = list(
		/obj/item/organ/skrell_headtails = "Long"
	)

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/skrell,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/skrell,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/skrell,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/skrell,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/skrell,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/skrell,
	)

/datum/species/skrell/spec_life(mob/living/carbon/human/skrell_mob, delta_time, times_fired)
	. = ..()
	if(skrell_mob.nutrition > NUTRITION_LEVEL_ALMOST_FULL)
		skrell_mob.set_nutrition(NUTRITION_LEVEL_ALMOST_FULL)

/datum/species/skrell/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.mutant_colors[MUTCOLORS_GENERIC_1] = COLOR_BLUE_GRAY
	human.hair_color = COLOR_BLUE_GRAY
	human.update_body(TRUE)

// Copper restores blood for Skrell instead of iron.
/datum/species/skrell/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	. = ..()
	if(chem.type == /datum/reagent/copper)
		if(H.blood_volume < BLOOD_VOLUME_NORMAL)
			H.blood_volume += 0.5 * delta_time
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)
		return TRUE
	if(chem.type == /datum/reagent/iron)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)
		return TRUE

/datum/species/skrell/random_name(gender, unique, lastname, attempts)
	. = ""

	var/full_name = ""
	var/new_name = ""
	var/static/list/syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix")
	for(var/x = rand(1,2) to 0 step -1)
		new_name += pick(syllables)
		full_name += pick(syllables)

	full_name += " [capitalize(new_name)]"
	. += "[capitalize(full_name)]"

	if(unique && attempts < 10)
		if(findname(new_name))
			. = .(gender, TRUE, null, attempts++)

	return .

//Skrell lore
/datum/species/skrell/get_species_description()
	return "Skrells are aquatic humanoids coming from the planet of Qerrbalak, often deeply ceremonial and focused on learning more about the galaxy. \
		Their inherent fondness for learning and technology has resulted in them advancing further in science when compared to humanity, \
		however progress has mostly gone stagnant due to recent political turmoil and the economic crisis back home."

/datum/species/skrell/get_species_lore()
	return list(
		"Skrellian society is obviously quite different from that of humanity, and many outsiders often call Skrell emotionless however this is wrong,  \
		as Skrell lack facial muscles and frequently make use of their tone of voice, movement and more. \
		Skrell also sees things far more in the long term side of things because of their long lifespan.",

		"Despite the good relations enjoyed with most other species, there is a deep fear within the federation of foreign influence, and because of this   \
		fear, the federation adopted a rather isolationist foreign policy which was mostly caused by the recent political turmoil and  \
		economic crash.",

		"The economic crash also known as \"Qerrbalak recession\" was caused when a large disaster happened on huge mining facility at Urmx housing one  \
		of the federations biggest plasma mines, this disaster was caused when a fire erupted in one of the lower tunnels of XM-2 a mining site, this \
		caused an immense plasmafire that raged for 6 years and lead to the casualities of 84 employees of the facility, with 4356 being injured and around  \
		50.0000 people living on the planet being directly affected.",

		"Not only did this fire destroy one of the biggest mining sites of the federation, but as well affected various other nearby sites causing a huge scarcity in plasma. \
		As plasma supply dropped around various worlds in federation such as Qerrbalak were unable to maintain the demand in plasma, and caused a \
		huge rise in unemployment and caused a stock crash in the plasma market in federation.",
	)

//Skrell features

/datum/species/skrell/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "biohazard",
			SPECIES_PERK_NAME = "Toxin Tolerance",
			SPECIES_PERK_DESC = "Skrell have a higher resistance to toxins.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "syringe",
			SPECIES_PERK_NAME = "Haemocyanin-Based Circulatory System",
			SPECIES_PERK_DESC = "Skrell blood is restored faster with copper, iron doesn't work.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "thermometer",
			SPECIES_PERK_NAME = "Temperature Intolerance",
			SPECIES_PERK_DESC = "Skrell lungs cannot handle temperature differences.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "sun",
			SPECIES_PERK_NAME = "High Light Sensitivity",
			SPECIES_PERK_DESC = "Skrell eyes are sensitive to bright lights and are more susceptible to damage when not sufficiently protected.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "wine-bottle",
			SPECIES_PERK_NAME = "Low Alcohol Tolerance",
			SPECIES_PERK_DESC = "Skrell have a low tolerance to alcohol, resulting in them feeling the effects of it much earlier compared to other species."
		),
	)

	return to_add
