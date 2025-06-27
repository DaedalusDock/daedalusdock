/obj/effect/mapping_helpers/access
	layer = DOOR_HELPER_LAYER
	icon_state = "access_helper"
	// Shouldn't *NEED* to be late?

	abstract_type = /obj/effect/mapping_helpers/access

	var/granted_access = list()

	var/search_type

/obj/effect/mapping_helpers/access/proc/payload(obj/target)
	CRASH("Payload hit for abstract access helper???")

/obj/effect/mapping_helpers/access/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

	var/obj/target = locate(search_type) in loc
	if(!target)
		log_mapping("[src] failed to find obj of type [search_type] at [AREACOORD(src)]")
	else
		payload(target)

/obj/effect/mapping_helpers/access/proc/get_access()
	return granted_access

// Stub types for definition location.
/obj/effect/mapping_helpers/access/all
/obj/effect/mapping_helpers/access/any

// These are mutually exclusive; can't have req_any and req_all
/obj/effect/mapping_helpers/access/any/payload(obj/target)
	if(target.req_access_txt == "0")
		var/list/access_list = get_access()
		// Overwrite if there is no access set, otherwise add onto existing access
		if(target.req_one_access_txt == "0")
			target.req_one_access_txt = access_list.Join(";")
		else
			target.req_one_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_one_access, but req_access_txt was already set!")

/obj/effect/mapping_helpers/access/all/payload(obj/target)
	if(target.req_one_access_txt == "0")
		var/list/access_list = get_access()
		if(target.req_access_txt == "0")
			target.req_access_txt = access_list.Join(";")
		else
			target.req_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_access, but req_one_access_txt was already set!")
