/datum/playlist
	var/datum/persistent_client/parent

	/// The media track selected.
	var/datum/media/selected_track
	/// The actual playlist.
	var/list/datum/media/tracks = list()

/datum/playlist/New(datum/persistent_client/_parent)
	parent = _parent
	RegisterSignal(SSticker, COMSIG_TICKER_ENTER_PREGAME, PROC_REF(announce_track))

/datum/playlist/proc/announce_track()
	if(selected_track && SSticker.current_state >= GAME_STATE_PREGAME)
		to_chat(parent.client, span_system("<B>AUDIO:</B> Now playing: <i>[selected_track.name]</i>[selected_track.author ? " by [selected_track.author]" : ""]"))

/// Plays the current selected track.
/datum/playlist/proc/play_track()
	if(!selected_track || !(parent.client?.prefs.toggles & SOUND_LOBBY))
		return

	var/sound/S = sound(selected_track.path, repeat = 0, wait = 0, volume = 85, channel = CHANNEL_LOBBYMUSIC)
	S.params = "on-end=.cycle_title_music&on-preempt="
	SEND_SOUND(parent.client, S)

	announce_track()

/// Stops the current track.
/datum/playlist/proc/stop_track()
	SEND_SOUND(parent.client, sound(wait = FALSE, channel = CHANNEL_LOBBYMUSIC))

/// Cycles the playlist, refreshing the queue if it is empty.
/datum/playlist/proc/cycle_track()
	if(!length(tracks))
		setup_tracks()

	selected_track = tracks[1]
	tracks.Cut(1, 2)

/datum/playlist/proc/setup_tracks()
	tracks = SSticker.login_music.Copy()

/// Pushes a track to the front of a playlist. Inserts it if it is not present.
/datum/playlist/proc/push_to_front(datum/media/desired_track)
	tracks -= desired_track
	tracks.Insert(1, desired_track)
