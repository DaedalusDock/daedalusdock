#define CAN_DEFAULT_RELEASE_PRESSURE (ONE_ATMOSPHERE)

///List of all the gases, used in labelling the canisters
GLOBAL_LIST_INIT(gas_id_to_canister, init_gas_id_to_canister())

/proc/init_gas_id_to_canister()
	return sort_list(list(
		GAS_NITROGEN = /obj/machinery/portable_atmospherics/canister/nitrogen,
		GAS_OXYGEN = /obj/machinery/portable_atmospherics/canister/oxygen,
		GAS_CO2 = /obj/machinery/portable_atmospherics/canister/carbon_dioxide,
		GAS_PLASMA = /obj/machinery/portable_atmospherics/canister/plasma,
		GAS_N2O = /obj/machinery/portable_atmospherics/canister/nitrous_oxide,
		GAS_XENON = /obj/machinery/portable_atmospherics/canister/xenon,
		GAS_KRYPTON = /obj/machinery/portable_atmospherics/canister/krypton,
		GAS_ARGON = /obj/machinery/portable_atmospherics/canister/argon,
		GAS_CHLORINE = /obj/machinery/portable_atmospherics/canister/chlorine,
		GAS_NEON = /obj/machinery/portable_atmospherics/canister/neon,
		"air" = /obj/machinery/portable_atmospherics/canister/air,
		GAS_HYDROGEN = /obj/machinery/portable_atmospherics/canister/hydrogen,
		GAS_DEUTERIUM = /obj/machinery/portable_atmospherics/canister/deuterium,
		GAS_TRITIUM = /obj/machinery/portable_atmospherics/canister/tritium,
		"caution" = /obj/machinery/portable_atmospherics/canister,
		GAS_STEAM = /obj/machinery/portable_atmospherics/canister/water_vapor,
	))


/obj/machinery/portable_atmospherics/canister
	name = "canister"
	desc = "A canister for the storage of gas."
	icon = 'icons/obj/atmospherics/canisters.dmi'
	icon_state = "#mapme"
	greyscale_config = /datum/greyscale_config/canister/hazard
	greyscale_colors = "#ffff00#000000"
	density = TRUE
	volume = 2000
	armor = list(BLUNT = 50, PUNCTURE = 50, SLASH = 0, LASER = 50, ENERGY = 100, BOMB = 10, BIO = 100, FIRE = 80, ACID = 50)
	max_integrity = 300
	integrity_failure = 0.4
	//pressure_resistance = 7 * ONE_ATMOSPHERE
	req_access = list()
	zmm_flags = ZMM_MANGLE_PLANES

	var/icon/canister_overlay_file = 'icons/obj/atmospherics/canisters.dmi'

	///Is the valve open?
	var/valve_open = FALSE
	///Used to log opening and closing of the valve, available on VV
	var/release_log = ""
	///How much the canister should be filled (recommended from 0 to 1)
	var/filled = 0.5
	///Maximum pressure allowed on initialize inside the canister, multiplied by the filled var
	var/maximum_pressure = 90 * ONE_ATMOSPHERE
	///Stores the id of the gas for mapped canisters
	var/gas_type
	///Player controlled var that set the release pressure of the canister
	var/release_pressure = ONE_ATMOSPHERE
	///Maximum pressure allowed for release_pressure var
	var/can_max_release_pressure = (ONE_ATMOSPHERE * 10)
	///Minimum pressure allower for release_pressure var
	var/can_min_release_pressure = (ONE_ATMOSPHERE * 0.1)
	///Max amount of heat allowed inside of the canister before it starts to melt (different tiers have different limits)
	var/heat_limit = 10000
	///Max amount of pressure allowed inside of the canister before it starts to break (different tiers have different limits)
	var/pressure_limit = 500000
	///Maximum amount of heat that the canister can handle before taking damage
	var/temperature_resistance = 1000 + T0C
	///Initial temperature gas mixture
	var/starter_temp
	// Prototype vars
	///Is the canister a prototype one?
	var/prototype = FALSE
	///Timer variables
	var/valve_timer = null
	var/timer_set = 30
	var/default_timer_set = 30
	var/minimum_timer_set = 1
	var/maximum_timer_set = 300
	var/timing = FALSE
	///If true, the prototype canister requires engi access to be used
	var/restricted = FALSE
	///Window overlay showing the gas inside the canister
	var/image/window

	var/shielding_powered = FALSE

	var/obj/item/stock_parts/cell/internal_cell

	var/cell_container_opened = FALSE

	var/protected_contents = FALSE

