/*Vomiting
 * Reduces stealth
 * Slight resistance reduction
 * Slight stage speed reduction
 * Increases transmissibility
 * Bonus : Forces the affected mob to vomit! Makes the affected mob lose nutrition and heal toxin damage
and your disease can spread via people walking on vomit.
*/

/datum/symptom/vomit
	name = "Vomiting"
	desc = "The virus causes nausea and irritates the stomach, causing occasional vomit."
	stealth = -2
	resistance = -1
	stage_speed = -1
	transmittable = 2
	level = 3
	severity = 3
	base_message_chance = 100
	symptom_delay_min = 25
	symptom_delay_max = 80
	var/vomit_blood = FALSE
	var/proj_vomit = 0
	threshold_descs = list(
		"Resistance 7" = "Host will vomit blood, causing internal damage.",
		"Transmission 7" = "Host will projectile vomit, increasing vomiting range.",
		"Stealth 4" = "The symptom remains hidden until active."
	)

/datum/symptom/vomit/sync_properties(list/properties)
	. = ..()
	if(!.)
		return
	if(properties[PATHOGEN_PROP_STEALTH] >= 4)
		suppress_warning = TRUE
	if(properties[PATHOGEN_PROP_RESISTANCE] >= 7) //blood vomit
		vomit_blood = TRUE
	if(properties[PATHOGEN_PROP_TRANSMITTABLE] >= 7) //projectile vomit
		proj_vomit = 5

/datum/symptom/vomit/on_process(datum/pathogen/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(M, span_warning("[pick("You feel nauseated.", "You feel like you're going to throw up!")]"))
		else
			vomit(M)

/datum/symptom/vomit/proc/vomit(mob/living/carbon/M)
	M.vomit(20, vomit_blood, distance = proj_vomit)
