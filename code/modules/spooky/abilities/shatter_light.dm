/datum/action/cooldown/shatter_light
	name = "Snuff Light"
	desc = "Overload a nearby source of light."

	click_to_activate = TRUE
	cooldown_time = 20 MINUTES
	write_log = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

/datum/action/cooldown/shatter_light/is_valid_target(atom/cast_on)
	return istype(cast_on, /obj/machinery/light)

/datum/action/cooldown/shatter_light/Activate(atom/target)
	. = ..()
	var/obj/machinery/light/L = target
	L.break_light_tube()

	RECORD_GHOST_POWER(src)
