/obj/machinery/jukebox
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
	var/active = FALSE
	/// A k:v list of weakref:status, either LISTENER_HEARING or LISTENER_MUTED
	var/list/hearers = list()

	// A timer id for stopping
	var/stop_timer

	var/list/songs = list()
	var/datum/media/selection = null
	/// Volume of the songs played
	var/volume = 65

	/// Prevents huge network overhead from the TGUI dial
	var/updating_volume = FALSE
	COOLDOWN_DECLARE(jukebox_error_cd)

	COOLDOWN_DECLARE(reactivation_timer)

// here lies the Disco machine. May it rest in fuck.

/obj/machinery/jukebox/Initialize(mapload)
	. = ..()
	songs = SSmedia.get_track_pool(MEDIA_TAG_JUKEBOX)
	if(songs.len)
		selection = pick(songs)

/obj/machinery/jukebox/Destroy()
	var/sound/S = sound()
	S.channel = CHANNEL_JUKEBOX

	for(var/mob/M in GLOB.player_list)
		SEND_SOUND(M, S)
	return ..()

/obj/machinery/jukebox/attackby(obj/item/O, mob/user, params)
	if(!active && !(flags_1 & NODECONSTRUCT_1))
		if(O.tool_behaviour == TOOL_WRENCH)
			if(!anchored && !isinspace())
				to_chat(user,span_notice("You secure [src] to the floor."))
				set_anchored(TRUE)
			else if(anchored)
				to_chat(user,span_notice("You unsecure and disconnect [src]."))
				set_anchored(FALSE)
			playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
			return
	return ..()

/obj/machinery/jukebox/update_icon_state()
	icon_state = "[initial(icon_state)][active ? "-active" : null]"
	return ..()

/obj/machinery/jukebox/ui_status(mob/user)
	if(!anchored)
		to_chat(user,span_warning("This device must be anchored by a wrench!"))
		return UI_CLOSE
	if(!allowed(user) && !isobserver(user))
		to_chat(user,span_warning("Error: Access Denied."))
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	if(!songs.len && !isobserver(user))
		to_chat(user,span_warning("Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue."))
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	return ..()

/obj/machinery/jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", name)
		ui.open()

/obj/machinery/jukebox/ui_data(mob/user)
	var/list/data = list()
	data["active"] = active
	data["songs"] = list()
	for(var/datum/media/S in songs)
		var/list/track_data = list(
			name = S.name
		)
		data["songs"] += list(track_data)
	data["track_selected"] = null
	data["track_length"] = null
	data["track_beat"] = null
	if(selection)
		data["track_selected"] = selection.name
		data["track_length"] = DisplayTimeText(selection.duration)
		data["track_author"] = selection.author
	data["volume"] = volume
	return data

/obj/machinery/jukebox/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			if(QDELETED(src))
				return
			if(!active)
				if(!COOLDOWN_FINISHED(src, reactivation_timer))
					to_chat(usr, span_warning("Error: The device is still resetting from the last activation, it will be ready again in [DisplayTimeText(COOLDOWN_TIMELEFT(src, reactivation_timer))]."))
					if(!COOLDOWN_FINISHED(src, jukebox_error_cd))
						return
					playsound(src, 'sound/misc/compiler-failure.ogg', 50, TRUE)
					COOLDOWN_START(src, jukebox_error_cd, 15 SECONDS)
					return
				activate_music()
				return TRUE
			else
				music_over()
				return TRUE
		if("select_track")
			if(active)
				to_chat(usr, span_warning("Error: You cannot change the song until the current one is over."))
				return
			var/list/available = list()
			for(var/datum/media/S in songs)
				available[S.name] = S
			var/selected = params["track"]
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/media))
				return
			selection = available[selected]
			return TRUE
		if("set_volume")
			var/new_volume = params["volume"]
			if(new_volume == "reset")
				volume = initial(volume)
				update_volume()
				return TRUE
			else if(new_volume == "min")
				volume = 0
				update_volume()
				return TRUE
			else if(new_volume == "max")
				volume = initial(volume)
				update_volume()
				return TRUE
			else if(text2num(new_volume) != null)
				volume = text2num(new_volume)
				update_volume()
				return TRUE


/obj/machinery/jukebox/proc/activate_music()
	active = TRUE
	update_use_power(ACTIVE_POWER_USE)
	update_appearance()
	update_clients()
	stop_timer = addtimer(CALLBACK(src, PROC_REF(music_over)), selection.duration, TIMER_STOPPABLE | TIMER_DELETE_ME)
	COOLDOWN_START(src, reactivation_timer, 30 SECONDS)

/obj/machinery/jukebox/proc/music_over()
	deltimer(stop_timer)

	for(var/mob/M as anything in hearers)
		unregister_signals(M)
	CHECK_TICK

	hearers.len = 0

	update_use_power(IDLE_POWER_USE)
	playsound(src,'sound/machines/terminal_off.ogg',50,TRUE)
	update_appearance()
	active = FALSE
	update_clients()

