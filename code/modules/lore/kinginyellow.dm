/obj/item/kinginyellow
	name = "The King In Yellow"
	desc = "An old book with the author's name scratched out, leaving only an \"H\"."
	icon = 'goon/icons/obj/kinginyellow.dmi'
	icon_state = "bookkiy"

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/kinginyellow/attack_self(mob/living/user, modifiers)
	var/datum/status_effect/grouped/king_in_yellow/curse = user.has_status_effect(/datum/status_effect/grouped/king_in_yellow)

	if(!curse)
		to_chat(user, span_notice("You turn open the cover of the book, and begin to read, \"Chapter One: The Repairer of Reputations\"..."))
		if(do_after(user, time = 8 SECONDS, interaction_key = "kinginyellow"))
			to_chat(user, span_notice("The first act is a confusing mess about 1920's America.") + "<br>" + span_danger("You feel as if you're about to faint."))
			user.apply_status_effect(/datum/status_effect/grouped/king_in_yellow, ref(src))
			user.adjust_drowsyness(3)
			return TRUE

	switch(curse.curse_severity)
		if(1)
			to_chat(user, span_notice("You begin to read the second chapter, it's title has been scratched out..."))
			if(do_after(user, time = 3 SECONDS, interaction_key = "kinginyellow"))
				to_chat(user, span_warning("No, no no what is this?! It's gibberish! It can't be!"))
				curse.curse_severity = 2
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 50, 150)
				else
					var/mob/living/L = user
					L.adjustBruteLoss(20)

		if(2)
			var/reads = 0
			while(do_after(user, time = 1 SECONDS, interaction_key = "kinginyellow"))
				reads++
				to_chat(user, span_danger("Your mind is scarred by the horrors within! You must keep reading!"))
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2.5 * reads)
				else if(isliving(user))
					var/mob/living/L = user
					L.adjustBruteLoss(10)

	return TRUE

/obj/item/kinginyellow/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	var/datum/status_effect/grouped/king_in_yellow/curse = L.has_status_effect(/datum/status_effect/grouped/king_in_yellow)
	var/text = "You feel the irresistible urge to keep reading [src]."
	to_chat(L, (curse?.curse_severity == 2) ? span_warning(text) : span_notice(text))
