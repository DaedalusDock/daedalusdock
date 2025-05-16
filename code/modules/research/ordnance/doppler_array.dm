/obj/machinery/doppler_array
	name = "tachyon-doppler array"
	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array.\n"
	circuit = /obj/item/circuitboard/machine/doppler_array
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "tdoppler"
	base_icon_state = "tdoppler"
	density = TRUE
	verb_say = "states coldly"
	var/cooldown = 10
	var/next_announce = 0
	var/max_dist = 150
	/// Number which will be part of the name of the next record, increased by one for each already created record
	var/record_number = 1
	/// List of all explosion records in the form of /datum/data/tachyon_record
	var/list/records = list()
	/// Reference to a drive we are going to print to.
	var/obj/item/computer_hardware/hard_drive/portable/inserted_drive

	// Lighting system to better communicate the directions.
	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_outer_range = 4
	light_power = 1
	light_color = COLOR_RED

/obj/machinery/doppler_array/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_EXPLOSION, PROC_REF(sense_explosion))
	RegisterSignal(src, COMSIG_MACHINERY_POWER_LOST, PROC_REF(update_doppler_light))
	RegisterSignal(src, COMSIG_MACHINERY_POWER_RESTORED, PROC_REF(update_doppler_light))
	update_doppler_light()

	// Rotation determines the detectable direction.
	AddComponent(/datum/component/simple_rotation)

/datum/data/tachyon_record
	name = "Log Recording"
	var/timestamp
	var/coordinates = ""
	var/displacement = 0
	var/factual_radius = list()
	var/theory_radius = list()
	/// Indexed to length 3 if filled properly. Should be an empty list otherwise.
	var/reaction_results = list()
	var/explosion_identifier

/obj/machinery/doppler_array/examine(mob/user)
	. = ..()
	. += span_notice("It is currently facing [dir2text(dir)]")

/obj/machinery/doppler_array/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/computer_hardware/hard_drive/portable))
		var/obj/item/computer_hardware/hard_drive/portable/disk = item
		eject_drive(user)
		if(user.transferItemToLoc(disk, src))
			inserted_drive = disk
			return
		else
			balloon_alert(user, span_warning("[disk] is stuck to your hand."))
			return ..()
	return ..()

/obj/machinery/doppler_array/wrench_act(mob/living/user, obj/item/tool)
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/doppler_array/screwdriver_act(mob/living/user, obj/item/tool)
	if(!default_deconstruction_screwdriver(user, "[base_icon_state]", "[base_icon_state]", tool))
		return FALSE
	power_change()
	update_appearance()
	return TRUE

/obj/machinery/doppler_array/crowbar_act(mob/living/user, obj/item/tool)
	if(!default_deconstruction_crowbar(tool))
		return FALSE
	return TRUE

/// Printing of a record into a disk.
/obj/machinery/doppler_array/proc/print(mob/user, datum/data/tachyon_record/record)
	if(!record || !inserted_drive)
		return

	var/datum/computer_file/data/ordnance/explosive/record_data = new
	record_data.filename = "Doppler Array " + record.name //Doppler Array Log Recording #x
	record_data.explosion_record = record

	if(inserted_drive.store_file(record_data))
		playsound(src, 'sound/machines/ping.ogg', 25)
	else
		playsound(src, 'sound/machines/terminal_error.ogg', 25)

/// Sensing, recording, and broadcasting of explosion
/obj/machinery/doppler_array/proc/sense_explosion(datum/source, turf/epicenter, devastation_range, heavy_impact_range, light_impact_range,
			took, orig_dev_range, orig_heavy_range, orig_light_range, explosion_cause, explosion_index)
	SIGNAL_HANDLER
	var/list/fetched_reaction_results = list()

	if(istype(explosion_cause, /obj/item/tank))
		var/obj/item/tank/exploding_tank = explosion_cause
		fetched_reaction_results = exploding_tank.explosion_information()

	if(machine_stat & NOPOWER)
		return FALSE
	var/turf/zone = get_turf(src)
	if(zone.z != epicenter.z)
		return FALSE

	if(next_announce > world.time)
		return FALSE
	next_announce = world.time + cooldown

	if((get_dist(epicenter, zone) > max_dist) || !(get_dir(zone, epicenter) & dir))
		return FALSE

	var/datum/data/tachyon_record/new_record = new /datum/data/tachyon_record()
	new_record.name = "Log Recording #[record_number]"
	new_record.timestamp = stationtime2text()
	new_record.coordinates = "[epicenter.x], [epicenter.y]"
	new_record.displacement = took
	new_record.factual_radius["epicenter_radius"] = devastation_range
	new_record.factual_radius["outer_radius"] = heavy_impact_range
	new_record.factual_radius["shockwave_radius"] = light_impact_range
	new_record.reaction_results = fetched_reaction_results
	new_record.explosion_identifier = explosion_index

	var/list/messages = list("Explosive disturbance detected.",
		"Epicenter at: grid ([epicenter.x], [epicenter.y]). Temporal displacement of tachyons: [took] seconds.",
		"Factual: Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range].",
	)

	// If the bomb was capped, say its theoretical size.
	if(devastation_range < orig_dev_range || heavy_impact_range < orig_heavy_range || light_impact_range < orig_light_range)
		messages += "Theoretical: Epicenter radius: [orig_dev_range]. Outer radius: [orig_heavy_range]. Shockwave radius: [orig_light_range]."
		new_record.theory_radius["epicenter_radius"] = orig_dev_range
		new_record.theory_radius["outer_radius"] = orig_heavy_range
		new_record.theory_radius["shockwave_radius"] = orig_light_range

	for(var/message in messages)
		say(message)

	record_number++
	records += new_record

	return TRUE

