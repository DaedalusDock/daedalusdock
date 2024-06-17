/datum/rpg_stat/motorics
	name = "Motorics"
	desc = ""

	value = STATS_BASELINE_VALUE

/datum/rpg_stat/motorics/get(mob/living/user)
	. = ..()
	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user

	var/obj/item/organ/brain/brain = carbon_user.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain && (brain.damage >= (brain.maxHealth * brain.low_threshold)))
		. -= 4
