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
	var/list/materials = list()
	/// The amount of time required to create one unit of the product.
	var/construction_time
	/// The typepath of the object produced by this design
	var/build_path = null
	/// Bitflags indicating what rnd machines should have this design roundstart.
	var/mapload_design_flags = NONE
	/// List of reagents produced by this design. Currently only supported by the biogenerator.
	var/list/make_reagents = list()
	/// What category this design falls under. Used for sorting in production machines, mostly the mechfab.
	var/list/category = null
	/// List of reagents required to create one unit of the product.
	var/list/reagents_list = list()
	/// The maximum number of units of whatever is produced by this can be produced in one go.
	var/maxstack = 1
	/// How many times faster than normal is this to build on the fabricator
	var/lathe_time_factor = 1
	#warn ^ Needs addressing
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
	/// For protolathe designs that don't require reagents: If they can be exported to autolathes with a design disk or not.
	var/autolathe_exportable = TRUE
	#warn ^ Needs addressing

/datum/design/error_design
	name = "ERROR"
	desc = "This usually means something in the database has corrupted. If this doesn't go away automatically, inform Central Comamnd so their techs can fix this ASAP(tm)"

/datum/design/Destroy()
	if(!force)
		stack_trace("Hey which asshole tried to qdel a design?")
		return QDEL_HINT_LETMELIVE
	return ..()

/datum/design/proc/InitializeMaterials()
	var/list/temp_list = list()
	for(var/i in materials) //Go through all of our materials, get the subsystem instance, and then replace the list.
		var/amount = materials[i]
		if(!istext(i)) //Not a category, so get the ref the normal way
			var/datum/material/M = GET_MATERIAL_REF(i)
			temp_list[M] = amount
		else
			temp_list[i] = amount
	materials = temp_list

/datum/design/proc/icon_html(client/user)
	var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/research_designs)
	sheet.send(user)
	return sheet.icon_tag(id)

/// Returns the description of the design
/datum/design/proc/get_description()
	var/obj/object_build_item_path = build_path

	return isnull(desc) ? initial(object_build_item_path.desc) : desc


////////////////////////////////////////
//Disks for transporting design datums//
////////////////////////////////////////

/obj/item/disk/design_disk
	name = "design disk"
	desc = "A disk for storing device design data for construction in fabricators."
	icon_state = "datadisk1"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass =100)

	/// How many designs are allowed to be stored on this disk
	VAR_PROTECTED/storage = 1
	var/list/datum/design/stored_designs = list()

/obj/item/disk/design_disk/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

///Removes a design from the data disk. Returns TRUE on success.
/obj/item/disk/design_disk/proc/remove_design(datum/design/D)
	if(!(D in stored_designs))
		return FALSE

	stored_designs -= D
	return TRUE

///Adds a design to the data disk. Returns TRUE on success.
/obj/item/disk/design_disk/proc/add_design(datum/design/D)
	if(length(stored_designs) >= storage)
		return FALSE

	if(D in stored_designs)
		return FALSE

	stored_designs += D
	return TRUE

/obj/item/disk/design_disk/proc/copy_designs()
	RETURN_TYPE(/list)
	return stored_designs.Copy()

/obj/item/disk/design_disk/proc/set_data(list/L)
	stored_designs = L

/obj/item/disk/design_disk/proc/wipe_data()
	stored_designs.Cut()

/obj/item/disk/design_disk/proc/add_design_list(list/L)
	if(length(L) + length(stored_designs) > storage)
		return FALSE

	stored_designs |= L
	return TRUE

/obj/item/disk/design_disk/proc/remove_design_list(list/L)
	stored_designs -= L
	return TRUE

/obj/item/disk/design_disk/adv
	name = "advanced design disk"
	desc = "A disk for storing device design data for construction in fabricators. This one has extra storage space."
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/silver = 50)
	storage = 5

/obj/item/disk/design_disk/master
	name = "master design disk"
	desc = "A disk for storing device design data for construction in fabricators. This one has extremely large storage space."
	storage = INFINITY

