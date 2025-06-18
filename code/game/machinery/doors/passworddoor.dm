TYPEINFO_DEF(/obj/machinery/door/password)
	default_armor = list(BLUNT = 100, PUNCTURE = 100, SLASH = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, FIRE = 100, ACID = 100)

/obj/machinery/door/password
	name = "door"
	desc = "This door only opens when provided a password."
	icon = 'icons/obj/doors/blastdoor.dmi'
	icon_state = "closed"
	explosion_block = 3
	heat_proof = TRUE
	max_integrity = 600
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	damage_deflection = 70
	var/password = "Swordfish"
	var/interaction_activated = TRUE //use the door to enter the password
	var/voice_activated = FALSE //Say the password nearby to open the door.

/obj/machinery/door/password/voice
	voice_activated = TRUE


/obj/machinery/door/password/Initialize(mapload)
	. = ..()
	if(voice_activated)
		become_hearing_sensitive()

/obj/machinery/door/password/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), atom/sound_loc, message_range)
	. = ..()
	if(!density || !voice_activated || radio_freq)
		return
	if(findtext(raw_message,password))
		open()

/obj/machinery/door/password/BumpedBy(atom/movable/AM)
	return !density && ..()

/obj/machinery/door/password/try_to_activate_door(mob/user, access_bypass = FALSE, obj/item/attackedby)
	if(attackedby)
		attackedby.leave_evidence(user, src)
	else
		add_fingerprint(user)
	if(operating)
		return
	if(density)
		if(access_bypass || ask_for_pass(user))
			open()
		else
			do_animate("deny")

/obj/machinery/door/password/update_icon_state()
	. = ..()
	icon_state = density ? "closed" : "open"

/obj/machinery/door/password/do_animate(animation)
	switch(animation)
		if("opening")
			z_flick("opening", src)
			playsound(src, 'sound/machines/doors/blastdoor_open.ogg', 30, TRUE)
		if("closing")
			z_flick("closing", src)
			playsound(src, 'sound/machines/doors/blastdoor_close.ogg', 30, TRUE)
		if("deny")
			//Deny animation would be nice to have.
			playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)

/obj/machinery/door/password/proc/ask_for_pass(mob/user)
	var/guess = tgui_input_text(user, "Enter the password", "Password")
	if(guess == password)
		return TRUE
	return FALSE

/obj/machinery/door/password/emp_act(severity)
	return

/obj/machinery/door/password/ex_act(severity, target)
	return FALSE
