#define MODE_QUEUE 1
#define MODE_BUILD 0
#define MAX_QUEUE_LEN 5

DEFINE_INTERACTABLE(/obj/machinery/rnd/production)
/obj/machinery/rnd/production
	name = "technology fabricator"
	desc = "Makes researched and prototype items with materials and energy."
	layer = BELOW_OBJ_LAYER
	/// Materials needed / coeff = actual.
	var/efficiency_coeff = 1
	var/datum/component/remote_materials/materials
	var/allowed_buildtypes = NONE

	/// Used by the search in the UI.
	var/list/datum/design/matching_designs

	/// Used for material distribution among other things.
	var/department_tag = "Unidentified"

	var/screen = FABRICATOR_SCREEN_MAIN
	/// Cache so we don't rebuild this every Topic(), see compile_categories().
	var/list/categories
	var/selected_category

	/// What color is this machine's stripe? Leave null to not have a stripe.
	var/stripe_color = null

	/// The queue of things to produce. It's a list of lists.
	var/list/queue
	/// A queue packet we are processing
	var/list/processing_packet

/obj/machinery/rnd/production/Initialize(mapload)
	. = ..()
	queue = list()
	selected_disk = internal_disk
	create_reagents(0, OPENCONTAINER)
	matching_designs = list()
	materials = AddComponent(/datum/component/remote_materials, "lathe", mapload, mat_container_flags=BREAKDOWN_FLAGS_LATHE)
	RefreshParts()
	update_icon(UPDATE_OVERLAYS)
	if(internal_disk)
		compile_categories()

/obj/machinery/rnd/production/Destroy()
	materials = null
	matching_designs = null
	return ..()

/obj/machinery/rnd/production/RefreshParts()
	. = ..()
	calculate_efficiency()

/obj/machinery/rnd/production/ui_interact(mob/user)
	user.set_machine(src)
	var/datum/browser/popup = new(user, "rndconsole", name, 460, 550)
	popup.set_content(generate_ui())
	popup.open()

/obj/machinery/rnd/production/proc/calculate_efficiency()
	efficiency_coeff = 1
	if(reagents) //If reagents/materials aren't initialized, don't bother, we'll be doing this again after reagents init anyways.
		reagents.maximum_volume = 0
		for(var/obj/item/reagent_containers/glass/G in component_parts)
			reagents.maximum_volume += G.volume
			G.reagents.trans_to(src, G.reagents.total_volume)
	if(materials)
		var/total_storage = 0
		for(var/obj/item/stock_parts/matter_bin/M in component_parts)
			total_storage += M.rating * 75000
		materials.set_local_size(total_storage)
	var/total_rating = 1.2
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		total_rating = clamp(total_rating - (M.rating * 0.1), 0, 1)
	if(total_rating == 0)
		efficiency_coeff = INFINITY
	else
		efficiency_coeff = 1/total_rating

//we eject the materials upon deconstruction.
/obj/machinery/rnd/production/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.trans_to(G, G.reagents.maximum_volume)
	return ..()

/obj/machinery/rnd/production/proc/add_to_queue(datum/design/D, amount, notify_admins)
	if(length(queue) >= MAX_QUEUE_LEN)
		say("The build queue is full.")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return

	queue += list(list(D, amount))

	if(notify_admins)
		investigate_log("[key_name(usr)] queued [amount] of [D.build_path] at [src]([type]).", INVESTIGATE_RESEARCH)
		message_admins("[ADMIN_LOOKUPFLW(usr)] has queued [amount] of [D.build_path] at \a [src]([type]).")

	if(!busy)
		run_queue()

/obj/machinery/rnd/production/proc/run_queue()
	set waitfor = FALSE
	if(busy)
		return
	busy = TRUE

	update_appearance(UPDATE_OVERLAYS)
	while(length(queue))
		var/list/queue_packet = queue[1]
		queue -= list(queue_packet)
		processing_packet = queue_packet
		updateUsrDialog()
		do_print(queue_packet[1], queue_packet[2])

	processing_packet = null
	busy = FALSE
	update_appearance(UPDATE_OVERLAYS)
	updateUsrDialog()

