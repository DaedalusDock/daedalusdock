/obj/machinery/jukebox
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
	var/active = FALSE
	/// A list of mobs who are listening or were listening to the current song.
	var/list/hearers = list()

	var/stop = 0
	var/list/songs = list()
	var/datum/media/selection = null
	/// Volume of the songs played
	var/volume = 65
	COOLDOWN_DECLARE(jukebox_error_cd)

// here lies the Disco machine. May it rest in fuck.

/obj/machinery/jukebox/Initialize(mapload)
	. = ..()
	songs = SSmedia.get_track_pool(MEDIA_TAG_JUKEBOX)
	if(songs.len)
		selection = pick(songs)

/obj/machinery/jukebox/Destroy()
	music_over()
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
				if(stop > world.time)
					to_chat(usr, span_warning("Error: The device is still resetting from the last activation, it will be ready again in [DisplayTimeText(stop-world.time)]."))
					if(!COOLDOWN_FINISHED(src, jukebox_error_cd))
						return
					playsound(src, 'sound/misc/compiler-failure.ogg', 50, TRUE)
					COOLDOWN_START(src, jukebox_error_cd, 15 SECONDS)
					return
				activate_music()
				START_PROCESSING(SSobj, src)
				return TRUE
			else
				stop = 0
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
				return TRUE
			else if(new_volume == "min")
				volume = 0
				return TRUE
			else if(new_volume == "max")
				volume = initial(volume)
				return TRUE
			else if(text2num(new_volume) != null)
				volume = text2num(new_volume)
				return TRUE

/obj/machinery/jukebox/proc/activate_music()
	active = TRUE
	update_use_power(ACTIVE_POWER_USE)
	update_appearance()
	START_PROCESSING(SSobj, src)
	stop = world.time + selection.duration




/mob/proc/dance_flip()
	if(dir == WEST)
		emote("flip")





/mob/living/proc/lying_fix()
	animate(src, transform = null, time = 1, loop = 0)
	lying_prev = 0

/obj/machinery/jukebox/proc/music_over()
	for(var/datum/weakref/W as anything in hearers)
		var/mob/M = W.resolve()
		if(!M)
			continue
		unregister_signals(M)

	hearers.len = 0

#define JUKEBOX_RANGE 10
#define LISTENER_MUTED "muted"
#define LISTENER_HEARING "hearing"
/obj/machinery/jukebox/process()
	if(world.time < stop && active)
		var/sound/song_played = sound(selection.path)

		for(var/mob/M in SSspatial_grid.orthogonal_range_search(src, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS, JUKEBOX_RANGE))
			if(!M.client || !(M.client.prefs.toggles & SOUND_INSTRUMENTS))
				continue

			var/datum/weakref/W = WEAKREF(M)
			if((W in hearers))
				continue

			register_signals(M)
			if(!M.can_hear())
				hearers[W] = LISTENER_MUTED
				var/sound/muted = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
				muted.status = SOUND_MUTE
				M.playsound_local(get_turf(M), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = muted, use_reverb = TRUE)
				continue

			hearers[W] = LISTENER_HEARING
			M.playsound_local(get_turf(M), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = song_played, use_reverb = TRUE)

	else if(active)
		active = FALSE
		update_use_power(IDLE_POWER_USE)
		STOP_PROCESSING(SSobj, src)
		music_over()
		playsound(src,'sound/machines/terminal_off.ogg',50,TRUE)
		update_appearance()
		stop = world.time + 10 SECONDS

/obj/machinery/jukebox/proc/hearer_moved(mob/source)
	SIGNAL_HANDLER

	// If they aren't hearing music...
	if(hearers[WEAKREF(source)] == LISTENER_MUTED)
		// But they are now within range and aren't deaf...
		if(get_dist(src, source) <= JUKEBOX_RANGE && source.can_hear())
			var/sound/S = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
			S.status = SOUND_UPDATE
			source.playsound_local(get_turf(source), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)
			hearers[WEAKREF(source)] = LISTENER_HEARING

	// If they were hearing, but are now out of range...
	else if(get_dist(src, source) > JUKEBOX_RANGE)
		var/sound/S = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
		S.status = SOUND_UPDATE|SOUND_MUTE
		source.playsound_local(get_turf(source), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)
		hearers[WEAKREF(source)] = LISTENER_MUTED

/obj/machinery/jukebox/proc/hearer_deafened(mob/source)
	SIGNAL_HANDLER
	if(hearers[WEAKREF(source)] == LISTENER_MUTED)
		return

	var/sound/S = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
	S.status = SOUND_UPDATE|SOUND_MUTE
	source.playsound_local(get_turf(source), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)
	hearers[WEAKREF(source)] = LISTENER_MUTED

	RegisterSignal(source, SIGNAL_REMOVETRAIT(TRAIT_DEAF), PROC_REF(hearer_undeafened))

/obj/machinery/jukebox/proc/hearer_undeafened(mob/source)
	SIGNAL_HANDLER
	if(get_dist(src, source) > JUKEBOX_RANGE)
		return

	var/sound/S = sound(selection.path, channel = CHANNEL_JUKEBOX, volume = volume)
	S.status = SOUND_UPDATE
	source.playsound_local(get_turf(source), null, volume, channel = CHANNEL_JUKEBOX, sound_to_use = S, use_reverb = TRUE)

	hearers[WEAKREF(source)] = LISTENER_HEARING

/obj/machinery/jukebox/proc/unregister_signals(mob/hearer)
	UnregisterSignal(hearer, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(hearer, SIGNAL_ADDTRAIT(TRAIT_DEAF))
	UnregisterSignal(hearer, SIGNAL_REMOVETRAIT(TRAIT_DEAF))
	if(hearer.client)
		hearer.stop_sound_channel(CHANNEL_JUKEBOX)

/obj/machinery/jukebox/proc/register_signals(mob/hearer)
	RegisterSignal(hearer, COMSIG_MOVABLE_MOVED, PROC_REF(hearer_moved))
	RegisterSignal(hearer, SIGNAL_ADDTRAIT(TRAIT_DEAF), PROC_REF(hearer_deafened))

#undef LISTENER_HEARING
#undef LISTENER_MUTED
#undef JUKEBOX_RANGE