/obj/machinery/portable_atmospherics/canister/Initialize(mapload, datum/gas_mixture/existing_mixture)
	. = ..()

	if(mapload)
		internal_cell = new /obj/item/stock_parts/cell/high(src)

	if(existing_mixture)
		air_contents.copyFrom(existing_mixture)
	else
		create_gas()
	if(gas_type)
		desc = "[xgm_gas_data.name[gas_type]]."

	update_window()

	var/random_quality = rand()
	pressure_limit = initial(pressure_limit) * (1 + 0.2 * random_quality)

	update_appearance()
	AddElement(/datum/element/volatile_gas_storage)
	AddComponent(/datum/component/gas_leaker, leak_rate=0.01)

/obj/machinery/portable_atmospherics/canister/interact(mob/user)
	. = ..()
	if(!allowed(user))
		to_chat(user, span_alert("Error - Unauthorized User."))
		playsound(src, 'sound/misc/compiler-failure.ogg', 50, TRUE)
		return

/obj/machinery/portable_atmospherics/canister/examine(user)
	. = ..()
	. += span_notice("A sticker on its side says <b>MAX SAFE PRESSURE: [siunit_pressure(initial(pressure_limit), 0)]; MAX SAFE TEMPERATURE: [siunit(heat_limit, "K", 0)]</b>.")
	if(internal_cell)
		. += span_notice("The internal cell has [internal_cell.percent()]% of its total charge.")
	else
		. += span_notice("Warning, no cell installed, use a screwdriver to open the hatch and insert one.")
	if(cell_container_opened)
		. += span_notice("Cell hatch open, close it with a screwdriver.")

// Please keep the canister types sorted
// Basic canister per gas below here

/obj/machinery/portable_atmospherics/canister/air
	name = "air canister"
	desc = "Pre-mixed air."
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#c6c0b5"

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "carbon dioxide canister"
	gas_type = GAS_CO2
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#4e4c48"

/obj/machinery/portable_atmospherics/canister/carbon_monoxide
	name = "carbon monoxide canister"
	gas_type = GAS_CO
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#808080"

/obj/machinery/portable_atmospherics/canister/xenon
	name = "xenon canister"
	gas_type = GAS_XENON
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#808080"

/obj/machinery/portable_atmospherics/canister/krypton
	name = "krypton canister"
	gas_type = GAS_KRYPTON
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#44E022"

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "nitrogen canister"
	gas_type = GAS_NITROGEN
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#d41010"

/obj/machinery/portable_atmospherics/canister/nitrous_oxide
	name = "nitrous oxide canister"
	gas_type = GAS_N2O
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#c63e3b#f7d5d3"

/obj/machinery/portable_atmospherics/canister/chlorine
	name = "chlorine canister"
	gas_type = GAS_CHLORINE
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#b9d41b"

/obj/machinery/portable_atmospherics/canister/argon
	name = "argon canister"
	gas_type = GAS_ARGON
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#CC4DCD"

/obj/machinery/portable_atmospherics/canister/neon
	name = "neon canister"
	gas_type = GAS_NEON
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#FF825C"

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "oxygen canister"
	gas_type = GAS_OXYGEN
	greyscale_config = /datum/greyscale_config/canister/stripe
	greyscale_colors = "#2786e5#e8fefe"

/obj/machinery/portable_atmospherics/canister/oxygen/cryo
	name = "cryogenic canister"
	starter_temp = 80
	filled = 0.2

/obj/machinery/portable_atmospherics/canister/boron
	name = "boron canister"
	gas_type = GAS_BORON
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#32DF1F"

