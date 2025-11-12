TYPEINFO_DEF(/obj/item/taperecorder)
	default_materials = list(/datum/material/iron=60, /datum/material/glass=30)

/obj/item/taperecorder
	name = "Fony Strideman R03"
	desc = "A device that can record and play magnetic tapes."
	icon = 'icons/obj/device.dmi'
	icon_state = "taperecorder_empty"
	inhand_icon_state = "analyzer"
	worn_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	force = 2
	throwforce = 2
	speech_span = SPAN_TAPE_RECORDER
	drop_sound = 'sound/items/handling/taperecorder_drop.ogg'
	pickup_sound = 'sound/items/handling/taperecorder_pickup.ogg'

	var/tmp/recording = FALSE
	var/tmp/playing = FALSE
	var/tmp/playsleepseconds = 0
	/// The tape inside.
	var/tmp/obj/item/tape/mytape
	/// Timer ID for the stop() callback. Used when playing media.
	var/tmp/stop_timer_id

	var/starting_tape_type = /obj/item/tape/random

	var/tmp/open_panel = FALSE
	var/canprint = FALSE

	var/list/icons_available = list()
	var/radial_icon_file = 'icons/hud/radial_taperecorder.dmi'
	///Whether we've warned during this recording session that the tape is almost up.
	var/time_warned = FALSE
	///Seconds under which to warn that the tape is almost up.
	var/time_left_warning = 60 SECONDS

	///Sound loop that plays when recording or playing back.
	var/tmp/datum/looping_sound/tape_recorder_hiss/soundloop

	/// Sound when playing a music tape.
	var/tmp/datum/sound_token/sound_token

/obj/item/taperecorder/Initialize(mapload)
	. = ..()
	if(starting_tape_type)
		mytape = new starting_tape_type(src)

	soundloop = new(src)
	update_appearance()
	become_hearing_sensitive()

/obj/item/taperecorder/Destroy()
	QDEL_NULL(soundloop)
	QDEL_NULL(sound_token)
	QDEL_NULL(mytape)
	deltimer(stop_timer_id)
	return ..()

/obj/item/taperecorder/proc/readout()
	if(mytape)
		if(playing)
			return span_info("<b>PLAYING</b>")
		else
			var/time = mytape.used_capacity / 10 //deciseconds / 10 = seconds
			var/mins = floor(time / 60)
			var/secs = time - mins * 60
			return span_info("<b>[mins]</b>m <b>[secs]</b>s")
	return span_info("<b>EMPTY</b>")

/obj/item/taperecorder/examine(mob/user)
	. = ..()
	if(in_range(src, user) || isobserver(user))
		. += span_info("The wire panel is [open_panel ? "opened" : "closed"]. The display reads:")
		. += "[readout()]"

/obj/item/taperecorder/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	switch(rand(1, 10))
		if(1 to 4)
			if(playing || recording)
				stop()
		if(5)
			eject()

		else
			noop()
	. = ..()

/obj/item/taperecorder/AltClick(mob/user)
	. = ..()
	play()

/obj/item/taperecorder/proc/update_available_icons()
	icons_available = list()

	if(!playing && !recording)
		icons_available += list("Record" = image(radial_icon_file,"record"))
		icons_available += list("Play" = image(radial_icon_file,"play"))
		if(canprint && mytape?.storedinfo.len)
			icons_available += list("Print Transcript" = image(radial_icon_file,"print"))

	if(playing || recording)
		icons_available += list("Stop" = image(radial_icon_file,"stop"))

	if(mytape)
		icons_available += list("Eject" = image(radial_icon_file,"eject"))

/// Updates the status of the soundloop.
/obj/item/taperecorder/proc/update_sound()
	if(!playing && !recording)
		soundloop.stop()
	else
		soundloop.start()

