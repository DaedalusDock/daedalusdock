/obj/effect/mapping_helpers/airlock/access
	layer = DOOR_HELPER_LAYER
	icon_state = "access_helper"

/// Getter stub for subtypes.
/obj/effect/mapping_helpers/airlock/access/proc/get_access()
	return

// These are mutually exclusive; can't have req_any and req_all
/obj/effect/mapping_helpers/airlock/access/any/payload(obj/machinery/door/airlock/airlock)
	if(airlock.req_access_txt == "0")
		var/list/access_list = get_access()
		// Overwrite if there is no access set, otherwise add onto existing access
		if(airlock.req_one_access_txt == "0")
			airlock.req_one_access_txt = access_list.Join(";")
		else
			airlock.req_one_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_one_access, but req_access_txt was already set!")

/obj/effect/mapping_helpers/airlock/access/all/payload(obj/machinery/door/airlock/airlock)
	if(airlock.req_one_access_txt == "0")
		var/list/access_list = get_access()
		if(airlock.req_access_txt == "0")
			airlock.req_access_txt = access_list.Join(";")
		else
			airlock.req_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_access, but req_one_access_txt was already set!")

/obj/effect/mapping_helpers/airlock/access/any
	/// Insert into req_one_access.
	var/list/granted_any_access = list()

/obj/effect/mapping_helpers/airlock/access/any/get_access()
	return granted_any_access

/obj/effect/mapping_helpers/airlock/access/all
	/// Insert into req_access.
	var/list/granted_all_access = list()

/obj/effect/mapping_helpers/airlock/access/all/get_access()
	return granted_all_access
