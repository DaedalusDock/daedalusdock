SUBSYSTEM_DEF(media)
	name = "RIAA"

	init_order = INIT_ORDER_MEDIA //We need to finish up before SSTicker for lobby music reasons.
	flags = SS_NO_FIRE

	/// Media definitions grouped by their `media_tags`, All tracks share the implicit tag `all`
	VAR_PRIVATE/list/datum/media/tracks_by_tag = list()
	VAR_PRIVATE/list/datum/media/all_tracks = list()

	/// Only notify admins once per init about invalid jsons
	VAR_PRIVATE/invalid_jsons_exist
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

	/// File types we can sniff the duration from using rustg.
	var/list/safe_extensions = list("ogg", "mp3")

#define MEDIA_LOAD_FAILED -1

/datum/controller/subsystem/media/Initialize(start_timeofday)
	SSlobby.set_game_status_text(sub_text = "Setting up track list")
	to_chat(world, systemtext("Media: Setting up track list..."))
	setup_tracks()

	SSlobby.set_game_status_text(sub_text = "Caching sound durations")
	to_chat(world, systemtext("Media: Caching sound durations..."))
	cache_tracks()
	return ..()

/datum/controller/subsystem/media/proc/setup_tracks()
//Reset warnings to clear any past runs.
	invalid_jsons_exist = FALSE
	errored_files = null

	//I'm not even going to bother supporting the existing jukebox shit. Jsons are easier.
	var/basedir = "[global.config.directory]/media/jsons/"
	//Fetch
	for(var/json_record in flist(basedir))
		//Decode
		var/list/json_data = decode_or_null(basedir,json_record)

		if(json_data == MEDIA_LOAD_FAILED)
			continue //We returned successfully, with a bad record that is already logged

		if(!json_data)
			//We did NOT return successfully, Log a very general error ourselves.
			log_load_fail(json_record,list("ERR_FATAL","JSON Record failed to load, Unknown error! Check the runtime log!"))
			continue

		//Skip the example file.
		if(json_data["name"] == "EXAMPLE")
			continue

		//Pre-Validation Fixups
		var/list/jd_tag_cache = json_data["media_tags"]+MEDIA_TAG_ALLMEDIA //cache for sanic speed, We add the allmedia check here for universal validations.
		var/jd_full_filepath = "[global.config.directory]/media/[json_data["file"]]"

		//Validation
		/// A two-entry list containing the erroring tag, and a reason for the error.
		var/tag_error = validate_media(json_data, jd_full_filepath, jd_tag_cache)

		//Failed Validation?
		if(tag_error)
			log_load_fail(json_record,tag_error)
			continue //Skip the track.

		var/file_extension = get_file_extension(json_data["file"])

		//JSON is fully validated. Wrap it in the datum and add it to the lists.
		var/datum/media/media_datum = new(
			json_data["name"],
			json_data["author"],
			jd_full_filepath,
			jd_tag_cache,
			json_data["map"],
			json_data["rare"],
			json_data["duration"],
			json_record,
			file_extension,
		)

		all_tracks += media_datum
		for(var/jd_tag in jd_tag_cache)
			LAZYADD(tracks_by_tag[jd_tag], media_datum)

/datum/controller/subsystem/media/proc/cache_tracks()
	var/list/path_to_track = list()
	for(var/datum/media/track as anything in all_tracks)
		if(track.file_extension in safe_extensions)
			path_to_track[track.path] = track

	var/list/cached_filepaths = SSsound_cache.cache_sounds(path_to_track)
	for(var/filepath in path_to_track)
		var/datum/media/track = path_to_track[filepath]
		track.duration = cached_filepaths[filepath]

/// Quarantine proc for json decoding, Has handling code for most reasonable issues with file structure, and can safely die.
/// Returns -1/MEDIA_LOAD_FAILED on error, a list on success, and null on suicide.
/datum/controller/subsystem/media/proc/decode_or_null(basedir,json_record)
	PRIVATE_PROC(TRUE)
	var/file_contents = rustg_file_read("[basedir][json_record]")
	if(!length(file_contents))
		log_load_fail(json_record,list("ERR_FATAL","File is empty."))
		return MEDIA_LOAD_FAILED
	if(!rustg_json_is_valid(file_contents))
		log_load_fail(json_record,list("ERR_FATAL","JSON content is invalid!"))
		return MEDIA_LOAD_FAILED
	return json_decode(file_contents)

