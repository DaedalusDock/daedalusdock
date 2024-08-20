/datum/dream/detective_nightmare
	abstract_type = /datum/dream/detective_nightmare

	dream_flags = parent_type::dream_flags & ~DREAM_GENERIC

/datum/dream/detective_nightmare/WrapMessage(mob/living/carbon/dreamer, message)
	return message

/datum/dream/detective_nightmare/proc/get_dream_name(mob/living/carbon/dreamer)
	if(prob(1))
		return "Harry"

	var/list/name_split = splittext(dreamer.mind.name, " ")
	return name_split[1]

/datum/dream/detective_nightmare/limbic_system
	abstract_type = /datum/dream/detective_nightmare/limbic_system

	dream_flags = parent_type::dream_flags | DREAM_ONCE_PER_ROUND | DREAM_CUT_SHORT_IS_COMPLETE
	weight = 350

	dream_cooldown = 25 SECONDS

	/// The fragments are deterministic, just need to replacetext the name.
	var/list/fragments

/datum/dream/detective_nightmare/limbic_system/GenerateDream(mob/living/carbon/dreamer)
	. = list()
	var/name = get_dream_name(dreamer)

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
	dream_flags = parent_type::dream_flags | DREAM_ONCE_PER_ROUND | DREAM_CUT_SHORT_IS_COMPLETE
	weight = 50

/datum/dream/detective_nightmare/wake_up_harry/GenerateDream(mob/living/carbon/dreamer)
	return list(
		"<i>[span_statsgood("... Harrier? Harrier?! ...")]</i>" = rand(1 SECOND, 3 SECONDS),
		"<i>[span_statsgood("... Damn it Harry wake up! ...")]</i>" = rand(1 SECOND, 3 SECONDS),
		"<i>[span_statsgood("... Harry I am <b>not</b> going to be the one to explain to the station how their prized Harrier DuBois overdosed on Pyrholidon, <b>again</b>. ...")]</i>",
	)

/datum/dream/detective_nightmare/random
	weight = 2000

/datum/dream/detective_nightmare/random/WrapMessage(mob/living/carbon/dreamer, message)
	return span_statsbad("<i>... [message] ...</i>")

/datum/dream/detective_nightmare/random/GenerateDream(mob/living/carbon/dreamer)
	. = list()

	var/name = get_dream_name(dreamer)

	var/list/options = list(
		"Wake up!",
		"Help me!",
		"I couldn't, I'm sorry.",
		"Useless.",
		"Tick tock tick tock tick tock tick tock",
		"I couldn't save them.",
		"*You hear a loud metallic banging.*",
		"Get up, %NAME%.",
		"Get up.",
		"Get out! I SAID GET OUT!",
		"*You hear the sound of water dripping onto ceramic.*",
		"%NAME%? This is the police, we know you're in there, we just want to talk. %NAME%!",
		"*You hear a distant gunshot, unmistakably a .44 magnum.*",
		"*You hear the heart wrenching screech of a terrified woman.*",
		"Don't go... please...",
		"Pleasepleasepleasepleaseplease.",
		"Please [dreamer.gender == MALE ? "sir" : "ma'am"] I have nowhere else to turn.",
		"You're a failure.",
		"Give up, %NAME%.",
		"Give up.",
		"Get out of my office.",
	)

	for(var/i in 1 to rand(1, 3))
		if(prob(33))
			.["[name]!"] = 2 SECONDS

		.[replacetext(pick_n_take(options), "%NAME%", name)] = 3 SECONDS

