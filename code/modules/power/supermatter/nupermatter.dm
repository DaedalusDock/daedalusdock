/*
	How to tweak the SM

	POWER_FACTOR		directly controls how much power the SM puts out at a given level of excitation (power var). Making this lower means you have to work the SM harder to get the same amount of power.
	CRITICAL_TEMPERATURE	The temperature at which the SM starts taking damage.

	CHARGING_FACTOR		Controls how much emitter shots excite the SM.
	DAMAGE_RATE_LIMIT	Controls the maximum rate at which the SM will take damage due to high temperatures.
*/

GLOBAL_DATUM(main_supermatter_engine, /obj/machinery/power/supermatter)

/obj/machinery/power/supermatter
	name = "supermatter crystal"
	desc = "A strangely translucent and iridescent crystal."
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "darkmatter"
	density = TRUE
	anchored = FALSE
	layer = MOB_LAYER
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	critical_machine = TRUE
	base_icon_state = "darkmatter"

	light_outer_range = 4
	///Higher == N2 slows reaction more
	var/nitrogen_retardation_factor = 0.15
	///Higher == more heat released during reaction
	var/thermal_release_modifier = 15000
	///Higher == less phoron released by reaction
	var/phoron_release_modifier = 1500
	///Higher == less oxygen released at high temperature/power
	var/oxygen_release_modifier = 15000
	///Higher == more radiation released with more power.
	var/radiation_release_modifier = 2
	///Higher == more overall power
	var/reaction_power_modifier = 1.1

	///Controls how much power is produced by each collector in range - this is the main parameter for tweaking SM balance, as it basically controls how the power variable relates to the rest of the game.
	var/power_factor = 1.0
	///Affects how fast the supermatter power decays
	var/decay_factor = 700
	var/critical_temperature = 5000	//K
	var/charging_factor = 0.05
	///damage rate cap at power = 300, scales linearly with power
	var/damage_rate_limit = 4.5

	var/gasefficency = 0.25

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/public_alert = 0 //Stick to Engineering frequency except for big warnings when integrity bad
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/emergency_point = 700
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000

	light_color = "#927a10"
	var/base_color = "#927a10"
	var/warning_color = "#c78c20"
	var/emergency_color = "#ffd04f"
	var/rotation_angle = 0

	var/grav_pulling = 0
	// Time in ticks between delamination ('exploding') and exploding (as in the actual boom)
	var/pull_time = 30 SECONDS
	var/explosion_power = 9

	var/emergency_issued = 0

	// Time in 1/10th of seconds since the last sent warning
	var/lastwarning = 0

	// This stops spawning redundant explosions. Also incidentally makes supermatter unexplodable if set to 1.
	var/exploded = 0

	var/power = 0
	var/oxygen = 0

	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/debug = 0

	var/disable_adminwarn = FALSE

	var/aw_normal = FALSE
	var/aw_warning = FALSE
	var/aw_danger = FALSE
	var/aw_emerg = FALSE
	var/aw_delam = FALSE
	var/aw_EPR = FALSE

	///Our internal radio
	var/obj/item/radio/radio
	///The key our internal radio uses
	var/radio_key = /obj/item/encryptionkey/headset_eng
	///The engineering channel
	var/engineering_channel = "Engineering"
	///The common channel
	var/common_channel = null

	var/is_main_engine = FALSE
	///Used to track when the SM is first turned on for admin logging.
	var/has_been_powered = FALSE
	///Idk why this exists actually, i think its for unwrenching behavior
	var/movable = TRUE

	///The amount of supermatters that have been created this round
	var/static/gl_uid = 1
	///This supermatter's number
	var/uid = 1
	///Can include in CIMs
	var/include_in_cims = TRUE

/obj/machinery/power/supermatter/Initialize(mapload)
	. = ..()
	uid = gl_uid++
	investigate_log("has been created.", INVESTIGATE_ENGINE)
	SSairmachines.start_processing_machine(src)
	SSpoints_of_interest.make_point_of_interest(src)

	if(is_main_engine)
		GLOB.main_supermatter_engine = src
	if(movable)
		move_resist = MOVE_FORCE_OVERPOWERING // Avoid being moved by statues or other memes

	radio = new(src)
	radio.keyslot = new radio_key
	radio.canhear_range = -1
	radio.set_listening(FALSE, TRUE)
	radio.recalculateChannels()

	AddElement(/datum/element/lateral_bound, TRUE)


