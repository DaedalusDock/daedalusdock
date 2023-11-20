///This file is for archiving values that are unused for one reason or another.
///I am doing this so I do not need to keep a messy bay repo open when reimplimenting features or cross-referencing differing values.

///Minimum damage taken when inhaling an airborne toxin
#define MIN_TOXIN_DAMAGE 1
///Maximum damage taken when inhaling an airborne toxin
#define MAX_TOXIN_DAMAGE 10


/// Liters in a normal breath. (Bay's)
#define STD_BREATH_VOLUME 12

///Likely LINDA stuff. This should never be used, really.
#define MOLES_O2ATMOS (MOLES_O2STANDARD*50)
#define MOLES_N2ATMOS (MOLES_N2STANDARD*50)

///The heat capacity of a meatbag (J/K For 80kg person).
#define HUMAN_HEAT_CAPACITY 280000

//////////////////// FEA LEFTOVERS ////////////////////
///These are likely left over from FEA.
#define MINIMUM_MOLES_DELTA_TO_MOVE  (MOLES_CELLSTANDARD * MINIMUM_AIR_RATIO_TO_SUSPEND) // Either this must be active
#define MINIMUM_TEMPERATURE_TO_MOVE  (T20C + 100)                                        // or this (or both, obviously)

#define NORMPIPERATE             30   // Pipe-insulation rate divisor.
#define HEATPIPERATE             8    // Heat-exchange pipe insulation.
#define FLOWFRAC                 0.99 // Fraction of gas transfered per process.

///////////////////////////////////////////////////////

//////////////////// SUPERCONDUCTION STUFF ////////////////////
#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION   (T20C + 10)
#define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION (T20C + 200)

// Must be between 0 and 1. Values closer to 1 equalize temperature faster. Should not exceed 0.4, else strange heat flow occurs.
#define  FLOOR_HEAT_TRANSFER_COEFFICIENT 0.4
#define   WALL_HEAT_TRANSFER_COEFFICIENT 0.0
#define   DOOR_HEAT_TRANSFER_COEFFICIENT 0.0
#define  SPACE_HEAT_TRANSFER_COEFFICIENT 0.2 // A hack to partly simulate radiative heat.
#define   OPEN_HEAT_TRANSFER_COEFFICIENT 0.4
#define WINDOW_HEAT_TRANSFER_COEFFICIENT 0.1 // A hack for now.

////////////////////////////////////////////////////////////////

// Fire damage. (Unused in ZAS Reforged right now)
#define CARBON_LIFEFORM_FIRE_RESISTANCE (T0C + 200)
#define CARBON_LIFEFORM_FIRE_DAMAGE     4