/obj/machinery/rnd/production/proc/do_print(datum/design/D, amount)
	if(!can_build_design(D, amount))
		return FALSE

	var/atom/path = D.build_path

	var/coeff = efficient_with(D.build_path) ? efficiency_coeff : 1
	var/list/efficient_mats = list()
	for(var/MAT in D.materials)
		efficient_mats[MAT] = D.materials[MAT]/coeff

	var/power = active_power_usage
	amount = clamp(amount, 1, 50)

	for(var/M in D.materials)
		power += round(D.materials[M] * amount / 35)

	power = min(active_power_usage, power)
	use_power(power)

	materials.mat_container.use_materials(efficient_mats, amount)
	materials.silo_log(src, "built", -amount, "[D.name]", efficient_mats)

	for(var/R in D.reagents_list)
		reagents.remove_reagent(R, D.reagents_list[R]*amount/coeff)

	var/time = (((D.construction_time || 2 SECONDS) / efficiency_coeff) * amount) ** 0.8
	if(!do_after(src, src, time, DO_IGNORE_USER_LOC_CHANGE))
		return FALSE

	for(var/i in 1 to amount)
		new path(get_turf(src))

	SSblackbox.record_feedback("nested tally", "item_printed", amount, list("[type]", "[path]"))
	playsound(src, 'goon/sounds/chime.ogg', 50, FALSE, ignore_walls = FALSE)

/obj/machinery/rnd/production/proc/can_build_design(datum/design/D, amount)
	var/coeff = efficient_with(D.build_path) ? efficiency_coeff : 1
	var/list/efficient_mats = list()
	for(var/MAT in D.materials)
		efficient_mats[MAT] = D.materials[MAT]/coeff

	if(!materials.mat_container.has_materials(efficient_mats, amount))
		say("Not enough materials to complete object[amount > 1? "s" : ""].")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return FALSE

	for(var/R in D.reagents_list)
		if(!reagents.has_reagent(R, D.reagents_list[R]*amount/coeff))
			say("Not enough reagents to complete object[amount > 1? "s" : ""].")
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			return FALSE

	if(D.build_type && !(D.build_type & allowed_buildtypes))
		say("This machine does not have the necessary manipulation systems for this design. Please contact Ananke Support!")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return FALSE

	if(!materials.mat_container)
		say("No connection to material storage, please contact the quartermaster.")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return FALSE

	if(materials.on_hold())
		say("Mineral access is on hold, please contact the quartermaster.")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return FALSE

	return TRUE

/**
 * Returns how many times over the given material requirement for the given design is satisfied.
 *
 * Arguments:
 * - [being_built][/datum/design]: The design being referenced.
 * - material: The material being checked.
 */
/obj/machinery/rnd/production/proc/check_material_req(datum/design/being_built, material)
	if(!materials.mat_container)  // no connected silo
		return 0

	var/mat_amt = materials.mat_container.get_material_amount(material)
	if(!mat_amt)
		return 0

	// these types don't have their .materials set in do_print, so don't allow
	// them to be constructed efficiently
	var/efficiency = efficient_with(being_built.build_path) ? efficiency_coeff : 1
	return round(mat_amt / max(1, being_built.materials[material] / efficiency))

/**
 * Returns how many times over the given reagent requirement for the given design is satisfied.
 *
 * Arguments:
 * - [being_built][/datum/design]: The design being referenced.
 * - reagent: The reagent being checked.
 */
/obj/machinery/rnd/production/proc/check_reagent_req(datum/design/being_built, reagent)
	if(!reagents)  // no reagent storage
		return 0

	var/chem_amt = reagents.get_reagent_amount(reagent)
	if(!chem_amt)
		return 0

	// these types don't have their .materials set in do_print, so don't allow
	// them to be constructed efficiently
	var/efficiency = efficient_with(being_built.build_path) ? efficiency_coeff : 1
	return round(chem_amt / max(1, being_built.reagents_list[reagent] / efficiency))

/obj/machinery/rnd/production/proc/efficient_with(path)
	return !ispath(path, /obj/item/stack/sheet) && !ispath(path, /obj/item/stack/ore/bluespace_crystal)

