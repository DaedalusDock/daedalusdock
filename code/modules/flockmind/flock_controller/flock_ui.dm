/datum/flock/ui_state(mob/user)
	return GLOB.flock_state

/datum/flock/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FlockPanel")
		ui.open()

/datum/flock/ui_data(mob/user)
	var/list/data = list()
	var/list/drone_info = list()
	var/list/vitals_info = list("name" = name)
	data["drones"] = drone_info
	data["vitals"] = vitals_info
	data["category"] = ui_tab
	data["category_lengths"] = list(
		"traces" = length(traces),
		"drones" = length(drones),
		"enemies" = length(enemies)
	)

	switch(ui_tab)
		if(FLOCK_UI_DRONES)
			for(var/mob/living/simple_animal/flock/drone/bird as anything in drones)
				drone_info[++drone_info.len] = bird.get_flock_data()

	return data

/datum/flock/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if ("change_tab")
			if (ui_tab != params["tab"])
				ui_tab = params["tab"]
				return TRUE
