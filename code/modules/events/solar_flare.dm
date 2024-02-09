/datum/round_event_control/solar_flare
	name = "Solar Flare"
	typepath = /datum/round_event/solar_flare
	max_occurrences = 2
	weight = 8
	min_players = 5
	earliest_start = 15 MINUTES

/datum/round_event/solar_flare
	announceWhen = 1
	startWhen = 30
	var/area/impact_area
	var/possible_turfs = list()
	var/number_of_fires = 5

/datum/round_event/solar_flare/proc/findEventArea()
	var/static/list/allowed_areas
	if(!allowed_areas)
		//Places that shouldn't ignite
		var/static/list/safe_area_types = typecacheof(list(
		/area/station/ai_monitored/turret_protected/ai,
		/area/station/ai_monitored/turret_protected/ai_upload,
		/area/station/engineering,
		/area/station/solars,
		/area/station/holodeck,
		/area/shuttle,
		/area/station/maintenance,
		/area/station/science/test_area,
	))

		//Subtypes from the above that actually should ignite.
		var/static/list/unsafe_area_subtypes = typecacheof(list(/area/station/engineering/break_room))

		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes
	var/list/possible_areas = typecache_filter_list(GLOB.areas, allowed_areas)
	if (length(possible_areas))
		return pick(possible_areas)

/datum/round_event/solar_flare/setup()
	impact_area = findEventArea()
	if(!impact_area)
		CRASH("No valid areas for a solar flare found.")
	possible_turfs = get_area_turfs(impact_area)
	if(!possible_turfs)
		CRASH("Solar flare : No valid turfs found for [impact_area] - [impact_area.type]")

/datum/round_event/solar_flare/announce(fake)
	priority_announce("An unexpected solar flare has been detected near the station and is predicted to hit [impact_area.name]. Evacuate the location immediately and remove any flammable material.", "Celestial Sensor Array", "SOLAR FLARE IMMINENT")

/datum/round_event/solar_flare/start()
	var/spots_left = number_of_fires
	while(spots_left > 0)
		var/turf/open/fireturf = (pick(possible_turfs))
		fireturf.create_fire(5, 8)
		spots_left -= 1
