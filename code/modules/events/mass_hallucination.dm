/datum/round_event_control/mass_hallucination
	name = "Mass Hallucination"
	typepath = /datum/round_event/mass_hallucination
	weight = 10
	max_occurrences = 2
	min_players = 1


/datum/round_event/mass_hallucination
	fakeable = FALSE

	/// 'normal' sound keys, index by them to get the friendly name.
	var/list/sound_pool = list(
		"airlock" = "Door",
		"airlock_pry" = "Door Prying",
		"console" = "Computer",
		"explosion" = "Explosion",
		"far_explosion" = "Distant Explosion",
		"mech" = "Mech Walking",
		"glass" = "Glass Breaking",
		"alarm" = "Alarm",
		"beepsky" = "Securiton",
		"wall_decon" = "Wall Deconstruction",
		"door_hack" = "Door Hacking",
		"tesla" = "Tesla Ball"
		)
	/// 'Weird' sound keys, index by them to get the friendly name.
	var/list/rare_sound_pool = list(
		"phone" = "Phone",
		"hallelujah" = "Holy",
		"highlander" = "Scottish Pride",
		"hyperspace" = "Shuttle Undocking",
		"game_over" = "Game Over",
		"creepy" = "Disembodied Voice",
		"tesla" = "Tesla Ball" //No, I don't know why this is duplicated.
		)
	/// Fake 'Station Message' keys, index by them to get the friendly name.
	var/list/stationmessage_pool = list(
		"ratvar" = "Ratvar Summoning",
		"shuttle_dock" = "Emergency Shuttle Dock Announcement",
		"blob_alert" = "Level 5 Biohazard Announcement",
		"malf_ai" = "Rampant AI Alert",
		"meteors" = "Meteor Announcement",
	)
	/// Pool for generic hallucinations. Types can't key lists, so we need to invert the accesses.
	var/list/generic_pool = list(
		"Fake bolted airlocks" = /datum/hallucination/bolts,
		"Imagined messages" = /datum/hallucination/chat,
		"Fake minor message" = /datum/hallucination/message,
		"Fake gas flood" = /datum/hallucination/fake_flood,
		"Fake combat noises" = /datum/hallucination/battle,
		"Imaginary spontaneous combustion" = /datum/hallucination/fire,
		"Self Delusion" = /datum/hallucination/self_delusion,
		"Fake Death" = /datum/hallucination/death,
		"Delusions" = /datum/hallucination/delusion,
		"Imaginary Bubblegum" = /datum/hallucination/oh_yeah
	)


/datum/round_event/mass_hallucination/start()
	switch(rand(1,4))
		if(1) //same sound for everyone
			var/picked_sound = pick(sound_pool)
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				if(C.z in SSmapping.levels_by_trait(ZTRAIT_CENTCOM))//not for admin/ooc stuff
					continue
				new /datum/hallucination/sounds(C, TRUE, picked_sound)
			deadchat_broadcast("[span_bold("Mass Hallucination")]: [sound_pool[picked_sound]] sounds.")
		if(2)
			var/weirdsound = pick(rare_sound_pool)
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				if(C.z in SSmapping.levels_by_trait(ZTRAIT_CENTCOM))//not for admin/ooc stuff
					continue
				new /datum/hallucination/weird_sounds(C, TRUE, weirdsound)
			deadchat_broadcast("[span_bold("Mass Hallucination")]: Weird [rare_sound_pool[weirdsound]] sounds.")
		if(3)
			var/stationmessage = pick(stationmessage_pool)
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				if(C.z in SSmapping.levels_by_trait(ZTRAIT_CENTCOM))//not for admin/ooc stuff
					continue
				new /datum/hallucination/stationmessage(C, TRUE, stationmessage)
			deadchat_broadcast("[span_bold("Mass Hallucination")]: Fake [stationmessage_pool[stationmessage]].")
		if(4 to 6)
			var/picked_hallucination = pick(generic_pool)
			//You can't index lists in the type part of new calls
			var/type_holder = generic_pool[picked_hallucination]
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				if(C.z in SSmapping.levels_by_trait(ZTRAIT_CENTCOM))//not for admin/ooc stuff
					continue
				new type_holder(C, TRUE)
			deadchat_broadcast("[span_bold("Mass Hallucination")]: [picked_hallucination].")
