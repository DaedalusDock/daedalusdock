GLOBAL_LIST_EMPTY(loadout_items)
GLOBAL_LIST_EMPTY(item_path_to_loadout_item)
GLOBAL_LIST_EMPTY(loadout_category_to_subcategory_to_items)

/datum/loadout_item
	///Name of the loadout item, automatically set by New() if null
	var/name
	///Description of the loadout item, automatically set by New() if null
	var/description
	///Typepath to the item being spawned
	var/path
	///How much loadout points does it cost?
	var/cost = 1
	///Category in which the item belongs to LOADOUT_CATEGORY_UNIFORM, LOADOUT_CATEGORY_BACKPACK etc.
	var/category = LOADOUT_CATEGORY_NONE
	///Subcategory in which the item belongs to
	var/subcategory = LOADOUT_SUBCATEGORY_MISC
	/// Flags for customizing the item
	var/customization_flags = CUSTOMIZE_NAME_DESC_ROTATION
	/// String of the default gags colors. Can be null even if `gags_colors` is something (for cases where default items randomize for example)
	var/gags_colors_string
	/// Amount of gags colors this item expects. If null, it's not a GAGS item
	var/gags_colors
	/// A list of job names this item is restricted to.
	var/list/restricted_roles

/datum/loadout_item/New()
	if(!description)
		description = format_text(initial(path:desc))
	if(!name)
		name = format_text(initial(path:name))

/datum/loadout_item/proc/on_equip(mob/living/carbon/human/owner, obj/item/I, datum/loadout_entry/loadout_datum, visuals_only)
	SHOULD_CALL_PARENT(TRUE)
	loadout_datum.customize(I, src)

/*
 * Place our [var/item_path] into [outfit].
 *
 * By default, just adds the item into the outfit's backpack contents, if non-visual.
 *
 * equipper - If we're equipping out outfit onto a mob at the time, this is the mob it is equipped on. Can be null.
 * outfit - The outfit we're equipping our items into.
 * visual - If TRUE, then our outfit is only for visual use (for example, a preview).
 */
/datum/loadout_item/proc/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(!visuals_only)
		LAZYADD(outfit.backpack_contents, path)

/// Ran from SSloadouts after SSgreyscale initializes so we can properly read some information
/datum/loadout_item/proc/parse_gags()
	var/obj/loadout_item = path
	var/gags_config_type = initial(loadout_item.greyscale_config)
	if(gags_config_type)
		gags_colors_string = initial(loadout_item.greyscale_colors)
		var/datum/greyscale_config/gags_config = SSgreyscale.configurations["[gags_config_type]"] //TODO: unwrap the gags config association from strings, literally no reason to do this
		gags_colors = gags_config.expected_colors
		customization_flags |= CUSTOMIZE_COLOR
		customization_flags &= ~CUSTOMIZE_COLOR_ROTATION

/// Gets a string for the gags config
/datum/loadout_item/proc/get_gags_string()
	if(!gags_colors)
		return
	if(gags_colors_string)
		return gags_colors_string
	. = ""
	for(var/i in 1 to gags_colors)
		. += "#FFFFFF" //If for some reason the item doesn't have default values. Fill it with whites

/// Datum for storing and customizing a selected loadout item
/datum/loadout_entry
	/// Path to the loadout item (/datum/loadout_item)
	var/path
	/// Customized name if any.
	var/custom_name
	/// Customized description if any.
	var/custom_desc
	/// Customized color if any.
	var/custom_color
	/// Customized GAGS colors if any.
	var/custom_gags_colors
	/// Customized color rotation if any.
	var/custom_color_rotation

/datum/loadout_entry/New(path, custom_name, custom_desc, custom_color, custom_gags_colors, custom_color_rotation, restricted_roles)
	src.path = path
	src.custom_name = custom_name
	src.custom_desc = custom_desc
	src.custom_color = custom_color
	src.custom_gags_colors = custom_gags_colors
	src.custom_color_rotation = custom_color_rotation

/datum/loadout_entry/proc/get_spawned_item()
	var/datum/loadout_item/loadout_item = locate(path) in GLOB.loadout_items
	var/obj/item/spawned = new loadout_item.path()
	customize(spawned, loadout_item)
	return spawned

/datum/loadout_entry/proc/customize(obj/item/spawned, datum/loadout_item/loadout_item)
	if(custom_name && loadout_item.customization_flags & CUSTOMIZE_NAME)
		spawned.name = custom_name
	if(custom_desc && loadout_item.customization_flags & CUSTOMIZE_DESC)
		spawned.desc = custom_desc
	if(custom_gags_colors && loadout_item.customization_flags & CUSTOMIZE_COLOR && loadout_item.gags_colors)
		spawned.set_greyscale(custom_gags_colors)
	if(custom_color && loadout_item.customization_flags & CUSTOMIZE_COLOR && !loadout_item.gags_colors)
		spawned.add_atom_colour(custom_color, FIXED_COLOUR_PRIORITY)
	if(custom_color_rotation && loadout_item.customization_flags & CUSTOMIZE_COLOR_ROTATION)
		spawned.add_atom_colour(color_matrix_rotate_hue(custom_color_rotation), FIXED_COLOUR_PRIORITY)
