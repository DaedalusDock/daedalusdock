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
#define SLAP_CAT_WEAPONS "Weapons"
#define SLAP_CAT_Ammo "Ammo"
#define SLAP_CAT_ROBOTS "Robots"
#define SLAP_CAT_TRIBAL "Tribal"
#define SLAP_CAT_CLOTHING "Clothing"
#define SLAP_CAT_DRINKS "Drinks"
#define SLAP_CAT_CHEMISTRY "Chemistry"

#define SLAP_CAT_FOOD "Food"
#define SLAP_SUBCAT_BREAD "Breads"
#define SLAP_SUBCAT_BURGER "Burgers"
#define SLAP_SUBCAT_CAKE "Cakes"
#define SLAP_SUBCAT_EGG "Egg-Based Food"
#define SLAP_SUBCAT_LIZARD "Lizard Food"
#define SLAP_SUBCAT_MEAT "Meats"
#define SLAP_SUBCAT_MISCFOOD "Misc. Food"
#define SLAP_SUBCAT_MEXICAN "Mexican Food"
#define SLAP_SUBCAT_PASTRY "Pastries"
#define SLAP_SUBCAT_PIE "Pies"
#define SLAP_SUBCAT_PIZZA "Pizzas"
#define SLAP_SUBCAT_SALAD "Salads"
#define SLAP_SUBCAT_SANDWICH "Sandwiches"
#define SLAP_SUBCAT_SOUP "Soups"
#define SLAP_SUBCAT_SPAGHETTI "Spaghettis"
#define SLAP_SUBCAT_ICE "Frozen"