/obj/machinery/portable_atmospherics/canister/plasma
	name = "plasma canister"
	gas_type = GAS_PLASMA
	greyscale_config = /datum/greyscale_config/canister/hazard
	greyscale_colors = "#f62800#000000"

/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "hydrogen canister"
	gas_type = GAS_HYDROGEN
	greyscale_config = /datum/greyscale_config/canister/hazard
	greyscale_colors = "#3fcd40#000000"

/obj/machinery/portable_atmospherics/canister/deuterium
	name = "hydrogen canister"
	gas_type = GAS_DEUTERIUM
	greyscale_config = /datum/greyscale_config/canister/hazard
	greyscale_colors = "#E81BFF#000000"

/obj/machinery/portable_atmospherics/canister/tritium
	name = "tritium canister"
	gas_type = GAS_TRITIUM
	greyscale_config = /datum/greyscale_config/canister/hazard
	greyscale_colors = "#3fcd40#000000"

/obj/machinery/portable_atmospherics/canister/water_vapor
	name = "steam canister"
	gas_type = GAS_STEAM
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#4c4e4d#f7d5d3"

// Special canisters below here
/obj/machinery/portable_atmospherics/canister/anesthetic_mix
	name = "anesthetic mix"
	desc = "A mixture of N2O and Oxygen"
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#9fba6c#3d4680"

