/datum/mood_event/revival
	description = "I'M ALIVE!"
	mood_change = MOOD_LEVEL_HAPPY4
	timeout = 5 MINUTES

/datum/mood_event/pain_one
	description = "My body is sore."
	mood_change = MOOD_LEVEL_NEUTRAL

/datum/mood_event/pain_two
	description = "I am in pain."
	mood_change = MOOD_LEVEL_SAD1

/datum/mood_event/pain_three
	description = "I am in severe pain."
	mood_change = -12

/datum/mood_event/pain_four
	description = "The pain is agonizing."
	mood_change = MOOD_LEVEL_SAD4

/datum/mood_event/cardiac_arrest
	description = "I don't feel my heart beating."
	mood_change = -100
	special_screen_obj = "mood_dread"
