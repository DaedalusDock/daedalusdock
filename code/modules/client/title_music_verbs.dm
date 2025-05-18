/client/proc/playtitlemusic()
	set waitfor = FALSE
	set instant = TRUE
	set hidden = TRUE

	UNTIL(length(SSticker.login_music)) //wait for SSticker init to set the login music

	if(prefs && (prefs.toggles & SOUND_LOBBY))
		next_in_line = SSticker.login_music[1]
		cycle_title_music()

/client/proc/stoptitlemusic()
	set instant = TRUE
	set hidden = TRUE

	next_in_line = null
	SEND_SOUND(src, sound(wait = FALSE, channel = CHANNEL_LOBBYMUSIC))

/client/proc/playcreditsmusic()
	set instant = TRUE
	set hidden = TRUE

	SEND_SOUND(src, sound(SSticker.credits_music.path, repeat = 0, wait = 0, volume = 85, channel = CHANNEL_LOBBYMUSIC))
	to_chat(src, span_greenannounce("Now Playing: <i>[SSticker.credits_music.name]</i>[SSticker.credits_music.author ? " by [SSticker.credits_music.author]" : ""]"))

/client/verb/cycle_title_music()
	set name = ".cycle_title_music"
	set instant = TRUE
	set hidden = TRUE
	set waitfor = FALSE

	var/datum/media/song = next_in_line
	if(!song)
		return

	var/sound/S = sound(song.path, repeat = 0, wait = 0, volume = 85, channel = CHANNEL_LOBBYMUSIC)
	S.params = "on-end=.cycle_title_music&on-preempt="
	SEND_SOUND(src, S)

	next_in_line = SSticker.get_login_song(SSticker.login_music.Find(song) + 1)

	UNTIL(SSticker.current_state >= GAME_STATE_PREGAME)
	to_chat(src, span_greenannounce("Now Playing: <i>[song.name]</i>[song.author ? " by [song.author]" : ""]"))
