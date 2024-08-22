/obj/item/mod/control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MODsuit", name)
		ui.open()

/obj/item/mod/control/ui_data(mob/user)
	var/data = list()
	data["interface_break"] = interface_break
	data["malfunctioning"] = malfunctioning
	data["open"] = open
	data["active"] = active
	data["locked"] = locked
	data["complexity"] = complexity
	data["selected_module"] = selected_module?.name
	data["link_id"] = mod_link.id
	data["link_call"] = mod_link.get_other()?.id
	data["wearer_name"] = wearer ? (wearer.get_authentification_name("Unknown") || "Unknown") : "No Occupant"
	data["wearer_job"] = wearer ? wearer.get_assignment("Unknown", "Unknown", FALSE) : "No Job"
	data["AI"] = ai?.name
	data["core"] = core?.name
	data["charge"] = get_charge_percent()
	data["modules"] = list()
	for(var/obj/item/mod/module/module as anything in modules)
		var/list/module_data = list(
			name = module.name,
			description = module.desc,
			module_type = module.module_type,
			active = module.active,
			pinned = module.pinned_to[user],
			idle_power = module.idle_power_cost,
			active_power = module.active_power_cost,
			use_power = module.use_power_cost,
			complexity = module.complexity,
			cooldown_time = module.cooldown_time,
			cooldown = round(COOLDOWN_TIMELEFT(module, cooldown_timer), 1 SECONDS),
			id = module.tgui_id,
			ref = REF(module),
			configuration_data = module.get_configuration()
		)
		module_data += module.add_ui_data()
		data["modules"] += list(module_data)
	return data

/obj/item/mod/control/ui_static_data(mob/user)
	var/data = list()
	data["ui_theme"] = ui_theme
	data["control"] = name
	data["complexity_max"] = complexity_max
	var/part_info = list()
	for(var/obj/item/part as anything in get_parts())
		part_info += list(list(
			"slot" = english_list(parse_slot_flags(part.slot_flags)),
			"name" = part.name,
		))
	data["parts"] = part_info
	return data

/obj/item/mod/control/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(locked && !allowed(usr))
		balloon_alert(usr, "insufficient access!")
		playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		return
	if(malfunctioning && prob(75))
		balloon_alert(usr, "button malfunctions!")
		return
	switch(action)
		if("lock")
			locked = !locked
			balloon_alert(usr, "[locked ? "locked" : "unlocked"]!")
		if("call")
			if(!mod_link.link_call)
				call_link(usr, mod_link)
			else
				mod_link.end_call()
		if("activate")
			toggle_activate(usr)
		if("select")
			var/obj/item/mod/module/module = locate(params["ref"]) in modules
			if(!module)
				return
			module.on_select()
		if("configure")
			var/obj/item/mod/module/module = locate(params["ref"]) in modules
			if(!module)
				return
			module.configure_edit(params["key"], params["value"])
		if("pin")
			var/obj/item/mod/module/module = locate(params["ref"]) in modules
			if(!module)
				return
			module.pin(usr)
	return TRUE
