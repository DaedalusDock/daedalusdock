/client/proc/playtitlemusic()
	set waitfor = FALSE
	set instant = TRUE
	set hidden = TRUE

	UNTIL(length(SSticker.login_music)) //wait for SSticker init to set the login music

	if(prefs && (prefs.toggles & SOUND_LOBBY))
		if(!persistent_client.playlist.selected_track)
			persistent_client.playlist.cycle_track()
		persistent_client.playlist.play_track()

/client/proc/stoptitlemusic()
	set instant = TRUE
	set hidden = TRUE

	persistent_client.playlist.stop_track()

/client/proc/playcreditsmusic()
	set instant = TRUE
	set hidden = TRUE

	SEND_SOUND(src, sound(SSticker.credits_music.path, repeat = 0, wait = 0, volume = 85, channel = CHANNEL_LOBBYMUSIC))
	to_chat(src, span_greenannounce("Now Playing: <i>[SSticker.credits_music.name]</i>[SSticker.credits_music.author ? " by [SSticker.credits_music.author]" : ""]"))

// verb for sound callbacks to invoke
/client/verb/cycle_title_music()
	set name = ".cycle_title_music"
	set instant = TRUE
	set hidden = TRUE
	set waitfor = FALSE

	persistent_client.playlist.cycle_track()
	persistent_client.playlist.play_track()
