/// The subsystem used to play ambience to users every now and then, makes them real excited.
SUBSYSTEM_DEF(ambience)
	name = "Ambience"
	flags = SS_BACKGROUND|SS_NO_INIT
	priority = FIRE_PRIORITY_AMBIENCE
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 1 SECONDS
	///Assoc list of listening client - next ambience time
	var/list/ambience_listening_clients = list()
	var/list/client_old_areas = list()
	///Cache for sanic speed :D
	var/list/currentrun = list()

/datum/controller/subsystem/ambience/fire(resumed)
	if(!resumed)
		currentrun = ambience_listening_clients.Copy()
	var/list/cached_clients = currentrun

	while(cached_clients.len)
		var/client/client_iterator = cached_clients[cached_clients.len]
		cached_clients.len--

		//Check to see if the client exists and isn't held by a new player
		var/mob/client_mob = client_iterator?.mob
		if(isnull(client_iterator))
			ambience_listening_clients -= client_iterator
			client_old_areas -= client_iterator
			continue

		if(isnewplayer(client_mob))
			client_old_areas -= client_iterator
			continue

		var/atom/movable/hearer = client_mob.hear_location()
		if(ismob(hearer))
			var/mob/hearer_mob = hearer
			if(!hearer_mob.can_hear())
				continue

		//Check to see if the client-mob is in a valid area
		var/area/current_area = get_area(client_mob)
		if(!current_area) //Something's gone horribly wrong
			stack_trace("[key_name(client_mob)] has somehow ended up in nullspace. WTF did you do")
			remove_ambience_client(client_iterator)
			continue

		if(ambience_listening_clients[client_iterator] > world.time)
			if(!(current_area.forced_ambience && (client_old_areas?[client_iterator] != current_area) && prob(5)))
				continue

		//Run play_ambience() on the client-mob and set a cooldown
		ambience_listening_clients[client_iterator] = world.time + current_area.play_ambience(client_mob)

		//We REALLY don't want runtimes in SSambience
		if(client_iterator)
			client_old_areas[client_iterator] = current_area

		if(MC_TICK_CHECK)
			return

///Attempts to play an ambient sound to a mob, returning the cooldown in deciseconds
/area/proc/play_ambience(mob/M, sound/override_sound, volume = 27)
	var/turf/T = get_turf(M)
	var/sound/new_sound = override_sound || pick(ambientsounds)
	new_sound = sound(new_sound, channel = CHANNEL_AMBIENCE)
	M.playsound_local(
		T,
		new_sound,
		volume,
		FALSE,
		channel = CHANNEL_AMBIENCE
	)

	var/sound_length = ceil(SSsound_cache.get_sound_length(new_sound.file))
	return rand(min_ambience_cooldown + sound_length, max_ambience_cooldown + sound_length)

/datum/controller/subsystem/ambience/proc/remove_ambience_client(client/to_remove)
	ambience_listening_clients -= to_remove
	client_old_areas -= to_remove
	currentrun -= to_remove

/area/station/maintenance
	min_ambience_cooldown = 20 SECONDS
	max_ambience_cooldown = 35 SECONDS

	///A list of rare sound effects to fuck with players.
	var/static/list/minecraft_cave_noises = list(
		'sound/machines/doors/airlock_open.ogg',
		'sound/effects/snap.ogg',
		'sound/effects/clownstep1.ogg',
		'sound/effects/clownstep2.ogg',
		'sound/items/welder.ogg',
		'sound/items/welder2.ogg',
		'sound/items/crowbar.ogg',
		'sound/items/deconstruct.ogg',
		'sound/ambience/source_holehit3.ogg',
		'sound/ambience/cavesound3.ogg',
		'sound/ambience/Cave1.ogg',
	)

/area/station/maintenance/play_ambience(mob/M, sound/override_sound, volume)
	if(!M.has_light_nearby() && prob(0.5))
		return ..(M, pick(minecraft_cave_noises))
	return ..()

/// Set the mob's tracked ambience area, and unset the old one.
/mob/proc/update_ambience_area(area/new_area)
	var/old_tracked_area = ambience_tracked_area
	if(old_tracked_area)
		UnregisterSignal(old_tracked_area, COMSIG_AREA_POWER_CHANGE)
		ambience_tracked_area = null

	if(new_area)
		ambience_tracked_area = new_area
		RegisterSignal(ambience_tracked_area, COMSIG_AREA_POWER_CHANGE, PROC_REF(refresh_looping_ambience), TRUE)

	if(!client)
		return

	refresh_looping_ambience()

///Tries to play looping ambience to the mobs.
/mob/proc/refresh_looping_ambience()
	SIGNAL_HANDLER
	if(!client)
		return

	var/sound_file = ambience_tracked_area?.ambient_buzz

	if(!(client.prefs.toggles & SOUND_SHIP_AMBIENCE) || !sound_file || !can_hear())
		SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = CHANNEL_BUZZ))
		client.playing_ambience = null
		return

	//Station ambience is dependant on a functioning and charged APC.
	if(!is_mining_level(ambience_tracked_area.z) && ((!ambience_tracked_area.apc || !ambience_tracked_area.apc.operating || !ambience_tracked_area.apc.cell?.charge && ambience_tracked_area.requires_power)))
		SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = CHANNEL_BUZZ))
		client.playing_ambience = null
		return

	else
		if(client.playing_ambience == sound_file)
			return

		client.playing_ambience = sound_file
		SEND_SOUND(src, sound(sound_file, repeat = 1, wait = 0, volume = ambience_tracked_area.ambient_buzz_vol, channel = CHANNEL_BUZZ))
