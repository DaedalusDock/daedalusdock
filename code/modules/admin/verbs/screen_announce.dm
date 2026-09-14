/client/proc/screen_announce(text as text|null)
	set name = "Screen Alert"
	set category = "Admin"

	if(length_char(text) > 256)
		text = copytext_char(text, 1, 256)

	if(!length_char(text))
		text = stripped_input(usr, "", "Screen Alert")
		if(!length_char(text))
			return

	text = "\"[text]\""
	var/atom/movable/screen/maptext_holder = new()
	maptext_holder.maptext = "<span class='maptext' valign='bottom' style='text-align:center;font-size:20pt;color:#03fca1;font-weight:bold'>[usr.ckey]:</span>"
	maptext_holder.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
	maptext_holder.maptext_height = 128
	maptext_holder.maptext_width = 128
	maptext_holder.maptext_x = -64
	maptext_holder.transform = maptext_holder.transform.Scale(2, 2)
	maptext_holder.transform = maptext_holder.transform.Translate(16, 18)

	var/sound/S = sound('sound/effects/fradio.ogg')
	for(var/mob/M in GLOB.player_list)
		SEND_SOUND(M, S)
		spawn(0.5 SECONDS)
			var/atom/movable/screen/text/screen_text/admin_announce/hud_obj = new()
			hud_obj.add_viscontents(holder)
			hud_obj.add_viscontents(maptext_holder)
			M.play_screen_text(text, hud_obj)

