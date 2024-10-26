#define MANCROWAVE_HOMEOSTATIS "Homeostasis"
#define MANCROWAVE_RARE "Rare"
#define MANCROWAVE_WELL_DONE "Well Done"

/obj/machinery/sleeper/mancrowave
	name = "thermal homeostasis regulator"
	desc = "A large device with heating coils lining the inner walls."
	base_icon_state = "mancrowave"
	icon_state = "mancrowave_open"
	circuit = /obj/item/circuitboard/machine/sleeper/mancrowave

	light_color = LIGHT_COLOR_ORANGE

	possible_chems = null
	has_panel = FALSE
	rotatable = FALSE
	/// Automatically start cooking when an occupant enters
	var/automatic = FALSE
	/// Automatically eject the occupant on completion.
	var/auto_eject = TRUE

	// Stateful vars
	var/is_cookin = FALSE
	var/current_setting = MANCROWAVE_HOMEOSTATIS

	/// The start time of the cook
	var/cook_start_time = 0
	COOLDOWN_DECLARE(cook_timer)

	var/list/cook_options = list(
		MANCROWAVE_HOMEOSTATIS = 5 SECONDS,
	)

/obj/machinery/sleeper/mancrowave/update_icon_state()
	. = ..()
	if(state_open)
		icon_state = "[base_icon_state]_open"
		return

	// Closed and on
	if(obj_flags & EMAGGED)
		icon_state = "[base_icon_state]_emagged"
		set_light_color(LIGHT_COLOR_INTENSE_RED)
	else
		icon_state = "[base_icon_state]_running"
		set_light_color(LIGHT_COLOR_ORANGE)

/obj/machinery/sleeper/mancrowave/on_set_is_operational(old_value)
	. = ..()
	if(!is_operational)
		end_cookin()

/obj/machinery/sleeper/mancrowave/refresh_light()
	if(is_operational && occupant)
		set_light(l_on = TRUE)
	else
		set_light(l_on = FALSE)

/obj/machinery/sleeper/mancrowave/close_machine(mob/user)
	. = ..()
	refresh_light()

/obj/machinery/sleeper/mancrowave/open_machine()
	. = ..()
	refresh_light()

/obj/machinery/sleeper/mancrowave/set_occupant(atom/movable/new_occupant)
	if(isnull(new_occupant))
		end_cookin()
	return ..()

/obj/machinery/sleeper/mancrowave/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return

	obj_flags |= EMAGGED
	name = "THE MANCROWAVE"
	cook_options += list(
		MANCROWAVE_RARE = 50 SECONDS,
		MANCROWAVE_WELL_DONE = 70 SECONDS,
	)

	refresh_light()
	update_appearance(UPDATE_ICON_STATE)
	SStgui.update_uis(src)

	if(user)
		to_chat(user, span_warning("The electromagnet shorts the safeties of [src]."))

/obj/machinery/sleeper/mancrowave/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Mancrowave", name)
		ui.open()

/obj/machinery/sleeper/mancrowave/ui_data()
	var/list/data = list()
	data["occupied"] = !!occupant
	data["open"] = state_open
	data["on"] = is_cookin
	data["cook_start"] = cook_start_time
	data["now"] = world.time
	data["cook_end"] = cook_timer
	data["cook_options"] = cook_options
	data["current_setting"] = current_setting

	var/list/occupant_data = list()
	data["occupant"] = occupant_data

	var/mob/living/carbon/human/human_occupant = occupant
	if(!human_occupant)
		return data

	occupant_data["name"] = human_occupant.name
	occupant_data["core_temperature"] = "[round(human_occupant.coretemperature - T0C, 0.1)] C"

	switch(human_occupant.stat)
		if(CONSCIOUS)
			if(!HAS_TRAIT(human_occupant, TRAIT_SOFT_CRITICAL_CONDITION))
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "good"
			else
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "average"
		if(UNCONSCIOUS)
			data["occupant"]["stat"] = "Unconscious"
			data["occupant"]["statstate"] = "average"
		if(DEAD)
			data["occupant"]["stat"] = "Dead"
			data["occupant"]["statstate"] = "bad"

	return data

/obj/machinery/sleeper/mancrowave/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("mancrowave-door")
			if(state_open)
				close_machine()
			else if(!is_cookin)
				open_machine()
			return TRUE

		if("mancrowave-emergency-stop")
			if(!state_open)
				end_cookin()
				open_machine()
			return TRUE

		if("mancrowave-cook")
			start_cookin(current_setting)
			return TRUE

		if("mancrowave-cook-setting")
			var/setting = params["setting"]
			if(is_cookin)
				return
			if(!(setting in cook_options))
				return

			current_setting = setting
			return TRUE

/obj/machinery/sleeper/mancrowave/process()
	if(!is_cookin)
		CRASH("Mancrowave was processing but not cookin'")

	var/mob/living/carbon/human/human_occupant = occupant
	var/desired_temp
	switch(current_setting)
		if(MANCROWAVE_HOMEOSTATIS)
			desired_temp = human_occupant.get_body_temp_normal()

		if(MANCROWAVE_RARE)
			human_occupant.add_body_temperature_change("MANCROWAVE", 100)
			desired_temp = human_occupant.get_body_temp_normal()

		if(MANCROWAVE_WELL_DONE)
			human_occupant.add_body_temperature_change("MANCROWAVE", 250)
			desired_temp = human_occupant.get_body_temp_normal()

	if(COOLDOWN_FINISHED(src, cook_timer))
		end_cookin(TRUE)
		human_occupant.set_coretemperature(desired_temp)
		human_occupant.bodytemperature = desired_temp
		return

	var/emag_bonus = (obj_flags & EMAGGED) ? 10 : 1
	var/time_fraction = cook_options[current_setting] / 250 * emag_bonus
	var/temp_delta = abs(desired_temp - human_occupant.coretemperature)

	if(human_occupant.coretemperature < desired_temp)
		human_occupant.adjust_coretemperature(temp_delta * time_fraction, max_temp = desired_temp)
	else
		human_occupant.adjust_coretemperature(-(temp_delta) * time_fraction, min_temp = desired_temp)

/// Attempt to start cookin', returns TRUE on success
/obj/machinery/sleeper/mancrowave/proc/start_cookin(setting)
	if(is_cookin || isnull(occupant) || !is_operational)
		return FALSE

	current_setting = setting
	is_cookin = TRUE
	cook_start_time = world.time
	COOLDOWN_START(src, cook_timer, cook_options[setting])
	update_use_power(ACTIVE_POWER_USE)
	begin_processing()
	return TRUE

/obj/machinery/sleeper/mancrowave/proc/end_cookin(times_up)
	is_cookin = FALSE
	update_use_power(IDLE_POWER_USE)
	end_processing()

	var/mob/living/carbon/human/human_occupant = occupant
	if(ishuman(human_occupant))
		human_occupant.remove_body_temperature_change("MANCROWAVE")

	if(!times_up)
		return

	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 50)

	if(auto_eject)
		open_machine()

#undef MANCROWAVE_HOMEOSTATIS
#undef MANCROWAVE_RARE
#undef MANCROWAVE_WELL_DONE
