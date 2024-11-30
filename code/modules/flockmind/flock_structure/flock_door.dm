/obj/machinery/door/flock
	icon = 'goon/icons/mob/featherzone.dmi'
	name = "weird imposing wall"
	desc = "It sounds like it's hollow."

	autoclose_delay = 5 SECONDS
	dont_close_on_dense_objects = FALSE

/obj/machinery/door/flock/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/flock_object)
	AddComponent(/datum/component/flock_protection, report_unarmed=FALSE)

/obj/machinery/door/flock/get_flock_id()
	return "Solid seal aperature"

/obj/machinery/door/flock/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/screwdriver)
	return FALSE

/obj/machinery/door/flock/allowed(mob/M)
	return isflockmob(M)

/obj/machinery/door/flock/do_animate(animation)
	. = ..()
	if(animation == "deny")
		playsound(src, 'goon/sounds/flockmind/flockdrone_door_deny.ogg', 50, TRUE, -2)

/obj/machinery/door/flock/try_flock_convert(datum/flock/flock, force)
	return
