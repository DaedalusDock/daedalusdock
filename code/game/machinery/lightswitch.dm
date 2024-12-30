/obj/item/wallframe/light_switch
	name = "light switch frame"
	icon = 'modular_pariah/modules/aesthetics/lightswitch/icons/lightswitch.dmi'
	icon_state = "lightswitch_frame"
	result_path = /obj/machinery/light_switch
	pixel_shift = 26

/obj/item/wallframe/light_switch/after_attach(obj/machinery/light_switch/light_switch)
	. = ..()
	light_switch.has_wires = FALSE
	light_switch.panel_open = TRUE
	light_switch.set_machine_stat(light_switch.machine_stat | MAINT)
	light_switch.update_appearance()

/datum/design/lightswitch_frame
	name = "Light Switch (Wallframe)"
	id = "lightswitch_frame"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(
		/datum/material/iron = 200,
		/datum/material/glass = 200,
	)
	build_path = /obj/item/wallframe/light_switch
	category = list(DCAT_FRAME)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_ENGINEERING

DEFINE_INTERACTABLE(/obj/machinery/light_switch)
/obj/machinery/light_switch
	name = "light switch"
	icon = 'modular_pariah/modules/aesthetics/lightswitch/icons/lightswitch.dmi'
	icon_state = "lightswitch-base"
	base_icon_state = "lightswitch"
	desc = "Make dark."
	power_channel = AREA_USAGE_LIGHT
	use_power = NO_POWER_USE
	zmm_flags = ZMM_MANGLE_PLANES

	/// Set this to a string, path, or area instance to control that area
	/// instead of the switch's location.
	var/area/area = null
	var/has_wires = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/light_switch, 26)

/obj/machinery/light_switch/Initialize(mapload)
	. = ..()

	SET_TRACKING(__TYPE__)
	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/light_switch,
	))

	if(istext(area))
		area = text2path(area)
	if(ispath(area))
		area = GLOB.areas_by_type[area]
	if(!area)
		area = get_area(src)

	if(!name)
		name = "light switch ([area.name])"

	area.light_switches += src
	update_appearance()

/obj/machinery/light_switch/Destroy()
	UNSET_TRACKING(__TYPE__)
	area.light_switches -= src
	if(!length(area.light_switches))
		set_lights(TRUE)
	area = null
	return ..()

/obj/machinery/light_switch/on_set_is_operational(old_value)
	luminosity = is_operational
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light_switch/update_overlays()
	. = ..()
	if(is_operational)
		var/target_state = "[base_icon_state]-[(area.lightswitch ? "on" : "off")]"
		. += mutable_appearance(icon, target_state, alpha = src.alpha)
		. += emissive_appearance(icon, target_state, alpha = 90)
	else
		if(panel_open && has_wires)
			. += mutable_appearance(icon, "[base_icon_state]-wires")

/obj/machinery/light_switch/screwdriver_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		panel_open = TRUE
		balloon_alert(user, "opened panel")
		set_machine_stat(machine_stat | MAINT)
		return TRUE

	if(!has_wires)
		balloon_alert(user, "you should wire it first")
		return TRUE

	panel_open = FALSE
	balloon_alert(user, "closed panel")
	set_machine_stat(machine_stat & ~MAINT)
	return TRUE

/obj/machinery/light_switch/wirecutter_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		return ..()

	if(!has_wires)
		balloon_alert(user, "there arent any wires")
		return TRUE

	has_wires = FALSE
	update_appearance()
	balloon_alert(user, "removed the wires")
	new /obj/item/stack/cable_coil(get_turf(user), 1)
	return TRUE

/obj/machinery/light_switch/crowbar_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		return ..()

	if(has_wires)
		if(user.electrocute_act(10))
			return TRUE

	new /obj/item/wallframe/light_switch(get_turf(user))
	qdel(src)
	return TRUE

/obj/machinery/light_switch/attackby(obj/item/stack/cable_coil, mob/user, params)
	if(!istype(cable_coil))
		return ..()

	cable_coil.use(1)
	has_wires = TRUE
	balloon_alert(user, "wired the switch")
	update_appearance()
	return TRUE

/obj/machinery/light_switch/examine(mob/user)
	. = ..()
	if(panel_open)
		if(has_wires)
			. += span_notice("The wires are visible and could be <i>screwed</i> in place.")
		else
			. += span_notice("The circuitry needs to be <i>wired</i> to be functional.")
		return .

	. += span_notice("It is in the [area.lightswitch ? "on" : "off"] position.")

/obj/machinery/light_switch/interact(mob/user)
	. = ..()
	if(!is_operational)
		return .

	var/did_anything = FALSE
	switch(user.simple_binary_radial(src))
		if(SIMPLE_RADIAL_ACTIVATE)
			did_anything = set_lights(TRUE)
		if(SIMPLE_RADIAL_DEACTIVATE)
			did_anything = set_lights(FALSE)
		if(SIMPLE_RADIAL_DOESNT_USE)
			did_anything = set_lights(!area.lightswitch)

	if(did_anything)
		playsound(src, 'modular_pariah/modules/aesthetics/lightswitch/sound/lightswitch.ogg', 100, 1)

	return TRUE

/obj/machinery/light_switch/proc/set_lights(status)
	if(area.lightswitch == status || !is_operational)
		return
	area.lightswitch = status
	area.update_appearance()

	for(var/obj/machinery/light_switch/light_switch as anything in area.light_switches)
		light_switch.update_appearance()
		SEND_SIGNAL(light_switch, COMSIG_LIGHT_SWITCH_SET, status)

	area.power_change()
	return TRUE

/obj/machinery/light_switch/power_change()
	SHOULD_CALL_PARENT(FALSE)
	if(area == get_area(src))
		return ..()

/obj/machinery/light_switch/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(!(machine_stat & (BROKEN|NOPOWER)))
		power_change()

/obj/item/circuit_component/light_switch
	display_name = "Light Switch"
	desc = "Allows to control the lights of an area."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL

	///If the lights should be turned on or off when the trigger is triggered.
	var/datum/port/input/on_setting
	///Whether the lights are turned on
	var/datum/port/output/is_on

	var/obj/machinery/light_switch/attached_switch

/obj/item/circuit_component/light_switch/populate_ports()
	on_setting = add_input_port("On", PORT_TYPE_NUMBER)
	is_on = add_output_port("Is On", PORT_TYPE_NUMBER)

/obj/item/circuit_component/light_switch/register_usb_parent(atom/movable/parent)
	. = ..()
	if(istype(parent, /obj/machinery/light_switch))
		attached_switch = parent
		RegisterSignal(parent, COMSIG_LIGHT_SWITCH_SET, PROC_REF(on_light_switch_set))

/obj/item/circuit_component/light_switch/unregister_usb_parent(atom/movable/parent)
	attached_switch = null
	UnregisterSignal(parent, COMSIG_LIGHT_SWITCH_SET)
	return ..()

/obj/item/circuit_component/light_switch/proc/on_light_switch_set(datum/source, status)
	SIGNAL_HANDLER
	is_on.set_output(status)

/obj/item/circuit_component/light_switch/input_received(datum/port/input/port)
	attached_switch?.set_lights(on_setting.value ? TRUE : FALSE)
