/datum/rpg_stat/psyche
	name = "Psyche"
	desc = ""

	value = STATS_BASELINE_VALUE
	sound = 'sound/three_dsix/psyche.ogg'

/datum/rpg_stat/psyche/get(mob/living/user)
	. = ..()
	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user

	var/obj/item/organ/brain/brain = carbon_user.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain && (brain.damage >= (brain.maxHealth * brain.low_threshold)))
		. -= 4
