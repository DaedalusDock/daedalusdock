/**
 * ## Rabbit
 *
 * A creature that hops around with small tails and long ears.
 *
 * This contains the code for both your standard rabbit as well as the subtypes commonly found during Easter.
 *
 */
/mob/living/simple_animal/rabbit
	name = "\improper rabbit"
	desc = "The hippiest hop around."
	gender = PLURAL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 15
	maxHealth = 15
	icon = 'icons/mob/rabbit.dmi'
	icon_state = "rabbit_white"
	icon_living = "rabbit_white"
	icon_dead = "rabbit_white_dead"
	speak_emote = list("sniffles","twitches")
	emote_hear = list("hops.")
	emote_see = list("hops around","bounces up and down")
	butcher_results = list(/obj/item/food/meat/slab = 1)
	density = FALSE
	speak_chance = 2
	turns_per_move = 3
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	gold_core_spawnable = FRIENDLY_SPAWN
	//passed to animal_varity as the prefix icon.
	var/icon_prefix = "rabbit"

/mob/living/simple_animal/rabbit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/pet_bonus, "hops around happily!")
	AddElement(/datum/element/animal_variety, icon_prefix, pick("brown","black","white"), TRUE)
