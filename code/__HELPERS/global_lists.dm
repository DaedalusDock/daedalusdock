//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/make_datum_references_lists()
	//hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/hair, GLOB.hairstyles_list, GLOB.hairstyles_male_list, GLOB.hairstyles_female_list)
	//facial hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_hair, GLOB.facial_hairstyles_list, GLOB.facial_hairstyles_male_list, GLOB.facial_hairstyles_female_list)
	//underwear
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
	//undershirt
	init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, GLOB.undershirt_list, GLOB.undershirt_m, GLOB.undershirt_f)
	//socks
	init_sprite_accessory_subtypes(/datum/sprite_accessory/socks, GLOB.socks_list)
	//bodypart accessories (blizzard intensifies)

	//Snowflakes
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails, GLOB.tails_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ears, GLOB.ears_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/human, GLOB.tails_list_human, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, GLOB.wings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings_open, GLOB.wings_open_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/caps, GLOB.caps_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/pod_hair, GLOB.pod_hair_list)

	// Lizadhs
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/lizard, GLOB.tails_list_lizard)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/snouts, GLOB.snouts_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/horns,GLOB.horns_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/frills, GLOB.frills_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spines, GLOB.spines_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/legs, GLOB.legs_list)

	// Moths
	init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_wings, GLOB.moth_wings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_antennae, GLOB.moth_antennae_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_markings, GLOB.moth_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_hair, GLOB.moth_hairstyles_list)

	// Teshari
	init_sprite_accessory_subtypes(/datum/sprite_accessory/teshari_feathers, GLOB.teshari_feathers_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/teshari_ears, GLOB.teshari_ears_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/teshari_body_feathers, GLOB.teshari_body_feathers_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/teshari, GLOB.teshari_tails_list)

	//Vox
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_hair, GLOB.vox_hair_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_vox_hair, GLOB.vox_facial_hair_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/vox, GLOB.tails_list_vox)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_snouts, GLOB.vox_snouts_list)

	//IPC
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_screen, GLOB.ipc_screens_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_antenna, GLOB.ipc_antenna_list, add_blank = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/saurian_screen, GLOB.saurian_screens_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/saurian_tail, GLOB.saurian_tails_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/saurian_scutes, GLOB.saurian_scutes_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/saurian_antenna, GLOB.saurian_antenna_list, add_blank = TRUE)

	//Species
	for(var/spath in subtypesof(/datum/species))
		var/datum/species/S = new spath()
		GLOB.species_list[S.id] = spath
	sort_list(GLOB.species_list, GLOBAL_PROC_REF(cmp_typepaths_asc))

	//Surgeries
	for(var/datum/surgery_step/path as anything in subtypesof(/datum/surgery_step))
		if(!isabstract(path))
			path = new path()
			GLOB.surgeries_list += path
			if(!length(path.allowed_tools))
				stack_trace("Surgery type [path.type] has no allowed_items list.")

	sort_list(GLOB.surgeries_list, GLOBAL_PROC_REF(cmp_typepaths_asc))

	// Hair Gradients - Initialise all /datum/sprite_accessory/hair_gradient into an list indexed by gradient-style name
	for(var/path in subtypesof(/datum/sprite_accessory/gradient))
		var/datum/sprite_accessory/gradient/gradient = new path()
		if(gradient.gradient_category  & GRADIENT_APPLIES_TO_HAIR)
			GLOB.hair_gradients_list[gradient.name] = gradient
		if(gradient.gradient_category & GRADIENT_APPLIES_TO_FACIAL_HAIR)
			GLOB.facial_hair_gradients_list[gradient.name] = gradient

	// Keybindings
	init_keybindings()

	GLOB.emote_list = init_emote_list()
	GLOB.mod_themes = setup_mod_themes()

	for(var/datum/grab/G as anything in subtypesof(/datum/grab))
		if(isabstract(G))
			continue
		GLOB.all_grabstates[G] = new G

	for(var/path in GLOB.all_grabstates)
		var/datum/grab/G = GLOB.all_grabstates[path]
		G.refresh_updown()

	init_crafting_recipes(GLOB.crafting_recipes)

	init_loadout_references()
	init_augment_references()

	init_magnet_error_codes()

	init_slapcraft_steps()
	init_slapcraft_recipes()

	init_blood_types()

	init_language_datums()

/// Inits the crafting recipe list, sorting crafting recipe requirements in the process.
/proc/init_crafting_recipes(list/crafting_recipes)
	for(var/path in subtypesof(/datum/crafting_recipe))
		var/datum/crafting_recipe/recipe = new path()
		recipe.reqs = sort_list(recipe.reqs, GLOBAL_PROC_REF(cmp_crafting_req_priority))
		crafting_recipes += recipe
	return crafting_recipes

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//returns a list of paths to every subtype of prototype (excluding prototype)
//if no list/L is provided, one is created.
/proc/init_paths(prototype, list/L)
	if(!istype(L))
		L = list()
		for(var/path in subtypesof(prototype))
			L+= path
		return L

/// Functions like init_subtypes, but uses the subtype's path as a key for easy access
/proc/init_subtypes_w_path_keys(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path as anything in subtypesof(prototype))
		L[path] = new path()
	return L

