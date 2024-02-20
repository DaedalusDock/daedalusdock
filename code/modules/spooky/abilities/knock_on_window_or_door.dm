/datum/action/cooldown/knock_sound
	name = "Knock"
	desc = "Create an audio phenomena centered on a door or window."

	click_to_activate = TRUE
	cooldown_time = 120 SECONDS
	write_log = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

/datum/action/cooldown/knock_sound/is_valid_target(atom/cast_on)
	return istype(cast_on, /obj/structure/window) || istype(cast_on, /obj/machinery/door)

/datum/action/cooldown/knock_sound/Activate(atom/target)
	. = ..()
	if(istype(target, /obj/machinery/door))
		var/obj/machinery/door/D = target
		D.knock_on()

	else if(istype(target, /obj/structure/window))
		var/obj/structure/window/W = target
		W.knock_on()

	RECORD_GHOST_POWER(src)

