/datum/action/cooldown/shatter_glass
	name = "Resonance"
	desc = "Vibrate a nearby glass object enough to cause integrity failure."

	click_to_activate = TRUE
	cooldown_time = 30 MINUTES
	write_log = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

/datum/action/cooldown/shatter_glass/is_valid_target(atom/cast_on)
	if(istype(target, /obj/structure/window))
		var/obj/structure/window/W = target
		if(W.reinf)
			to_chat(owner, span_warning("I cannot shatter that, it is too strong."))
			return FALSE
		return TRUE

	return istype(target, /obj/structure/table/glass)

/datum/action/cooldown/shatter_glass/Activate(atom/target)
	. = ..()
	var/obj/structure/S = target
	S.deconstruct()

	RECORD_GHOST_POWER(src)