/obj/item/taperecorder/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(mytape)
		return NONE

	if(!istype(tool, /obj/item/tape))
		return NONE

	if(!user.transferItemToLoc(tool,src))
		return ITEM_INTERACT_BLOCKING

	mytape = tool
	user.visible_message(span_notice("[user] inserts [tool] into [src]."), vision_distance = COMBAT_MESSAGE_RANGE)
	playsound(src, 'sound/items/taperecorder/taperecorder_close.ogg', 50, FALSE)
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/taperecorder/proc/eject(mob/user)
	if(mytape)
		playsound(src, 'sound/items/taperecorder/taperecorder_open.ogg', 50, FALSE)
		to_chat(user, span_notice("You remove [mytape] from [src]."))
		stop()
		user.put_in_hands(mytape)
		mytape = null
		update_appearance()

/obj/item/taperecorder/fire_act(exposed_temperature, exposed_volume, turf/adjacent)
	mytape.unspool() //Fires unspool the tape, which makes sense if you don't think about it
	..()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/taperecorder/attack_hand(mob/user, list/modifiers)
	if(loc != user || !mytape || !user.is_holding(src))
		return ..()
	eject(user)

/// Returns TRUE if given no user or the user is able to interact with this. Stupid legacy bullshit.
/obj/item/taperecorder/proc/can_use(mob/user)
	if(!ismob(user))
		return TRUE

	return !user.incapacitated()

/obj/item/taperecorder/verb/ejectverb()
	set name = "Eject Tape"
	set category = "Object"

	if(!can_use(usr))
		return
	if(!mytape)
		return

	eject(usr)

/obj/item/taperecorder/update_icon_state()
	if(!mytape)
		icon_state = "taperecorder_empty"
		return ..()
	if(recording)
		icon_state = "taperecorder_recording"
		return ..()
	if(playing)
		icon_state = "taperecorder_playing"
		return ..()
	icon_state = "taperecorder_idle"
	return ..()


/obj/item/taperecorder/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, spans, list/message_mods = list(), atom/sound_loc, message_range)
	. = ..()
	if(mytape && recording)
		mytape.timestamp += mytape.used_capacity
		mytape.storedinfo += "\[[time2text(mytape.used_capacity,"mm:ss")]\] [message]"


/obj/item/taperecorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(!can_use(usr))
		return
	if(!mytape || mytape.unspooled)
		return
	if(recording)
		return
	if(playing)
		return

	playsound(src, 'sound/items/taperecorder/taperecorder_play.ogg', 50, FALSE)

	if(mytape.used_capacity >= mytape.max_capacity)
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)
		return

	recording = TRUE
	say("BEGIN RECORDING")

	update_sound()
	update_appearance()
	var/used = mytape.used_capacity //to stop runtimes when you eject the tape
	var/max = mytape.max_capacity
	while(recording && used < max)
		mytape.used_capacity += 1 SECONDS
		used += 1 SECONDS
		if(max - used < time_left_warning && !time_warned)
			time_warned = TRUE
			say("[(max - used) / 10] SECONDS LEFT") //deciseconds / 10 = seconds
		sleep(1 SECONDS)

	if(used >= max)
		say("CASSETTE FULL")

	stop()

/// Stops playing or recording.
/obj/item/taperecorder/proc/stop(mob/user)
	if(!(playing || recording) || !can_use(user))
		return FALSE

	deltimer(stop_timer_id)
	stop_timer_id = null

	if(recording)
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)
		say("END RECORDING")
		recording = FALSE

	else if(playing)
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)
		playing = FALSE

	if(sound_token)
		QDEL_NULL(sound_token)

	time_warned = FALSE
	update_appearance()
	update_sound()
	return TRUE

