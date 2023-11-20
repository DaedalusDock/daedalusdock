/**
 * Create an announcement to send globally or to a specified list of players.
 *
 *
 * args:
 * * text (string) The body of the announcement
 * * title (string) The title of the announcement. Default: "Staton Announcement"
 * * sound_type (string OR sound) The sound to play alongside the message. If given a string like PA_COMMAND, it will pick the sound for you.
 * * send_to_newscaster (boolean) Whether or not to post this to newscasters
 * * do_not_modify (boolean) Whether or not station announcers can add to this message.
 * * players (list or null) The players we're sending to. If null, send to all players.
 */
/proc/priority_announce(text = "", super_title = "Station Announcement", sub_title = "", sound_type = ANNOUNCER_DEFAULT, send_to_newscaster, do_not_modify = FALSE, list/players)
	if(!text)
		return

	if(!players)
		players = GLOB.player_list


	var/announcement = "<h1 class='alert'>[html_encode(super_title)]</h1>"

	if(sub_title)
		announcement += "<h2 class='alert'>[html_encode(sub_title)]</h2><br>"

	///If the announcer overrides alert messages, use that message.
	if(SSstation.announcer.custom_alert_message && !do_not_modify)
		announcement += SSstation.announcer.custom_alert_message
	else
		announcement += "<br>[span_alert("[html_encode(text)]")]<br>"
	announcement += "<br>"

	var/sound/sound2use = SSstation.announcer.event_sounds[sound_type]

	//Find the sound requested if it isn't covered by announcer events already
	if(isnull(sound2use))
		switch(sound_type)
			if(ANNOUNCER_DEFAULT)
				sound2use = 'goon/sounds/announcement_1.ogg'
			if(ANNOUNCER_CENTCOM)
				sound2use = SSstation.announcer.get_rand_report_sound()
			if(ANNOUNCER_ATTENTION)
				sound2use = SSstation.announcer.get_rand_alert_sound()
			else
				sound2use = 'goon/sounds/announcement_1.ogg'


	sound2use = sound(sound2use)

	for(var/mob/target in players)
		if(!isnewplayer(target) && target.can_hear())
			to_chat(target, announcement)
			if(target.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				SEND_SOUND(target, sound2use)

	if(send_to_newscaster)
		if(sub_title == "")
			GLOB.news_network.submit_article(text, super_title, "Station Announcements", null)
		else
			GLOB.news_network.submit_article(sub_title + "<br><br>" + text, super_title, "Station Announcements", null)

/**
 * Summon the crew for an emergency meeting
 *
 * Teleports the crew to a specified area, and tells everyone (via an announcement) who called the meeting. Should only be used during april fools!
 * Arguments:
 * * user - Mob who called the meeting
 * * button_zone - Area where the meeting was called and where everyone will get teleported to
 */
/proc/call_emergency_meeting(mob/living/user, area/button_zone)
	var/meeting_sound = sound('sound/misc/emergency_meeting.ogg')
	var/announcement
	announcement += "<h1 class='alert'>Captain Alert</h1>"
	announcement += "<br>[span_alert("[user] has called an Emergency Meeting!")]<br><br>"

	for(var/mob/mob_to_teleport in GLOB.player_list) //gotta make sure the whole crew's here!
		if(isnewplayer(mob_to_teleport) || iscameramob(mob_to_teleport))
			continue
		to_chat(mob_to_teleport, announcement)
		SEND_SOUND(mob_to_teleport, meeting_sound) //no preferences here, you must hear the funny sound
		mob_to_teleport.overlay_fullscreen("emergency_meeting", /atom/movable/screen/fullscreen/emergency_meeting, 1)
		addtimer(CALLBACK(mob_to_teleport, TYPE_PROC_REF(/mob, clear_fullscreen), "emergency_meeting"), 3 SECONDS)

		if (is_station_level(mob_to_teleport.z)) //teleport the mob to the crew meeting
			var/turf/target
			var/list/turf_list = get_area_turfs(button_zone)
			while (!target && turf_list.len)
				target = pick_n_take(turf_list)
				if (isclosedturf(target))
					target = null
					continue
				mob_to_teleport.forceMove(target)

/proc/print_command_report(text = "", title = null, announce=TRUE)
	if(!title)
		title = "Classified [command_name()] Update"

	if(announce)
		priority_announce(
			"A report has been downloaded and printed out at all communications consoles.",
			sub_title = "Incoming Classified Message",
			sound_type = ANNOUNCER_CENTCOM,
			do_not_modify = TRUE
		)

	var/datum/comm_message/M = new
	M.title = title
	M.content = text

	SScommunications.send_message(M)

/proc/minor_announce(message, title = "Station Announcement", alert, html_encode = TRUE, list/players)
	if(!message)
		return

	if (html_encode)
		title = html_encode(title)
		message = html_encode(message)

	if(!players)
		players = GLOB.player_list

	if(title)
		message = "<font color = red>[title]</font color><BR>[message]"

	for(var/mob/target in players)
		if(!isnewplayer(target) && target.can_hear())
			to_chat(target, span_minorannounce(message))
			if(target.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				if(alert)
					SEND_SOUND(target, sound('sound/misc/notice1.ogg'))
				else
					SEND_SOUND(target, sound('goon/sounds/announcement_1.ogg'))
