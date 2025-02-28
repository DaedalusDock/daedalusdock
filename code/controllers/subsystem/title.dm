SUBSYSTEM_DEF(title)
	name = "Title Screen"
	flags = SS_BACKGROUND
	wait = 1 SECOND
	priority = FIRE_PRIORITY_TITLE
	init_order = INIT_ORDER_TITLE
	init_stage = INITSTAGE_EARLY
	runlevels = ALL

	var/file_path
	var/icon/icon
	var/icon/previous_icon

	/// The turf that contains all of the splash screen stuff
	var/turf/closed/indestructible/splashscreen/splash_turf

	/// The master object that everything is a child of, so that offsetting works.
	var/obj/effect/abstract/splashscreen/master/master_object

	/// The actual splashscreen image
	var/obj/effect/abstract/splashscreen/backdrop/backdrop
	/// Displays subsystem loading text
	var/obj/effect/abstract/splashscreen/game_status
	/// Displays a clock
	var/obj/effect/abstract/splashscreen/clock
	/// Displays the gamemode name
	var/obj/effect/abstract/splashscreen/gamemode
	/// Displays the tip of the round
	var/obj/effect/abstract/splashscreen/tip

/datum/controller/subsystem/title/Initialize()
	if(file_path && icon)
		return

	if(fexists("data/previous_title.dat"))
		var/previous_path = file2text("data/previous_title.dat")
		if(istext(previous_path))
			previous_icon = new(previous_icon)
	fdel("data/previous_title.dat")

	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/title_screens = list()
	var/use_rare_screens = prob(1)

	for(var/S in provisional_title_screens)
		var/list/L = splittext(S,"+")
		if((L.len == 1 && (L[1] != "exclude" && L[1] != "blank.png"))|| (L.len > 1 && ((use_rare_screens && lowertext(L[1]) == "rare") || (lowertext(L[1]) == lowertext(SSmapping.config.map_name)))))
			title_screens += S

	if(length(title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(title_screens)]"

	if(!file_path)
		file_path = "icons/runtime/default_title.dmi"

	ASSERT(fexists(file_path))

	icon = new(fcopy_rsc(file_path))

	if(splash_turf)
		setup_objects()

	return ..()

/datum/controller/subsystem/title/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, icon))
				if(splash_turf)
					splash_turf.icon = icon

/datum/controller/subsystem/title/Shutdown()
	if(file_path)
		var/F = file("data/previous_title.dat")
		WRITE_FILE(F, file_path)

/datum/controller/subsystem/title/Recover()
	icon = SStitle.icon
	splash_turf = SStitle.splash_turf
	file_path = SStitle.file_path
	previous_icon = SStitle.previous_icon

/datum/controller/subsystem/title/fire(resumed)
	if(!splash_turf) // Something is wrong
		can_fire = FALSE
		return

	clock.maptext = "<span class='vga outline' style='text-align: right;color: #aaaaaa'>[time_to_twelve_hour(WRAP_UP(world.timeofday + (TIMEZONE_EST HOURS), 24 HOURS), "hh:mm")]</span>"

	gamemode.maptext = "<span class='vga outline' style='color: #aaaaaa'>Gamemode: [SSticker.get_mode_name()]</span>"

/// Called in init to create all of the vis contents objects
/datum/controller/subsystem/title/proc/setup_objects()
	backdrop.icon = icon
	backdrop.handle_generic_titlescreen_sizes()

	game_status = new()
	game_status.maptext_height = 48
	game_status.maptext_width = 320
	game_status.maptext_x = -(320 / 2) + 16
	game_status.pixel_x = world.icon_size * 7
	add_child_object(game_status, "Game Status")

	clock = new()
	clock.maptext_width = 320
	clock.maptext_height = 48
	clock.maptext_x = -clock.maptext_width + world.icon_size
	clock.pixel_x = (world.icon_size * 14) - 8 // -8 for padding
	clock.pixel_y = world.icon_size * 14
	add_child_object(clock, "Clock")

	gamemode = new()
	gamemode.maptext_width = 320
	gamemode.maptext_height = 48
	gamemode.pixel_y = world.icon_size * 14
	gamemode.pixel_x = 8 // Add some padding
	gamemode.maptext = "<span class='vga'>[SSticker.get_mode_name()]</span>"
	add_child_object(gamemode, "Gamemode")

	tip = new()
	tip.maptext_width = 320
	tip.maptext_height = 48
	tip.pixel_y = world.icon_size * 7
	tip.pixel_x = world.icon_size * 7
	add_child_object(tip, "Tip")

/// Adds an atom to the vis contents of the master.
/datum/controller/subsystem/title/proc/add_child_object(obj/effect/abstract/new_object, object_name)
	master_object.add_viscontents(new_object)
	new_object.name = object_name // So you can VV the master object to see children easily.
	return new_object

/// Update the load status of the game
/datum/controller/subsystem/title/proc/set_game_status_text(new_text = "Setting up game...", sub_text)
	if(!game_status)
		return

	game_status.maptext = "<span class='vga center align-top outline'>[new_text]\n<span style='color: #aaaaaa'>[sub_text]</span></span>"
