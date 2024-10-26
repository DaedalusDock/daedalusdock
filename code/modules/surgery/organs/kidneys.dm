/obj/item/organ/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL

	maxHealth = 70
	high_threshold = 0.5
	low_threshold = 0.35

	slot = ORGAN_SLOT_KIDNEYS
	zone = BODY_ZONE_CHEST
	relative_size = 10

/obj/item/organ/kidneys/on_life(delta_time, times_fired)
	. = ..()

	// This is really stupid code copy pasting but muh Life() ticks
	if(damage > maxHealth * high_threshold)
		var/datum/reagent/coffee = locate(/datum/reagent/consumable/coffee) in owner.reagents.reagent_list
		if(coffee)
			owner.adjustToxLoss(0.3, FALSE, cause_of_death = "Kidney failure")

		if(!owner.reagents.has_reagent(/datum/reagent/potassium, 15))
			owner.reagents.add_reagent(/datum/reagent/potassium, 0.4)

		if(!CHEM_EFFECT_MAGNITUDE(owner, CE_ANTITOX) && prob(33))
			owner.adjustToxLoss(0.3, FALSE, cause_of_death = "Kidney failure")

	else if(damage > maxHealth * low_threshold)
		var/datum/reagent/coffee = locate(/datum/reagent/consumable/coffee) in owner.reagents.reagent_list
		if(coffee)
			owner.adjustToxLoss(0.1, FALSE, cause_of_death = "Kidney failure")

		if(!owner.reagents.has_reagent(/datum/reagent/potassium, 5))
			owner.reagents.add_reagent(/datum/reagent/potassium, 1)


/obj/item/organ/kidneys/on_death(delta_time, times_fired)
	. = ..()
	if(!owner || (owner.stat == DEAD))
		return

	if(!CHEM_EFFECT_MAGNITUDE(owner, CE_ANTITOX) && prob(33))
		owner.adjustToxLoss(1, FALSE, cause_of_death = "Kidney failure")
		. = TRUE