/obj/machinery/doppler_array/proc/eject_drive(mob/user)
	if(!inserted_drive)
		return FALSE
	if(user)
		user.put_in_hands(inserted_drive)
	else
		inserted_drive.forceMove(drop_location())
	playsound(src, 'sound/machines/card_slide.ogg', 50)
	return TRUE

/// We rely on exited to clear references.
/obj/machinery/doppler_array/Exited(atom/movable/gone, direction)
	if(gone == inserted_drive)
		inserted_drive = null
	. = ..()

/obj/machinery/doppler_array/powered()
	if(panel_open)
		return FALSE
	return ..()

/obj/machinery/doppler_array/update_overlays()
	. = ..()
	if(panel_open)
		. += mutable_appearance(icon, "[base_icon_state]_open")
	else
		. += mutable_appearance(icon,"[base_icon_state]_cable")

	if(machine_stat & BROKEN) // Probably meant to be used on an indestructible doppler, but this is not implemented.
		. += mutable_appearance(icon, "[base_icon_state]_screen-broken")
	else if (machine_stat & NOPOWER)
		. += mutable_appearance(icon, "[base_icon_state]_screen-off")

/obj/machinery/doppler_array/on_deconstruction()
	eject_drive()
	. = ..()

/obj/machinery/doppler_array/Destroy()
	inserted_drive = null
	QDEL_NULL(records) //We only want the list nuked, not the contents.
	. = ..()

/obj/machinery/doppler_array/proc/update_doppler_light()
	SIGNAL_HANDLER
	set_light_on(!(machine_stat & NOPOWER))

/obj/machinery/doppler_array/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/machinery/doppler_array/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DopplerArray", name)
		ui.open()

/obj/machinery/doppler_array/ui_data(mob/user)
	var/list/data = list()
	data["records"] = list()
	data["disk"] = inserted_drive?.name
	data["storage"] = "[inserted_drive?.used_capacity] / [inserted_drive?.max_capacity] GQ"
	for(var/datum/data/tachyon_record/singular_record in records)
		var/list/record_data = list(
			"name" = singular_record.name,
			"timestamp" = singular_record.timestamp,
			"coordinates" = singular_record.coordinates,
			"displacement" = singular_record.displacement,
			"factual_epicenter_radius" = singular_record.factual_radius["epicenter_radius"],
			"factual_outer_radius" = singular_record.factual_radius["outer_radius"],
			"factual_shockwave_radius" = singular_record.factual_radius["shockwave_radius"],
			"theory_epicenter_radius" = singular_record.theory_radius["epicenter_radius"],
			"theory_outer_radius" = singular_record.theory_radius["outer_radius"],
			"theory_shockwave_radius" = singular_record.theory_radius["shockwave_radius"],
			"reaction_results" = list(),
			"ref" = REF(singular_record)
		)

		var/list/reaction_data = singular_record.reaction_results
		// Make sure the list is indexed first.
		if(reaction_data.len)
			for (var/path in reaction_data[TANK_RESULTS_REACTION])
				//var/datum/gas_reaction/reaction_path = path
				record_data["reaction_results"] += "UNIMPLIMENTED - GAS REACTIONS"
			if(TANK_MERGE_OVERPRESSURE in reaction_data[TANK_RESULTS_MISC])
				record_data["reaction_results"] += "Tank overpressurized before reaction"

		data["records"] += list(record_data)
	return data

/obj/machinery/doppler_array/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("delete_record")
			var/datum/data/tachyon_record/record = locate(params["ref"]) in records
			if(!records || !(record in records))
				return
			records -= record
			return TRUE
		if("print_record")
			var/datum/data/tachyon_record/record  = locate(params["ref"]) in records
			if(!records || !(record in records))
				return
			print(usr, record)
			return TRUE
		if("eject_disk")
			eject_drive(usr)
