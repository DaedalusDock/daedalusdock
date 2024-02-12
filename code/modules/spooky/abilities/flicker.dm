/datum/action/cooldown/flicker
	name = "Flicker"
	desc = "Use your electromagnetic influence to disrupt a nearby light fixture."

	click_to_activate = TRUE
	cooldown_time = 120 SECONDS
	write_log = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

/datum/action/cooldown/flicker/is_valid_target(atom/cast_on)
	return istype(cast_on, /obj/machinery/light)

/datum/action/cooldown/flicker/Activate(atom/target)
	. = ..()
	var/obj/machinery/light/L = target
	L.flicker()

	RECORD_GHOST_POWER(src)