/obj/machinery/power/supermatter/Destroy()
	investigate_log("has been destroyed.", INVESTIGATE_ENGINE)
	SSairmachines.stop_processing_machine(src)
	QDEL_NULL(radio)
	if(is_main_engine && GLOB.main_supermatter_engine == src)
		GLOB.main_supermatter_engine = null
	return ..()

/obj/machinery/power/supermatter/proc/handle_admin_warnings()
	if(disable_adminwarn)
		return

	// Generic checks, similar to checks done by supermatter monitor program.
	aw_normal = status_adminwarn_check(SUPERMATTER_NORMAL, aw_normal, "INFO: Supermatter crystal has been energised", FALSE)
	aw_warning = status_adminwarn_check(SUPERMATTER_WARNING, aw_warning, "WARN: Supermatter crystal is taking integrity damage", FALSE)
	aw_danger = status_adminwarn_check(SUPERMATTER_DANGER, aw_danger, "WARN: Supermatter integrity is below 50%", TRUE)
	aw_emerg = status_adminwarn_check(SUPERMATTER_EMERGENCY, aw_emerg, "CRIT: Supermatter integrity is below 25%", FALSE)
	aw_delam = status_adminwarn_check(SUPERMATTER_DELAMINATING, aw_delam, "CRIT: Supermatter is delaminating", TRUE)

	// EPR check. Only runs when supermatter is energised. Triggers when there is very low amount of coolant in the core (less than one standard canister).
	// This usually means a core breach or deliberate venting.
	if(get_status() && (get_epr() < 0.5))
		if(!aw_EPR)
			message_admins("WARN: Supermatter EPR value low. Possible core breach detected in [ADMIN_LOOKUPFLW(src)]")
		aw_EPR = TRUE
	else
		aw_EPR = FALSE

/obj/machinery/power/supermatter/proc/status_adminwarn_check(min_status, current_state, message, send_to_irc = FALSE)
	var/status = get_status()
	if(status >= min_status)
		if(!current_state)
			message_admins(message + " [ADMIN_LOOKUPFLW(src)]")
		return TRUE
	else
		return FALSE

/obj/machinery/power/supermatter/proc/get_epr()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/air = T.unsafe_return_air()
	if(!air)
		return 0
	return round((air.total_moles / air.group_multiplier) / 23.1, 0.01)

/obj/machinery/power/supermatter/proc/get_status()
	var/turf/T = get_turf(src)
	if(!T)
		return SUPERMATTER_ERROR
	var/datum/gas_mixture/air = T.unsafe_return_air()
	if(!air)
		return SUPERMATTER_ERROR

	if(grav_pulling || exploded)
		return SUPERMATTER_DELAMINATING

	if(get_integrity_percentage() < 25)
		return SUPERMATTER_EMERGENCY

	if(get_integrity_percentage() < 50)
		return SUPERMATTER_DANGER

	if((get_integrity_percentage() < 100) || (air.temperature > critical_temperature))
		return SUPERMATTER_WARNING

	if(power > 5)
		return SUPERMATTER_NORMAL
	return SUPERMATTER_INACTIVE


