/client/proc/show_location_blurb(duration = 3 SECONDS)
	set waitfor = FALSE

	var/style = "font-family: 'Fixedsys'; -dm-text-outline: 1 black; font-size: 11px;"
	var/area/A = get_area(mob)
	var/text = "[stationdate2text()], [time_to_twelve_hour(station_time()-1, "hh:mm")]\n[station_name()], [A.name]"
	text = uppertext(text)

	var/atom/movable/screen/T = new /atom/movable/screen{
		maptext_height = 64;
		maptext_width = 512;
		layer = FLOAT_LAYER;
		plane = HUD_PLANE;
		appearance_flags = APPEARANCE_UI_IGNORE_ALPHA;
		screen_loc = "LEFT+1,BOTTOM+2";
		alpha = 0;
	}

	screen += T
	animate(T, alpha = 255, time = 10)
	for(var/i = 1 to length_char(text) + 1)
		T.maptext = "<span style=\"[style]\">[copytext_char(text, 1, i)] </span>"
		sleep(1)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_location_blurb), src, T), duration)

/proc/fade_location_blurb(client/C, obj/T)
	animate(T, alpha = 0, time = 5)
	sleep(5)
	if(C)
		C.screen -= T
	qdel(T)
