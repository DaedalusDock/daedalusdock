/// List of all navbeacons by Z level
GLOBAL_LIST_EMPTY(navbeacons)
/// List of beacons set to delivery mode
GLOBAL_LIST_EMPTY(deliverybeacons)         //list of all MULEbot delivery beacons.
/// List of tags belonging to beacons set to delivery mode
GLOBAL_LIST_EMPTY(deliverybeacontags)     //list of all tags associated with delivery beacons.

GLOBAL_LIST_EMPTY_TYPED(singularities, /datum/component/singularity) //list of all singularities on the station

GLOBAL_LIST_EMPTY(tech_list) //list of all /datum/tech datums indexed by id.
GLOBAL_LIST_EMPTY(surgeries_list) //list of all surgeries by name, associated with their path.
GLOBAL_LIST_EMPTY(crafting_recipes) //list of all table craft recipes
GLOBAL_LIST_EMPTY(tracked_implants) //list of all current implants that are tracked to work out what sort of trek everyone is on. Sadly not on lavaworld not implemented...
GLOBAL_LIST_EMPTY(tracked_chem_implants) //list of implants the prisoner console can track and send inject commands too
GLOBAL_LIST_EMPTY(pinpointer_list) //list of all pinpointers. Used to change stuff they are pointing to all at once.
GLOBAL_LIST_EMPTY(zombie_infection_list) // A list of all zombie_infection organs, for any mass "animation"
GLOBAL_LIST_EMPTY(meteor_list) // List of all meteors.
GLOBAL_LIST_EMPTY(active_jammers)  // List of active radio jammers
GLOBAL_LIST_EMPTY(janitor_devices)
GLOBAL_LIST_EMPTY(trophy_cases)
GLOBAL_LIST_EMPTY(experiment_handlers)
///This is a global list of all signs you can change an existing sign or new sign backing to, when using a pen on them.
GLOBAL_LIST_INIT(editable_sign_types, populate_editable_sign_types())

GLOBAL_LIST_EMPTY(wire_color_directory)
GLOBAL_LIST_EMPTY(wire_name_directory)

GLOBAL_LIST_EMPTY(ai_status_displays)

GLOBAL_LIST_EMPTY(mob_spawners)     // All mob_spawn objects
GLOBAL_LIST_EMPTY(alert_consoles) // Station alert consoles, /obj/machinery/computer/station_alert

GLOBAL_LIST_EMPTY(air_scrub_names) // Name list of all air scrubbers
GLOBAL_LIST_EMPTY(air_vent_names) // Name list of all air vents

GLOBAL_LIST_EMPTY(roundstart_station_borgcharger_areas) // List of area names of roundstart station cyborg rechargers, for the low charge/no charge cyborg screen alert tooltips.
GLOBAL_LIST_EMPTY(roundstart_station_mechcharger_areas) // List of area names of roundstart station mech rechargers, for the low charge/no charge mech screen alert tooltips.

/// Contains all atmospheric machinery, only used if DEBUG_MAPS is defined.
GLOBAL_REAL_VAR(list/atmospherics) = list()

/// Is a real global for speed
GLOBAL_REAL_VAR(list/cable_list) = list()
