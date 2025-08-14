/// Sets the pinpad ID (not the linking ID!!!).
/obj/effect/mapping_helpers/embedded_controller/static_id
	icon_state = "pincode_helper"

	var/static_pin_id = ""
	var/static_pin_length = 5

/obj/effect/mapping_helpers/embedded_controller/static_id/payload(obj/machinery/c4_embedded_controller/controller)
	var/obj/machinery/c4_embedded_controller/airlock_pinpad/pinpad = controller
	ASSERT(istype(pinpad))

	pinpad.static_pin_id = static_pin_id
	pinpad.static_pin_length = static_pin_length

/obj/effect/mapping_helpers/embedded_controller/static_id/bartender
	static_pin_id = /datum/job/bartender::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/botanist
	static_pin_id = /datum/job/botanist::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/chaplain
	static_pin_id = /datum/job/chaplain::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/clown
	static_pin_id = /datum/job/clown::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/cook
	static_pin_id = /datum/job/cook::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/curator
	static_pin_id = /datum/job/curator::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/detective
	static_pin_id = /datum/job/detective::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/janitor
	static_pin_id = /datum/job/janitor::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/lawyer
	static_pin_id = /datum/job/lawyer::pinpad_key

/obj/effect/mapping_helpers/embedded_controller/static_id/psychologist
	static_pin_id = /datum/job/psychologist::pinpad_key
