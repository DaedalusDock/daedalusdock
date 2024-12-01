/datum/vampire_state/bloodlust
	regress_into_message = span_statsgood("The Thirst is too much, you must feed! More! More!")

// Bloodlust is only active at this stage
/datum/vampire_state/bloodlust/can_be_active()
	return parent.thirst_stage == THIRST_STAGE_BLOODLUST

/datum/vampire_state/bloodlust/tick(delta_time, mob/living/carbon/human/host)
	. = ..()

	for(var/obj/item/organ/O as anything in shuffle(host.processing_organs))
		if(!O.damage)
			continue

		if(O.organ_flags & (ORGAN_DEAD | ORGAN_CUT_AWAY | ORGAN_SYNTHETIC))
			continue

		O.applyOrganDamage(-2 * delta_time, silent = TRUE, updating_health = FALSE)
		break

	host.heal_overall_damage(2 * delta_time, 2 * delta_time)

	// I'd rather this be too strong than too weak, ideally a blood-crazed vampire is an extremely dangerous force.
	host.AdjustAllImmobility(-3 SECONDS * delta_time)