/obj/machinery/power/supermatter/proc/explode()
	set waitfor = 0

	if(exploded)
		return

	message_admins("Supermatter delaminating!! [ADMIN_FLW(src)]")
	anchored = TRUE
	grav_pulling = 1
	exploded = 1

	sleep(pull_time)

	var/turf/TS = get_turf(src) // The turf supermatter is on. SM being in a locker, exosuit, or other container shouldn't block it's effects that way.
	if(!istype(TS))
		return

	var/list/affected_z = SSmapping.get_zstack(TS.z)

	// Effect 1: Radiation, weakening to all mobs on Z level
	SSweather.run_weather(/datum/weather/rad_storm, affected_z, FALSE)

	for(var/mob/living/mob in GLOB.mob_living_list)
		CHECK_TICK
		var/turf/TM = get_turf(mob)
		if(!TM)
			continue
		if(!(TM.z in affected_z))
			continue

		mob.Knockdown(DETONATION_MOB_CONCUSSION)
		to_chat(mob, span_danger("An invisible force slams you against the ground!"))

	// Effect 2: Z-level wide electrical pulse
	for(var/obj/machinery/power/apc/A in GLOB.machines)
		CHECK_TICK
		if(!(A.z in affected_z))
			continue

		// Overloads lights
		if(prob(DETONATION_APC_OVERLOAD_PROB))
			A.overload_lighting()
		// Causes the APCs to go into system failure mode.
		var/random_change = rand(100 - DETONATION_SHUTDOWN_RNG_FACTOR, 100 + DETONATION_SHUTDOWN_RNG_FACTOR) / 100
		A.energy_fail(round(DETONATION_SHUTDOWN_APC * random_change))

	// Effect 3: Break solar arrays

	for(var/obj/machinery/power/solar/S in GLOB.machines)
		CHECK_TICK
		if(!(S.z in affected_z))
			continue
		if(prob(DETONATION_SOLAR_BREAK_CHANCE))
			S.atom_break()

	// Effect 4: Medium scale explosion
	spawn(0)
		explosion(TS, explosion_power/2, explosion_power, explosion_power * 2, explosion_power * 4, 1)
		qdel(src)

/obj/machinery/power/supermatter/examine(mob/user)
	. = ..()
	switch(get_integrity())
		if(0 to 30)
			. += span_danger("It looks highly unstable!")
		if(31 to 70)
			. += span_warning("It appears to be losing cohesion!")
		else
			. += span_notice("At a glance, it seems to be in sound shape.")

	var/immune = HAS_TRAIT(user, TRAIT_SUPERMATTER_MADNESS_IMMUNE) || (user.mind && HAS_TRAIT(user.mind, TRAIT_SUPERMATTER_MADNESS_IMMUNE))
	if(isliving(user) && !immune && (get_dist(user, src) < HALLUCINATION_RANGE(power)))
		. += span_danger("You get headaches just from looking at it.")

//Changes color and luminosity of the light to these values if they were not already set
/obj/machinery/power/supermatter/proc/shift_light(lum, clr)
	if(lum != light_outer_range || clr != light_color)
		set_light(1, 0.1, lum, l_color = clr)

/obj/machinery/power/supermatter/get_integrity_percentage()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity


/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = get_integrity_percentage()
	var/alert_msg = " Integrity at [integrity]%"

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg = null
	if(alert_msg)
		radio.talk_into(src, alert_msg, engineering_channel)
		//Public alerts
		if((damage > emergency_point) && !public_alert)
			radio.talk_into(src, alert_msg, common_channel)
			public_alert = 1
			for(var/mob/M in GLOB.player_list)
				if((is_station_level(M.z)))
					M.playsound_local(get_turf(M), 'sound/ambience/matteralarm.ogg')

		else if(safe_warned && public_alert)
			priority_announce(alert_msg, "Station Announcement","Supermatter Monitor", ANNOUNCER_ATTENTION)
			public_alert = 0