/obj/item/taperecorder/verb/play()
	set name = "Play Tape"
	set category = "Object"

	if(!can_use(usr))
		return
	if(!mytape || mytape.unspooled)
		return
	if(recording)
		return
	if(playing)
		return

	playing = TRUE
	update_appearance()
	update_sound()

	if(mytape.song_currentside)
		sound_token = new(src, sound(mytape.song_currentside.path), 4, 15, 2)
		stop_timer_id = addtimer(CALLBACK(src, PROC_REF(stop)), mytape.song_currentside.duration, TIMER_STOPPABLE | TIMER_DELETE_ME | TIMER_CLIENT_TIME)
		return

	say("BEGIN PLAYBACK")
	playsound(src, 'sound/items/taperecorder/taperecorder_play.ogg', 50, FALSE)
	var/used = mytape.used_capacity //to stop runtimes when you eject the tape
	var/max = mytape.max_capacity
	for(var/i = 1, used <= max, sleep(playsleepseconds))
		if(!mytape)
			break
		if(playing == FALSE)
			break
		if(mytape.storedinfo.len < i)
			say("END OF RECORDING")
			break

		say("[mytape.storedinfo[i]]", sanitize=FALSE)//We want to display this properly, don't double encode

		if(mytape.storedinfo.len < i + 1)
			playsleepseconds = 1
			sleep(1 SECONDS)
		else
			playsleepseconds = mytape.timestamp[i + 1] - mytape.timestamp[i]

		if(playsleepseconds > 14 SECONDS)
			sleep(1 SECONDS)
			say("SKIPPING [playsleepseconds / 10] SECONDS OF SILENCE")
			playsleepseconds = clamp(playsleepseconds / 10, 1 SECONDS, 3 SECONDS)

		i++

	stop(null) // Auto-stop, doesn't care about the user.

/// Wrapper verb for the stop proc.
/obj/item/taperecorder/verb/stop_verb()
	set name = "Stop"
	set category = "Object"

	stop(usr)

/obj/item/taperecorder/attack_self(mob/user)
	if(!mytape)
		to_chat(user, span_notice("\The [src] is empty."))
		return
	if(mytape.unspooled)
		to_chat(user, span_warning("\The tape inside \the [src] is broken!"))
		return

	update_available_icons()
	if(icons_available)
		var/selection = show_radial_menu(user, src, icons_available, radius = 38, require_near = TRUE, tooltips = TRUE)
		if(!selection)
			return
		switch(selection)
			if("Stop")
				stop()
			if("Record")
				record()
			if("Play")
				play()
			if("Print Transcript")
				print_transcript()
			if("Eject")
				eject(user)

/obj/item/taperecorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(!mytape.storedinfo.len)
		return
	if(!can_use(usr))
		return
	if(!mytape)
		return
	if(!canprint)
		to_chat(usr, span_warning("The recorder can't print that fast!"))
		return
	if(recording || playing)
		return

	say("TRANSCRIPT PRINTED")
	playsound(src, 'sound/items/taperecorder/taperecorder_print.ogg', 50, FALSE)

	var/obj/item/paper/P = new /obj/item/paper/thermal(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i in 1 to mytape.storedinfo.len)
		t1 += "[mytape.storedinfo[i]]<BR>"
	P.info = t1

	var/tapename = mytape.name
	var/prototapename = initial(mytape.name)
	P.name = "paper- '[tapename == prototapename ? "Tape" : "[tapename]"] Transcript'"
	P.update_icon_state()
	usr.put_in_hands(P)
	canprint = FALSE
	addtimer(VARSET_CALLBACK(src, canprint, TRUE), 30 SECONDS)


//empty tape recorders
/obj/item/taperecorder/empty
	starting_tape_type = null


TYPEINFO_DEF(/obj/item/tape)
	default_materials = list(/datum/material/iron=20, /datum/material/glass=5)

/obj/item/tape
	name = "cassette"
	desc = "A magnetic tape for storing audio."
	icon_state = "tape_white"
	icon = 'icons/obj/device.dmi'
	inhand_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	force = 1
	throwforce = 0
	obj_flags = UNIQUE_RENAME //my mixtape
	drop_sound = 'sound/items/handling/tape_drop.ogg'
	pickup_sound = 'sound/items/handling/tape_pickup.ogg'

	// I don't want song info to update as the songs are changed, since that isn't immersive. So they're stored on init and kept forever.
	var/desc_song_currentside
	var/desc_song_otherside

	///Because we can't expect God to do all the work.
	var/initial_icon_state
	var/max_capacity = 10 MINUTES
	var/used_capacity = 0 SECONDS
	///Numbered list of chat messages the recorder has heard with spans and prepended timestamps. Used for playback and transcription.
	var/list/storedinfo = list()
	///Numbered list of seconds the messages in the previous list appear at on the tape. Used by playback to get the timing right.
	var/list/timestamp = list()
	var/used_capacity_otherside = 0 SECONDS //Separate my side
	var/list/storedinfo_otherside = list()
	var/list/timestamp_otherside = list()
	var/unspooled = FALSE
	var/list/icons_available = list()
	var/radial_icon_file = 'icons/hud/radial_tape.dmi'

	/// Media ref for the song on side A
	var/datum/media/song_currentside
	/// Media ref for the song on side B
	var/datum/media/song_otherside

