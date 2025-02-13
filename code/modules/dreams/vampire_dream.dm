/datum/dream/vampire_tasty
	weight = 100
	dream_class = DREAM_CLASS_VAMPIRE

	dream_cooldown = 20 SECONDS

	// Your friends are tasty looking...

	var/list/subjects = list(
		"your coworker",
		"your mother",
		"your father",
		"your best friend",
		"a coworker",
		"a friend",
	)

	var/list/descriptions = list(
		"they look scared",
		"they are running from you",
		"what does their flesh taste like?",
		"you hunger",
		"a meal",
		"bleeding on the floor",
		"lifeless",
		"you are hungry",
	)

/datum/dream/vampire_tasty/GenerateDream(mob/living/carbon/dreamer)
	. = list()
	.["you see"] = 2 SECONDS

	.[pick(subjects)] = 5 SECONDS
	. += pick(descriptions)

/datum/dream/vampire_tasty/WrapMessage(mob/living/carbon/dreamer, message)
	return span_statsbad("<i>... [message] ...</i>")

/datum/dream/simple/fearful_friend
	weight = 50
	dream_class = DREAM_CLASS_VAMPIRE

	options = list(
		"%NAME%? Is that you?",
		"H-hey, what are you doing?",
		"Stay away, you're not %NAME%!",
		"Why are you looking at me like that?",
		"Get away from me!",

	)

/datum/dream/simple/fearful_friend/WrapMessage(mob/living/carbon/dreamer, message)
	return span_statsbad("<i>... [message] ...</i>")

/datum/dream/random/vampire_bite
	weight = 100
	dream_class = DREAM_CLASS_VAMPIRE
	dream_cooldown = 20 SECONDS

	// Your friends are tasty indeed...
	subject_list = list(
		"yourself",
	)

	ing_verbs_list = list(
		"chasing",
		"tackling",
		"biting",
		"devouring",
		"ripping into",
		"biting",
		"feasting on",
		"running after",
	)

	object_list = list(
		"your best friend",
		"your boss",
		"your mother",
		"someone",
		"your coworker",
		"a friend",
	)

/datum/dream/random/vampire_bite/WrapMessage(mob/living/carbon/dreamer, message)
	return span_statsbad("<i>... [message] ...</i>")
