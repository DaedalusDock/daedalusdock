//used for holding information about unique properties of maps
//feed it json files that match the datum layout
//defaults to box
//  -Cyberboss

/datum/map_config
	// Metadata
	var/config_filename = "_maps/theseus.json"
	var/defaulted = TRUE  // set to FALSE by LoadConfig() succeeding
	// Config from maps.txt
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1
	var/votable = FALSE

	// Config actually from the JSON - should default to Theseus
	var/map_name = "Theseus"
	var/map_path = "map_files/Theseus"
	var/map_file = "Theseus.dmm"
	var/webmap_id = "DaedalusMeta"

	var/traits = null
	var/space_ruin_levels = 7
	var/space_empty_levels = 1

	var/minetype = "lavaland"

	/// X,Y values for the holomap offset. The holomap draws to a 480x480 image, so by default the offset is 480 / 4.
	var/holomap_offsets = list(120, 120)

	var/allow_custom_shuttles = TRUE
	var/shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_box",
		"emergency" = "emergency_box")

	/// Dictionary of job sub-typepath to template changes dictionary
	var/job_changes = list()
	/// List of additional areas that count as a part of the library
	var/library_areas = list()

	/// Do we run mapping standards unit tests on this map?
	var/run_mapping_tests = FALSE

/**
 * Proc that simply loads the default map config, which should always be functional.
 */
/proc/load_default_map_config()
	return new /datum/map_config


/**
 * Proc handling the loading of map configs. Will return the default map config using [/proc/load_default_map_config] if the loading of said file fails for any reason whatsoever, so we always have a working map for the server to run.
 *
 * Arguments:
 * * filename - Name of the config file for the map we want to load. The .json file extension is added during the proc, so do not specify filenames with the extension.
 * * directory - Name of the directory containing our .json - Must be in `MAP_DIRECTORY_WHITELIST`. We default this to `MAP_DIRECTORY_MAPS` as it will likely be the most common usecase. If no filename is set, we ignore this.
 * * log_missing - Bool that says whether failing to load the config for the map will be logged in log_world or not as it's passed to LoadConfig().
 * * log_whitelist - Bool that says whether the directory not being in `MAP_DIRECTORY_WHITELIST` will be logged in log_world.
 *
 * Returns the config for the map to load.
 */
/proc/load_map_config(filename = null, directory = null, log_missing = TRUE, log_whitelist = TRUE)
	var/datum/map_config/config = load_default_map_config()

	if(filename) // If none is specified, then go to look for next_map.json, for map rotation purposes.

		//Default to MAP_DIRECTORY_MAPS if no directory is passed
		if(directory)
			if(!(directory in MAP_DIRECTORY_WHITELIST))
				if(log_whitelist)
					log_world("map directory not in whitelist: [directory] for map [filename]")
				return config
		else
			directory = MAP_DIRECTORY_MAPS

		filename = "[directory]/[filename].json"
	else
		filename = PATH_TO_NEXT_MAP_JSON


	if (!config.LoadConfig(filename, log_missing))
		qdel(config)
		return load_default_map_config()
	return config


#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world("[##X] missing from json!"); return; }

/datum/map_config/proc/LoadConfig(filename, log_missing)
	if(!fexists(filename))
		if(log_missing)
			log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return

	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return

	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	config_filename = filename

	if(!json["version"])
		log_world("map_config missing version!")
		return

	if(json["version"] != MAP_CURRENT_VERSION)
		log_world("map_config has invalid version [json["version"]]!")
		return

	CHECK_EXISTS("map_name")
	map_name = json["map_name"]
	CHECK_EXISTS("map_path")
	map_path = json["map_path"]

	map_file = json["map_file"]
	// "map_file": "Theseus.dmm"
	if (istext(map_file))
		if (!fexists("_maps/[map_path]/[map_file]"))
			log_world("Map file ([map_path]/[map_file]) does not exist!")
			return
	// "map_file": ["Lower.dmm", "Upper.dmm"]
	else if (islist(map_file))
		for (var/file in map_file)
			if (!fexists("_maps/[map_path]/[file]"))
				log_world("Map file ([map_path]/[file]) does not exist!")
				return
	else
		log_world("map_file missing from json!")
		return

	webmap_id = json["webmap_id"]
	if(!webmap_id)
		log_mapping("Map is missing a webmap ID.")

	if (islist(json["shuttles"]))
		var/list/L = json["shuttles"]
		for(var/key in L)
			var/value = L[key]
			shuttles[key] = value
	else if ("shuttles" in json)
		log_world("map_config shuttles is not a list!")
		return

	traits = json["traits"]
	// "traits": [{"Linkage": "Cross"}, {"Space Ruins": true}]
	if (islist(traits))
		// "Station" is set by default, but it's assumed if you're setting
		// traits you want to customize which level is cross-linked
		for (var/level in traits)
			if (!(ZTRAIT_STATION in level))
				level[ZTRAIT_STATION] = TRUE
	// "traits": null or absent -> default
	else if (!isnull(traits))
		log_world("map_config traits is not a list!")
		return

	var/temp = json["space_ruin_levels"]
	if (isnum(temp))
		space_ruin_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_ruin_levels is not a number!")
		return

	temp = json["space_empty_levels"]
	if (isnum(temp))
		space_empty_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_empty_levels is not a number!")
		return

	allow_custom_shuttles = json["allow_custom_shuttles"] != FALSE

	if ("job_changes" in json)
		if(!islist(json["job_changes"]))
			log_world("map_config \"job_changes\" field is missing or invalid!")
			return
		job_changes = json["job_changes"]

	if("library_areas" in json)
		if(!islist(json["library_areas"]))
			log_world("map_config \"library_areas\" field is missing or invalid!")
			return
		for(var/path_as_text in json["library_areas"])
			var/path = text2path(path_as_text)
			if(!ispath(path, /area))
				stack_trace("Invalid path in mapping config for additional library areas: \[[path_as_text]\]")
				continue
			library_areas += path

	if("holomap_offset" in json)
		if(!islist(json["holomap_offset"]) || length(json["holomap_offset"] != 2))
			log_world("map_config \"holomap_offset\" field is invalid!")
			return
		temp = json["holomap_offset"]
		if(!isnum(temp[1]) || !isnum(temp[2]))
			log_world("map_config \"holomap_offset\" contains non-numbers!")
			return

		holomap_offsets = temp

	if("run_mapping_tests" in json)
		//This should be true, but just in case...
		run_mapping_tests = json["run_mapping_tests"]

	defaulted = FALSE
	return TRUE

#undef CHECK_EXISTS

/datum/map_config/proc/GetFullMapPaths()
	if (istext(map_file))
		return list("_maps/[map_path]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "_maps/[map_path]/[file]"

/datum/map_config/proc/MakeNextMap()
	return config_filename == PATH_TO_NEXT_MAP_JSON || fcopy(config_filename, PATH_TO_NEXT_MAP_JSON)