/obj/item/tape/fire_act(exposed_temperature, exposed_volume, turf/adjacent)
	unspool()
	..()

/obj/item/tape/Initialize(mapload)
	. = ..()
	initial_icon_state = icon_state //random tapes will set this after choosing their icon

	var/mycolor = random_short_color()
	if(icon_state == "tape_greyscale")
		add_atom_colour("#[mycolor]", FIXED_COLOUR_PRIORITY)

	return INITIALIZE_HINT_LATELOAD

/obj/item/tape/LateInitialize()
	if(prob(50))
		tapeflip()

/obj/item/tape/proc/update_available_icons()
	icons_available = list()

	if(!unspooled)
		icons_available += list("Unwind tape" = image(radial_icon_file,"tape_unwind"))
	icons_available += list("Flip tape" = image(radial_icon_file,"tape_flip"))

/obj/item/tape/examine(mob/user)
	. = ..()
	if(desc_song_currentside)
		. += span_info("This side is labelled \"[desc_song_currentside]\".")

/obj/item/tape/attack_self(mob/user)
	update_available_icons()
	if(icons_available)
		var/selection = show_radial_menu(user, src, icons_available, radius = 38, require_near = TRUE, tooltips = TRUE)
		if(!selection)
			return

		switch(selection)
			if("Flip tape")
				if(loc != user)
					return

				tapeflip()
				to_chat(user, span_notice("You turn \the [src] over."))
				playsound(src, 'sound/items/taperecorder/tape_flip.ogg', 70, FALSE)

			if("Unwind tape")
				if(loc != user)
					return

				unspool()
				to_chat(user, span_warning("You pull out all the tape."))

/obj/item/tape/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(prob(50))
		tapeflip()
	. = ..()

/obj/item/tape/proc/unspool()
	if(unspooled)
		return

	add_overlay("ribbonoverlay")
	unspooled = TRUE

/obj/item/tape/proc/respool()
	cut_overlay("ribbonoverlay")
	unspooled = FALSE

/// Flips the tape, changing all of the relevant values and updating the appearance.
/obj/item/tape/proc/tapeflip()
	//first we save a copy of our current side
	var/list/storedinfo_currentside = storedinfo.Copy()
	var/list/timestamp_currentside = timestamp.Copy()
	var/used_capacity_currentside = used_capacity
	var/new_song_otherside = song_currentside
	var/new_song_desc_otherside = desc_song_currentside

	//then we overwite our current side with our other side
	storedinfo = storedinfo_otherside.Copy()
	timestamp = timestamp_otherside.Copy()
	used_capacity = used_capacity_otherside
	song_currentside = song_otherside
	desc_song_currentside = desc_song_otherside

	//then we overwrite our other side with the saved side
	storedinfo_otherside = storedinfo_currentside.Copy()
	timestamp_otherside = timestamp_currentside.Copy()
	used_capacity_otherside = used_capacity_currentside
	song_otherside = new_song_otherside
	desc_song_otherside = new_song_desc_otherside

	if(icon_state == initial_icon_state)
		icon_state = "[initial_icon_state]_reverse"
	else if(icon_state == "[initial_icon_state]_reverse") //so flipping doesn't overwrite an unexpected icon_state (e.g. an admin's)
		icon_state = initial_icon_state

/obj/item/tape/screwdriver_act(mob/living/user, obj/item/tool)
	if(!unspooled)
		return FALSE

	to_chat(user, span_notice("You start winding the tape back in..."))

	if(tool.use_tool(src, user, 120))
		to_chat(user, span_notice("You wind the tape back in."))
		respool()

