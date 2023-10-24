/*! How material datums work
Materials are now instanced datums, with an associative list of them being kept in SSmaterials. We only instance the materials once and then re-use these instances for everything.

These materials call on_applied() on whatever item they are applied to, common effects are adding components, changing color and changing description. This allows us to differentiate items based on the material they are made out of.area

*/

SUBSYSTEM_DEF(materials)
	name = "Materials"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MATERIALS
	///Dictionary of material.id || material ref
	var/list/materials
	///Dictionary of type || list of material refs
	var/list/materials_by_type
	///Dictionary of type || list of material ids
	var/list/materialids_by_type
	///Dictionary of category || list of material refs
	var/list/materials_by_category
	///Dictionary of category || list of material ids, mostly used by rnd machines like autolathes.
	var/list/materialids_by_category
	///A cache of all material combinations that have been used
	var/list/list/material_combos
	///List of stackcrafting recipes for materials using base recipes
	var/list/base_stack_recipes = list(
		new /datum/stack_recipe("Chair", /obj/structure/chair/greyscale, one_per_turf = TRUE, on_floor = TRUE, applies_mats = TRUE),
		new /datum/stack_recipe("Toilet", /obj/structure/toilet/greyscale, one_per_turf = TRUE, on_floor = TRUE, applies_mats = TRUE),
		new /datum/stack_recipe("Sink Frame", /obj/structure/sinkframe, one_per_turf = TRUE, on_floor = TRUE, applies_mats = TRUE),
		new /datum/stack_recipe("Material floor tile", /obj/item/stack/tile/material, 1, 4, 20, applies_mats = TRUE),
	)
	///List of stackcrafting recipes for materials using rigid recipes
	var/list/rigid_stack_recipes = list(
		new /datum/stack_recipe("Carving block", /obj/structure/carving_block, 5, one_per_turf = TRUE, on_floor = TRUE, applies_mats = TRUE),
	)

/datum/controller/subsystem/materials/Initialize(start_timeofday)
	InitializeMaterials()
	return ..()

///Ran on initialize, populated the materials and materials_by_category dictionaries with their appropiate vars (See these variables for more info)
/datum/controller/subsystem/materials/proc/InitializeMaterials()
	PRIVATE_PROC(TRUE)

	materials = list()
	materials_by_type = list()
	materialids_by_type = list()
	materials_by_category = list()
	materialids_by_category = list()
	material_combos = list()
	for(var/datum/material/mat_type as anything in subtypesof(/datum/material))
		if(isabstract(mat_type) || (initial(mat_type.bespoke)))
			continue // Do not initialize at mapload
		InitializeMaterial(mat_type)

/** Creates and caches a material datum.
 *
 * Arugments:
 * - [arguments][/list]: The arguments to use to create the material datum
 *   - The first element is the type of material to initialize.
 */
/datum/controller/subsystem/materials/proc/InitializeMaterial(...)
	PRIVATE_PROC(TRUE)

	var/datum/material/mat_type = args[1]
	if(initial(mat_type.bespoke))
		args[1] = GetIdFromArguments(arglist(args))

	var/datum/material/mat_ref = new mat_type
	if(!mat_ref.Initialize(arglist(args)))
		return null

	var/mat_id = mat_ref.id
	materials[mat_id] = mat_ref
	materials_by_type[mat_type] += list(mat_ref)
	materialids_by_type[mat_type] += list(mat_id)
	for(var/category in mat_ref.categories)
		materials_by_category[category] += list(mat_ref)
		materialids_by_category[category] += list(mat_id)

	return mat_ref

