GLOBAL_LIST_INIT(default_material_container_material_whitelist, list(
		/datum/material/iron,
		/datum/material/glass,
		/datum/material/silver,
		/datum/material/gold,
		/datum/material/diamond,
		/datum/material/plasma,
		/datum/material/uranium,
		/datum/material/bananium,
		/datum/material/titanium,
		/datum/material/bluespace,
		/datum/material/plastic,
))

/obj/machinery/mineral/material_bank
	name = "material bank"
	desc = "A machine for storing different kinds of materials in large quantities."
	icon_state = "ore_redemption"
	density = TRUE
	input_dir = NORTH
	output_dir = SOUTH
	req_access = list(ACCESS_MINERAL_STOREROOM)
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/ore_redemption
	needs_item_input = TRUE
	processing_flags = START_PROCESSING_MANUALLY

	/// Variable that holds a timer which is used for callbacks to `send_console_message()`. Used for preventing multiple calls to this proc while the ORM is eating a stack of ores.
	var/console_notify_timer

	var/datum/component/material_container/mat_container

/obj/machinery/mineral/material_bank/Initialize(mapload)
	. = ..()

	var/datum/c4_file/fab_design_bundle/dundle = new(SStech.fetch_designs(subtypesof(/datum/design/alloy)))
	disk_write_file(dundle, internal_disk)

	var/datum/callback/precondition = CALLBACK(src, PROC_REF(can_accept_material))
	mat_container = AddComponent(/datum/component/material_container, GLOB.default_material_container_material_whitelist, INFINITY, NONE, allowed_items=/obj/item/stack, _precondition = precondition)

/obj/machinery/mineral/material_bank/Destroy()
	mat_container = null
	return ..()

/obj/machinery/mineral/material_bank/examine(mob/user)
	. = ..()
	if(panel_open)
		. += span_info("Alt-click to rotate the input and output direction.")

/obj/machinery/mineral/material_bank/proc/can_accept_material(mob/user)
	return !panel_open && powered()

/obj/machinery/mineral/material_bank/proc/smelt_ore(obj/item/stack/ore/O)
	if(QDELETED(O))
		return

	if (!mat_container)
		return

	if(O.refined_type == null)
		return

	var/material_amount = mat_container.get_item_material_amount(O)

	if(!material_amount)
		qdel(O) //no materials, incinerate it

	else if(!mat_container.has_space(material_amount * O.amount)) //if there is no space, eject it
		unload_mineral(O)

	else
		mat_container.insert_item(O) //insert it
		qdel(O)

/obj/machinery/mineral/material_bank/proc/can_smelt_alloy(datum/design/D)
	if(!mat_container || length(D.make_reagents))
		return FALSE

	var/build_amount = 0

	for(var/mat in D.materials)
		var/amount = D.materials[mat]
		var/datum/material/redemption_mat_amount = mat_container.materials[mat]

		if(!amount || !redemption_mat_amount)
			return FALSE

		var/smeltable_sheets = FLOOR(redemption_mat_amount / amount, 1)

		if(!smeltable_sheets)
			return FALSE

		if(!build_amount)
			build_amount = smeltable_sheets

		build_amount = min(build_amount, smeltable_sheets)

	return build_amount

/obj/machinery/mineral/material_bank/proc/process_ores(list/ores_to_process)
	for(var/ore in ores_to_process)
		smelt_ore(ore)

/obj/machinery/mineral/material_bank/proc/send_console_message()
	if(!mat_container || !is_station_level(z))
		return

	console_notify_timer = null

	var/area/A = get_area(src)
	var/msg = "Now available in [A]:<br>"

	var/has_minerals = FALSE

	for(var/mat in mat_container.materials)
		var/datum/material/M = mat
		var/mineral_amount = mat_container.materials[mat] / MINERAL_MATERIAL_AMOUNT
		if(mineral_amount)
			has_minerals = TRUE
		msg += "[capitalize(M.name)]: [mineral_amount] sheets<br>"

	if(!has_minerals)
		return

	var/datum/signal/subspace/messaging/rc/signal = new(src, packetv2(payload = list(
		"ore_update" = TRUE,
		"sender" = "Ore Bank",
		"message" = msg,
		"verified" = "<font color='green'><b>Verified by Ore Bank</b></font>",
		"priority" = REQ_NORMAL_MESSAGE_PRIORITY
	)))
	signal.send_to_receivers()

/obj/machinery/mineral/material_bank/pickup_item(datum/source, atom/movable/target, direction)
	if(QDELETED(target))
		return
	if(panel_open || !powered())
		return

	if(istype(target, /obj/structure/ore_box))
		var/obj/structure/ore_box/box = target
		process_ores(box.contents)
	else if(istype(target, /obj/item/stack/ore))
		var/obj/item/stack/ore/O = target
		smelt_ore(O)
	else
		return

	if(!console_notify_timer)
		// gives 5 seconds for a load of ores to be sucked up by the ORM before it sends out request console notifications. This should be enough time for most deposits that people make
		console_notify_timer = addtimer(CALLBACK(src, PROC_REF(send_console_message)), 5 SECONDS)

/obj/machinery/mineral/material_bank/default_unfasten_wrench(mob/user, obj/item/I)
	. = ..()
	if(. != SUCCESSFUL_UNFASTEN)
		return
	if(anchored)
		register_input_turf() // someone just wrenched us down, re-register the turf
	else
		unregister_input_turf() // someone just un-wrenched us, unregister the turf

