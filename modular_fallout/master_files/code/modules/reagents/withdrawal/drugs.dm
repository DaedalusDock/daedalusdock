// Fallout addictions

/datum/addiction/jet
	name = "jet"

/datum/addiction/jet/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(prob(20))
		affected_carbon.emote(pick("twitch","drool","moan"))

/datum/addiction/jet/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	affected_carbon.set_timed_status_effect(5 SECONDS, /datum/status_effect/dizziness)
	affected_carbon.adjustToxLoss(1, 0)
	if(prob(30))
		affected_carbon.emote(pick("twitch","drool","moan"))

/datum/addiction/jet/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(!(affected_carbon.mobility_flags && MOBILITY_MOVE))
		for(var/i = 0, i < 4, i++)
			step(affected_carbon, pick(GLOB.cardinals))
	affected_carbon.adjustToxLoss(3, 0)
	affected_carbon.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, updating_health = FALSE)
	affected_carbon.adjust_disgust(60)
	affected_carbon.set_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness)
	if(prob(40))
		affected_carbon.emote(pick("twitch","drool","moan"))

/datum/addiction/jet/withdrawal_stage_4_process(mob/living/carbon/affected_carbon, delta_time)
	.=..()
	if(!(affected_carbon.mobility_flags && MOBILITY_MOVE))
		for(var/i = 0, i < 8, i++)
			step(affected_carbon, pick(GLOB.cardinals))
	affected_carbon.adjustToxLoss(5, 0)
	affected_carbon.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10, updating_health = FALSE)
	affected_carbon.adjust_disgust(100)
	affected_carbon.set_timed_status_effect(15 SECONDS, /datum/status_effect/dizziness)
	if(prob(50))
		affected_carbon.emote(pick("twitch","drool","moan"))
	. = TRUE

/datum/addiction/jet/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()

// Turbo
/datum/addiction/turbo
	name = "turbo"

/datum/addiction/turbo/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	affected_carbon.set_timed_status_effect(5 SECONDS, /datum/status_effect/jitter)
	if(prob(20))
		affected_carbon.emote(pick("twitch","drool","moan"))

/datum/addiction/turbo/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	affected_carbon.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter)
	affected_carbon.set_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness)
	if(prob(30))
		affected_carbon.emote(pick("twitch","drool","moan"))

/datum/addiction/turbo/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(!(affected_carbon.mobility_flags && MOBILITY_MOVE))
		for(var/i = 0, i < 4, i++)
			step(affected_carbon, pick(GLOB.cardinals))
	affected_carbon.set_timed_status_effect(15 SECONDS, /datum/status_effect/jitter)
	affected_carbon.set_timed_status_effect(15 SECONDS, /datum/status_effect/dizziness)
	if(prob(40))
		affected_carbon.emote(pick("twitch","drool","moan"))

/datum/addiction/turbo/withdrawal_stage_4_process(mob/living/carbon/affected_carbon, delta_time)
	.=..()
	if(!(affected_carbon.mobility_flags && MOBILITY_MOVE))
		for(var/i = 0, i < 8, i++)
			step(affected_carbon, pick(GLOB.cardinals))
	affected_carbon.set_timed_status_effect(20 SECONDS, /datum/status_effect/jitter)
	affected_carbon.set_timed_status_effect(20 SECONDS, /datum/status_effect/dizziness)
	affected_carbon.adjustToxLoss(6, 0)
	if(prob(50))
		affected_carbon.emote(pick("twitch","drool","moan"))
	. = TRUE

/datum/addiction/turbo/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()

// Prophet

/datum/addiction/psycho
	name = "psycho"

/datum/addiction/psycho/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	affected_carbon.hallucination += 10
	affected_carbon.set_timed_status_effect(5 SECONDS, /datum/status_effect/jitter)
	affected_carbon.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1, updating_health = FALSE)
	if(prob(20))
		affected_carbon.emote(pick("twitch","scream","laugh"))
	return

