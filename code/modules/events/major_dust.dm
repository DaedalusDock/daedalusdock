/datum/round_event_control/meteor_wave/major_dust
	name = "Major Space Dust"
	typepath = /datum/round_event/meteor_wave/major_dust
	weight = 20

/datum/round_event/meteor_wave/major_dust
	wave_name = "space dust"

/datum/round_event/meteor_wave/major_dust/announce(fake)
	var/reason = pick(
		"The station is passing through a debris cloud, expect minor damage \
		to external fittings and fixtures.",
		"A neighbouring station is throwing rocks at you. (Perhaps they've \
		grown tired of your messages.)")
	priority_announce(pick(reason), sub_title = "Collision Alert")
