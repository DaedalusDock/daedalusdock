TYPEINFO_DEF(/obj/item/assembly/health)
	default_materials = list(/datum/material/iron=800, /datum/material/glass=200)

/obj/item/assembly/health
	name = "health sensor"
	desc = "Used for scanning and monitoring health."
	icon_state = "health"
	attachable = TRUE

	var/scanning = FALSE
	var/health_scan
	var/alarm_health = HEALTH_THRESHOLD_CRIT

/obj/item/assembly/health/examine(mob/user)
	. = ..()
	. += "Use it in hand to turn it off/on and Alt-click to swap between \"detect death\" mode and \"detect critical state\" mode."
	. += "[src.scanning ? "The sensor is on and you can see [health_scan] displayed on the screen" : "The sensor is off"]."

/obj/item/assembly/health/activate()
	if(!..())
		return FALSE//Cooldown check
	toggle_scan()
	return TRUE

/obj/item/assembly/health/toggle_secure()
	secured = !secured
	if(secured && scanning)
		START_PROCESSING(SSobj, src)
	else
		scanning = FALSE
		STOP_PROCESSING(SSobj, src)
	update_appearance()
	return secured

/obj/item/assembly/health/AltClick(mob/living/user)
	if(alarm_health == HEALTH_THRESHOLD_CRIT)
		alarm_health = HEALTH_THRESHOLD_DEAD
		to_chat(user, span_notice("You toggle [src] to \"detect death\" mode."))
	else
		alarm_health = HEALTH_THRESHOLD_CRIT
		to_chat(user, span_notice("You toggle [src] to \"detect critical state\" mode."))

/obj/item/assembly/health/process()
	if(!scanning || !secured)
		return

	var/atom/A = src
	if(connected?.holder)
		A = connected.holder
	for(A, A && !ismob(A), A=A.loc);
	// like get_turf(), but for mobs.
	var/mob/living/M = A

	if(M)
		health_scan = M.health
		if(health_scan <= alarm_health)
			pulse()
			audible_message("<span class='infoplain'>[icon2html(src, hearers(src))] *beep* *beep* *beep*</span>")
			playsound(src, 'sound/machines/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
			toggle_scan()
		return
	return

/obj/item/assembly/health/proc/toggle_scan()
	if(!secured)
		return 0
	scanning = !scanning
	if(scanning)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	return

/obj/item/assembly/health/attack_self(mob/user)
	. = ..()
	if (secured)
		balloon_alert(user, "scanning [scanning ? "disabled" : "enabled"]")
	else
		balloon_alert(user, span_warning("secure it first!"))
	toggle_scan()
