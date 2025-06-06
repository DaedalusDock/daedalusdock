/obj/effect/mapping_helpers/embedded_controller
	layer = DOOR_HELPER_LAYER
	icon_state = "access_helper"

/obj/effect/mapping_helpers/embedded_controller/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

	var/obj/machinery/embedded_controller/compooter = locate() in loc
	if(!compooter)
		log_mapping("[src] failed to find an embedded controller at [AREACOORD(src)]")
	else
		payload(compooter)
	return INITIALIZE_HINT_QDEL

/obj/effect/mapping_helpers/embedded_controller/proc/payload(/obj/machinery/embedded_controller/computer)
	return

/// Getter stub for subtypes.
/obj/effect/mapping_helpers/embedded_controller/access/proc/get_access()
	return


/obj/effect/mapping_helpers/embedded_controller/access

// These are mutually exclusive; can't have req_any and req_all
/obj/effect/mapping_helpers/embedded_controller/access/any/payload(obj/machinery/embedded_controller/computer)
	if(computer.req_access_txt == "0")
		var/list/access_list = get_access()
		// Overwrite if there is no access set, otherwise add onto existing access
		if(computer.req_one_access_txt == "0")
			computer.req_one_access_txt = access_list.Join(";")
		else
			computer.req_one_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_one_access, but req_access_txt was already set!")

/obj/effect/mapping_helpers/embedded_controller/access/all/payload(obj/machinery/embedded_controller/computer)
	if(computer.req_one_access_txt == "0")
		var/list/access_list = get_access()
		if(computer.req_access_txt == "0")
			computer.req_access_txt = access_list.Join(";")
		else
			computer.req_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_access, but req_one_access_txt was already set!")

/obj/effect/mapping_helpers/embedded_controller/access/any
	/// Insert into req_one_access.
	var/list/granted_any_access = list()

/obj/effect/mapping_helpers/embedded_controller/access/any/get_access()
	return granted_any_access

/obj/effect/mapping_helpers/embedded_controller/access/all
	/// Insert into req_access.
	var/list/granted_all_access = list()

/obj/effect/mapping_helpers/embedded_controller/access/all/get_access()
	return granted_all_access