/obj/machinery/power/supermatter/process_atmos()
	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return //Yeah just stop.

	if(damage > explosion_point)
		if(!exploded)
			if(!isspaceturf(L) && is_station_level(L.z))
				announce_warning()
			explode()
	else if(damage > warning_point) // while the core is still damaged and it's still worth noting its status
		shift_light(5, warning_color)
		if(damage > emergency_point)
			shift_light(7, emergency_color)
		if(!isspaceturf(L) && ((world.timeofday - lastwarning) >= WARNING_DELAY * 10) && is_station_level(L.z))
			announce_warning()
	else
		shift_light(4,base_color)
	if(grav_pulling)
		supermatter_pull(src)

	//Ok, get the air from the turf
	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null

	//ensure that damage doesn't increase too quickly due to super high temperatures resulting from no coolant, for example. We don't want the SM exploding before anyone can react.
	//We want the cap to scale linearly with power (and explosion_point). Let's aim for a cap of 5 at power = 300 (based on testing, equals roughly 5% per SM alert announcement).
	var/damage_inc_limit = (power/300)*(explosion_point/1000)*damage_rate_limit

	if(!isspaceturf(L))
		env = L.return_air()
		removed = env.remove(gasefficency * env.total_moles)	//Remove gas from surrounding area

	if(!env || !removed || !removed.total_moles)
		damage_archived = damage
		damage += max((power - 15*power_factor)/10, 0)
	else if (grav_pulling) //If supermatter is detonating, remove all air from the zone
		env.remove(env.total_moles)
	else
		damage_archived = damage

		damage = max(0, damage + clamp((removed.temperature - critical_temperature) / 150, -damage_rate_limit, damage_inc_limit))

		//Ok, 100% oxygen atmosphere = best reaction
		//Maxes out at 100% oxygen pressure
		oxygen = clamp((removed.getByFlag(XGM_GAS_OXIDIZER) - (removed.gas[GAS_NITROGEN] * nitrogen_retardation_factor)) / removed.total_moles, 0, 1)

		//calculate power gain for oxygen reaction
		var/temp_factor
		var/equilibrium_power
		if (oxygen > 0.8)
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 400
			equilibrium_power = 400
			icon_state = "[base_icon_state]_glow"
		else
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 250
			equilibrium_power = 250
			icon_state = base_icon_state

		temp_factor = ( (equilibrium_power/decay_factor)**3 )/800
		power = max( (removed.temperature * temp_factor) * oxygen + power, 0)

		var/device_energy = power * reaction_power_modifier

		//Release reaction gasses
		var/heat_capacity = removed.getHeatCapacity()
		removed.adjustMultipleGases(
			GAS_PLASMA, max(device_energy / phoron_release_modifier, 0),
			GAS_OXYGEN, max((device_energy + removed.temperature - T0C) / oxygen_release_modifier, 0)
		)

		var/thermal_power = thermal_release_modifier * device_energy
		if (debug)
			var/heat_capacity_new = removed.getHeatCapacity()
			visible_message("[src]: Releasing [round(thermal_power)] J.")
			visible_message("[src]: Releasing additional [round((heat_capacity_new - heat_capacity)*removed.temperature)] J with exhaust gasses.")

		removed.adjustThermalEnergy(thermal_power)
		removed.temperature = clamp(removed.temperature, 0, 10000)

		env.merge(removed)

	for(var/mob/living/carbon/human/subject in view(src, min(7, round(sqrt(power/6)))))
		var/obj/item/organ/internal/eyes/eyes = subject.getorganslot(ORGAN_SLOT_EYES)
		if (!eyes)
			continue
		if (eyes.organ_flags & ORGAN_SYNTHETIC)
			continue
		if(HAS_TRAIT(subject, TRAIT_SUPERMATTER_MADNESS_IMMUNE) || (subject.mind && HAS_TRAIT(subject.mind, TRAIT_SUPERMATTER_MADNESS_IMMUNE)))
			continue
		var/effect = max(0, min(200, power * config_hallucination_power * sqrt( 1 / max(1,get_dist(subject, src)))) )
		subject.hallucination += effect

	var/level = LERP(0, 50, clamp( (damage - emergency_point) / (explosion_point - emergency_point),0,1))
	var/list/new_color = color_contrast(level)
	//Apply visual effects based on damage
	if(rotation_angle != 0)
		if(level != 0)
			new_color = multiply_matrices(new_color, color_rotation(rotation_angle), 4, 3,3)
		else
			new_color = color_rotation(rotation_angle)

	color = new_color

	if (damage >= emergency_point && !filters.len)
		filters = filter(type="rays", size = 64, color = "#ffd04f", factor = 0.6, density = 12)
		animate(filters[1], time = 10 SECONDS, offset = 10, loop=-1)
		animate(time = 10 SECONDS, offset = 0, loop=-1)

		animate(filters[1], time = 2 SECONDS, size = 80, loop=-1, flags = ANIMATION_PARALLEL)
		animate(time = 2 SECONDS, size = 10, loop=-1, flags = ANIMATION_PARALLEL)
	else if (damage < emergency_point)
		filters = null

	emit_radiation() //Better close those shutters!
	power -= (power/decay_factor)**3		//energy losses due to radiation
	handle_admin_warnings()

	return 1

