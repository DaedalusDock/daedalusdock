/obj/effect/mapping_helpers/door_control_linker
	icon = 'icons/effects/mapping_helpers_96x96.dmi'
	icon_state = "pincode_helper"
	layer = DOOR_HELPER_LAYER - 0.01 // This helper is huge so render under similar ones.
	pixel_x = -32
	pixel_y = -32

	/// The ID used to link everything together.
	var/linker_id

/obj/effect/mapping_helpers/door_control_linker/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

	link_machines()

/obj/effect/mapping_helpers/door_control_linker/proc/link_machines()
	var/obj/machinery/door/airlock/airlock = locate() in loc
	if(!airlock)
		log_mapping("DCL: ([src]) at [AREACOORD(src)]| Door linker not placed on a door.")
		return

	// Make sure the door is actually radio-enabled.
	new /obj/effect/mapping_helpers/airlock/frequency/airlock_control(loc)

	var/list/nearby = orange(1, airlock.loc)

	var/obj/machinery/c4_embedded_controller/master_controller
	var/obj/machinery/c4_embedded_controller/slave/slave_controller

	for(var/obj/machinery/c4_embedded_controller/controller in nearby)
		if(istype(controller, /obj/machinery/c4_embedded_controller/slave))
			if(slave_controller)
				log_mapping("DCL: ([src]) at [AREACOORD(src)]| Multiple slave controllers affected by door linker.")
				continue

			slave_controller = controller
			continue

		if(!controller.autolink_capable)
			log_mapping("DCL: ([src]) at [AREACOORD(src)]| Incompatible controller type [controller.type] affected by door linker.")
			continue

		if(master_controller)
			log_mapping("DCL: ([src]) at [AREACOORD(src)]| Multiple master controllers affected by door linker.")
			continue

		master_controller = controller

	// Link up controllers
	var/slave_id = "[linker_id]_slave"
	airlock.id_tag = linker_id
	slave_controller?.id_tag = slave_id

	if(master_controller)
		if(istype(master_controller, /obj/machinery/c4_embedded_controller/airlock_pinpad))
			var/obj/machinery/c4_embedded_controller/airlock_pinpad/pinpad = master_controller
			pinpad.tag_target = linker_id
			pinpad.tag_slave = slave_id

		else if (istype(master_controller, /obj/machinery/c4_embedded_controller/airlock_access))
			var/obj/machinery/c4_embedded_controller/airlock_access/pinpad = master_controller
			pinpad.tag_target = linker_id
			pinpad.tag_slave = slave_id
		else
			CRASH("Embedded Controller of type [master_controller.type] is marked as DCL capable but is not handled!")
	else
		log_mapping("DCL: ([src]) at [AREACOORD(src)]| Door linker with no master controller[slave_controller ? "." : " or slave controller."]")

/// Generates a random ID instead of a manual one. Saves on mapping time if you don't care about the IDs.
/obj/effect/mapping_helpers/door_control_linker/random_id
	/// Juuuuuust in case.
	var/static/list/consumed_ids = list()

/obj/effect/mapping_helpers/door_control_linker/random_id/Initialize(mapload)
	do
		linker_id = "[world.timeofday][rand(1, 100)][rand(1, 100)]"
	while(consumed_ids[linker_id])

	consumed_ids[linker_id] = TRUE

	. = ..()