/obj/machinery/rnd/production/proc/user_try_print_id(id, amount)
	if(!id)
		return FALSE
	if(istext(amount))
		amount = text2num(amount)
	if(isnull(amount))
		amount = 1
	var/datum/design/D = SStech.designs_by_id[id]
	if(!istype(D))
		return FALSE
	if(!(D in internal_disk.read(DATA_IDX_DESIGNS)))
		CRASH("Tried to print a design we don't have! Potential exploit?")

	playsound(src, 'goon/sounds/button.ogg', 100)
	update_appearance(UPDATE_OVERLAYS)
	add_to_queue(D, amount, D.dangerous_construction)
	return TRUE

/obj/machinery/rnd/production/proc/search(string)
	matching_designs.Cut()
	for(var/datum/design/D as anything in internal_disk.read(DATA_IDX_DESIGNS))
		if(!(D.build_type & allowed_buildtypes))
			continue
		if(findtext(D.name,string))
			matching_designs.Add(D)

/obj/machinery/rnd/production/proc/generate_ui()
	var/list/ui = list()
	ui += ui_header()
	switch(screen)
		if(FABRICATOR_SCREEN_MATERIALS)
			ui += ui_screen_materials()
		if(FABRICATOR_SCREEN_CHEMICALS)
			ui += ui_screen_chemicals()
		if(FABRICATOR_SCREEN_SEARCH)
			ui += ui_screen_search()
		if(FABRICATOR_SCREEN_CATEGORYVIEW)
			ui += ui_screen_category_view()
		if(FABRICATOR_SCREEN_MODIFY_MEMORY)
			ui += ui_screen_modify_memory()
		if(FABRICATOR_SCREEN_QUEUE)
			ui += ui_screen_queue()
		else
			ui += ui_screen_main()
	for(var/i in 1 to length(ui))
		if(!findtextEx(ui[i], RDSCREEN_NOBREAK))
			ui[i] += "<br>"
		ui[i] = replacetextEx(ui[i], RDSCREEN_NOBREAK, "")
	return ui.Join("")

/obj/machinery/rnd/production/proc/ui_header()
	var/list/l = list()
	l += "<fieldset class='computerPaneSimple'><legend class='computerLegend'><b>Ananke [department_tag ? "[department_tag] Fabricator" : "Omni Fabricator"]</b></legend>[RDSCREEN_NOBREAK]"
	if (materials.mat_container)
		l += "<A href='?src=[REF(src)];switch_screen=[FABRICATOR_SCREEN_MATERIALS]'><B>Material Amount:</B> [materials.format_amount()]</A>"
	else
		l += "<font color='red'>No material storage connected, please contact the quartermaster.</font>"
	l += "<A href='?src=[REF(src)];switch_screen=[FABRICATOR_SCREEN_CHEMICALS]'><B>Chemical volume:</B> [reagents.total_volume] / [reagents.maximum_volume]</A>"
	l += "<a href='?src=[REF(src)];switch_screen=[FABRICATOR_SCREEN_MODIFY_MEMORY]'>Manage Data</a>"
	l += "<a href='?src=[REF(src)];switch_screen=[FABRICATOR_SCREEN_MAIN]'>Main Screen</a><br>"
	l += "<a href='?src=[REF(src)];switch_screen=[FABRICATOR_SCREEN_QUEUE]'>View Queue</a></fieldset>[RDSCREEN_NOBREAK]"
	return l

/obj/machinery/rnd/production/proc/ui_screen_materials()
	if (!materials.mat_container)
		screen = FABRICATOR_SCREEN_MAIN
		return ui_screen_main()
	var/list/l = list()
	l += "<fieldset class='computerPaneSimple'><legend class='computerLegend'><b>Material Storage</b></legend>"
	for(var/mat_id in materials.mat_container.materials)
		var/datum/material/M = mat_id
		var/amount = materials.mat_container.materials[mat_id]
		var/ref = REF(M)
		l += "* [amount] of [M.name]: "
		if(amount >= MINERAL_MATERIAL_AMOUNT) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=1'>Eject</A> [RDSCREEN_NOBREAK]"
		if(amount >= MINERAL_MATERIAL_AMOUNT*5) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=5'>5x</A> [RDSCREEN_NOBREAK]"
		if(amount >= MINERAL_MATERIAL_AMOUNT) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=50'>All</A>[RDSCREEN_NOBREAK]"
		l += ""
	l += "</fieldset>[RDSCREEN_NOBREAK]"
	return l

