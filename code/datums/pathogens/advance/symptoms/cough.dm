/**Coughing
 * Slightly decreases stealth
 * Reduces resistance
 * Slightly increases stage speed
 * Increases transmissibility
 * Low level
 * Bonus: Spreads the virus in a small square around the host. Can force the affected mob to drop small items!
*/
/datum/symptom/cough
	name = "Cough"
	desc = "The virus irritates the throat of the host, causing occasional coughing. Each cough will try to infect bystanders who are within 1 tile of the host with the virus."
	stealth = -1
	resistance = 3
	stage_speed = 1
	transmittable = 2
	level = 1
	severity = 1
	base_message_chance = 15
	symptom_delay_min = 2
	symptom_delay_max = 15
	var/spread_range = 1
	threshold_descs = list(
		"Resistance 11" = "The host will drop small items when coughing.",
		"Resistance 15" = "Occasionally causes coughing fits that stun the host. The extra coughs do not spread the virus.",
		"Stage Speed 6" = "Increases cough frequency.",
		"Transmission 7" = "Coughing will now infect bystanders up to 2 tiles away.",
		"Stealth 4" = "The symptom remains hidden until active.",
	)

/datum/symptom/cough/sync_properties(list/properties)
	. = ..()
	if(!.)
		return
	if(properties[PATHOGEN_PROP_STEALTH] >= 4)
		suppress_warning = TRUE
	if(properties[PATHOGEN_PROP_TRANSMITTABLE] >= 7)
		spread_range = 2
	if(properties[PATHOGEN_PROP_RESISTANCE] >= 11) //strong enough to drop items
		power = 1.5
	if(properties[PATHOGEN_PROP_RESISTANCE] >= 15) //strong enough to stun (occasionally)
		power = 2
	if(properties[PATHOGEN_PROP_STAGE_RATE] >= 6) //cough more often
		symptom_delay_max = 10

/datum/symptom/cough/on_process(datum/pathogen/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/M = A.affected_mob
	if(HAS_TRAIT(M, TRAIT_SOOTHED_THROAT))
		return
	switch(A.stage)
		if(1, 2, 3)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(M, span_warning("[pick("You swallow excess mucus.", "You lightly cough.")]"))
		else
			M.emote("cough")
			A.airborne_spread(spread_range)
			if(power >= 1.5)
				var/obj/item/I = M.get_active_held_item()
				if(I && I.w_class == WEIGHT_CLASS_TINY)
					M.dropItemToGround(I)
			if(power >= 2 && prob(30))
				to_chat(M, span_userdanger("[pick("You have a coughing fit!", "You can't stop coughing!")]"))
				M.Immobilize(20)
				addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "cough"), 6)
				addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "cough"), 12)
				addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "cough"), 18)