/// Log a failure to load a specific media track, and notify admins.
/datum/controller/subsystem/media/proc/log_load_fail(entry,list/error_tuple)
	PRIVATE_PROC(TRUE)
	LAZYINITLIST(errored_files)
	errored_files[entry] = "[error_tuple[1]]:[error_tuple[2]]"
	log_config("MEDIA: [entry] FAILED: [error_tuple[1]]:[error_tuple[2]]")
	if(!invalid_jsons_exist)
		//Only fire this once. Just check config_error...
		invalid_jsons_exist = TRUE
		spawn(0)
			UNTIL(SSmedia.initialized)
			message_admins("MEDIA: At least 1 Media JSON is invalid. Please check SSMedia.errored_files or config_error.log")
	return

/// Run media validation checks. Returns null on success, or a log_load_failure compatible tuple-list on failure.
/datum/controller/subsystem/media/proc/validate_media(json_data, jd_full_filepath, jd_tag_cache)
	if(!json_data || !jd_full_filepath || !jd_tag_cache)
		stack_trace("BAD CALLING ARGUMENTS TO VALIDATE_MEDIA")
		return list("ERR_FATAL", "Record validation was called with bad arguments: [json_data || "#FALSY_DATA"], [jd_full_filepath || "#FALSY_DATA"], [english_list(jd_tag_cache, nothing_text = "#FALSY_DATA")]")

	for(var/jd_tag in jd_tag_cache)
		switch(jd_tag)

			//Validation relevant for ALL tracks.
			if(MEDIA_TAG_ALLMEDIA)
				// Simple Data
				if(!json_data["name"])
					return list(MEDIA_TAG_ALLMEDIA, "Track has no name.")
				if(!json_data["author"])
					return list(MEDIA_TAG_ALLMEDIA, "Track has no author.")

				// Does our file actually exist?
				if(!rustg_file_exists(jd_full_filepath))
					return list(MEDIA_TAG_ALLMEDIA, "File [jd_full_filepath] does not exist.")

				var/file_ext = get_file_extension(json_data["file"])
				//Verify that the file extension is allowed, because BYOND is sure happy to not say a fucking word.
				if(file_ext)
					if(!byond_sound_formats[file_ext])
						return list(MEDIA_TAG_ALLMEDIA, "[file_ext] is an illegal file extension (and probably a bad format too.)")
				else
					return list(MEDIA_TAG_ALLMEDIA, "Media is missing a file extension.")

			// Ensure common and rare lobby music pools are not contaminated.
			if(MEDIA_TAG_LOBBYMUSIC_COMMON)
				if(MEDIA_TAG_LOBBYMUSIC_RARE in jd_tag_cache)
					return list(MEDIA_TAG_LOBBYMUSIC_COMMON, "Track tagged as BOTH COMMON and RARE lobby music.")

			// Ensure common and rare credit music pools are not contaminated.
			if(MEDIA_TAG_ROUNDEND_COMMON)
				if(MEDIA_TAG_ROUNDEND_RARE in jd_tag_cache)
					return list(MEDIA_TAG_ROUNDEND_COMMON, "Track tagged as BOTH COMMON and RARE endround music.")

			// Jukebox tracks MUST have a duration if they aren't MP3 or OGG.
			if(MEDIA_TAG_JUKEBOX)
				if(!json_data["duration"] && !(get_file_extension(json_data["file"]) in safe_extensions))
					return list(MEDIA_TAG_JUKEBOX, "Jukebox tracks MUST have a valid duration.")

/datum/controller/subsystem/media/proc/get_track_pool(media_tag)
	var/list/pool = tracks_by_tag[media_tag]
	return LAZYCOPY(pool)

/// Returns the file extension of a given filepath.
/datum/controller/subsystem/media/proc/get_file_extension(filepath)
	var/list/directory_split = splittext(filepath, "/")
	var/list/extension_split = splittext(directory_split[length(directory_split)], ".")
	var/ext = lowertext(extension_split[length(extension_split)])
	if(length(ext) < 3)
		return null
	return ext

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
	/// The file extension
	var/file_extension

/datum/media/New(name, author, path, tags, map, rare, length, src_file, file_ext)
	src.name = name
	src.author = author
	src.path = path
	src.map = map
	src.rare = rare
	media_tags = tags
	duration = length
	definition_file = src_file
	file_extension = file_ext

#undef MEDIA_LOAD_FAILED
