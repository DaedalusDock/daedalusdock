TYPEINFO_DEF(/obj/item/tape)
	default_materials = list(/datum/material/iron=20, /datum/material/glass=5)

/obj/item/tape
	name = "cassette"
	desc = "A magnetic tape for storing audio."
	icon_state = "tape_white"
	icon = 'icons/obj/device.dmi'
	inhand_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	force = 1
	throwforce = 0
	obj_flags = UNIQUE_RENAME //my mixtape
	drop_sound = 'sound/items/handling/tape_drop.ogg'
	pickup_sound = 'sound/items/handling/tape_pickup.ogg'

	// Either "A" or "B", purely used for examine.
	var/current_side = "A"

	// I don't want song info to update as the songs are changed, since that isn't immersive. So they're stored on init and kept forever.
	var/desc_song_currentside
	var/desc_song_otherside

	///Because we can't expect God to do all the work.
	var/initial_icon_state
	var/max_capacity = 10 MINUTES
	var/used_capacity = 0 SECONDS
	///Numbered list of chat messages the recorder has heard with spans and prepended timestamps. Used for playback and transcription.
	var/list/storedinfo = list()
	///Numbered list of seconds the messages in the previous list appear at on the tape. Used by playback to get the timing right.
	var/list/timestamp = list()
	var/used_capacity_otherside = 0 SECONDS //Separate my side
	var/list/storedinfo_otherside = list()
	var/list/timestamp_otherside = list()
	var/unspooled = FALSE
	var/list/icons_available = list()
	var/radial_icon_file = 'icons/hud/radial_tape.dmi'

	/// Media ref for the song on side A
	var/datum/media/song_currentside
	/// Media ref for the song on side B
	var/datum/media/song_otherside

/obj/item/tape/fire_act(exposed_temperature, exposed_volume, turf/adjacent)
	unspool()
	..()

/obj/item/tape/Initialize(mapload)
	. = ..()
	initial_icon_state = icon_state //random tapes will set this after choosing their icon

	var/mycolor = random_short_color()
	if(icon_state == "tape_greyscale")
		add_atom_colour("#[mycolor]", FIXED_COLOUR_PRIORITY)

	return INITIALIZE_HINT_LATELOAD

/obj/item/tape/LateInitialize()
	// This is in late initialize so that all child types don't need to think about the sides changing during ..()
	if(prob(50))
		flip_tape()

/obj/item/tape/proc/update_available_icons()
	icons_available = list()

	if(!unspooled)
		icons_available += list("Unwind tape" = image(radial_icon_file,"tape_unwind"))
	icons_available += list("Flip tape" = image(radial_icon_file,"tape_flip"))

/obj/item/tape/examine(mob/user)
	. = ..()
	. += span_info("It is on the \"[current_side]\" side.")
	if(desc_song_currentside)
		. += span_info("This side is labelled \"[desc_song_currentside]\".")

/obj/item/tape/attack_self(mob/user)
	update_available_icons()
	if(icons_available)
		var/selection = show_radial_menu(user, src, icons_available, radius = 38, require_near = TRUE, tooltips = TRUE)
		if(!selection)
			return

		switch(selection)
			if("Flip tape")
				if(loc != user)
					return

				flip_tape()
				to_chat(user, span_notice("You turn \the [src] over."))
				playsound(src, 'sound/items/taperecorder/tape_flip.ogg', 70, FALSE)

			if("Unwind tape")
				if(loc != user)
					return

				unspool()
				to_chat(user, span_warning("You pull out all the tape."))

/obj/item/tape/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(prob(50))
		flip_tape()
	. = ..()

/obj/item/tape/proc/unspool()
	if(unspooled)
		return

	add_overlay("ribbonoverlay")
	unspooled = TRUE

/obj/item/tape/proc/respool()
	cut_overlay("ribbonoverlay")
	unspooled = FALSE

/// Flips the tape, changing all of the relevant values and updating the appearance.
/obj/item/tape/proc/flip_tape()
	//first we save a copy of our current side
	var/list/storedinfo_currentside = storedinfo.Copy()
	var/list/timestamp_currentside = timestamp.Copy()
	var/used_capacity_currentside = used_capacity
	var/new_song_otherside = song_currentside
	var/new_song_desc_otherside = desc_song_currentside

	//then we overwite our current side with our other side
	storedinfo = storedinfo_otherside.Copy()
	timestamp = timestamp_otherside.Copy()
	used_capacity = used_capacity_otherside
	song_currentside = song_otherside
	desc_song_currentside = desc_song_otherside

	//then we overwrite our other side with the saved side
	storedinfo_otherside = storedinfo_currentside.Copy()
	timestamp_otherside = timestamp_currentside.Copy()
	used_capacity_otherside = used_capacity_currentside
	song_otherside = new_song_otherside
	desc_song_otherside = new_song_desc_otherside

	current_side = current_side == "A" ? "B" : "A"

	var/spin_time = 0.4 SECONDS
	animate(src, transform = matrix().Scale(-1, 1), time = spin_time, flags = ANIMATION_PARALLEL)
	animate(transform = matrix())

	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_appearance), spin_time), TIMER_CLIENT_TIME)

