/datum/dream/hatman
	weight = 1000000 // THe hatman cometh
	dream_class = DREAM_CLASS_HATMAN
	dream_flags = DREAM_ONCE_PER_ROUND

/datum/dream/hatman/GenerateDream(mob/living/carbon/dreamer)
	. = list()
	.["you see"] = 2 SECONDS
	.["a shadowy figure with a large hat"] = 5 SECONDS
