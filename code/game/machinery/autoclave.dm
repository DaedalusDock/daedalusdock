/obj/machinery/autoclave
	name = "autoclave"
	desc = "A pressurized chamber used to eliminate bacteria."

	icon = 'icons/obj/machines/autoclave.dmi'
	base_icon_state = "autoclave"
	icon_state = "autoclave"

	light_color = LIGHT_COLOR_FAINT_BLUE
	light_power = 0.8
	light_inner_range = 0.5
	light_outer_range = 2.5
	light_on = FALSE

	occupant_typecache = list(/obj/item)
	state_open = FALSE

	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 5
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05

	var/sanitize_time = 30 SECONDS

	var/static/alpha_mask_filter
	var/datum/looping_sound/microwave/soundloop

	/// Timer ID for the actual work. Can be used to check if the machine is "busy"
	var/work_timer_id

/obj/machinery/autoclave/Initialize(mapload)
	. = ..()
	soundloop = new(src)
	alpha_mask_filter ||= filter(type = "alpha", icon = icon(icon, "alphamask"))

	update_appearance(UPDATE_OVERLAYS)
	register_context()

/obj/machinery/autoclave/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/autoclave/examine(mob/user)
	. = ..()
	if(occupant)
		. += span_info("There is \a [occupant] inside.")

/obj/machinery/autoclave/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(held_item)
		context[SCREENTIP_CONTEXT_LMB] = "Insert"
	else
		context[SCREENTIP_CONTEXT_LMB] = state_open ? "Close" : "Open"

	context[SCREENTIP_CONTEXT_RMB] = "Turn on"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/autoclave/update_overlays()
	. = ..()
	if(state_open)
		. += image(icon, "door-open")
	else
		if(occupant)
			var/mutable_appearance/content_copy = new /mutable_appearance(occupant)
			content_copy.layer = FLOAT_LAYER
			content_copy.plane = FLOAT_PLANE
			content_copy.pixel_x = 0
			content_copy.pixel_y = 0
			content_copy.appearance_flags |= KEEP_TOGETHER
			content_copy.filters += alpha_mask_filter
			. += content_copy

		. += image(icon, "door-closed")

	if(!is_operational)
		. += image(icon, "lights-off")

	else if(work_timer_id)
		. += image(icon, "lights-green")
		. += emissive_appearance(icon, "lights-green-emi", alpha = 90)
	else
		. += image(icon, "lights-red")
		. += emissive_appearance(icon, "lights-red-emi", alpha = 90)

/obj/machinery/autoclave/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(try_start())
		user.animate_interact(src, INTERACT_GENERIC)
		add_fingerprint(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return SECONDARY_ATTACK_CONTINUE_CHAIN

/obj/machinery/autoclave/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(.)
		return

	if(!state_open)
		return

	if(!user.temporarilyRemoveItemFromInventory(I))
		return TRUE

	add_fingerprint(user)
	close_machine(I)
	user.visible_message(span_notice("[user] places [I] into [src]."))
	return TRUE

/obj/machinery/autoclave/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(work_timer_id)
		to_chat(user, span_warning("[src] is locked."))
		return TRUE

	if(state_open)
		close_machine()
	else
		open_machine()

	return TRUE

/obj/machinery/autoclave/on_set_is_operational(old_value)
	. = ..()
	if(!is_operational)
		try_stop()

/obj/machinery/autoclave/proc/try_start()
	if(work_timer_id || !occupant)
		return FALSE

	soundloop.start()
	work_timer_id = addtimer(CALLBACK(src, PROC_REF(try_stop)), sanitize_time, TIMER_DELETE_ME|TIMER_STOPPABLE)
	update_appearance(UPDATE_OVERLAYS)
	set_light(l_on = TRUE)
	update_use_power(ACTIVE_POWER_USE)
	return TRUE

/obj/machinery/autoclave/proc/try_stop()
	if(!work_timer_id)
		return FALSE

	if(is_operational && occupant)
		sanitize()

	deltimer(work_timer_id)
	work_timer_id = null

	soundloop.stop()
	update_appearance(UPDATE_OVERLAYS)
	set_light(l_on = FALSE)
	update_use_power(IDLE_POWER_USE)
	return TRUE

/obj/machinery/autoclave/proc/sanitize()
	var/obj/item/I = occupant

	I.microwave_act(src)
