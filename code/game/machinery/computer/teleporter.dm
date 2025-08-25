/obj/machinery/computer/teleporter
	name = "teleporter control console"
	desc = "Used to control a linked teleportation Hub and Station."
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	light_color = LIGHT_COLOR_BLUE
	circuit = /obj/item/circuitboard/computer/teleporter

	var/regime_set = "Teleporter"
	var/id
	var/obj/machinery/teleport/station/power_station
	var/calibrating
	///Weakref to the target atom we're pointed at currently
	var/datum/weakref/target_ref

/obj/machinery/computer/teleporter/Initialize(mapload)
	. = ..()
	SET_TRACKING(__TYPE__)
	id = "[rand(1000, 9999)]"
	link_power_station()

/obj/machinery/computer/teleporter/Destroy()
	UNSET_TRACKING(__TYPE__)
	if (power_station)
		power_station.teleporter_console = null
		power_station = null
	return ..()

/obj/machinery/computer/teleporter/proc/link_power_station()
	if(power_station)
		return
	for(var/direction in GLOB.cardinals)
		power_station = locate(/obj/machinery/teleport/station, get_step(src, direction))
		if(power_station)
			power_station.link_console_and_hub()
			break
	return power_station

/obj/machinery/computer/teleporter/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Teleporter", name)
		ui.open()

/obj/machinery/computer/teleporter/ui_data(mob/user)
	var/atom/target
	if(target_ref)
		target = target_ref.resolve()
	if(!target)
		target_ref = null
	var/list/data = list()
	data["power_station"] = power_station ? TRUE : FALSE
	data["teleporter_hub"] = power_station?.teleporter_hub ? TRUE : FALSE
	data["regime_set"] = regime_set
	data["target"] = !target ? "None" : "[get_area(target)] [(regime_set != "Gate") ? "" : "Teleporter"]"
	data["calibrating"] = calibrating

	if(power_station?.teleporter_hub?.calibrated || power_station?.teleporter_hub?.accuracy >= 3)
		data["calibrated"] = TRUE
	else
		data["calibrated"] = FALSE

	return data

/obj/machinery/computer/teleporter/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(!check_hub_connection())
		say("Error: Unable to detect hub.")
		return
	if(calibrating)
		say("Error: Calibration in progress. Stand by.")
		return

	switch(action)
		if("regimeset")
			power_station.engaged = FALSE
			power_station.teleporter_hub.update_appearance()
			power_station.teleporter_hub.calibrated = FALSE
			reset_regime()
			. = TRUE
		if("settarget")
			power_station.engaged = FALSE
			power_station.teleporter_hub.update_appearance()
			power_station.teleporter_hub.calibrated = FALSE
			set_target(usr)
			. = TRUE
		if("calibrate")
			if(!target_ref)
				say("Error: No target set to calibrate to.")
				return
			if(power_station.teleporter_hub.calibrated || power_station.teleporter_hub.accuracy >= 3)
				say("Hub is already calibrated!")
				return

			say("Processing hub calibration to target...")
			calibrating = TRUE
			power_station.update_appearance()
			addtimer(CALLBACK(src, PROC_REF(finish_calibration)), 50 * (3 - power_station.teleporter_hub.accuracy)) //Better parts mean faster calibration
			return TRUE

/obj/machinery/computer/teleporter/proc/set_teleport_target(new_target)
	var/datum/weakref/new_target_ref = WEAKREF(new_target)
	if (target_ref == new_target_ref)
		return
	SEND_SIGNAL(src, COMSIG_TELEPORTER_NEW_TARGET, new_target)
	target_ref = new_target_ref

/obj/machinery/computer/teleporter/proc/finish_calibration()
	calibrating = FALSE
	if(check_hub_connection())
		power_station.teleporter_hub.calibrated = TRUE
		say("Calibration complete.")
	else
		say("Error: Unable to detect hub.")
	power_station.update_appearance()

/obj/machinery/computer/teleporter/proc/check_hub_connection()
	if(!power_station)
		return FALSE
	if(!power_station.teleporter_hub)
		return FALSE
	return TRUE