/obj/machinery/rnd/production/proc/ui_screen_chemicals()
	var/list/l = list()
	l += "<legend>Chemical Storage</legend>"
	l +="<A href='?src=[REF(src)];disposeall=1'>Disposal All Chemicals in Storage</A>"
	for(var/datum/reagent/R in reagents.reagent_list)
		l += "[R.name]: [R.volume]"
		l += "<A href='?src=[REF(src)];dispose=[R.type]'>Purge</A>"
	return l

/obj/machinery/rnd/production/proc/ui_screen_search()
	var/list/l = list()
	var/coeff = efficiency_coeff
	l += "<h2>Search Results:</h2>"
	l += "<form name='search' action='?src=[REF(src)]'>\
	<input type='hidden' name='src' value='[REF(src)]'>\
	<input type='hidden' name='search' value='to_search'>\
	<input type='text' name='to_search'>\
	<input type='submit' value='Search'>\
	</form><HR>"
	for(var/datum/design/D in matching_designs)
		l += design_menu_entry(D, coeff)
	l += "</div>"
	return l

/obj/machinery/rnd/production/proc/design_menu_entry(datum/design/D, coeff)
	if(!istype(D))
		return
	if(!efficient_with(D.build_path))
		coeff = 1
	else if(!coeff)
		coeff = efficiency_coeff

	var/list/entry_text = list()
	var/temp_material
	var/max_production = 50
	var/list/cached_mats = D.materials
	for(var/material in cached_mats)
		var/enough_mats = check_material_req(D, material)
		max_production = min(max_production, enough_mats)

		temp_material += " | "
		if (enough_mats < 1)
			temp_material += "<span class='bad'>[cached_mats[material]/coeff] [SSmaterials.GetMaterialName(material)]</span>"
		else
			temp_material += " [cached_mats[material]/coeff] [SSmaterials.GetMaterialName(material)]"

	var/list/cached_reagents = D.reagents_list
	for(var/reagent in cached_reagents)
		var/enough_chems = check_reagent_req(D, reagent)
		max_production = min(max_production, enough_chems)

		temp_material += " | "
		if (enough_chems < 1)
			temp_material += "<span class='bad'>[cached_reagents[reagent]/coeff] [SSmaterials.GetMaterialName(reagent)]</span>"
		else
			temp_material += " [cached_reagents[reagent]/coeff] [SSmaterials.GetMaterialName(reagent)]"

	if (max_production >= 1)
		entry_text += "<A href='?src=[REF(src)];build=[D.id];amount=1'>[D.name]</A>[RDSCREEN_NOBREAK]"
		if(max_production >= 5)
			entry_text += "<A href='?src=[REF(src)];build=[D.id];amount=5'>x5</A>[RDSCREEN_NOBREAK]"
		if(max_production >= 10)
			entry_text += "<A href='?src=[REF(src)];build=[D.id];amount=10'>x10</A>[RDSCREEN_NOBREAK]"
		entry_text += "[temp_material][RDSCREEN_NOBREAK]"
	else
		entry_text += "<span class='linkOff'>[D.name]</span>[temp_material][RDSCREEN_NOBREAK]"
	entry_text += ""
	return entry_text

/obj/machinery/rnd/production/Topic(raw, ls)
	if(..())
		return
	usr.set_machine(src)
	if(ls["switch_screen"])
		screen = text2num(ls["switch_screen"])

	if(ls["build"]) //Causes the Protolathe to build something.
		user_try_print_id(ls["build"], ls["amount"])

	if(ls["dequeue"])
		var/index = text2num(ls["dequeue"])
		if(!isnull(index))
			queue -= list(queue[index])

	if(ls["search"]) //Search for designs with name matching pattern
		search(ls["to_search"])
		screen = FABRICATOR_SCREEN_SEARCH

	if(ls["category"])
		selected_category = ls["category"]

	if(ls["dispose"])  //Causes the protolathe to dispose of a single reagent (all of it)
		var/reagent_path = text2path(ls["dispose"])
		if(!ispath(reagent_path, /datum/reagent))
			stack_trace("Invalid reagent typepath - [ls["dispose"]] - returned in reagent disposal topic call")
		else
			reagents.del_reagent(reagent_path)

	if(ls["disposeall"]) //Causes the protolathe to dispose of all it's reagents.
		reagents.clear_reagents()

	if(ls["ejectsheet"]) //Causes the protolathe to eject a sheet of material
		var/datum/material/M = locate(ls["ejectsheet"])
		eject_sheets(M, ls["eject_amt"])

	if(ls["toggle_disk"])
		toggle_disk(usr)

	if(ls["mem_trg"])
		var/datum/design/target = locate(ls["mem_trg"]) in selected_disk.read(DATA_IDX_DESIGNS)
		if(!target)
			CRASH("Tried to perform a data operation on data we don't have. Potential HREF exploit.")

		switch(ls["mem_act"])
			if("mem_del")
				disk_del(usr, DATA_IDX_DESIGNS, target)
			if("mem_copy")
				disk_copy(usr, DATA_IDX_DESIGNS, target, TRUE)
			if("mem_move")
				disk_move(usr, DATA_IDX_DESIGNS, target, TRUE)

	updateUsrDialog()

