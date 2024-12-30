#define PULSE_ALERT 1
#define BRAIN_ALERT 2
#define LUNGS_ALERT 3

DEFINE_INTERACTABLE(/obj/machinery/vitals_monitor)

/obj/machinery/vitals_monitor
	name = "vitals monitor"
	desc = "A bulky yet mobile machine, showing some odd graphs."
	icon = 'icons/obj/machines/heartmonitor.dmi'
	icon_state = "base"
	anchored = FALSE
	power_channel = AREA_USAGE_EQUIP
	idle_power_usage = 10
	active_power_usage = 100
	processing_flags = START_PROCESSING_MANUALLY

	var/obj/structure/table/optable/connected_optable
	var/beep = TRUE

	//alert stuff
	var/read_alerts = TRUE
	COOLDOWN_DECLARE(alert_cooldown) // buffer to prevent rapid changes in state
	var/list/alerts = null
	var/list/last_alert = null

/obj/machinery/vitals_monitor/Initialize()
	. = ..()
	alerts = new /list(3)
	last_alert = new /list(3)
	for (dir in GLOB.cardinals)
		var/optable = locate(/obj/structure/table/optable, get_step(src, dir))
		if (optable)
			set_optable(optable)
			break

/obj/machinery/vitals_monitor/Destroy()
	set_optable(null)
	return ..()

/obj/machinery/vitals_monitor/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(connected_optable && !Adjacent(connected_optable))
		set_optable(null)

/obj/machinery/vitals_monitor/proc/set_optable(obj/structure/table/optable/target)
	if (target == connected_optable)
		return

	STOP_PROCESSING(SSmachines, src)
	if (connected_optable) //gotta clear existing connections first
		connected_optable.connected_monitor = null

	connected_optable = target

	if (connected_optable)
		connected_optable.connected_monitor = src
		visible_message(span_notice("\The [src] is now relaying information from \the [connected_optable]"))
		START_PROCESSING(SSmachines, src)

	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/vitals_monitor/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!.)
		return

	if (istype(over, /obj/structure/table/optable))
		set_optable(over)

/obj/machinery/vitals_monitor/update_overlays()
	. = ..()
	if (machine_stat & NOPOWER)
		return
	. += image(icon, icon_state = "screen")

	if(connected_optable?.patient)
		handle_pulse(.)
		handle_brain(.)
		handle_lungs(.)
		handle_alerts(.)

/obj/machinery/vitals_monitor/process()
	if(!Adjacent(connected_optable))
		set_optable(null)
		return

	if (connected_optable.patient)
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/vitals_monitor/proc/handle_pulse(list/overlays)
	. = overlays
	var/obj/item/organ/heart/heart = connected_optable.patient.getorganslot(ORGAN_SLOT_HEART)
	if (istype(heart) && !(heart.organ_flags & ORGAN_SYNTHETIC))
		switch (connected_optable.patient.pulse())
			if (PULSE_NONE)
				. += emissive_appearance(icon, "pulse_flatline", alpha = 90)
				. += emissive_appearance(icon, "pulse_warning", alpha = 90)
				. += image(icon, icon_state = "pulse_flatline")
				. += image(icon, icon_state = "pulse_warning")
				if (beep)
					playsound(src, 'sound/machines/flatline.ogg', 20)
				if (read_alerts)
					alerts[PULSE_ALERT] = "Cardiac flatline detected!"

			if (PULSE_SLOW, PULSE_NORM)
				. += emissive_appearance(icon, "pulse_normal", alpha = 90)
				. += image(icon, icon_state = "pulse_normal")
				if (beep)
					playsound(src, 'sound/machines/quiet_beep.ogg', 30)

			if (PULSE_FAST, PULSE_2FAST)
				. += emissive_appearance(icon, "pulse_veryfast", alpha = 90)
				. += image(icon, icon_state = "pulse_veryfast")
				if (beep)
					playsound(src, 'sound/machines/quiet_double_beep.ogg', 40)

			if (PULSE_THREADY)
				. += emissive_appearance(icon, "pulse_thready", alpha = 90)
				. += image(icon, icon_state = "pulse_thready")
				. += emissive_appearance(icon, "pulse_warning", alpha = 90)
				. += image(icon, icon_state = "pulse_warning")
				if (beep)
					playsound(src, 'sound/machines/ekg_alert.ogg', 40)

				if (read_alerts)
					alerts[PULSE_ALERT] = "Excessive heartbeat! Possible Shock Detected!"
	else
		. += emissive_appearance(icon, "pulse_warning", alpha = 90)
		. += image(icon, icon_state = "pulse_warning")

/obj/machinery/vitals_monitor/proc/handle_brain(list/overlays)
	. = overlays
	var/obj/item/organ/brain/brain = connected_optable.patient.getorganslot(ORGAN_SLOT_BRAIN)
	if (istype(brain) && connected_optable.patient.stat != DEAD && !HAS_TRAIT(connected_optable.patient, TRAIT_FAKEDEATH))
		switch (round(brain.damage / brain.damage_threshold_value))
			if (0 to 2)
				. += (emissive_appearance(icon, "brain_ok", alpha = 90))
				. += (image(icon, icon_state = "brain_ok"))
			if (3 to 5)
				. += (emissive_appearance(icon, "breathing_bad", alpha = 90))
				. += (image(icon, icon_state = "brain_bad"))
				if (read_alerts)
					alerts[BRAIN_ALERT] = "Weak brain activity!"
			if (6 to INFINITY)
				. += (emissive_appearance(icon, "brain_verybad", alpha = 90))
				. += (image(icon, icon_state = "brain_verybad"))
				. += (emissive_appearance(icon, "brain_warning", alpha = 90))
				. += (image(icon, icon_state = "brain_warning"))
				if (read_alerts)
					alerts[BRAIN_ALERT] = "Very weak brain activity!"
	else
		. += (emissive_appearance(icon, "brain_warning", alpha = 90))
		. += (image(icon, icon_state = "brain_warning"))