/obj/machinery/portable_atmospherics/canister/anesthetic_mix/create_gas()
	air_contents.adjustGas(GAS_OXYGEN, (O2_ANESTHETIC * maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	air_contents.adjustGas(GAS_N2O, (N2O_ANESTHETIC * maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	SSairmachines.start_processing_machine(src)

/**
 * Getter for the amount of time left in the timer of prototype canisters
 */
/obj/machinery/portable_atmospherics/canister/proc/get_time_left()
	if(timing)
		. = round(max(0, valve_timer - world.time) * 0.1, 1)
	else
		. = timer_set

/**
 * Starts the timer of prototype canisters
 */
/obj/machinery/portable_atmospherics/canister/proc/set_active()
	timing = !timing
	if(timing)
		valve_timer = world.time + (timer_set SECONDS)
	update_appearance()

/obj/machinery/portable_atmospherics/canister/proto
	name = "prototype canister"
	greyscale_config = /datum/greyscale_config/prototype_canister
	greyscale_colors = "#ffffff#a50021#ffffff"

/obj/machinery/portable_atmospherics/canister/proto/default
	name = "prototype canister"
	desc = "The best way to fix an atmospheric emergency... or the best way to introduce one."
	volume = 5000
	max_integrity = 300
	temperature_resistance = 2000 + T0C
	can_max_release_pressure = (ONE_ATMOSPHERE * 30)
	can_min_release_pressure = (ONE_ATMOSPHERE / 30)
	prototype = TRUE

/obj/machinery/portable_atmospherics/canister/proto/default/oxygen
	name = "prototype canister"
	desc = "A prototype canister for a prototype bike, what could go wrong?"
	gas_type = GAS_OXYGEN
	filled = 1
	release_pressure = ONE_ATMOSPHERE*2

/**
 * Called on Initialize(), fill the canister with the gas_type specified up to the filled level (half if 0.5, full if 1)
 * Used for canisters spawned in maps and by admins
 */
/obj/machinery/portable_atmospherics/canister/proc/create_gas()
	if(!gas_type)
		return
	if(starter_temp)
		air_contents.temperature = starter_temp
	air_contents.adjustGas(gas_type,(maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	SSairmachines.start_processing_machine(src)

/obj/machinery/portable_atmospherics/canister/air/create_gas()
	air_contents.adjustGas(GAS_OXYGEN, (O2STANDARD * maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	air_contents.adjustGas(GAS_NITROGEN, (N2STANDARD * maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	SSairmachines.start_processing_machine(src)

/obj/machinery/portable_atmospherics/canister/update_icon_state()
	if(machine_stat & BROKEN)
		icon_state = "[base_icon_state]-1"
	return ..()

/obj/machinery/portable_atmospherics/canister/update_overlays()
	. = ..()

	if(shielding_powered)
		. += mutable_appearance(canister_overlay_file, "shielding")
		. += emissive_appearance(canister_overlay_file, "shielding", alpha = 90)

	if(cell_container_opened)
		. += mutable_appearance(canister_overlay_file, "cell_hatch")

	var/isBroken = machine_stat & BROKEN
	///Function is used to actually set the overlays
	if(isBroken)
		. += mutable_appearance(canister_overlay_file, "broken")
	if(holding)
		. += mutable_appearance(canister_overlay_file, "can-open")
	if(connected_port)
		. += mutable_appearance(canister_overlay_file, "can-connector")

	var/air_pressure = air_contents.returnPressure()

	switch(air_pressure)
		if((40 * ONE_ATMOSPHERE) to INFINITY)
			. += mutable_appearance(canister_overlay_file, "can-3")
			. += emissive_appearance(canister_overlay_file, "can-3-light", alpha = 90)
		if((10 * ONE_ATMOSPHERE) to (40 * ONE_ATMOSPHERE))
			. += mutable_appearance(canister_overlay_file, "can-2")
			. += emissive_appearance(canister_overlay_file, "can-2-light", alpha = 90)
		if((5 * ONE_ATMOSPHERE) to (10 * ONE_ATMOSPHERE))
			. += mutable_appearance(canister_overlay_file, "can-1")
			. += emissive_appearance(canister_overlay_file, "can-1-light", alpha = 90)
		if((10) to (5 * ONE_ATMOSPHERE))
			. += mutable_appearance(canister_overlay_file, "can-0")
			. += emissive_appearance(canister_overlay_file, "can-0-light", alpha = 90)

	update_window()

/obj/machinery/portable_atmospherics/canister/update_greyscale()
	. = ..()
	update_window()

/obj/machinery/portable_atmospherics/canister/proc/update_window()
	if(!air_contents)
		return
	var/static/alpha_filter
	if(!alpha_filter) // Gotta do this separate since the icon may not be correct at world init
		alpha_filter = filter(type="alpha", icon=icon(icon, "window-base"))

	cut_overlay(window)
	window = image(icon, icon_state="window-base", layer=FLOAT_LAYER)
	var/list/window_overlays = list()
	/*for(var/visual in air_contents.returnVisuals())
		var/image/new_visual = image(visual, layer=FLOAT_LAYER)
		new_visual.filters = alpha_filter
		window_overlays += new_visual*/
	window.overlays = window_overlays
	add_overlay(window)

/obj/machinery/portable_atmospherics/canister/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	if(exposed_temperature > temperature_resistance &&!shielding_powered)
		take_damage(5, BURN, 0)

/obj/machinery/portable_atmospherics/canister/deconstruct(disassembled = TRUE)
	if((flags_1 & NODECONSTRUCT_1))
		return
	if(!(machine_stat & BROKEN))
		canister_break()
	if(!disassembled)
		new /obj/item/stack/sheet/iron (drop_location(), 5)
		qdel(src)
		return
	new /obj/item/stack/sheet/iron (drop_location(), 10)
	if(internal_cell)
		internal_cell.forceMove(drop_location())
	qdel(src)

/obj/machinery/portable_atmospherics/canister/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/active_cell = item
		if(!cell_container_opened)
			balloon_alert(user, "open the hatch first")
			return
		if(!user.transferItemToLoc(active_cell, src))
			return
		if(internal_cell)
			user.put_in_hands(internal_cell)
			balloon_alert(user, "you successfully replace the cell")
		else
			balloon_alert(user, "you successfully install the cell")
		internal_cell = active_cell
		return
	return ..()

/obj/machinery/portable_atmospherics/canister/screwdriver_act(mob/living/user, obj/item/screwdriver)
	if(screwdriver.tool_behaviour != TOOL_SCREWDRIVER)
		return
	screwdriver.play_tool_sound(src, 50)
	cell_container_opened = !cell_container_opened
	to_chat(user, span_notice("You [cell_container_opened ? "open" : "close"] the cell container hatch of [src]."))
	update_appearance()
	return TRUE

/obj/machinery/portable_atmospherics/canister/crowbar_act(mob/living/user, obj/item/tool)
	if(!cell_container_opened || !internal_cell)
		return
	internal_cell.forceMove(drop_location())
	balloon_alert(user, "you successfully remove the cell")
	return TRUE

/obj/machinery/portable_atmospherics/canister/welder_act_secondary(mob/living/user, obj/item/I)
	. = ..()
	if(!I.tool_start_check(user, amount=0))
		return TRUE
	var/pressure = air_contents.returnPressure()
	if(pressure > 300)
		to_chat(user, span_alert("The pressure gauge on [src] indicates a high pressure inside... maybe you want to reconsider?"))
		message_admins("[src] deconstructed by [ADMIN_LOOKUPFLW(user)]")
		log_game("[src] deconstructed by [key_name(user)]")
	to_chat(user, span_notice("You begin cutting [src] apart..."))
	if(I.use_tool(src, user, 3 SECONDS, volume=50))
		to_chat(user, span_notice("You cut [src] apart."))
		deconstruct(TRUE)
	return TRUE

/obj/machinery/portable_atmospherics/canister/welder_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.combat_mode)
		return FALSE
	if(atom_integrity >= max_integrity)
		return TRUE
	if(machine_stat & BROKEN)
		return TRUE
	if(!tool.tool_start_check(user, amount=0))
		return TRUE
	to_chat(user, span_notice("You begin repairing cracks in [src]..."))
	while(tool.use_tool(src, user, 2.5 SECONDS, volume=40))
		atom_integrity = min(atom_integrity + 25, max_integrity)
		if(atom_integrity >= max_integrity)
			to_chat(user, span_notice("You've finished repairing [src]."))
			return TRUE
		to_chat(user, span_notice("You repair some of the cracks in [src]..."))
	return TRUE

/obj/machinery/portable_atmospherics/canister/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == internal_cell)
		internal_cell = null

/obj/machinery/portable_atmospherics/canister/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armor_penetration = 0)
	. = ..()
	if(!. || QDELETED(src))
		return

/obj/machinery/portable_atmospherics/canister/atom_break(damage_flag)
	. = ..()
	if(!.)
		return
	canister_break()

/**
 * Handle canisters disassemble, releases the gas content in the turf
 */
/obj/machinery/portable_atmospherics/canister/proc/canister_break()
	disconnect()
	var/turf/T = get_turf(src)
	T.assume_air(air_contents)

	atom_break()

	set_density(FALSE)
	playsound(src.loc, 'sound/effects/spray.ogg', 10, TRUE, -3)
	investigate_log("was destroyed.", INVESTIGATE_ATMOS)

	if(holding)
		holding.forceMove(T)
		holding = null

	animate(src, 0.5 SECONDS, transform=turn(transform, rand(-179, 180)), easing=BOUNCE_EASING)

/obj/machinery/portable_atmospherics/canister/replace_tank(mob/living/user, close_valve)
	. = ..()
	if(!.)
		return
	if(close_valve)
		valve_open = FALSE
		update_appearance()
		investigate_log("Valve was <b>closed</b> by [key_name(user)].", INVESTIGATE_ATMOS)
	else if(valve_open && holding)
		investigate_log("[key_name(user)] started a transfer into [holding].", INVESTIGATE_ATMOS)

/obj/machinery/portable_atmospherics/canister/process(delta_time)

	var/our_pressure = air_contents.returnPressure()
	var/our_temperature = air_contents.temperature

	protected_contents = FALSE
	if(shielding_powered)
		var/power_factor = round(log(10, max(our_pressure - pressure_limit, 1)) + log(10, max(our_temperature - heat_limit, 1)))
		var/power_consumed = power_factor * 250 * delta_time
		if(powered(AREA_USAGE_EQUIP, ignore_use_power = TRUE))
			use_power(power_consumed, AREA_USAGE_EQUIP)
			protected_contents = TRUE
		else if(internal_cell?.use(power_consumed * 0.025))
			protected_contents = TRUE
		else
			shielding_powered = FALSE

	///function used to check the limit of the canisters and also set the amount of damage that the canister can receive, if the heat and pressure are way higher than the limit the more damage will be done
	if(!excited && !protected_contents && (our_temperature > heat_limit || our_pressure > pressure_limit))
		take_damage(clamp((our_temperature/heat_limit) * (our_pressure/pressure_limit), 5, 50), BURN, 0)
		excited = TRUE

/obj/machinery/portable_atmospherics/canister/process_atmos()
	if(machine_stat & BROKEN)
		return PROCESS_KILL
	if(timing && valve_timer < world.time)
		valve_open = !valve_open
		timing = FALSE

	// Handle gas transfer.
	if(valve_open)
		var/turf/location = get_turf(src)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = location.return_air()

		var/env_pressure = environment.returnPressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_pressure/air_contents.volume)*air_contents.total_moles) //flow rate limit

			pump_gas_passive(air_contents, environment, transfer_moles)

	air_contents.react()

	var/our_pressure = air_contents.returnPressure()
	var/our_temperature = air_contents.temperature

	///function used to check the limit of the canisters and also set the amount of damage that the canister can receive, if the heat and pressure are way higher than the limit the more damage will be done
	if(!protected_contents && (our_temperature > heat_limit || our_pressure > pressure_limit))
		take_damage(clamp((our_temperature/heat_limit) * (our_pressure/pressure_limit), 5, 50), BURN, 0)
		excited = TRUE
	update_appearance()

/obj/machinery/portable_atmospherics/canister/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Canister", name)
		ui.open()

/obj/machinery/portable_atmospherics/canister/ui_static_data(mob/user)
	return list(
		"defaultReleasePressure" = round(CAN_DEFAULT_RELEASE_PRESSURE),
		"minReleasePressure" = round(can_min_release_pressure),
		"maxReleasePressure" = round(can_max_release_pressure),
		"pressureLimit" = round(pressure_limit),
		"holdingTankLeakPressure" = round(TANK_LEAK_PRESSURE),
		"holdingTankFragPressure" = round(TANK_FRAGMENT_PRESSURE)
	)

/obj/machinery/portable_atmospherics/canister/ui_data()
	. = list(
		"portConnected" = !!connected_port,
		"tankPressure" = round(air_contents.returnPressure()),
		"releasePressure" = round(release_pressure),
		"valveOpen" = !!valve_open,
		"isPrototype" = !!prototype,
		"hasHoldingTank" = !!holding
	)

	if (prototype)
		. += list(
			"restricted" = restricted,
			"timing" = timing,
			"time_left" = get_time_left(),
			"timer_set" = timer_set,
			"timer_is_not_default" = timer_set != default_timer_set,
			"timer_is_not_min" = timer_set != minimum_timer_set,
			"timer_is_not_max" = timer_set != maximum_timer_set
		)

	if (holding)
		var/datum/gas_mixture/holding_mix = holding.return_air()
		. += list(
			"holdingTank" = list(
				"name" = holding.name,
				"tankPressure" = round(holding_mix.returnPressure())
			)
		)
	. += list(
		"shielding" = shielding_powered,
		"has_cell" = (internal_cell ? TRUE : FALSE),
		"cell_charge" = internal_cell?.percent()
	)

/obj/machinery/portable_atmospherics/canister/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("relabel")
			var/label = tgui_input_list(usr, "New canister label", "Canister", GLOB.gas_id_to_canister)
			if(isnull(label))
				return
			if(!..())
				var/newtype = GLOB.gas_id_to_canister[label]
				if(newtype)
					var/obj/machinery/portable_atmospherics/canister/replacement = newtype
					investigate_log("was relabelled to [initial(replacement.name)] by [key_name(usr)].", INVESTIGATE_ATMOS)
					name = initial(replacement.name)
					desc = initial(replacement.desc)
					icon_state = initial(replacement.icon_state)
					base_icon_state = icon_state
					set_greyscale(initial(replacement.greyscale_colors), initial(replacement.greyscale_config))
		if("restricted")
			restricted = !restricted
			if(restricted)
				req_access = list(ACCESS_ENGINE)
			else
				req_access = list()
				. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = CAN_DEFAULT_RELEASE_PRESSURE
				. = TRUE
			else if(pressure == "min")
				pressure = can_min_release_pressure
				. = TRUE
			else if(pressure == "max")
				pressure = can_max_release_pressure
				. = TRUE
			else if(pressure == "input")
				pressure = tgui_input_number(usr, "New release pressure", "Canister Pressure", release_pressure, can_max_release_pressure, can_min_release_pressure)
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				release_pressure = clamp(round(pressure), can_min_release_pressure, can_max_release_pressure)
				investigate_log("was set to [release_pressure] kPa by [key_name(usr)].", INVESTIGATE_ATMOS)
		if("valve")		//logging for openning canisters
			var/logmsg
			var/admin_msg
			var/danger = FALSE
			var/n = 0
			valve_open = !valve_open
			if(valve_open)
				SSairmachines.start_processing_machine(src)
				logmsg = "Valve was <b>opened</b> by [key_name(usr)], starting a transfer into \the [holding || "air"].<br>"
				if(!holding)
					var/list/gaseslog = list() //list for logging all gases in canister
					for(var/gas in air_contents.gas)
						gaseslog[xgm_gas_data.name[gas]] = air_contents.gas[gas]	//adds gases to gaseslog
						if(!(xgm_gas_data.flags[gas] & (XGM_GAS_CONTAMINANT|XGM_GAS_FUEL)))
							continue
						danger = TRUE //at least 1 danger gas
					logmsg = "[key_name(usr)] <b>opened</b> a canister that contains the following:"
					admin_msg = "[key_name(usr)] <b>opened</b> a canister that contains the following at [ADMIN_VERBOSEJMP(src)]:"
					for(var/name in gaseslog)
						n = n + 1
						logmsg += "\n[name]: [gaseslog[name]] moles."
						if(n <= 5) //the first five gases added
							admin_msg += "\n[name]: [gaseslog[name]] moles."
						if(n == 5 && length(gaseslog) > 5) //message added if more than 5 gases
							admin_msg += "\nToo many gases to log. Check investigate log."
					if(danger) //sent to admin's chat if contains dangerous gases
						message_admins(admin_msg)
			else
				logmsg = "Valve was <b>closed</b> by [key_name(usr)], stopping the transfer into \the [holding || "air"].<br>"
			investigate_log(logmsg, INVESTIGATE_ATMOS)
			release_log += logmsg
			. = TRUE
		if("timer")
			var/change = params["change"]
			switch(change)
				if("reset")
					timer_set = default_timer_set
				if("decrease")
					timer_set = max(minimum_timer_set, timer_set - 10)
				if("increase")
					timer_set = min(maximum_timer_set, timer_set + 10)
				if("input")
					var/user_input = tgui_input_number(usr, "Set time to valve toggle", "Canister Timer", timer_set, maximum_timer_set, minimum_timer_set)
					if(isnull(user_input) || QDELETED(usr) || QDELETED(src) || !usr.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
						return
					timer_set = user_input
					log_admin("[key_name(usr)] has activated a prototype valve timer")
					. = TRUE
				if("toggle_timer")
					set_active()
		if("eject")
			if(holding)
				if(valve_open)
					message_admins("[ADMIN_LOOKUPFLW(usr)] removed [holding] from [src] with valve still open at [ADMIN_VERBOSEJMP(src)] releasing contents into the [span_boldannounce("air")].")
					investigate_log("[key_name(usr)] removed the [holding], leaving the valve open and transferring into the [span_boldannounce("air")].", INVESTIGATE_ATMOS)
				replace_tank(usr, FALSE)
				. = TRUE

		if("shielding")
			shielding_powered = !shielding_powered
			message_admins("[ADMIN_LOOKUPFLW(usr)] turned [shielding_powered ? "on" : "off"] the [src] powered shielding.")
			investigate_log("[key_name(usr)] turned [shielding_powered ? "on" : "off"] the [src] powered shielding.")
			. = TRUE

	update_appearance()

/obj/machinery/portable_atmospherics/canister/unregister_holding()
	valve_open = FALSE
	return ..()