/datum/addiction/psycho/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	affected_carbon.hallucination += 20
	affected_carbon.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter)
	affected_carbon.set_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness)
	affected_carbon.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1, updating_health = FALSE)
	if(prob(30))
		affected_carbon.emote(pick("twitch","scream","laugh"))
	return

/datum/addiction/psycho/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	affected_carbon.hallucination += 30
	if(!(affected_carbon.mobility_flags && MOBILITY_MOVE))
		for(var/i = 0, i < 2, i++)
			step(affected_carbon, pick(GLOB.cardinals))
	affected_carbon.set_timed_status_effect(15 SECONDS, /datum/status_effect/jitter)
	affected_carbon.set_timed_status_effect(15 SECONDS, /datum/status_effect/dizziness)
	affected_carbon.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10, updating_health = FALSE)
	if(prob(40))
		affected_carbon.emote(pick("twitch","scream","laugh"))
	return

/datum/addiction/psycho/withdrawal_stage_4_process(mob/living/carbon/affected_carbon, delta_time)
	.=..()
	affected_carbon.hallucination += 40
	if(!(affected_carbon.mobility_flags && MOBILITY_MOVE))
		for(var/i = 0, i < 4, i++)
			step(affected_carbon, pick(GLOB.cardinals))
	affected_carbon.set_timed_status_effect(50 SECONDS, /datum/status_effect/jitter)
	affected_carbon.set_timed_status_effect(50 SECONDS, /datum/status_effect/dizziness)
	affected_carbon.adjustToxLoss(5)
	affected_carbon.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, updating_health = FALSE)
	if(prob(50))
		affected_carbon.emote(pick("twitch","scream","laugh"))
	return

/datum/addiction/psycho/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()

// Buffout

/datum/addiction/buffout
	name = "buffout"

/datum/addiction/buffout/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	to_chat(affected_carbon, "<span class='notice'>Your muscles ache slightly.</span>")
	affected_carbon.adjustBruteLoss(1.5)
	if(prob(15))
		affected_carbon.emote(pick("twitch"))
	return

/datum/addiction/buffout/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	to_chat(affected_carbon, "<span class='notice'>Your muscles feel incredibly sore.</span>")
	affected_carbon.adjustBruteLoss(4)
	if(prob(30))
		to_chat(affected_carbon, "<span class='notice'>Your muscles spasm, making you drop what you were holding.</span>")
		affected_carbon.drop_all_held_items()
		affected_carbon.emote(pick("twitch"))
	return

/datum/addiction/buffout/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	to_chat(affected_carbon, "<span class='notice'>Your muscles start to hurt badly, and everything feels like it hurts more.</span>")
	affected_carbon.adjustBruteLoss(7.5)
	affected_carbon.maxHealth -= 1.5
	affected_carbon.health -= 1.5
	if(prob(50))
		to_chat(affected_carbon, "<span class='notice'>Your muscles spasm, making you drop what you were holding. You're not even sure if you can control your arms!</span>")
		affected_carbon.drop_all_held_items()
		affected_carbon.emote(pick("twitch"))
	return

/datum/addiction/buffout/withdrawal_stage_4_process(mob/living/carbon/affected_carbon, delta_time)
	.=..()
	to_chat(affected_carbon, "<span class='danger'>Your muscles are in incredible pain! When will it stop!?</span>")
	affected_carbon.adjustBruteLoss(12.5)
	affected_carbon.maxHealth -= 5
	affected_carbon.health -= 5
	if(prob(90))
		to_chat(affected_carbon, "<span class='danger'>You can't even keep control of your muscles anymore!</span>")
		affected_carbon.drop_all_held_items()
		affected_carbon.emote(pick("twitch"))
	if(!(affected_carbon.mobility_flags && MOBILITY_MOVE) && prob(25))
		step(affected_carbon, pick(GLOB.cardinals))
	affected_carbon.adjustOrganLoss(ORGAN_SLOT_HEART, 20)
	return

/datum/addiction/buffout/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()
