SUBSYSTEM_DEF(media)
	name = "RIAA"

	init_order = INIT_ORDER_MEDIA //We need to finish up before SSTicker for lobby music reasons.
	flags = SS_NO_FIRE

	/// Media definitions grouped by their `media_tags`, All tracks share the implicit tag `all`
	VAR_PRIVATE/list/datum/media/tracks_by_tag

	/// It's more consistently functional to just store these in a list and tell admins to go digging than log it.
	VAR_PRIVATE/list/errored_files

	/// Stores all sound formats byond understands.
	var/list/byond_sound_formats = list(
		"mid" = TRUE, //Midi, 8.3 File Name
		"midi" = TRUE, //Midi, Long File Name
		"mod" = TRUE, //Module, Original Amiga Tracker format
		"it" = TRUE, //Impulse Tracker Module format
		"s3m" = TRUE, //ScreamTracker 3 Module
		"xm" = TRUE, //FastTracker 2 Module
		"oxm" = TRUE, //FastTracker 2 (Vorbis Compressed Samples)
		"wav" = TRUE, //Waveform Audio File Format, A (R)IFF-class format, and Microsoft's choice in the 80s sound format pissing match.
		"ogg" = TRUE, //OGG Audio Container, Usually contains Vorbis-compressed Audio
		//"raw" = TRUE, //On the tin, byond purports to support raw, uncompressed PCM Audio. I actually have no fucking idea how FMOD actually handles these.
		//since they completely lack all information. As a confusion based anti-footgun, I'm just going to wire this to FALSE for now. It's here though.
		"wma" = TRUE, //Windows Media Audio container
		"aiff" = TRUE, //Audio Interchange File Format, Apple's side of the 80s sound format pissing match. It's also (R)IFF in a trenchcoat.
		"mp3" = TRUE, //MPeg Layer 3 Container (And usually, Codec.)
	)

/datum/controller/subsystem/media/Initialize(start_timeofday)
	//I'm not even going to bother supporting the existing jukebox shit. Jsons are easier.
	tracks_by_tag = list()
	var/basedir = "[global.config.directory]/media/jsons/"
	var/invalid_jsons_exist = FALSE
	//Fetch
	for(var/json_record in flist(basedir))
		//Decode
		var/list/json_data = json_decode(rustg_file_read("[basedir][json_record]"))

		//Skip the example file.
		if(json_data["name"] == "EXAMPLE")
			continue

		//Pre-Validation Fixups
		var/jd_tag_cache = json_data["media_tags"]+MEDIA_TAG_ALLMEDIA //cache for sanic speed, We add the allmedia check here for universal validations.
		var/jd_full_filepath = "[global.config.directory]/media/[json_data["file"]]"

		//Validation
		/// A two-entry list containing the erroring tag, and a reason for the error.
		var/tag_error
		for(var/jd_tag in jd_tag_cache)
			switch(jd_tag)

				//Validation relevant for ALL tracks.
				if(MEDIA_TAG_ALLMEDIA)
					if(!json_data["name"])
						tag_error = list(MEDIA_TAG_ALLMEDIA, "Track has no name.")
						break
					if(!rustg_file_exists(jd_full_filepath))
						tag_error = list(MEDIA_TAG_ALLMEDIA, "File [jd_full_filepath] does not exist.")
						break
					//Verify that the file extension is allowed, because BYOND is sure happy to not say a fucking word.
					var/list/directory_split = splittext(json_data["file"], "/")
					var/list/extension_split = splittext(directory_split[length(directory_split)], ".")
					if(extension_split.len >= 2)
						var/ext = lowertext(extension_split[length(extension_split)]) //pick the real extension, no 'honk.ogg.exe' nonsense here
						if(!byond_sound_formats[ext])
							tag_error = list(MEDIA_TAG_ALLMEDIA, "[ext] is an illegal file extension (and probably a bad format too.)")
							break

				// Ensure common and rare lobby music pools are not contaminated.
				if(MEDIA_TAG_LOBBYMUSIC_COMMON)
					if(MEDIA_TAG_LOBBYMUSIC_RARE in jd_tag_cache)
						tag_error = list(MEDIA_TAG_LOBBYMUSIC_COMMON, "Track tagged as BOTH COMMON and RARE lobby music.")
						break

				// Ensure common and rare credit music pools are not contaminated.
				if(MEDIA_TAG_ROUNDEND_COMMON)
					if(MEDIA_TAG_ROUNDEND_RARE in jd_tag_cache)
						tag_error = list(MEDIA_TAG_ROUNDEND_COMMON, "Track tagged as BOTH COMMON and RARE endround music.")
						break


				// Jukebox tracks MUST have a duration.
				if(MEDIA_TAG_JUKEBOX)
					if(!json_data["duration"])
						tag_error = list(MEDIA_TAG_JUKEBOX, "Jukebox tracks MUST have a valid duration.")
						break
			//For Loop begins at L:47

		//Failed Validation?
		if(tag_error)
			LAZYINITLIST(errored_files)
			errored_files[json_record] = "[tag_error[1]]:[tag_error[2]]"
			if(!invalid_jsons_exist)
				//Only fire this once. Just check config_error...
				invalid_jsons_exist = TRUE
				spawn(0)
					UNTIL(SSmedia.initialized)
					message_admins("MEDIA: At least 1 Media JSON is invalid. Please check SSMedia.errored_files")
			continue //Skip the track.

		//JSON is fully validated. Wrap it in the datum and add it to the lists.
		var/datum/media/media_datum = new(
			json_data["name"],
			json_data["author"],
			jd_full_filepath,
			jd_tag_cache,
			json_data["map"],
			json_data["rare"],
			json_data["duration"],
			json_record
			)
		for(var/jd_tag in jd_tag_cache)
			LAZYADD(tracks_by_tag[jd_tag], media_datum)

		//For loop begins at L:32
	return ..()

/datum/controller/subsystem/media/proc/get_track_pool(media_tag)
	var/list/pool = tracks_by_tag[media_tag]
	return LAZYCOPY(pool)




/datum/media
	/// Name of the track. Should be "friendly".
	var/name
	/// Author of the track.
	var/author
	/// File path of the actual sound.
	var/path
	/// OPTIONAL for LOBBY tagged music, Map-specific tracks.
	var/map
	/// OPTIONAL for LOBBY tagged music, Rarity control flag. 0 By default.
	var/rare
	/// List of Media tags, used to allow tracks to be shared between various pools, such as
	/// lobby tracks also being jukebox playable.
	var/list/media_tags
	/// REQUIRED for JUKEBOX tagged music, Duration of the track in Deciseconds. Yes it's a shit unit, blame BYOND.
	var/duration = 0
	/// Back-reference name of the originating JSON file, so that you can track it down
	var/definition_file

/datum/media/New(name, author, path, tags, map, rare, length, src_file)
	src.name = name
	src.author = author
	src.path = path
	src.map = map
	src.rare = rare
	media_tags = tags
	duration = length
	definition_file = src_file
