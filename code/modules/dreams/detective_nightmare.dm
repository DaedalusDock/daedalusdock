/datum/dream/detective_nightmare
	abstract_type = /datum/dream/detective_nightmare

	dream_flags = parent_type::dream_flags & ~DREAM_GENERIC

/datum/dream/detective_nightmare/WrapMessage(mob/living/carbon/dreamer, message)
	return message

/datum/dream/detective_nightmare/limbic_system
	abstract_type = /datum/dream/detective_nightmare/limbic_system

	dream_flags = parent_type::dream_flags | DREAM_ONCE_PER_ROUND
	weight = 350

	/// The fragments are deterministic, just need to replacetext the name.
	var/list/fragments

/datum/dream/detective_nightmare/limbic_system/GenerateDream(mob/living/carbon/dreamer)
	. = list()
	var/name = prob(1) ? "Harry" : (dreamer.mind.name)

	for(var/fragment in fragments)
		.["<i>[span_statsbad(replacetext(fragment, "%NAME%", name))]</i>"] = fragments[fragment]

/datum/dream/detective_nightmare/limbic_system/super_asshole
	fragments = list(
		"Hello %NAME%, I am so pleased you could join us again. NOT." = 7 SECONDS,
		"This station is tearing your feeble, disgusting excuse for a body to shreeeedssss." = 9 SECONDS,
		"You should've listened to me loooooong aaaggoooo, %NAME%. Maybe you would not be such a violent, waste of space if you had." = 12 SECONDS,
		"Alright then, be that way. I'll be waiting for your next visit."
	)

/datum/dream/detective_nightmare/limbic_system/calm_asshole
	fragments = list(
		"Here we are again, my broken bird. You stay so long yet always leave, why?." = 7 SECONDS,
		"We think you should give up and stay with us, it will be better that way. Do you truly believe you can keep going how you are?" = 12 SECONDS,
		"Would you rather spend the rest of your days wasting away on an old, rickety station in the corner of the Pool?." = 12 SECONDS,
		"We will see you again soon, %NAME%."
	)

/datum/dream/detective_nightmare/limbic_system/still_an_asshole
	fragments = list(
		"Welcome back %NAME%, come to visit your old pals again? Stay a while, you always do." = 7 SECONDS,
		"Don't be so hard on yourself, %NAME%. You may be a disappointment to those around you, a useless lump of flesh, lumbering about the station, but, what do they know?" = 12 SECONDS,
		"Was that too mean? I apologize, I will be more positive from here on out." = 7 SECONDS,
		"Oh, we're out of time. See you soon."
	)

/datum/dream/detective_nightmare/wake_up_harry
	dream_flags = parent_type::dream_flags | DREAM_ONCE_PER_ROUND
	weight = 50

/datum/dream/detective_nightmare/wake_up_harry/GenerateDream(mob/living/carbon/dreamer)
	return list(
		"<i>[span_statsgood("Harrier? Harrier?!")]</i>" = rand(1 SECOND, 3 SECONDS),
		"<i>[span_statsgood("Damn it Harry wake up!")]</i>" = rand(1 SECOND, 3 SECONDS),
		"<i>[span_statsgood("Harry I am <b>not</b> going to be the one to explain to the station how their prized Harrier DuBois overdosed on Pyrholion, <b>again</b>")].</i>",
	)
