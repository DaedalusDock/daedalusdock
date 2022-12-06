SUBSYSTEM_DEF(dynost)
	name = "Dynamic OST"
	wait = 1 SECONDS
	flags = SS_KEEP_TIMING

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/dynost/fire(resumed)
	if(!resumed)
		currentrun = processing.Copy()

	for(var/datum/dynost/control as anything in currentrun)
		if(!control.parent.client)
			currentrun -= control
			if(MC_TICK_CHECK)
				return
			continue

		control.process()
		if(MC_TICK_CHECK)
			return

#define NO_UPDATE 0
#define UPDATE_PAUSE 1
#define UPDATE_UNPAUSE 2

/datum/dynost
	var/mob/parent

	var/list/sounddata

	var/is_paused = FALSE
	var/is_active = FALSE
	var/needs_update_flags = UPDATE_PAUSE

	var/process_count = 0
	var/step = 0
	var/dead_air_time = 0
	var/last_process_tod = 0
	var/sound_data_ready = TRUE
	var/awaiting_data = FALSE

	var/datum/dynsound/tension = new('sound/dynamic_ost/DrumBeats.mp3', CHANNEL_DYNOST_TENSION)
	var/datum/dynsound/action = new('sound/dynamic_ost/DrumBeats.mp3', CHANNEL_DYNOST_ACTION)
	var/datum/dynsound/calm = new('sound/dynamic_ost/DrumBeats.mp3', CHANNEL_DYNOST_CALM)
	var/list/channels = new()

/datum/dynost/New(owner)
	parent = owner
	RegisterSignal(parent, COMSIG_MOB_LOGIN, .proc/on_login)
	RegisterSignal(parent, COMSIG_MOB_LOGOUT, .proc/on_logout)
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, .proc/on_parent_del)

	channels[tension.channel] = tension
	channels[action.channel] = action
	channels[calm.channel] = calm

	if(parent.client)
		on_login()


/datum/dynost/Destroy(force, ...)
	on_logout()
	return ..()

/datum/dynost/proc/on_login()
	SIGNAL_HANDLER
	SEND_SOUND(parent.client, sound(tension.music_file, repeat = TRUE, channel = tension.channel, volume = 0))
	SEND_SOUND(parent.client, sound(action.music_file, repeat = TRUE, channel = action.channel, volume = 0))
	SEND_SOUND(parent.client, sound(calm.music_file, repeat = TRUE, channel = calm.channel, volume = 0))
	is_active = TRUE
	SSdynost.processing |= src
	last_process_tod = world.timeofday

/datum/dynost/proc/on_logout()
	SIGNAL_HANDLER
	SSdynost.processing -= src
	is_active = FALSE
	needs_update_flags = NO_UPDATE
	tension.clear()
	action.clear()
	calm.clear()

/datum/dynost/proc/on_parent_del()
	SIGNAL_HANDLER
	qdel(src)

/datum/dynost/process()
	process_count++
	step++
	if(step == 4)
		step = 1
	var/current_time = world.timeofday

	if(needs_update_flags)
		if(!sound_data_ready)
			if(!awaiting_data)
				get_sound_data()
			return
		else
			if(needs_update_flags & UPDATE_PAUSE)
				pause()
				return
			else if(needs_update_flags & UPDATE_UNPAUSE)
				unpause()
				return

	if(tension.current < 10 && calm.current <= 10 && action.current <= 10)
		dead_air_time += current_time - last_process_tod
		if(dead_air_time >= 10 SECONDS)
			needs_update_flags = UPDATE_PAUSE
			return

	else if(is_paused)
		needs_update_flags = UPDATE_UNPAUSE
		return

	if(current_time - tension.last_event >= 10 SECONDS)
		tension.target -= tension.decay_rate
	if(current_time - action.last_event >= 10 SECONDS)
		action.target -= action.decay_rate
	if(current_time - calm.last_event >= 10 SECONDS)
		calm.target -= tension.decay_rate

	if(!process_count % 3)
		calm.update_target()
		tension.update_target()
		action.update_target()

	if(parent.client)
		calm.tick(parent.client, step)
		tension.tick(parent.client, step)
		action.tick(parent.client, step)

	last_process_tod = current_time

/datum/dynost/proc/get_sound_data()
	set waitfor = FALSE
	awaiting_data = TRUE
	sounddata = parent.client?.SoundQuery()
	sound_data_ready = TRUE
	awaiting_data = FALSE
	return TRUE

/datum/dynost/proc/pause()
	if(!parent.client)
		return FALSE

	for(var/sound/S as anything in sounddata)
		if(!(S.channel in channels))
			continue
		if(!(S.status & SOUND_PAUSED))
			var/datum/dynsound/ost = channels[S.channel]
			var/sound/sound_update = sound(ost.music_file, repeat = TRUE, channel = S.channel, volume = S.volume)
			S.status = SOUND_UPDATE | SOUND_PAUSED
			SEND_SOUND(parent.client, sound_update)
			ost.paused = TRUE
	is_paused = TRUE
	sound_data_ready = FALSE
	needs_update_flags &= ~UPDATE_PAUSE
	return TRUE

/datum/dynost/proc/unpause()
	if(!parent.client)
		return FALSE
	for(var/sound/S as anything in sounddata)
		if(!(S.channel in channels))
			continue
		if(S.status & SOUND_PAUSED)
			var/datum/dynsound/ost = channels[S.channel]
			var/sound/sound_update = sound(ost.music_file, repeat = TRUE, channel = S.channel, volume = S.volume)
			S.status = SOUND_UPDATE | SOUND_PAUSED
			SEND_SOUND(parent.client, sound_update)
			ost.paused = FALSE
	is_paused = FALSE
	sound_data_ready = FALSE
	needs_update_flags &= ~ UPDATE_UNPAUSE

	return TRUE

/datum/dynsound
	var/music_file = ""
	var/current = 0
	var/last_event = 0
	///The rate that current decays at.
	var/decay_rate = 1
	var/target = 0
	var/channel = ""
	var/paused = FALSE

/datum/dynsound/New(music, channel)
	src.music_file = music
	src.channel = channel

/datum/dynsound/proc/adjust(amt as num)
	target = clamp(target + amt, 0, 20)
	last_event = world.timeofday

/datum/dynsound/proc/clear()
	current = 0
	last_event = 0
	target = 0
	paused = FALSE

/datum/dynsound/proc/update_target()
	target = current

/datum/dynsound/proc/tick(client/C, var/step)
	if(target == 0 && current == 0)
		return
	if(target == current)
		return

	var/diff = abs(target-current)
	var/set_to = clamp(abs(target > current ? current + diff : current - diff) * (step/3), 2, 35)
	var/sound/S = sound(music_file, repeat = TRUE, channel = channel, volume = set_to)
	S.status = SOUND_UPDATE
	SEND_SOUND(C, S) //1.6

#undef NO_UPDATE
#undef UPDATE_PAUSE
#undef UPDATE_UNPAUSE
