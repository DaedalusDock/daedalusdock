/atom/movable/screen/text/screen_text/atom_hud
	screen_loc = "WEST+25%:CENTER+2"
	style_open = "<span class='maptext' style=font-size:20pt;text-align:left valign='top'>"
	style_close = "</span>"

	play_delay = 0.5
	letters_per_update = 3
	auto_end = FALSE

/atom/movable/screen/text/screen_text/atom_hud/Click(location, control, params)
	end_play(usr.client)
