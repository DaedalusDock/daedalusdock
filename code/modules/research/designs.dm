/***************************************************************
** Design Datums   **
** All the data for building stuff.   **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a $ to denote that they aren't reagents.
The currently supporting non-reagent materials. All material amounts are set as the define MINERAL_MATERIAL_AMOUNT, which defaults to 2000

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from iron). Only add raw materials.

Design Guidelines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides iron/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- Add the AUTOLATHE tag to
*/

/datum/design //Datum for object designs, used in construction
	/// Name of the created object
	var/name = "Name"
	/// Description of the created object
	var/desc = null
	/// The ID of the design. Used for quick reference. Alphanumeric, lower-case, no symbols
	var/id = DESIGN_ID_IGNORE
	/// Bitflags indicating what machines this design is compatable with. ([IMPRINTER]|[AWAY_IMPRINTER]|[FABRICATOR]|[AWAY_LATHE]|[AUTOLATHE]|[MECHFAB]|[BIOGENERATOR]|[LIMBGROWER]|[SMELTER])
	var/build_type = null
	/// List of materials required to create one unit of the product. Format is (typepath or caregory) -> amount
	var/list/materials
	/// The amount of time required to create one unit of the product.
	var/construction_time
	/// The typepath of the object produced by this design
	var/build_path = null
	/// Bitflags indicating what rnd machines should have this design roundstart.
	var/mapload_design_flags = NONE
	/// List of reagents produced by this design. Currently only supported by the biogenerator.
	var/list/make_reagents
	/// What category this design falls under. Used for sorting in production machines, mostly the mechfab.
	var/list/category = null
	/// List of reagents required to create one unit of the product.
	var/list/reagents_list
	/// The maximum number of units of whatever is produced by this can be produced in one go.
	var/maxstack = 1
	/// Production speed multiplier
	var/lathe_time_factor = 1

	/// If this is [TRUE] the admins get notified whenever anyone prints this. Currently only used by the BoH.
	var/dangerous_construction = FALSE

	/// Override for the automatic icon generation used for some UIs
	var/research_icon
	/// Override for the automatic icon state generation used for some UIs.
	var/research_icon_state

	/// Appears to be unused.
	var/icon_cache
	/// Optional string that interfaces can use as part of search filters. See- item/borg/upgrade/ai and the Exosuit Fabs.
	var/search_metadata

/datum/design/error_design
	name = "ERROR"
	desc = "This usually means something in the database has corrupted. If this doesn't go away automatically, inform Central Comamnd so their techs can fix this ASAP(tm)"

/datum/design/New()
	. = ..()
	if(length(materials))
		var/list/temp_list = list()
		for(var/i in materials) //Go through all of our materials, get the subsystem instance, and then replace the list.
			var/amount = materials[i]
			if(!istext(i)) //Not a category, so get the ref the normal way
				temp_list[GET_MATERIAL_REF(i)] = amount
			else
				temp_list[i] = amount
		materials = temp_list

/datum/design/Destroy(force)
	if(!force)
		stack_trace("Hey which asshole tried to qdel a design?")
		return QDEL_HINT_LETMELIVE
	return ..()

/// Returns the description of the design
/datum/design/proc/get_description()
	var/obj/object_build_item_path = build_path

	return isnull(desc) ? initial(object_build_item_path.desc) : desc
