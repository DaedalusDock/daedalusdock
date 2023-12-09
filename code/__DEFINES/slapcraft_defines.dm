#define SLAPCRAFT_STEP(type) GLOB.slapcraft_steps[type]
#define SLAPCRAFT_RECIPE(type) GLOB.slapcraft_recipes[type]

// Defines for ordering in which the recipe steps have to be done
// Step by step
#define SLAP_ORDER_STEP_BY_STEP 1
// First and last have to be done in order, but the rest is freeform.
#define SLAP_ORDER_FIRST_AND_LAST 2
// First has to be done in order, rest is freeform.
#define SLAP_ORDER_FIRST_THEN_FREEFORM 3

// General, default categories.
#define SLAP_CAT_MISC "Misc."
#define SLAP_SUBCAT_MISC "Misc."

// Other categories and their subcategories
#define SLAP_CAT_PROCESSING "Processing"
#define SLAP_CAT_COMPONENTS "Components"
#define SLAP_CAT_WEAPONS "Weapons"
#define SLAP_CAT_ROBOTS "Robots"
#define SLAP_CAT_CLOTHING "Clothing"
#define SLAP_CAT_RUSTIC "Rustic"
