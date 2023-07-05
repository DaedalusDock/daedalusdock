#define LOADOUT_POINTS_MAX 10

#define LOADOUT_CATEGORY_NONE				"ERROR"
//Those three subcategories are good to apply to any category
#define LOADOUT_SUBCATEGORY_MISC			"Miscellaneous"

//In backpack
#define LOADOUT_CATEGORY_BACKPACK 				"In backpack"
#define LOADOUT_SUBCATEGORY_BACKPACK_TOYS 		"Toys"
#define LOADOUT_SUBCATEGORY_BACKPACK_FRAGRANCE "Fragrance"

//Neck
#define LOADOUT_CATEGORY_NECK 				"Neck"
#define LOADOUT_SUBCATEGORY_NECK_TIE 		"Ties"
#define LOADOUT_SUBCATEGORY_NECK_SCARVES 	"Scarves"

//Mask
#define LOADOUT_CATEGORY_MASK 				"Mask"

//In hands
#define LOADOUT_CATEGORY_HANDS 				"Held Items"

//Uniform
#define LOADOUT_CATEGORY_UNIFORM 			"Uniform"
#define LOADOUT_SUBCATEGORY_UNIFORM_SUITS	"Suits"
#define LOADOUT_SUBCATEGORY_UNIFORM_SKIRTS	"Skirts"
#define LOADOUT_SUBCATEGORY_UNIFORM_DRESSES	"Dresses"
#define LOADOUT_SUBCATEGORY_UNIFORM_SWEATERS	"Sweaters"
#define LOADOUT_SUBCATEGORY_UNIFORM_PANTS	"Pants"
#define LOADOUT_SUBCATEGORY_UNIFORM_SHORTS	"Shorts"

//Suit
#define LOADOUT_CATEGORY_SUIT 				"Suit"
#define LOADOUT_SUBCATEGORY_SUIT_COATS 		"Coats"
#define LOADOUT_SUBCATEGORY_SUIT_JACKETS 	"Jackets"

//Head
#define LOADOUT_CATEGORY_HEAD 				"Head"

//Shoes
#define LOADOUT_CATEGORY_SHOES 				"Shoes"

//Gloves
#define LOADOUT_CATEGORY_GLOVES				"Gloves"

//Glasses
#define LOADOUT_CATEGORY_GLASSES			"Glasses"

//Loadout information types, allowing a user to set more customization to them
//Doesn't store any extra information a user could set
#define LOADOUT_INFO_NONE			0
//Stores a "style", which user can set from a pre-defined list on the loadout datum
#define LOADOUT_INFO_STYLE			1
//Stores a single color for use by the loadout datum
#define LOADOUT_INFO_ONE_COLOR 		2
//Stores three colors! Good for polychromatic stuff
#define LOADOUT_INFO_THREE_COLORS	3

#define MAX_LOADOUT_SLOTS 6

// Flags for customizing the loadout items
#define CUSTOMIZE_NAME (1<<0)
#define CUSTOMIZE_DESC (1<<1)
#define CUSTOMIZE_COLOR (1<<2)
#define CUSTOMIZE_COLOR_ROTATION (1<<3)
#define CUSTOMIZE_NAME_DESC (CUSTOMIZE_NAME|CUSTOMIZE_DESC)
#define CUSTOMIZE_NAME_DESC_COLOR (CUSTOMIZE_NAME|CUSTOMIZE_DESC|CUSTOMIZE_COLOR)
#define CUSTOMIZE_NAME_DESC_ROTATION (CUSTOMIZE_NAME|CUSTOMIZE_DESC|CUSTOMIZE_COLOR_ROTATION)
// BEWARE!! Non-GAGS color customization is not compatible with color rotation.
#define CUSTOMIZE_ALL (CUSTOMIZE_NAME|CUSTOMIZE_DESC|CUSTOMIZE_COLOR|CUSTOMIZE_COLOR_ROTATION)

#define TOPIC_CUSTOMIZE_NAME 1
#define TOPIC_CUSTOMIZE_DESC 2
#define TOPIC_CUSTOMIZE_COLOR 3
#define TOPIC_CUSTOMIZE_COLOR_GAGS 4
#define TOPIC_CUSTOMIZE_COLOR_ROTATION 5

#define MAX_ITEM_NAME_LEN 40
#define MAX_ITEM_DESC_LEN 200

#define LOADOUT_OVERRIDE_BACKPACK "Place job items in backpack"
#define LOADOUT_OVERRIDE_CASE "Place all in briefcase"
#define LOADOUT_OVERRIDE_DISCARD "Discard job items"