/obj/machinery/power/supermatter/Bumped(atom/AM as mob|obj)
	if(istype(AM, /obj/effect))
		return
	if(istype(AM, /mob/living))
		AM.visible_message(
			span_warning("[AM] slams into [src], inducing a resonance. For a brief instant, [AM.p_their()] body glows brilliantly, then flashes into ash."),
			span_userdanger("You slam into [src], and your mind fills with unearthly shrieking. Your vision floods with light as your body instantly dissolves into dust."),
			span_warning("You hear an unearthly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.")
		)
	else if(!grav_pulling) //To prevent spam, detonating supermatter does not indicate non-mobs being destroyed
		AM.visible_message(
			span_warning("[AM] smacks into [src] and rapidly flashes to ash."),
			span_warning("You hear a loud crack as you are washed with a wave of heat.")
		)

	Consume(AM)

/*
/obj/machinery/power/supermatter/proc/Consume(mob/living/user)
	if(istype(user))
		dust_mob(user)
		power += 200
	else
		qdel(user)

	power += 200

	//Some poor sod got eaten, go ahead and irradiate people nearby.
	var/list/viewers = viewers(src)
	for(var/mob/living/l in range(10))
		if(l in viewers)
			to_chat(l, span_warning("As [src] slowly stops resonating, you feel an intense wave of heat wash over you."))
		else
			to_chat(l, span_warning("You hear a muffled, shrill ringing as an intense wave of heat washes over you."))
	var/rads = 500
	SSradiation.radiate(src, rads)
*/

/proc/supermatter_pull(atom/target, pull_range = 255, pull_power = STAGE_FIVE)
	for(var/atom/A in range(pull_range, target))
		A.singularity_pull(target, pull_power)
		CHECK_TICK


/obj/machinery/power/supermatter/GotoAirflowDest(n) //Supermatter not pushed around by airflow
	return

/obj/machinery/power/supermatter/RepelAirflowDest(n)
	return

/obj/machinery/power/supermatter/ex_act(severity)
	..()
	switch(severity)
		if(EXPLODE_DEVASTATE)
			power *= 4
		if(EXPLODE_HEAVY)
			power *= 3
		if(EXPLODE_LIGHT)
			power *= 2
	message_admins("WARN: Explosion near the Supermatter ([ADMIN_LOOKUPFLW(src)]! New EER: [power].")

// SupermatterMonitor UI for ghosts only. Inherited attack_ghost will call this.
/obj/machinery/power/supermatter/ui_interact(mob/user, datum/tgui/ui)
	if(!isobserver(user))
		return FALSE
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SupermatterMonitor")
		ui.open()

/obj/machinery/power/supermatter/ui_data(mob/user)
	var/list/data = list()

	var/turf/local_turf = get_turf(src)

	var/datum/gas_mixture/air = local_turf.unsafe_return_air()

	// singlecrystal set to true eliminates the back sign on the gases breakdown.
	data["singlecrystal"] = TRUE
	data["active"] = TRUE
	data["SM_integrity"] = get_integrity_percentage()
	data["SM_power"] = power
	data["SM_ambienttemp"] = air.temperature
	data["SM_ambientpressure"] = air.returnPressure()
	data["SM_bad_moles_amount"] = 0
	data["SM_moles"] = 0
	data["SM_uid"] = uid
	var/area/active_supermatter_area = get_area(src)
	data["SM_area_name"] = active_supermatter_area.name

	var/list/gasdata = list()

	if(air.total_moles)
		data["SM_moles"] = air.total_moles
		for(var/gasid in air.gas)
			gasdata.Add(list(list(
			"name"= xgm_gas_data.name[gasid],
			"amount" = round(100*air.gas[gasid]/air.total_moles,0.01))))

	else
		for(var/gasid in air.gas)
			gasdata.Add(list(list(
				"name"= xgm_gas_data.name[gasid],
				"amount" = 0)))

	data["gases"] = gasdata

	return data