/obj/machinery/mineral/material_bank/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/mineral/material_bank/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(default_deconstruction_screwdriver(user, "ore_redemption-open", "ore_redemption", tool))
		return ITEM_INTERACT_SUCCESS
	if(default_deconstruction_crowbar(tool))
		return ITEM_INTERACT_SUCCESS

	if(!powered())
		return NONE

	if(istype(tool, /obj/item/disk/data))
		if(user.transferItemToLoc(tool))
			set_inserted_disk(tool)
			return ITEM_INTERACT_SUCCESS

/obj/machinery/mineral/material_bank/AltClick(mob/living/user)
	. = ..()
	if(!user.canUseTopic(src, USE_CLOSE))
		return
	if(panel_open)
		input_dir = turn(input_dir, -90)
		output_dir = turn(output_dir, -90)
		to_chat(user, span_notice("You change [src]'s I/O settings, setting the input to [dir2text(input_dir)] and the output to [dir2text(output_dir)]."))
		unregister_input_turf() // someone just rotated the input and output directions, unregister the old turf
		register_input_turf() // register the new one
		return TRUE

/obj/machinery/mineral/material_bank/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MaterialBank")
		ui.open()

/obj/machinery/mineral/material_bank/ui_data(mob/user)
	var/list/data = list()

	data["materials"] = list()

	if (mat_container)
		for(var/mat in mat_container.materials)
			var/datum/material/M = mat
			var/amount = mat_container.materials[M]
			var/sheet_amount = amount / MINERAL_MATERIAL_AMOUNT
			var/ref = REF(M)
			data["materials"] += list(
				list(
					"name" = M.name,
					"id" = ref,
					"amount" = sheet_amount,
				)
			)

		data["alloys"] = list()
		for(var/datum/design/D as anything in subtypesof(/datum/design/alloy))
			D = SStech.designs_by_type[D]
			data["alloys"] += list(
				list(
					"name" = D.name,
					"id" = D.id,
					"amount" = can_smelt_alloy(D)
				)
			)

	if (!mat_container)
		data["disconnected"] = "local mineral storage is unavailable"

	data["diskDesigns"] = list()
	data["hasDisk"] = FALSE
	if(inserted_disk)
		data["hasDisk"] = TRUE
		var/index = 1
		for (var/datum/design/thisdesign in disk_get_designs(FABRICATOR_FILE_NAME, inserted_disk))
			data["diskDesigns"] += list(
				list(
					"name" = thisdesign.name,
					"index" = index,
					"canupload" = thisdesign.build_type & SMELTER
				)
			)
			index++
	return data

/obj/machinery/mineral/material_bank/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("Release")
			if(!mat_container)
				return
			else if(!allowed(usr)) //Check the ID inside, otherwise check the user
				to_chat(usr, span_warning("Required access not found."))
			else
				var/datum/material/mat = locate(params["id"])

				var/amount = mat_container.materials[mat]
				if(!amount)
					return

				var/stored_amount = CEILING(amount / MINERAL_MATERIAL_AMOUNT, 0.1)

				if(!stored_amount)
					return

				var/desired = 0
				if (params["sheets"])
					desired = text2num(params["sheets"])
				else
					desired = tgui_input_number(usr, "How many sheets would you like to smelt?", "Smelt",  max_value = stored_amount)
					if(!desired || QDELETED(usr) || QDELETED(src) || !usr.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
						return
				var/sheets_to_remove = round(min(desired,50,stored_amount))

				mat_container.retrieve_sheets(sheets_to_remove, mat, get_step(src, output_dir))
			return TRUE

		if("diskInsert")
			if(!insert_disk(usr, usr.get_active_held_item()))
				to_chat(usr, span_warning("Not a valid Design Disk!"))
			return TRUE

		if("diskEject")
			if(inserted_disk)
				eject_disk(usr)
			return TRUE

		if("diskUpload")
			var/n = text2num(params["design"])
			if(inserted_disk)
				var/datum/design/to_add = disk_get_designs(FABRICATOR_FILE_NAME, inserted_disk)[n]
				var/datum/c4_file/fab_design_bundle/dundle = disk_get_file(FABRICATOR_FILE_NAME, internal_disk)
				if(!istype(dundle))
					to_chat(usr, span_warning("Internal design database missing or corrupt. Operation failed."))
				else
					dundle.included_designs |= to_add
			return TRUE

		if("Smelt")
			var/alloy_id = params["id"]
			var/datum/design/alloy = SStech.designs_by_id[alloy_id]
			if(!(alloy in disk_get_designs(FABRICATOR_FILE_NAME)))
				CRASH("Attempted to smelt an alloy we don't have a design for. HREF exploit?")

			var/obj/item/card/id/I

			if(isliving(usr))
				var/mob/living/L = usr
				I = L.get_idcard(TRUE)

			if((check_access(I) || allowed(usr)) && alloy)
				var/smelt_amount = can_smelt_alloy(alloy)
				var/desired = 0
				if (params["sheets"])
					desired = text2num(params["sheets"])
				else
					desired = tgui_input_number(usr, "How many sheets would you like to smelt?", "Smelt", max_value = smelt_amount)
					if(!desired || QDELETED(usr) || QDELETED(src) || !usr.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
						return
				var/amount = round(min(desired,50,smelt_amount))
				mat_container.use_materials(alloy.materials, amount)
				var/output
				if(ispath(alloy.build_path, /obj/item/stack/sheet))
					output = new alloy.build_path(src, amount)
				else
					output = new alloy.build_path(src)
				unload_mineral(output)
			else
				to_chat(usr, span_warning("Required access not found."))
			return TRUE

/obj/machinery/mineral/material_bank/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	return ..()

/obj/machinery/mineral/material_bank/update_icon_state()
	icon_state = "[initial(icon_state)][powered() ? null : "-off"]"
	return ..()
