/obj/effect/mapping_helpers/windoor/access
	layer = DOOR_HELPER_LAYER
	icon_state = "access_helper"

/// Getter stub for subtypes.
/obj/effect/mapping_helpers/windoor/access/proc/get_access()
	return

// These are mutually exclusive; can't have req_any and req_all
/obj/effect/mapping_helpers/windoor/access/any/payload(obj/machinery/door/window/windoor)
	if(windoor.req_access_txt == "0")
		var/list/access_list = get_access()
		// Overwrite if there is no access set, otherwise add onto existing access
		if(windoor.req_one_access_txt == "0")
			windoor.req_one_access_txt = access_list.Join(";")
		else
			windoor.req_one_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_one_access, but req_access_txt was already set!")

/obj/effect/mapping_helpers/windoor/access/all/payload(obj/machinery/door/window/windoor)
	if(windoor.req_one_access_txt == "0")
		var/list/access_list = get_access()
		if(windoor.req_access_txt == "0")
			windoor.req_access_txt = access_list.Join(";")
		else
			windoor.req_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_access, but req_one_access_txt was already set!")

/obj/effect/mapping_helpers/windoor/access/any
	/// Insert into req_one_access.
	var/list/granted_any_access = list()

/obj/effect/mapping_helpers/windoor/access/any/get_access()
	return granted_any_access

/obj/effect/mapping_helpers/windoor/access/all
	/// Insert into req_access.
	var/list/granted_all_access = list()

/obj/effect/mapping_helpers/windoor/access/all/get_access()
	return granted_all_access
