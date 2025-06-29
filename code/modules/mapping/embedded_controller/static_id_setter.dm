/obj/effect/mapping_helpers/embedded_controller/static_id
	icon_state = "pincode_helper"

	var/static_pin_id = ""
	var/static_pin_length = 5

/obj/effect/mapping_helpers/embedded_controller/static_id/payload(obj/machinery/c4_embedded_controller/controller)
	var/obj/machinery/c4_embedded_controller/airlock_pinpad/pinpad = controller
	ASSERT(istype(pinpad))

	pinpad.static_pin_id = static_pin_id
	pinpad.static_pin_length = static_pin_length

/obj/effect/mapping_helpers/embedded_controller/static_id/hydroponics
	static_pin_id = JOB_BOTANIST