/obj/item/tape/update_icon_state()
	if(icon_state == "[initial_icon_state]_reverse") // To allow for admin-set icon states to persist.
		icon_state = initial_icon_state
	else if(icon_state == initial_icon_state) // To allow for admin-set icon states to persist.
		icon_state = "[initial_icon_state]_reverse"
	. = ..()

/obj/item/tape/screwdriver_act(mob/living/user, obj/item/tool)
	if(!unspooled)
		return FALSE

	to_chat(user, span_notice("You start winding the tape back in..."))

	if(tool.use_tool(src, user, 120))
		to_chat(user, span_notice("You wind the tape back in."))
		respool()

//Random colour tapes
/obj/item/tape/random
	icon_state = "random_tape"

/obj/item/tape/random/Initialize(mapload)
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple", "greyscale")]"
	. = ..()

// Media tapes
/obj/item/tape/music

/obj/item/tape/music/Initialize(mapload)
	. = ..()
	desc_song_currentside ||= "[song_currentside?.name]"
	desc_song_otherside ||= "[song_otherside?.name]"

	if(song_currentside)
		used_capacity = song_currentside.duration

	if(song_otherside)
		used_capacity_otherside = song_otherside.duration

/obj/item/tape/music
	/// The media tag to pull from
	var/media_tag = MEDIA_TAG_CASSETTE
	/// If TRUE, will pick_n_take() vs using the first two entries
	var/random_songs = FALSE

/obj/item/tape/music/Initialize(mapload, datum/media/a_side_song, datum/media/b_side_song)
	if(a_side_song || b_side_song)
		song_currentside = a_side_song
		song_otherside = b_side_song

	#ifndef UNIT_TESTS
	else if(media_tag)
		var/list/song_pool = SSmedia.get_track_pool(media_tag)
		if(!length(song_pool))
			WARNING("Music tape with tag [media_tag] could not load any songs.")
		else
			if(random_songs)
				song_currentside = pick_n_take(song_pool)
				song_otherside = pick_n_take(song_pool)
			else
				song_currentside = song_pool[1]
				if(length(song_pool) >= 2)
					song_otherside = song_pool[2]
	#endif
	. = ..()

/obj/item/tape/music/white
	name = "cassette \"Ghost Gurlz\""
	icon_state = "tape_white"

	media_tag = MEDIA_TAG_WHITEWOMEN
	random_songs = TRUE

/obj/item/tape/music/red
	name = "cassette \"RED PRIDE\""
	desc = "A magnetic tape so blisteringly RED it strains your eyes."
	icon_state = "tape_red"

	media_tag = MEDIA_TAG_IS12

/obj/item/tape/music/red/Initialize(mapload)
	. = ..()
	name = pick("cassette \"RED PRIDE\"", "cassette \"GREAT LEADER MIX\"", "cassette \"ITALIAN HATE SESH\"")

/obj/item/tape/music/carmen
	name = "cassette \"Carmen Miranda's Ghost\""
	desc = "An all-time classic album of space-wives' tales."
	icon_state = "tape_blue"

	media_tag = MEDIA_TAG_CARMEN_MIRANDA
	random_songs = TRUE

/obj/item/tape/dyed
	icon_state = "greyscale"

/obj/item/tape/rats
	storedinfo = list(
		"\[00:01\] This place is a mess, how do people live here?",
		"\[00:04\] It's like this station hasn't been serviced in decades.",
		"\[00:07\] Atleast the people here are kind, except for Ann. The wench. |+I CAN HEAR YOU IN THERE!+|",
		"\[00:08\] +PISS OFF, ANN!+",
		"\[00:42\] |I'll finish this tomorrow.|",
		"\[00:50\] How are there |rats| on a space station this far out? This has to be some kind of scientific wonder.",
		"\[01:00\] |Tom? Would you mind helping me with something in the botanical lab?|",
		"\[01:05\] Yeah, yeah.",
		"\[01:10\] Mary, the station's botanist, is a loon. She \"took care\" of a rat with a |monkey wrench|, who does that?!",
		"\[01:19\] The squeaking outside my room is driving me mad. I may ask Mary for some help with this.",
		"\[01:29\] *Airlock opening*",
		"\[01:33\] Mary? What ar-",
		"\[01:35\] *|CLANG!|*",
		"\[01:37\] *|CLANG!|*",
		"\[01:39\] *|CLANG!|*",
		"\[01:47\] *Feminine panting*",
		"\[01:59\] Mary Ann.",
	)

	timestamp = list(
		1 SECONDS,
		4 SECONDS,
		7 SECONDS,
		8 SECONDS,
		42 SECONDS,
		50 SECONDS,
		1 MINUTES,
		1 MINUTES + 5 SECONDS,
		1 MINUTES + 10 SECONDS,
		1 MINUTES + 19 SECONDS,
		1 MINUTES + 29 SECONDS,
		1 MINUTES + 33 SECONDS,
		1 MINUTES + 35 SECONDS,
		1 MINUTES + 37 SECONDS,
		1 MINUTES + 39 SECONDS,
		1 MINUTES + 47 SECONDS,
		1 MINUTES + 59 SECONDS,
	)
