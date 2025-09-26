/obj/item/hotplate
	name = "hot plate"
	desc = "TODO"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "hotplate"

	w_class = WEIGHT_CLASS_NORMAL
	heat = 500

	/// Thermal energy coeff
	var/heater_coefficient = 0.8
	/// At max ramp-up, multiply the thermal energy by this.
	var/heat_rampup_temp = 10
	/// How many seconds it takes to reach max heat ramp-up.
	var/heat_rampup_time = 15
	var/tmp/current_rampup = 0

	var/tmp/on = FALSE
	var/tmp/obj/item/reagent_containers/cup/container

/obj/item/hotplate/Destroy(force)
	QDEL_NULL(container)
	if(on)
		toggle_on()
	return ..()

/obj/item/hotplate/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	toggle_on()
	visible_message(span_notice("[user] turns [src] [on ? "on" : "off"]."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/hotplate/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return contained == container

/obj/item/hotplate/equipped(mob/user, slot, initial)
	. = ..()
	if(on)
		toggle_on()

/obj/item/hotplate/update_overlays()
	. = ..()
	if(on)
		. += image(icon, "hotplate-on")
		. += emissive_appearance(icon, "hotplate-on", alpha = 100)

/obj/item/hotplate/proc/toggle_on()
	on = !on
	if(on)
		START_PROCESSING(SSfastprocess, src)
	else
		STOP_PROCESSING(SSfastprocess, src)
		current_rampup = 0

	update_appearance(UPDATE_OVERLAYS)

/obj/item/hotplate/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/reagent_containers/cup))
		return NONE

	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING

	set_container(tool)
	return ITEM_INTERACT_SUCCESS

/obj/item/hotplate/proc/set_container(obj/item/reagent_containers/cup/new_container)
	if(container)
		UnregisterSignal(container, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
		remove_viscontents(container)
		container.update_offsets()

	container = new_container

	if(!container)
		return

	RegisterSignal(container, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(container_deleted))
	add_viscontents(container)
	container.pixel_y = 4

/obj/item/hotplate/proc/container_deleted(datum/source)
	SIGNAL_HANDLER
	set_container(null)

/obj/item/hotplate/process(delta_time)
	if(!container)
		return

	var/rampup_coeff = (current_rampup / heat_rampup_time) * heat_rampup_temp
	// 80% to 110%
	var/random_mult = rand(8,11) * 0.1
	var/thermal_adjustment = SPECIFIC_HEAT_DEFAULT * delta_time * rampup_coeff * heater_coefficient * random_mult * container.reagents.total_volume

	container.reagents.adjust_thermal_energy(thermal_adjustment)
	current_rampup = clamp(current_rampup + delta_time, 0, heat_rampup_time)