/mob/proc/dance_flip()
	if(dir == WEST)
		emote("flip")

/mob/living/proc/lying_fix()
	animate(src, transform = null, time = 1, loop = 0)
	lying_prev = 0


#define JUKEBOX_RANGE 10
#define LISTENER_MUTED "muted"
#define LISTENER_HEARING "hearing"
/obj/machinery/jukebox/proc/update_clients()
	if(!active)
		var/sound/S = sound()
		S.channel = CHANNEL_JUKEBOX

		for(var/mob/M in GLOB.player_list)
			SEND_SOUND(M, S)
		return

	var/sound/song_played = sound(selection.path)
	song_played.status = SOUND_STREAM
	for(var/mob/M in GLOB.player_list)
		CHECK_TICK
		if(isnewplayer(M) || !M.client || !(M.client.prefs.toggles & SOUND_INSTRUMENTS))
			continue

		if(hearers[M])
			continue

		register_signals(M)
		if(M.z != src.z || get_dist(src, M) > JUKEBOX_RANGE || !M.can_hear())
			hearers[M] = LISTENER_MUTED
			var/sound/muted = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
			muted.status = SOUND_MUTE|SOUND_STREAM
			M.playsound_local(get_turf(M), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = muted, use_reverb = TRUE)
			continue

		hearers[M] = LISTENER_HEARING
		M.playsound_local(get_turf(M), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = song_played, use_reverb = TRUE)

/obj/machinery/jukebox/proc/update_volume()
	set waitfor = FALSE
	if(updating_volume)
		return

	updating_volume = TRUE
	sleep(3 SECONDS) //Give a 3 second buffer for volume changes
	if(QDELETED(src))
		return

	var/sound/S = sound(selection.path)
	S.status = SOUND_UPDATE
	for(var/mob/hearer as anything in hearers)
		if(hearers[hearer] == LISTENER_MUTED)
			continue
		CHECK_TICK

		hearer.playsound_local(get_turf(hearer), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)

	updating_volume = FALSE

/obj/machinery/jukebox/proc/hearer_moved(mob/source)
	SIGNAL_HANDLER

	if(!hearers[source])
		return

	// If they aren't hearing music...
	if(hearers[source] == LISTENER_MUTED)
		// But they are now within range and aren't deaf...
		if(get_dist(src, source) <= JUKEBOX_RANGE && source.z == src.z && source.can_hear())
			var/sound/S = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
			S.status = SOUND_UPDATE
			source.playsound_local(get_turf(source), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)
			hearers[source] = LISTENER_HEARING

	// If they were hearing, but are now out of range...
	else if(source.z != src.z || get_dist(src, source) > JUKEBOX_RANGE)
		var/sound/S = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
		S.status = SOUND_UPDATE|SOUND_MUTE
		source.playsound_local(get_turf(source), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)
		hearers[source] = LISTENER_MUTED

/obj/machinery/jukebox/proc/hearer_deafened(mob/source)
	SIGNAL_HANDLER
	if(hearers[source] == LISTENER_MUTED)
		return

	var/sound/S = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
	S.status = SOUND_UPDATE|SOUND_MUTE
	source.playsound_local(get_turf(source), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)
	hearers[source] = LISTENER_MUTED

	RegisterSignal(source, SIGNAL_REMOVETRAIT(TRAIT_DEAF), PROC_REF(hearer_undeafened), TRUE)

/obj/machinery/jukebox/proc/hearer_undeafened(mob/source)
	SIGNAL_HANDLER
	if(get_dist(src, source) > JUKEBOX_RANGE || source.z != src.z)
		return

	var/sound/S = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
	S.status = SOUND_UPDATE
	source.playsound_local(get_turf(source), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)

	hearers[source] = LISTENER_HEARING

/obj/machinery/jukebox/proc/hearer_logout(mob/source)
	SIGNAL_HANDLER
	hearers -= source
	unregister_signals(source)

/obj/machinery/jukebox/proc/unregister_signals(mob/hearer)
	UnregisterSignal(
		hearer,
		list(
			COMSIG_MOVABLE_MOVED,
			COMSIG_MOVABLE_Z_CHANGED,
			SIGNAL_ADDTRAIT(TRAIT_DEAF),
			SIGNAL_REMOVETRAIT(TRAIT_DEAF),
			COMSIG_MOB_LOGOUT,
			COMSIG_PARENT_QDELETING,
		)
	)

	if(hearer.client)
		hearer.stop_sound_channel(CHANNEL_JUKEBOX)

/obj/machinery/jukebox/proc/register_signals(mob/hearer)
	RegisterSignal(hearer, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED), PROC_REF(hearer_moved))
	RegisterSignal(hearer, SIGNAL_ADDTRAIT(TRAIT_DEAF), PROC_REF(hearer_deafened))
	RegisterSignal(hearer, list(COMSIG_MOB_LOGOUT, COMSIG_PARENT_QDELETING), PROC_REF(hearer_logout))

#undef LISTENER_HEARING
#undef LISTENER_MUTED
#undef JUKEBOX_RANGE
