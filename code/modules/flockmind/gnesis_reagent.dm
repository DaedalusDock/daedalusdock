/datum/reagent/toxin/gnesis
	name = "coagulated gnesis"
	description = "A thick teal fluid of alien origin. It moves in ways that suggest it might be alive in some way."
	color =  "#4d736d"

	taste_description = "oily, with a sweet aftertaste"
	chemical_flags = REAGENT_DEAD_PROCESS

	ingest_met = INFINITY

	/// Reagent -> Blood-replacement rate per 2 seconds
	var/conversion_rate = 0.4
	/// Amount of gnesis required to turn the victim into a flockbit
	var/flocksplosion_threshold = 200

// /datum/reagent/toxin/gnesis/affect_blood(mob/living/carbon/C, removed)
// 	if(volume > 40)
// 		C.adjustBloodVolume(-conversion_rate)
// 		C.reagents.add_reagent(type, conversion_rate)

// 	if(volume >= flocksplosion_threshold)
// 		if(prob(max(2, (volume - flocksplosion_threshold) / 5)))
// 			//flockgib
// 			return


// 	if(volume < (flocksplosion_threshold / 2))
// 		if(prob(2))
// 			//playsound
// 		if(prob(6))
// 			//message
// 	else
// 		if(prob(5))
// 			//organ
// 		if(prob(15))
// 			//gnesis glow
// 		if(prob(30))
// 			//message

// 	var/datum/reagents/bloodstream = C.bloodstream
// 	if(length(bloodstream.reagent_list) <= 1)
// 		return

// 	var/static/list/do_not_purge = typecacheof(
// 		/datum/reagent/medicine/ipecac,
// 		/datum/reagent/medicine/dylovene,
// 		/datum/reagent/medicine/activated_charcoal,
// 	)

// 	var/list/candidate_reagents = bloodstream.reagent_list.Copy()
// 	candidate_reagents -= src

// 	for(var/datum/reagent/R as anything in candidate_reagents)
// 		if(do_not_purge[R.type])
// 			candidate_reagents -= R

// 	if(!length(candidate_reagents))
// 		return

// 	var/datum/reagent/chosen_reagent = pick(candidate_reagents)

// 	var/converted_amt = bloodstream.remove_reagent(chosen_reagent.type, 0.4)
// 	bloodstream.add_reagent(type, converted_amt)