//Random colour tapes
/obj/item/tape/random
	icon_state = "random_tape"

/obj/item/tape/random/Initialize(mapload)
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple", "greyscale")]"
	. = ..()

// Media tapes
/obj/item/tape/music

/obj/item/tape/music/Initialize(mapload)
	. = ..()
	desc_song_currentside ||= "[song_currentside?.name]"
	desc_song_otherside ||= "[song_otherside?.name]"

	if(song_currentside)
		used_capacity = song_currentside.duration

	if(song_otherside)
		used_capacity_otherside = song_otherside.duration

/obj/item/tape/music
	/// The media tag to pull from
	var/media_tag = MEDIA_TAG_CASSETTE
	/// If TRUE, will pick_n_take() vs using the first two entries
	var/random_songs = FALSE

/obj/item/tape/music/Initialize(mapload)
	var/list/song_pool = SSmedia.get_track_pool(media_tag)
	if(!length(song_pool))
		WARNING("Music tape with tag [media_tag] could not load any songs.")
	else
		if(random_songs)
			song_currentside = pick_n_take(song_pool)
			song_otherside = pick_n_take(song_pool)
		else
			song_currentside = song_pool[1]
			if(length(song_pool) >= 2)
				song_otherside = song_pool[2]
	. = ..()

/obj/item/tape/music/white
	name = "cassette \"Ghost Gurlz\""
	icon_state = "tape_white"
	media_tag = MEDIA_TAG_WHITEWOMEN
	random_songs = TRUE

/obj/item/tape/music/red
	name = "cassette \"RED PRIDE\""
	desc = "A magnetic tape so blisteringly RED it strains your eyes."
	icon_state = "tape_red"

	media_tag = MEDIA_TAG_IS12

/obj/item/tape/music/red/Initialize(mapload)
	. = ..()
	name = pick("cassette \"RED PRIDE\"", "cassette \"GREAT LEADER MIX\"", "cassette \"ITALIAN HATE SESH\"")

/obj/item/tape/dyed
	icon_state = "greyscale"

/obj/item/tape/rats
	storedinfo = list(
		"\[00:01\] This place is a mess, how do people live here?",
		"\[00:04\] It's like this station hasn't been serviced in decades.",
		"\[00:07\] Atleast the people here are kind, except for Ann. The wench. |+I CAN HEAR YOU IN THERE!+|",
		"\[00:08\] +PISS OFF, ANN!+",
		"\[00:42\] |I'll finish this tomorrow.|",
		"\[00:50\] How are there |rats| on a space station this far out? This has to be some kind of scientific wonder.",
		"\[01:00\] |Tom? Would you mind helping me with something in the botanical lab?|",
		"\[01:05\] Yeah, yeah.",
		"\[01:10\] Mary, the station's botanist, is a loon. She \"took care\" of a rat with a |monkey wrench|, who does that?!",
		"\[01:19\] The squeaking outside my room is driving me mad. I may ask Mary for some help with this.",
		"\[01:29\] *Airlock opening*",
		"\[01:33\] Mary? What ar-",
		"\[01:35\] *|CLANG!|*",
		"\[01:37\] *|CLANG!|*",
		"\[01:39\] *|CLANG!|*",
		"\[01:47\] *Feminine panting*",
		"\[01:59\] Mary Ann.",
	)

	timestamp = list(
		1 SECONDS,
		4 SECONDS,
		7 SECONDS,
		8 SECONDS,
		42 SECONDS,
		50 SECONDS,
		1 MINUTES,
		1 MINUTES + 5 SECONDS,
		1 MINUTES + 10 SECONDS,
		1 MINUTES + 19 SECONDS,
		1 MINUTES + 29 SECONDS,
		1 MINUTES + 33 SECONDS,
		1 MINUTES + 35 SECONDS,
		1 MINUTES + 37 SECONDS,
		1 MINUTES + 39 SECONDS,
		1 MINUTES + 47 SECONDS,
		1 MINUTES + 59 SECONDS,
	)