/obj/machinery/vitals_monitor/proc/handle_lungs(list/overlays)
	. = overlays
	var/obj/item/organ/lungs/lungs = connected_optable.patient.getorganslot(ORGAN_SLOT_LUNGS)
	if (istype(lungs) && !HAS_TRAIT(connected_optable.patient, TRAIT_FAKEDEATH))
		if (!connected_optable.patient.failed_last_breath)
			. += (emissive_appearance(icon, "breathing_normal", alpha = 90))
			. += (image(icon, icon_state = "breathing_normal"))
		else if (connected_optable.patient.losebreath)
			. += (emissive_appearance(icon, "breathing_shallow", alpha = 90))
			. += (image(icon, icon_state = "breathing_shallow"))
			if (read_alerts)
				alerts[LUNGS_ALERT] = "Abnormal breathing detected!"
		else
			. += (emissive_appearance(icon, "breathing_warning", alpha = 90))
			. += (image(icon, icon_state = "breathing_warning"))
			if (read_alerts)
				alerts[LUNGS_ALERT] = "Patient is not breathing!"
	else
		. += (emissive_appearance(icon, "breathing_warning", alpha = 90))
		. += (image(icon, icon_state = "breathing_warning"))

/obj/machinery/vitals_monitor/proc/handle_alerts(list/overlays)
	. = overlays
	if (!connected_optable?.patient || !read_alerts) //Clear our alerts
		alerts[PULSE_ALERT] = ""
		alerts[BRAIN_ALERT] = ""
		alerts[LUNGS_ALERT] = ""
		return

	if (COOLDOWN_FINISHED(src, alert_cooldown))
		if (alerts[PULSE_ALERT] && alerts[PULSE_ALERT] != last_alert[PULSE_ALERT])
			audible_message(span_warning("<b>\The [src]</b> beeps, \"[alerts[PULSE_ALERT]]\""))
		if (alerts[BRAIN_ALERT] && alerts[BRAIN_ALERT] != last_alert[BRAIN_ALERT])
			audible_message(span_warning("<b>\The [src]</b> alarms, \"[alerts[BRAIN_ALERT]]\""))
		if (alerts[LUNGS_ALERT] && alerts[LUNGS_ALERT] != last_alert[LUNGS_ALERT])
			audible_message(span_warning("<b>\The [src]</b> warns, \"[alerts[LUNGS_ALERT]]\""))
		last_alert = alerts.Copy()
		COOLDOWN_START(src, alert_cooldown, 5 SECONDS)

/obj/machinery/vitals_monitor/examine(mob/user)
	. = ..()
	if(machine_stat & NOPOWER)
		. += span_notice("It's unpowered.")
		return
	if(!connected_optable?.patient)
		return
	var/mob/living/carbon/victim = connected_optable.patient

	. += span_notice("Vitals of [victim]:")
	. += span_notice("Pulse: [victim.get_pulse(GETPULSE_TOOL)]")
	. += span_notice("Blood pressure: [victim.get_blood_pressure()]")
	. += span_notice("Blood oxygenation: [victim.get_blood_oxygenation()]%")
	. += span_notice("Body temperature: [victim.bodytemperature-T0C]&deg;C ([victim.bodytemperature*1.8-459.67]&deg;F)")

	var/brain_activity = "none"
	var/obj/item/organ/brain/brain = victim.getorganslot(ORGAN_SLOT_BRAIN)
	var/danger = FALSE
	if (istype(brain) && victim.stat != DEAD && !HAS_TRAIT(victim, TRAIT_FAKEDEATH))
		switch (round(brain.damage / brain.damage_threshold_value))
			if (0)
				brain_activity = "normal"
			if (1 to 2)
				brain_activity = "minor brain damage"
			if (3 to 5)
				brain_activity = "weak"
				danger = TRUE
			if (6 to 8)
				brain_activity = "extremely weak"
				danger = TRUE
			if (9 to INFINITY)
				brain_activity = "fading"
				danger = TRUE

	if (!danger)
		. += span_notice("Brain activity: [brain_activity]")
	else
		. += span_warning("Brain activity: [brain_activity]")

	var/breathing = "normal"
	var/obj/item/organ/lungs/lungs = victim.getorganslot(ORGAN_SLOT_LUNGS)
	if (istype(lungs) && !HAS_TRAIT(victim, TRAIT_FAKEDEATH))
		if (victim.failed_last_breath)
			breathing = "none"
		else if(victim.losebreath)
			breathing = "shallow"
	else
		breathing = "none"

	. += span_notice("Breathing: [breathing]")

/obj/machinery/vitals_monitor/verb/toggle_beep()
	set name = "Toggle Monitor Beeping"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if (!istype(user))
		return

	if (can_interact(user))
		beep = !beep
		to_chat(user, span_notice("You turn the sound on \the [src] [beep ? "on" : "off"]."))

/obj/machinery/vitals_monitor/verb/toggle_alerts()
	set name = "Toggle Alert Annunciator"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if (!istype(user))
		return

	if (can_interact(user))
		read_alerts = !read_alerts
		to_chat(user, span_notice("You turn the alert reader on \the [src] [read_alerts ? "on" : "off"]."))

#undef PULSE_ALERT
#undef BRAIN_ALERT
#undef LUNGS_ALERT
