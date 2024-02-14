/// Checks if an object is covered in blood
#define HAS_BLOOD_DNA(thing) (length(thing.forensics?.blood_DNA))

/// Returns a reference to a blood datum
#define GET_BLOOD_REF(blood_type) GLOB.blood_datums[blood_type]

//Bloody shoes/footprints
/// Minimum alpha of footprints
#define BLOODY_FOOTPRINT_BASE_ALPHA 120
/// How much blood a regular blood splatter contains
#define BLOOD_AMOUNT_PER_DECAL      100
/// How much blood an item can have stuck on it
#define BLOOD_ITEM_MAX              200
/// How much blood a blood decal can contain
#define BLOOD_POOL_MAX              300
/// How much blood a footprint need to at least contain
#define BLOOD_FOOTPRINTS_MIN        5


#define BLOOD_PRINT_HUMAN "blood"
#define BLOOD_PRINT_PAWS "bloodpaw"
#define BLOOD_PRINT_CLAWS "bloodclaw"