/**
 * Checks if that loc and dir has an item on the wall
**/
// Wall mounted machinery which are visually on the wall.
GLOBAL_LIST_INIT(WALLITEMS_INTERIOR, typecacheof(list(
	/obj/item/radio/intercom,
	/obj/item/storage/secure/safe,
	/obj/machinery/airalarm,
	/obj/machinery/newscaster,
	/obj/machinery/button,
	/obj/machinery/computer/security/telescreen,
	/obj/machinery/computer/security/telescreen/entertainment,
	/obj/machinery/defibrillator_mount,
	/obj/machinery/door_timer,
	/obj/machinery/embedded_controller/radio/simple_vent_controller,
	/obj/machinery/firealarm,
	/obj/machinery/flasher,
	/obj/machinery/keycard_auth,
	/obj/machinery/light_switch,
	/obj/machinery/newscaster,
	/obj/machinery/power/apc,
	/obj/machinery/requests_console,
	/obj/machinery/status_display,
	/obj/machinery/ticket_machine,
	/obj/machinery/turretid,
	/obj/structure/extinguisher_cabinet,
	/obj/structure/fireaxecabinet,
	/obj/structure/mirror,
	/obj/structure/noticeboard,
	/obj/structure/reagent_dispensers/wall,
	/obj/structure/sign,
	/obj/structure/sign/picture_frame,
	/obj/structure/sign/poster/random,
	/obj/structure/sign/poster/contraband/random,
	/obj/structure/sign/poster/official/random,
	)))

// Wall mounted machinery which are visually coming out of the wall.
// These do not conflict with machinery which are visually placed on the wall.
GLOBAL_LIST_INIT(WALLITEMS_EXTERIOR, typecacheof(list(
	/obj/machinery/camera,
	/obj/machinery/light,
	/obj/structure/camera_assembly,
	/obj/structure/light_construct
	)))

/proc/init_loadout_references()
	// Here we build the global loadout lists
	for(var/datum/loadout_item/L as anything in subtypesof(/datum/loadout_item))
		if(!initial(L.path))
			continue
		L = new L()
		GLOB.loadout_items += L
		GLOB.item_path_to_loadout_item[L.path] = L
		if(!GLOB.loadout_category_to_subcategory_to_items[L.category])
			GLOB.loadout_category_to_subcategory_to_items[L.category] = list()
		if(!GLOB.loadout_category_to_subcategory_to_items[L.category][L.subcategory])
			GLOB.loadout_category_to_subcategory_to_items[L.category][L.subcategory] = list()
		GLOB.loadout_category_to_subcategory_to_items[L.category][L.subcategory] += L

	for(var/category as anything in GLOB.loadout_category_to_subcategory_to_items)
		for(var/subcategory as anything in GLOB.loadout_category_to_subcategory_to_items[category])
			GLOB.loadout_category_to_subcategory_to_items[category][subcategory] = sortTim(GLOB.loadout_category_to_subcategory_to_items[category][subcategory], GLOBAL_PROC_REF(cmp_loadout_name))

/proc/init_augment_references()
	// Here we build the global loadout lists
	for(var/path in subtypesof(/datum/augment_item))
		var/datum/augment_item/L = path
		if(!initial(L.path))
			continue

		L = new path()
		GLOB.augment_items[L.type] = L

		if(!GLOB.augment_slot_to_items[L.slot])
			GLOB.augment_slot_to_items[L.slot] = list()
			if(!GLOB.augment_categories_to_slots[L.category])
				GLOB.augment_categories_to_slots[L.category] = list()
			GLOB.augment_categories_to_slots[L.category] += L.slot
		GLOB.augment_slot_to_items[L.slot] += L.type

GLOBAL_LIST_INIT(magnet_error_codes, list(
	MAGNET_ERROR_KEY_BUSY,
	MAGNET_ERROR_KEY_USED_COORD,
	MAGNET_ERROR_KEY_COOLDOWN,
	MAGNET_ERROR_KEY_MOB,
	MAGNET_ERROR_KEY_NO_COORD

))

/proc/init_magnet_error_codes()
	var/list/existing_codes = list()
	var/code
	for(var/key in GLOB.magnet_error_codes)
		do
			code = "[pick(GLOB.alphabet_upper)][rand(1,9)]"
			if(code in existing_codes)
				continue
			else
				GLOB.magnet_error_codes[key] = code
				existing_codes += code
		while(isnull(GLOB.magnet_error_codes[key]))

/proc/init_blood_types()
	for(var/datum/blood/path as anything in typesof(/datum/blood))
		if(isabstract(path))
			continue
		GLOB.blood_datums[path] = new path()

/proc/init_language_datums()
	for(var/datum/language/language as anything in subtypesof(/datum/language))
		if(isabstract(language) || !initial(language.key))
			continue

		var/datum/language/instance = new language
		GLOB.all_languages += instance
		GLOB.language_datum_instances[language] = instance

		if(instance.flags & (LANGUAGE_SELECTABLE_SPEAK | LANGUAGE_SELECTABLE_UNDERSTAND))
			GLOB.preference_language_types += language
