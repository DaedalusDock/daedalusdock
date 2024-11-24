SUBSYSTEM_DEF(sound_cache)
	name = "Sound Cache"
	init_order = INIT_ORDER_AO
	flags = SS_NO_FIRE

	/// k:v list of file_path : length
	var/list/sound_lengths = list()

	/// A list of sounds to cache upon initialize.
	VAR_PRIVATE/list/sounds_to_precache = list()
	/// Any errors from precaching.
	VAR_PRIVATE/list/precache_errors = list()

/datum/controller/subsystem/sound_cache/Initialize(start_timeofday)
	if(!(RUST_G))
		to_chat(world, span_boldnotice("Sound Cache: No rust_g detected."))
		return ..()

	if(length(sounds_to_precache))
		var/list/lengths = rustg_sound_length_list(sounds_to_precache)
		precache_errors = lengths[RUSTG_SOUNDLEN_ERRORS]
		sound_lengths = lengths[RUSTG_SOUNDLEN_SUCCESSES]

	return ..()

/// Cache and return a list of sound lengths.
/datum/controller/subsystem/sound_cache/proc/cache_sounds(list/paths)
	var/list/reconstructed = list()
	reconstructed.len = length(paths)

	for(var/i in 1 to length(paths))
		reconstructed[i] = "[paths[i]]"

	var/list/out = rustg_sound_length_list(paths)

	sound_lengths |= out[RUSTG_SOUNDLEN_SUCCESSES]
	return out[RUSTG_SOUNDLEN_SUCCESSES]

/// Cache and return a single sound.
/datum/controller/subsystem/sound_cache/proc/get_or_cache_sound(file_path)
	. = 0
	if(!istext(file_path))
		if(!isfile(file_path))
			CRASH("rustg_sound_length error: Passed non-text object")

		if(length("[file_path]")) // Runtime generated RSC references stringify into 0-length strings.
			file_path = "[file_path]"
		else
			CRASH("rustg_sound_length does not support non-static file refs.")

	var/cached_length = sound_lengths[file_path]
	if(!isnull(cached_length))
		return cached_length

	var/ret = RUSTG_CALL(RUST_G, "sound_len")(file_path)
	var/as_num = text2num(ret)
	if(isnull(ret))
		. = 0
		CRASH("rustg_sound_length error: [ret]")

	sound_lengths[file_path] = as_num
	return as_num
