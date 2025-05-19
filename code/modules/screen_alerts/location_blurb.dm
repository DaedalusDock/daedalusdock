/client/proc/show_location_blurb(duration = 3 SECONDS, animate_maptext = TRUE, name_only = FALSE)
	set waitfor = FALSE

	if(HAS_TRAIT(src, "seeing_blurb"))
		return

	ADD_TRAIT(src, "seeing_blurb", INNATE_TRAIT)

	var/style = "font-family: 'Fixedsys'; -dm-text-outline: 1 black; font-size: 11px;"
	var/area/A = get_area(mob)
	var/text
	if(!name_only)
		text = "[stationdate2text()], [time_to_twelve_hour(station_time()-1, "hh:mm")]\n[station_name()], [A]"
	else
		text = "[A]"

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
	animate(T, alpha = 255, time = 1 SECOND)
	if(animate_maptext)
		for(var/i = 1 to length_char(text) + 1)
			T.maptext = "<span style=\"[style]\">[copytext_char(text, 1, i)] </span>"
			sleep(1)
	else
		T.maptext = "<span style=\"[style]\">[text]</span>"

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_location_blurb), src, T), duration)

/proc/fade_location_blurb(client/C, obj/T)
	animate(T, alpha = 0, time = 0.5 SECONDS)
	sleep(0.5 SECONDS)
	if(C)
		C.screen -= T
		REMOVE_TRAIT(C, "seeing_blurb", INNATE_TRAIT)
	qdel(T)