/obj/machinery/rnd/production/proc/eject_sheets(eject_sheet, eject_amt)
	var/datum/component/material_container/mat_container = materials.mat_container
	if (!mat_container)
		say("No access to material storage, please contact the quartermaster.")
		return 0
	if (materials.on_hold())
		say("Mineral access is on hold, please contact the quartermaster.")
		return 0
	var/count = mat_container.retrieve_sheets(text2num(eject_amt), eject_sheet, drop_location())
	var/list/matlist = list()
	matlist[eject_sheet] = MINERAL_MATERIAL_AMOUNT
	materials.silo_log(src, "ejected", -count, "sheets", matlist)
	return count

/obj/machinery/rnd/production/proc/ui_screen_main()
	var/list/l = list()
	l += "<fieldset class='computerPaneSimple'><legend class='computerLegend'><b>Designs</b></legend>[RDSCREEN_NOBREAK]"
	l += "<form name='search' action='?src=[REF(src)]'>\
	<input type='hidden' name='src' value='[REF(src)]'>\
	<input type='hidden' name='search' value='to_search'>\
	<input type='hidden' name='type' value='proto'>\
	<input type='text' name='to_search'>\
	<input type='submit' value='Search'>\
	</form><HR>"

	l += list_categories(categories, FABRICATOR_SCREEN_CATEGORYVIEW)
	l += "</fieldset>"

	return l

/obj/machinery/rnd/production/proc/ui_screen_category_view()
	if(!selected_category)
		return ui_screen_main()
	var/list/l = list()
	l += "<div class='computerPaneSimple'><h3>Browsing [selected_category]:</h3>"
	var/coeff = efficiency_coeff
	for(var/datum/design/D as anything in sortTim(internal_disk.read(DATA_IDX_DESIGNS), GLOBAL_PROC_REF(cmp_name_asc)))
		if(!(selected_category in D.category)|| !(D.build_type & allowed_buildtypes))
			continue
		l += design_menu_entry(D, coeff)
	l += "</div>"
	return l

/obj/machinery/rnd/production/proc/list_categories(list/categories, menu_num)
	if(!categories)
		return

	sortTim(categories, GLOBAL_PROC_REF(cmp_text_asc))
	var/line_length = 1
	var/list/l = "<table style='width:100%' align='center'><tr>"

	for(var/C in categories)
		if(line_length > 2)
			l += "</tr><tr>"
			line_length = 1

		l += "<td><A href='?src=[REF(src)];category=[C];switch_screen=[menu_num]'>[C]</A></td>"
		line_length++

	l += "</tr></table></div>"
	return l

