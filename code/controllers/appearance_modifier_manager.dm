GLOBAL_REAL_VAR(datum/controller/modmanager/ModManager) = new
#define VALID_COLOR_BLENDS list("[ICON_ADD]", "[ICON_AND]", "[ICON_SUBTRACT]", "[ICON_MULTIPLY]", "[ICON_OVERLAY]")

/* A serialized mod looks like:
list(
	"path" = "/datum/appearance_modifier/goonhead",
	"color" = "FFFFFF",
	"priority" = "1",
	"color_blend" = "0", // ICON_ADD
)
*/

/* A DEserialized mod looks like:
list(
	"path" = /datum/appearance_modifier/goonhead
	"color" = "FFFFFFF",
	"priority" = 1,
	color_blend = 0, // ICON_ADD
)
*/
/datum/controller/modmanager
	///A flat list of all appearance mod templates
	var/list/mod_singletons = list()
	///A list of all appearance mod template instances mapped by their name
	var/list/mods_by_name = list()
	///A list of all appearance mod template instances mapped by their type
	var/list/mods_by_type = list()
	///A list of all appearance mod template instances mapped by what species can use them
	var/list/mods_by_species = list()
	var/list/modnames_by_species = list()

/datum/controller/modmanager/Initialize()
	for(var/path as anything in subtypesof(/datum/appearance_modifier))
		var/datum/appearance_modifier/mod = new path
		if(mod.abstract_type == mod.type)
			continue
		mod_singletons += mod
		mods_by_type[path] = mod
		mods_by_name[mod.name] = mod


	for(var/path in get_selectable_species_by_type())
		var/datum/species/species_path = path
		mods_by_species[path] = list()
		modnames_by_species[path] = list()
		for(var/datum/appearance_modifier/mod as anything in mod_singletons)
			if(initial(species_path.id) in mod.species_can_use)
				modnames_by_species[path] += mod.name
				mods_by_species[path] += mod

/datum/controller/modmanager/proc/NewInstance(path)
	var/datum/appearance_modifier/mod = new path
	return mod

/datum/controller/modmanager/proc/SerializeModData(list/deserialized)
	RETURN_TYPE(/list)

	var/list/serialized_mod = list(
		"path" = "[deserialized["path"]]",
		"color" = "[deserialized["color"]]",
		"priority" = "[deserialized["priority"]]",
		"color_blend" = "[deserialized["color_blend"]]",
	)
	return ValidateSerializedList(serialized_mod)

/datum/controller/modmanager/proc/ValidateSerializedList(list/verify)
	var/path = verify["path"]
	if(!istext(path))
		stack_trace("Appearance Mod path value is not text!")
		return FALSE
	path = text2path(path)
	if(!ispath(path))
		stack_trace("Appearance Mod path value does not exist! ([path])")
		return FALSE

	var/color = verify["color"]
	if(!findtext(color, GLOB.is_color))
		stack_trace("Appearance Mod color value is not a color! ([color])")
		return FALSE

	var/priority = verify["priority"]
	if(!isnum(text2num(priority)))
		stack_trace("Appearance Mod priority value is not a number! ([priority])")
		return FALSE

	var/color_blend_func = verify["color_blend"]
	if(!("[color_blend_func]" in VALID_COLOR_BLENDS))
		stack_trace("Appearance Mod color blend mode value is invalid! ([color_blend_func])")
		return FALSE

	return verify

/datum/controller/modmanager/proc/ValidateDeserializedList(list/verify)
	var/path = verify["path"]
	if(!ispath(path))
		stack_trace("Appearance Mod path value does not exist! ([path])")
		return FALSE
	var/color = verify["color"]
	if(!findtext(color, GLOB.is_color))
		stack_trace("Appearance Mod color value is not a color! ([color])")
		return FALSE

	var/priority = verify["priority"]
	if(!isnum(priority))
		stack_trace("Appearance Mod priority value is not a number! ([priority])")
		return FALSE
	var/color_blend_func = verify["color_blend"]

	if(!("[color_blend_func]" in VALID_COLOR_BLENDS))
		stack_trace("Appearance Mod color blend mode value is invalid! ([color_blend_func])")
		return FALSE

	return verify

/datum/controller/modmanager/proc/DeserializeSavedMod(list/saved)
	RETURN_TYPE(/datum/appearance_modifier)

	var/list/deserialized = list()

	deserialized["path"] = text2path(saved["path"])
	deserialized["color"] = saved["color"]
	deserialized["priority"] = text2num(saved["priority"])
	deserialized["color_blend"] = text2num(saved["color_blend"])

	var/valid = ValidateDeserializedList(deserialized)
	if(!valid)
		return FALSE

	return deserialized


#undef VALID_COLOR_BLENDS
