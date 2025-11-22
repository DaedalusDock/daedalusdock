TYPEINFO_DEF(/obj/item/taperecorder)
	default_materials = list(/datum/material/iron=60, /datum/material/glass=30)

/obj/item/taperecorder
	name = "\improper Fony Strideman R03"
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
		if(mytape)
			. += span_info("There is \a [mytape.name] loaded.")
		. += span_info("The display reads: \"[readout()]\"")

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
		sound_token = new(src, sound(mytape.song_currentside.path), 4, 20, 2)
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