/obj/machinery/computer/teleporter/proc/reset_regime()
	set_teleport_target(null)
	if(regime_set == "Teleporter")
		regime_set = "Gate"
	else
		regime_set = "Teleporter"

/// Gets a list of targets to teleport to.
/// List is an assoc list of descriptors to locations.
/obj/machinery/computer/teleporter/proc/get_targets()
	var/list/targets = list()
	var/list/area_index = list()

	if (regime_set == "Teleporter")
		for (var/obj/item/beacon/beacon as anything in INSTANCES_OF(/obj/item/beacon))
			if (!is_eligible(beacon))
				continue

			if(beacon.renamed)
				targets[avoid_assoc_duplicate_keys("[beacon.name] ([get_area(beacon)])", area_index)] = beacon
			else
				var/area/area = get_area(beacon)
				targets[avoid_assoc_duplicate_keys(area.name, area_index)] = beacon

		for (var/obj/item/implant/tracking/tracking_implant in GLOB.tracked_implants)
			if (!tracking_implant.imp_in || !isliving(tracking_implant.loc) || !tracking_implant.allow_teleport)
				continue

			var/mob/living/implanted = tracking_implant.loc
			if (implanted.stat == DEAD && implanted.timeofdeath + tracking_implant.lifespan_postmortem < world.time)
				continue

			if (is_eligible(tracking_implant))
				targets[avoid_assoc_duplicate_keys("[implanted.real_name] ([get_area(implanted)])", area_index)] = tracking_implant
	else
		for (var/obj/machinery/teleport/station/station as anything in power_station.linked_stations)
			if (is_eligible(station) && station.teleporter_hub)
				var/area/area = get_area(station)
				targets[avoid_assoc_duplicate_keys(area.name, area_index)] = station

	return targets

/// Given a target station, will power and link it.
/obj/machinery/computer/teleporter/proc/lock_in_station(obj/machinery/teleport/station/target_station)
	target_station.linked_stations |= power_station
	target_station.set_machine_stat(target_station.machine_stat & ~NOPOWER)
	if(target_station.teleporter_hub)
		target_station.teleporter_hub.set_machine_stat(target_station.teleporter_hub.machine_stat & ~NOPOWER)
		target_station.teleporter_hub.update_appearance()
	if(target_station.teleporter_console)
		target_station.teleporter_console.set_machine_stat(target_station.teleporter_console.machine_stat & ~NOPOWER)
		target_station.teleporter_console.update_appearance()

/obj/machinery/computer/teleporter/proc/set_target(mob/user)
	var/list/targets = get_targets()

	if (regime_set == "Teleporter")
		var/desc = tgui_input_list(usr, "Select a location to lock in", "Locking Computer", sort_list(targets))
		if(isnull(desc))
			return
		set_teleport_target(targets[desc])
		var/turf/target_turf = get_turf(targets[desc])
		log_game("[key_name(user)] has set the teleporter target to [targets[desc]] at [AREACOORD(target_turf)]")
	else
		if (!length(targets))
			to_chat(user, span_alert("No active connected stations located."))
			return

		var/desc = tgui_input_list(usr, "Select a station to lock in", "Locking Computer", sort_list(targets))
		if(isnull(desc))
			return
		var/obj/machinery/teleport/station/target_station = targets[desc]
		if(!target_station || !target_station.teleporter_hub)
			return
		var/turf/target_station_turf = get_turf(target_station)
		log_game("[key_name(user)] has set the teleporter target to [target_station] at [AREACOORD(target_station_turf)]")
		set_teleport_target(target_station.teleporter_hub)
		lock_in_station(target_station)

/obj/machinery/computer/teleporter/proc/is_eligible(atom/movable/AM)
	var/turf/T = get_turf(AM)
	if(!T)
		return FALSE
	if(is_centcom_level(T.z) || is_away_level(T.z))
		return FALSE
	var/area/A = get_area(T)
	if(!A ||(A.area_flags & NOTELEPORT))
		return FALSE
	return TRUE
