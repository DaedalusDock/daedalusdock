///alien immune to tox damage
/mob/living/carbon/alien/getToxLoss()
	return FALSE

///alien immune to tox damage
/mob/living/carbon/alien/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, cause_of_death = "Systemic organ failure")
	return FALSE

///aliens are immune to stamina damage.
/mob/living/carbon/alien/pre_stamina_change(diff as num)
	return 0