/*
	data["integrity_percentage"] = round(get_integrity_percentage())
	var/datum/gas_mixture/env = null
	var/turf/T = get_turf(src)

	if(istype(T))
		env = T.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.returnPressure())
	data["detonating"] = grav_pulling
	data["energy"] = power
*/

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and more sensitive, but less boom.
	name = "supermatter shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. <span class='danger'>You get headaches just from looking at it.</span>"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	warning_point = 50
	emergency_point = 400
	explosion_point = 600

	gasefficency = 0.125

	pull_time = 150
	explosion_power = 3

/obj/machinery/power/supermatter/shard/announce_warning() //Shards don't get announcements
	return


/obj/machinery/power/supermatter/randomsample
	name = "experimental supermatter sample"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

/obj/machinery/power/supermatter/randomsample/Initialize()
	. = ..()
	nitrogen_retardation_factor = rand(0.01, 1)	//Higher == N2 slows reaction more
	thermal_release_modifier = rand(100, 1000000)		//Higher == more heat released during reaction
	phoron_release_modifier = rand(0, 100000)		//Higher == less phoron released by reaction
	oxygen_release_modifier = rand(0, 100000)		//Higher == less oxygen released at high temperature/power
	radiation_release_modifier = rand(0, 100)    //Higher == more radiation released with more power.
	reaction_power_modifier =  rand(0, 100)			//Higher == more overall power

	power_factor = rand(0, 20)
	decay_factor = rand(50, 70000)			//Affects how fast the supermatter power decays
	critical_temperature = rand(3000, 5000)	//K
	charging_factor = rand(0, 1)
	damage_rate_limit = rand( 1, 10)		//damage rate cap at power = 300, scales linearly with power

	//Change fune colours
	var/angle = rand(-180, 180)
	var/list/color_matrix = color_rotation(angle)
	rotation_angle = angle

	color = color_matrix

	var/HSV = RGBtoHSV(base_color)
	var/RGB = HSVtoRGB(RotateHue(HSV, angle))
	base_color = RGB

	HSV = RGBtoHSV(warning_color)
	RGB = HSVtoRGB(RotateHue(HSV, angle))
	warning_color = RGB

	HSV = RGBtoHSV(emergency_color)
	RGB = HSVtoRGB(RotateHue(HSV, angle))
	emergency_color = RGB

/obj/machinery/power/supermatter/inert
	name = "experimental supermatter sample"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"
	thermal_release_modifier = 0 //Basically inert
	phoron_release_modifier = 100000000000
	oxygen_release_modifier = 100000000000
	radiation_release_modifier = 1

/obj/structure/closet/crate/secure/large/phoron/experimentalsm
	name = "experimental supermatter crate"
	desc = "Are you sure you want to open this?"

/obj/structure/closet/crate/secure/large/phoron/experimentalsm/PopulateContents()
	. = ..()
	new /obj/machinery/power/supermatter/randomsample(src)

/*
//Warning lights
/obj/machinery/rotating_alarm/supermatter
	name = "Supermatter alarm"
	desc = "An industrial rotating alarm light. This one is used to monitor supermatter engines."

	frame_type = /obj/item/frame/supermatter_alarm
	construct_state = /singleton/machine_construction/default/item_chassis
	base_type = /obj/machinery/rotating_alarm/supermatter

/obj/machinery/rotating_alarm/supermatter/Initialize()
	. = ..()
	GLOB.supermatter_status.register_global(src, .proc/check_supermatter)

/obj/machinery/rotating_alarm/supermatter/Destroy()
	GLOB.supermatter_status.unregister_global(src, .proc/check_supermatter)
	. = ..()

/obj/machinery/rotating_alarm/supermatter/proc/check_supermatter(obj/machinery/power/supermatter/SM, danger)
	if (SM)
		if (SM.z in GetConnectedZlevels(src.z))
			if (danger && !on)
				set_on()
			else if (!danger && on)
				set_off()
*/
