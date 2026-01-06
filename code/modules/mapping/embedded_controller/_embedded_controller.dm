/obj/effect/mapping_helpers/embedded_controller
	layer = DOOR_HELPER_LAYER - 0.01

/obj/effect/mapping_helpers/embedded_controller/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

	var/obj/machinery/c4_embedded_controller/controller = locate(/obj/machinery/c4_embedded_controller) in loc
	if(!controller)
		log_mapping("[src] failed to find a controller at [AREACOORD(src)]")
	else
		payload(controller)

/obj/effect/mapping_helpers/embedded_controller/proc/payload(obj/machinery/c4_embedded_controller/controller)
	return
