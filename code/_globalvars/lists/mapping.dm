GLOBAL_LIST_INIT(cardinals, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
))
GLOBAL_LIST_INIT(cardinals_multiz, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	UP,
	DOWN,
))
GLOBAL_LIST_INIT(diagonals, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,
))
GLOBAL_LIST_INIT(corners_multiz, list(
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(diagonals_multiz, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,

	UP|NORTH,
	UP|SOUTH,
	UP|EAST,
	UP|WEST,
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,

	DOWN|NORTH,
	DOWN|SOUTH,
	DOWN|EAST,
	DOWN|WEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(alldirs_multiz, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,

	UP,
	UP|NORTH,
	UP|SOUTH,
	UP|EAST,
	UP|WEST,
	UP|NORTHEAST,
	UP|NORTHWEST,
	UP|SOUTHEAST,
	UP|SOUTHWEST,

	DOWN,
	DOWN|NORTH,
	DOWN|SOUTH,
	DOWN|EAST,
	DOWN|WEST,
	DOWN|NORTHEAST,
	DOWN|NORTHWEST,
	DOWN|SOUTHEAST,
	DOWN|SOUTHWEST,
))
GLOBAL_LIST_INIT(alldirs, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,
))

GLOBAL_LIST_EMPTY(landmarks_list) //list of all landmarks created
GLOBAL_LIST_EMPTY(start_landmarks_list) //list of all spawn points created
GLOBAL_LIST_EMPTY(start_landmarks_by_name) // List of lists keyed by name
GLOBAL_LIST_EMPTY(high_priority_spawns)
GLOBAL_LIST_EMPTY(department_security_spawns) //list of all department security spawns

GLOBAL_LIST_EMPTY(generic_event_spawns) //handles clockwork portal+eminence teleport destinations
GLOBAL_LIST_EMPTY(wizardstart)
GLOBAL_LIST_EMPTY(nukeop_start)
GLOBAL_LIST_EMPTY(nukeop_leader_start)
GLOBAL_LIST_EMPTY(newplayer_start)
GLOBAL_LIST_EMPTY(prisonwarp) //admin prisoners go to these
GLOBAL_LIST_EMPTY(holdingfacility) //captured people go here (ninja energy net)
GLOBAL_LIST_EMPTY(xeno_spawn)//aliens, morphs and nightmares spawn at these
GLOBAL_LIST_EMPTY(tdome1)
GLOBAL_LIST_EMPTY(tdome2)
GLOBAL_LIST_EMPTY(tdomeobserve)
GLOBAL_LIST_EMPTY(tdomeadmin)
GLOBAL_LIST_EMPTY(prisonwarped) //list of players already warped
GLOBAL_LIST_EMPTY(blobstart) //stationloving objects, blobs, santa
GLOBAL_LIST_EMPTY(navigate_destinations) //list of all destinations used by the navigate verb
GLOBAL_LIST_EMPTY(secequipment) //sec equipment lockers that scale with the number of sec players
GLOBAL_LIST_EMPTY(deathsquadspawn)
GLOBAL_LIST_EMPTY(emergencyresponseteamspawn)
GLOBAL_LIST_EMPTY(ruin_landmarks)
GLOBAL_LIST_EMPTY(bar_areas)

//away missions
GLOBAL_LIST_EMPTY(vr_spawnpoints)

// Just a list of all the area objects in the game
/// Note, areas can have duplicate types
GLOBAL_LIST_EMPTY(areas)
/// Used by jump-to-area etc. Updated by area/updateName()
/// If this is null, it needs to be recalculated. Use get_sorted_areas() as a getter please
GLOBAL_LIST_EMPTY(sortedAreas)
/// An association from typepath to area instance. Only includes areas with `unique` set.
GLOBAL_LIST_EMPTY_TYPED(areas_by_type, /area)

GLOBAL_LIST_EMPTY(all_abstract_markers)