/obj/machinery/rnd/production/proc/ui_screen_modify_memory()
	var/list/l = list()
	var/list/designs = sortTim(selected_disk.read(DATA_IDX_DESIGNS), GLOBAL_PROC_REF(cmp_design_name))
	l += "<fieldset class='computerPaneSimple'><legend class='computerLegend'><A href='?src=[REF(src)];toggle_disk=1'>Selected Disk: [selected_disk == internal_disk ? "Internal" : "Foreign"]</A></legend>[RDSCREEN_NOBREAK]"
	if(selected_disk)
		l += "<table>[RDSCREEN_NOBREAK]"
		for(var/datum/design/D as anything in designs)
			l += "<tr><td>[D.name]<td>[RDSCREEN_NOBREAK]"
			l += "<td><A href='?src=[REF(src)];mem_trg=[REF(D)];mem_act=mem_move'>MOVE</A></td>[RDSCREEN_NOBREAK]"
			l += "<td><A href='?src=[REF(src)];mem_trg=[REF(D)];mem_act=mem_copy'>COPY</A></td>[RDSCREEN_NOBREAK]"
			l += "<td><A href='?src=[REF(src)];mem_trg=[REF(D)];mem_act=mem_del'>DELETE</A></td></tr>[RDSCREEN_NOBREAK]"
		l += "</table>[RDSCREEN_NOBREAK]"

	else
		l += "<h2>No Disk Inserted!</h2>[RDSCREEN_NOBREAK]"
	l += "</fieldset>[RDSCREEN_NOBREAK]"
	return l

/obj/machinery/rnd/production/proc/ui_screen_queue()
	var/list/l = list()
	l += "<fieldset class='computerPaneSimple'><legend class='computerLegend'>Queue</legend>[RDSCREEN_NOBREAK]"
	if(processing_packet)
		l += "<table style='width:100%;border:1px solid rgba(255, 183, 0, 0.5)'>[RDSCREEN_NOBREAK]"
		l += "<tr><th style='width:33.33%;text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'>Design</th>[RDSCREEN_NOBREAK]"
		l += "<th style='width:33.33%;text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'>Amount</th>[RDSCREEN_NOBREAK]"
		l += "<th style='width:33.33%;text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'>Options</th></tr>[RDSCREEN_NOBREAK]"
		var/datum/design/D = processing_packet[1]
		l += "<tr><td style='text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'>[D.name]</td>[RDSCREEN_NOBREAK]"
		l += "<td style='text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'>[processing_packet[2]]</td>[RDSCREEN_NOBREAK]"
		l += "<td style='text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'><span class='linkOn'>PROCESSING</span></td></tr>[RDSCREEN_NOBREAK]"

		for(var/i in 1 to length(queue))
			var/list/queue_packet = queue[i]
			D = queue_packet[1]
			l += "<tr><td style='text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'>[D.name]</td>[RDSCREEN_NOBREAK]"
			l += "<td style='text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'>[queue_packet[2]]</td>[RDSCREEN_NOBREAK]"
			l += "<td style='text-align:center;border:1px solid rgba(255, 183, 0, 0.5)'><A href='?src=[REF(src)];dequeue=[i]'>CANCEL</A></td></tr>[RDSCREEN_NOBREAK]"
		l +="</table>[RDSCREEN_NOBREAK]"
	else
		l += "<h2>Nothing queued!</h2>[RDSCREEN_NOBREAK]"
	l += "</fieldset>[RDSCREEN_NOBREAK]"
	return l

// Stuff for the stripe on the department machines
/obj/machinery/rnd/production/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/screwdriver)
	. = ..()
	update_icon(UPDATE_OVERLAYS)

/obj/machinery/rnd/production/update_overlays()
	. = ..()
	if(!stripe_color)
		return
	var/mutable_appearance/stripe = mutable_appearance('icons/obj/machines/research.dmi', "protolate_stripe")
	if(!panel_open)
		stripe.icon_state = "protolathe_stripe"
	else
		stripe.icon_state = "protolathe_stripe_t"
	stripe.color = stripe_color
	. += stripe

/obj/machinery/rnd/production/proc/compile_categories()
	categories = list()
	for(var/datum/design/D as anything in internal_disk.read(DATA_IDX_DESIGNS))
		if(!isnull(D.category))
			categories |= D.category

/obj/machinery/rnd/production/disk_move(mob/user, index, data, unique)
	. = ..()
	if(!.)
		return
	compile_categories()
	updateUsrDialog()


/obj/machinery/rnd/production/disk_del(mob/user, index, data)
	. = ..()
	if(!.)
		return
	compile_categories()
	updateUsrDialog()


/obj/machinery/rnd/production/disk_copy(mob/user, index, data, unique)
	. = ..()
	if(!.)
		return
	compile_categories()

#undef MODE_BUILD
#undef MODE_QUEUE
#undef MAX_QUEUE_LEN