/** Fetches a cached material singleton when passed sufficient arguments.
 *
 * Arguments:
 * - [arguments][/list]: The list of arguments used to fetch the material ref.
 *   - The first element is a material datum, text string, or material type.
 *     - [Material datums][/datum/material] are assumed to be references to the cached datum and are returned
 *     - Text is assumed to be the text ID of a material and the corresponding material is fetched from the cache
 *     - A material type is checked for bespokeness:
 *       - If the material type is not bespoke the type is assumed to be the id for a material and the corresponding material is loaded from the cache.
 *       - If the material type is bespoke a text ID is generated from the arguments list and used to load a material datum from the cache.
 *   - The following elements are used to generate bespoke IDs
 */
/datum/controller/subsystem/materials/proc/_GetMaterialRef(...)
	var/datum/material/key = args[1]
	if(istype(key))
		return key // We are assuming here that the only thing allowed to create material datums is [/datum/controller/subsystem/materials/proc/InitializeMaterial]

	if(ispath(key, /datum/material))
		if(!(initial(key.bespoke)))
			. = materials[key]
			if(!.)
				CRASH("Attempted to fetch reference to an abstract material with key [key]")
			return .

	else if(istext(key)) // Handle text id
		. = materials[key]
		if(!.)
			CRASH("Attempted to fetch material ref with invalid text id '[key]'")
	else
		CRASH("Attempted to fetch material ref with invalid key [isdatum(key) ? "[REF(key)] ([key.type])" : "[key]"]")

	// Only Bespoke (mid-round generated) materials should make it this far.
	key = GetIdFromArguments(arglist(args))
	return materials[key] || InitializeMaterial(arglist(args))

/// Generates a unique ID from a list of arguments. Does not support passing in lists.
/datum/controller/subsystem/materials/proc/GetIdFromArguments(...)
	PRIVATE_PROC(TRUE)

	var/datum/material/mattype = args[1]
	if(length(args) == 1)
		return "[initial(mattype.id) || mattype]"

	var/list/fullid = list("[initial(mattype.id) || mattype]")

	for(var/i in 2 to length(args))
		var/argument = args[i]
		if(!(istext(argument) || isnum(argument)))
			fullid += REF(argument)
			continue

		fullid += "[argument]" // Key is stringified so numbers dont break things

	return json_encode(fullid)

/// Returns a list to be used as an object's custom_materials. Lists will be cached and re-used based on the parameters.
/datum/controller/subsystem/materials/proc/FindOrCreateMaterialCombo(list/materials_declaration, multiplier)
	if(!LAZYLEN(materials_declaration))
		return null // If we get a null we pass it right back, we don't want to generate stack traces just because something is clearing out its materials list.

	var/combo_index
	if(length(materials_declaration) == 1)
		var/datum/material/mat = materials_declaration[1]
		combo_index = "[istype(mat) ? mat.id : mat]=[materials_declaration[mat] * multiplier]"

	else
		var/list/combo_params = list()
		for(var/datum/material/mat as anything in materials_declaration)
			combo_params += "[istype(mat) ? mat.id : mat]=[materials_declaration[mat] * multiplier]"

		sortTim(combo_params, GLOBAL_PROC_REF(cmp_text_asc)) // We have to sort now in case the declaration was not in order

		combo_index = jointext(combo_params, "-")

	var/list/combo = material_combos[combo_index]
	if(isnull(combo))
		combo = list()
		for(var/mat in materials_declaration)
			combo[GET_MATERIAL_REF(mat)] = materials_declaration[mat] * multiplier
		material_combos[combo_index] = combo
	return combo

/// Returns the name of a supplied material datum or reagent ID.
/datum/controller/subsystem/materials/proc/GetMaterialName(id_or_instance)
	if (istype(id_or_instance, /datum/material))
		var/datum/material/material = id_or_instance
		return material.name

	else if(SSreagents.chemical_reagents_list[id_or_instance])
		var/datum/reagent/reagent = SSreagents.chemical_reagents_list[id_or_instance]
		return reagent.name

	CRASH("Bad argument to GetMaterialName() argument: [(isnum(id_or_instance) || istext(id_or_instance)) ? "[id_or_instance]" : "[REF(id_or_instance)]"]")
