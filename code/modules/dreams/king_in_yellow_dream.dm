/datum/dream/kiy_appearance
	weight = 100
	dream_class = DREAM_CLASS_KING_IN_YELLOW

	sleep_until_finished = TRUE
	dream_cooldown = 20 SECONDS

/datum/dream/kiy_appearance/GenerateDream(mob/living/carbon/dreamer)
	. = list()
	.["you see"] = 2 SECONDS

	.["a large figure"] = 3 SECONDS

	var/list/descriptions = list("wearing a yellow cape", "with angelic wings", "a white mask upon their face", "adorned by a gilded crown")

	while(length(descriptions))
		.[pick_n_take(descriptions)] = 3 SECONDS

	.["you kneel before them"] = 3 SECONDS

/datum/dream/kiy_appearance/WrapMessage(mob/living/carbon/dreamer, message)
	return span_statsbad("<i>... [message] ...</i>")
