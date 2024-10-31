/datum/mood_event/revival
	description = "I'M ALIVE!"
	mood_change = MOOD_LEVEL_HAPPY4
	timeout = 5 MINUTES

/datum/mood_event/pain_one
	description = "Your body is sore."
	mood_change = MOOD_LEVEL_SAD1

/datum/mood_event/pain_two
	description = "You are in pain."
	mood_change = MOOD_LEVEL_SAD2

/datum/mood_event/pain_three
	description = "You are in severe pain."
	mood_change = -12

/datum/mood_event/pain_four
	description = "The pain is agonizing."
	mood_change = MOOD_LEVEL_SAD4

/datum/mood_event/cardiac_arrest
	description = "You do not feel your heartbeat."
	mood_change = -100
	special_screen_obj = "mood_dread"
