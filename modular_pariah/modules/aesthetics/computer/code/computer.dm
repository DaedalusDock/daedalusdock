#define CLICKSOUND_TIME 5 SECONDS

/obj/machinery/computer
	var/clicksound = SFX_KEYBOARD
	var/clickvol = 40
	var/next_clicksound

/obj/machinery/computer/interact(mob/user, special_state)
	. = ..()
	if(clicksound && world.time > next_clicksound && isliving(user))
		next_clicksound = world.time + CLICKSOUND_TIME
		playsound(src, clicksound, clickvol)

#undef CLICKSOUND_TIME

