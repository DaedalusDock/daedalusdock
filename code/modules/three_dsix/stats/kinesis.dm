/datum/rpg_stat/kinesis
	name = "kinesis"
	desc = ""

	value = STATS_BASELINE_VALUE
	sound = 'sound/three_dsix/kinesis.ogg'

/datum/rpg_stat/kinesis/get(mob/living/user)
	. = ..()
	if(!iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user

	var/obj/item/organ/brain/brain = carbon_user.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain && (brain.damage >= (brain.maxHealth * brain.low_threshold)))
		. -= 4

	if(carbon_user.has_status_effect(/datum/status_effect/speech/slurring/drunk))
		. -= 2
