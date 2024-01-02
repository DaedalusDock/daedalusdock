/**
 * proc for playing a screen_text on a mob.
 * enqueues it if a screen text is running and plays i otherwise
 * Arguments:
 * * text: text we want to be displayed
 * * alert_type: typepath for screen text type we want to play here
 */
/mob/proc/play_screen_text(text, alert = /atom/movable/screen/text/screen_text)
	if(!client)
		return

	var/atom/movable/screen/text/screen_text/text_box
	if(ispath(alert))
		text_box = new alert()
	else
		text_box = alert

	if(text)
		text_box.text_to_play = text

	LAZYADD(client.screen_texts, text_box)
	text_box.owner_ref = WEAKREF(client)

	if(LAZYLEN(client.screen_texts) == 1) //lets only play one at a time, for thematic effect and prevent overlap
		INVOKE_ASYNC(text_box, TYPE_PROC_REF(/atom/movable/screen/text/screen_text, play_to_client))
		return

/atom/movable/screen/text/screen_text
	icon = null
	icon_state = null
	alpha = 255
	plane = HUD_PLANE

	maptext_height = 64
	maptext_width = 480
	maptext_x = 0
	maptext_y = 0
	screen_loc = "LEFT,TOP-3"

	///A weakref to the client this belongs to
	var/datum/weakref/owner_ref

	///Time taken to fade in as we start printing text
	var/fade_in_time = 0
	///Time before fade out after printing is finished
	var/fade_out_delay = 8 SECONDS
	///Time taken when fading out after fade_out_delay
	var/fade_out_time = 0.5 SECONDS
	///delay between playing each letter. in general use 1 for fluff and 0.5 for time sensitive messsages
	var/play_delay = 1
	///letters to update by per text to per play_delay
	var/letters_per_update = 1

	///opening styling for the message
	var/style_open = "<span class='maptext' style=font-size:20pt;text-align:center valign='top'>"
	///closing styling for the message
	var/style_close = "</span>"
	///var for the text we are going to play
	var/text_to_play

	/// Should this automatically end?
	var/auto_end = TRUE

/atom/movable/screen/text/screen_text/Destroy()
	if(owner_ref)
		remove_from_screen()
	return ..()

/**
 * proc for actually playing this screen_text on a mob.
 */
/atom/movable/screen/text/screen_text/proc/play_to_client()

	var/client/owner = owner_ref.resolve()
	if(!owner)
		return

	owner.screen += src

	if(fade_in_time)
		animate(src, alpha = 255)

	var/list/lines_to_skip = list()
	var/static/html_locate_regex = regex("<.*>")
	var/tag_position = findtext(text_to_play, html_locate_regex)
	var/reading_tag = TRUE

	while(tag_position)
		if(reading_tag)
			if(text_to_play[tag_position] == ">")
				reading_tag = FALSE
				lines_to_skip += tag_position
			else
				lines_to_skip += tag_position
			tag_position++
		else
			tag_position = findtext(text_to_play, html_locate_regex, tag_position)
			reading_tag = TRUE

	// tag_position = findtext(text_to_play, "&nbsp;")
	// while(tag_position)
	// 	lines_to_skip.Add(tag_position, tag_position+1, tag_position+2, tag_position+3, tag_position+4, tag_position+5)
	// 	tag_position = tag_position + 6
	// 	tag_position = findtext(text_to_play, "&nbsp;", tag_position)

	for(var/letter = 2 to length(text_to_play) + letters_per_update step letters_per_update)
		if(letter in lines_to_skip)
			continue

		maptext = "[style_open][copytext_char(text_to_play, 1, letter)][style_close]"
		if(QDELETED(src))
			return
		sleep(play_delay)

	if(auto_end)
		addtimer(CALLBACK(src, PROC_REF(fade_out)), fade_out_delay)

///handles post-play effects like fade out after the fade out delay
/atom/movable/screen/text/screen_text/proc/fade_out()
	if(!fade_out_time)
		end_play()
		return

	animate(src, alpha = 0, time = fade_out_time)
	addtimer(CALLBACK(src, PROC_REF(end_play)), fade_out_time)

///ends the play then deletes this screen object and plalys the next one in queue if it exists
/atom/movable/screen/text/screen_text/proc/end_play()
	remove_and_play_next()
	qdel(src)

/// Removes the text from the player's screen and plays the next one if present.
/atom/movable/screen/text/screen_text/proc/remove_and_play_next()
	var/client/owner = owner_ref.resolve()
	if(isnull(owner))
		return

	remove_from_screen()
	if(!LAZYLEN(owner.screen_texts))
		return
	owner.screen_texts[1].play_to_client()

/atom/movable/screen/text/screen_text/proc/remove_from_screen()
	var/client/owner = owner_ref.resolve()
	if(isnull(owner))
		return

	owner.screen -= src
	LAZYREMOVE(owner.screen_texts, src)
