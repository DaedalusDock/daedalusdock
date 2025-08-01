/obj/item/uv_light
	name = "\improper UV light"
	desc = "A small handheld black light."
	icon = 'icons/obj/device.dmi'
	icon_state = "uv_off"

	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'

	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL

	light_system = OVERLAY_LIGHT
	light_outer_range = 2
	light_color = "#991d8f"
	light_power = 0.3
	light_on = FALSE

	var/uv_range = 5
	var/list/illuminated = list()
	var/is_on = FALSE

/obj/item/uv_light/Destroy()
	if(is_on)
		toggle_light()
	illuminated = null
	return ..()

/obj/item/uv_light/update_icon_state()
	if(is_on)
		icon_state = "uv_on"
	else
		icon_state = "uv_off"
	return ..()

/obj/item/uv_light/unequipped(mob/user, silent)
	. = ..()
	if(is_on)
		toggle_light(user)

/obj/item/uv_light/attack_self(mob/user, modifiers)
	. = ..()
	toggle_light(user)

/obj/item/uv_light/proc/toggle_light(user)
	is_on = !is_on

	if(is_on)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(update_uv))
		set_light_on(TRUE)
	else
		set_light_on(FALSE)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)


	update_appearance(UPDATE_ICON_STATE)
	update_uv()

/obj/item/uv_light/proc/update_uv(datum/source)
	SIGNAL_HANDLER

	var/turf/origin = get_turf(src)
	var/should_hide_anyway = !is_on || !isturf(drop_location())

	for(var/datum/weakref/weakref as anything in illuminated)
		var/atom/movable/AM = weakref.resolve()
		if(!AM)
			illuminated -= weakref
			continue

		if(should_hide_anyway || get_dist(get_turf(AM), origin) >= uv_range)
			AM.uv_hide(ref(src))
			illuminated -= weakref

	if(!is_on || !origin || should_hide_anyway)
		return

	var/step_alpha = floor(255 / uv_range)

	for(var/turf/T in view(uv_range, origin))
		var/dist = get_dist(origin, T)
		var/use_alpha = 255 - (step_alpha * dist)
		var/animate_time = 0.5 * get_dist(origin, T)
		for(var/atom/movable/AM as anything in T)
			if(!HAS_TRAIT(AM, TRAIT_MOVABLE_FLUORESCENT))
				continue

			illuminated |= WEAKREF(AM)

			AM.uv_illuminate(
				ref(src),
				HAS_TRAIT_FROM(src, TRAIT_MOVABLE_FLUORESCENCE_REVEALED, ref(src)) ? 0.5 : animate_time,
				use_alpha
			)

