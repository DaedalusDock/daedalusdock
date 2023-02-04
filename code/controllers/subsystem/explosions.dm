#define EXPLOSION_THROW_SPEED 4
GLOBAL_LIST_EMPTY(explosions)

SUBSYSTEM_DEF(explosions)
	name = "Explosions"
	init_order = INIT_ORDER_EXPLOSIONS
	priority = FIRE_PRIORITY_EXPLOSIONS
	wait = 1
	flags = SS_TICKER
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/cost_lowturf = 0
	var/cost_medturf = 0
	var/cost_highturf = 0
	var/cost_flameturf = 0

	var/cost_throwturf = 0

	var/cost_low_mov_atom = 0
	var/cost_med_mov_atom = 0
	var/cost_high_mov_atom = 0

	var/list/lowturf = list()
	var/list/medturf = list()
	var/list/highturf = list()
	var/list/flameturf = list()

	var/list/throwturf = list()

	var/list/low_mov_atom = list()
	var/list/med_mov_atom = list()
	var/list/high_mov_atom = list()

	// Track how many explosions have happened.
	var/explosion_index = 0

	var/currentpart = SSEXPLOSIONS_MOVABLES

	var/iterative_explosions_z_threshold = 0
	var/iterative_explosions_z_multiplier = 0
	var/using_iterative = FALSE

/datum/controller/subsystem/explosions/Initialize(start_timeofday)
	. = ..()
	iterative_explosions_z_threshold = CONFIG_GET(number/iterative_explosions_z_threshold)
	iterative_explosions_z_multiplier = CONFIG_GET(number/iterative_explosions_z_multiplier)
	using_iterative = CONFIG_GET(flag/iterative_explosions)
	if(using_iterative)
		flags |= SS_NO_FIRE

/datum/controller/subsystem/explosions/stat_entry(msg)
	msg += "C:{"
	msg += "LT:[round(cost_lowturf,1)]|"
	msg += "MT:[round(cost_medturf,1)]|"
	msg += "HT:[round(cost_highturf,1)]|"
	msg += "FT:[round(cost_flameturf,1)]||"

	msg += "LO:[round(cost_low_mov_atom,1)]|"
	msg += "MO:[round(cost_med_mov_atom,1)]|"
	msg += "HO:[round(cost_high_mov_atom,1)]|"

	msg += "TO:[round(cost_throwturf,1)]"

	msg += "} "

	msg += "AMT:{"
	msg += "LT:[lowturf.len]|"
	msg += "MT:[medturf.len]|"
	msg += "HT:[highturf.len]|"
	msg += "FT:[flameturf.len]||"

	msg += "LO:[low_mov_atom.len]|"
	msg += "MO:[med_mov_atom.len]|"
	msg += "HO:[high_mov_atom.len]|"

	msg += "TO:[throwturf.len]"

	msg += "} "
	return ..()


#define SSEX_TURF "turf"
#define SSEX_OBJ "obj"

/datum/controller/subsystem/explosions/proc/is_exploding()
	return (lowturf.len || medturf.len || highturf.len || flameturf.len || throwturf.len || low_mov_atom.len || med_mov_atom.len || high_mov_atom.len)

/datum/controller/subsystem/explosions/proc/wipe_turf(turf/T)
	lowturf -= T
	medturf -= T
	highturf -= T
	flameturf -= T
	throwturf -= T

/client/proc/check_bomb_impacts()
	set name = "Check Bomb Impact"
	set category = "Debug"

	var/newmode = tgui_alert(usr, "Use reactionary explosions?","Check Bomb Impact", list("Yes", "No"))
	var/turf/epicenter = get_turf(mob)
	if(!epicenter)
		return

	var/dev = 0
	var/heavy = 0
	var/light = 0
	var/list/choices = list("Small Bomb","Medium Bomb","Big Bomb","Custom Bomb")
	var/choice = tgui_input_list(usr, "Pick the bomb size", "Bomb Size?", choices)
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			dev = 1
			heavy = 2
			light = 3
		if("Medium Bomb")
			dev = 2
			heavy = 3
			light = 4
		if("Big Bomb")
			dev = 3
			heavy = 5
			light = 7
		if("Custom Bomb")
			dev = input("Devastation range (Tiles):") as num
			heavy = input("Heavy impact range (Tiles):") as num
			light = input("Light impact range (Tiles):") as num

	var/max_range = max(dev, heavy, light)
	var/x0 = epicenter.x
	var/y0 = epicenter.y
	var/list/wipe_colours = list()
	for(var/turf/T in spiral_range_turfs(max_range, epicenter))
		wipe_colours += T
		var/dist = cheap_hypotenuse(T.x, T.y, x0, y0)

		if(newmode == "Yes")
			var/turf/TT = T
			while(TT != epicenter)
				TT = get_step_towards(TT,epicenter)
				if(TT.density)
					dist += TT.explosion_block

				for(var/obj/O in T)
					dist += GET_EXPLOSION_BLOCK(O)

		if(dist < dev)
			T.color = "red"
			T.maptext = MAPTEXT("Dev")
		else if (dist < heavy)
			T.color = "yellow"
			T.maptext = MAPTEXT("Heavy")
		else if (dist < light)
			T.color = "blue"
			T.maptext = MAPTEXT("Light")
		else
			continue

	addtimer(CALLBACK(GLOBAL_PROC, .proc/wipe_color_and_text, wipe_colours), 100)

/proc/wipe_color_and_text(list/atom/wiping)
	for(var/i in wiping)
		var/atom/A = i
		A.color = null
		A.maptext = ""

/**
 * Using default dyn_ex scale:
 *
 * 100 explosion power is a (5, 10, 20) explosion.
 * 75 explosion power is a (4, 8, 17) explosion.
 * 50 explosion power is a (3, 7, 14) explosion.
 * 25 explosion power is a (2, 5, 10) explosion.
 * 10 explosion power is a (1, 3, 6) explosion.
 * 5 explosion power is a (0, 1, 3) explosion.
 * 1 explosion power is a (0, 0, 1) explosion.
 *
 * Arguments:
 * * epicenter: Turf the explosion is centered at.
 * * power - Dyn explosion power. See reference above.
 * * flame_range: Flame range. Equal to the equivalent of the light impact range multiplied by this value.
 * * flash_range: The range at which the explosion flashes people. Equal to the equivalent of the light impact range multiplied by this value.
 * * adminlog: Whether to log the explosion/report it to the administration.
 * * ignorecap: Whether to ignore the relevant bombcap. Defaults to FALSE.
 * * flame_range: The range at which the explosion should produce hotspots.
 * * silent: Whether to generate/execute sound effects.
 * * smoke: Whether to generate a smoke cloud provided the explosion is powerful enough to warrant it.
 * * explosion_cause: [Optional] The atom that caused the explosion, when different to the origin. Used for logging.
 */
/proc/dyn_explosion(turf/epicenter, power, flame_range = 0, flash_range = null, adminlog = TRUE, ignorecap = TRUE, silent = FALSE, smoke = TRUE, atom/explosion_cause = null)
	if(!power)
		return
	var/range = 0
	range = round((2 * power)**GLOB.DYN_EX_SCALE)
	return explosion(epicenter, devastation_range = round(range * 0.25), heavy_impact_range = round(range * 0.5), light_impact_range = round(range), flame_range = flame_range*range, flash_range = flash_range*range, adminlog = adminlog, ignorecap = ignorecap, silent = silent, smoke = smoke, explosion_cause = explosion_cause)



/**
 * Makes a given atom explode.
 *
 * Arguments:
 * - [origin][/atom]: The atom that's exploding.
 * - devastation_range: The range at which the effects of the explosion are at their strongest.
 * - heavy_impact_range: The range at which the effects of the explosion are relatively severe.
 * - light_impact_range: The range at which the effects of the explosion are relatively weak.
 * - flash_range: The range at which the explosion flashes people.
 * - adminlog: Whether to log the explosion/report it to the administration.
 * - ignorecap: Whether to ignore the relevant bombcap. Defaults to FALSE.
 * - flame_range: The range at which the explosion should produce hotspots.
 * - silent: Whether to generate/execute sound effects.
 * - smoke: Whether to generate a smoke cloud provided the explosion is powerful enough to warrant it.
 * - explosion_cause: [Optional] The atom that caused the explosion, when different to the origin. Used for logging.
 */
/proc/explosion(atom/origin, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 0, flame_range = 0, flash_range = 0, adminlog = TRUE, ignorecap = FALSE, silent = FALSE, smoke = FALSE, atom/explosion_cause = null)
	return SSexplosions.iterative_explode(origin, (devastation_range * 2 + heavy_impact_range + light_impact_range))

/**
 * Makes a given atom explode. Now on the explosions subsystem!
 *
 * Arguments:
 * - [origin][/atom]: The atom that's exploding.
 * - devastation_range: The range at which the effects of the explosion are at their strongest.
 * - heavy_impact_range: The range at which the effects of the explosion are relatively severe.
 * - light_impact_range: The range at which the effects of the explosion are relatively weak.
 * - flash_range: The range at which the explosion flashes people.
 * - adminlog: Whether to log the explosion/report it to the administration.
 * - ignorecap: Whether to ignore the relevant bombcap. Defaults to FALSE.
 * - flame_range: The range at which the explosion should produce hotspots.
 * - silent: Whether to generate/execute sound effects.
 * - smoke: Whether to generate a smoke cloud provided the explosion is powerful enough to warrant it.
 * - explosion_cause: [Optional] The atom that caused the explosion, when different to the origin. Used for logging.
 */
/datum/controller/subsystem/explosions/proc/explode(atom/origin, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 0, flame_range = 0, flash_range = 0, adminlog = TRUE, ignorecap = FALSE, silent = FALSE, smoke = FALSE, atom/explosion_cause = null)
	var/list/arguments = list(
		EXARG_KEY_ORIGIN = origin,
		EXARG_KEY_DEV_RANGE = devastation_range,
		EXARG_KEY_HEAVY_RANGE = heavy_impact_range,
		EXARG_KEY_LIGHT_RANGE = light_impact_range,
		EXARG_KEY_FLAME_RANGE = flame_range,
		EXARG_KEY_FLASH_RANGE = flash_range,
		EXARG_KEY_ADMIN_LOG = adminlog,
		EXARG_KEY_IGNORE_CAP = ignorecap,
		EXARG_KEY_SILENT = silent,
		EXARG_KEY_SMOKE = smoke,
		EXARG_KEY_EXPLOSION_CAUSE = explosion_cause ? explosion_cause : origin,
	)
	var/atom/location = isturf(origin) ? origin : origin.loc
	if(SEND_SIGNAL(origin, COMSIG_ATOM_EXPLODE, arguments) & COMSIG_CANCEL_EXPLOSION)
		return COMSIG_CANCEL_EXPLOSION // Signals are incompatible with `arglist(...)` so we can't actually use that for these. Additionally,

	while(location)
		var/next_loc = location.loc
		if(SEND_SIGNAL(location, COMSIG_ATOM_INTERNAL_EXPLOSION, arguments) & COMSIG_CANCEL_EXPLOSION)
			return COMSIG_CANCEL_EXPLOSION
		if(isturf(location))
			break
		location = next_loc

	if(!location)
		return

	var/area/epicenter_area = get_area(location)
	if(SEND_SIGNAL(epicenter_area, COMSIG_AREA_INTERNAL_EXPLOSION, arguments) & COMSIG_CANCEL_EXPLOSION)
		return COMSIG_CANCEL_EXPLOSION

	arguments -= EXARG_KEY_ORIGIN

	propagate_blastwave(arglist(list(location) + arguments))

/**
 * Handles the effects of an explosion originating from a given point.
 *
 * Primarily handles popagating the balstwave of the explosion to the relevant turfs.
 * Also handles the fireball from the explosion.
 * Also handles the smoke cloud from the explosion.
 * Also handles sfx and screenshake.
 *
 * Arguments:
 * - [epicenter][/atom]: The location of the explosion rounded to the nearest turf.
 * - devastation_range: The range at which the effects of the explosion are at their strongest.
 * - heavy_impact_range: The range at which the effects of the explosion are relatively severe.
 * - light_impact_range: The range at which the effects of the explosion are relatively weak.
 * - flash_range: The range at which the explosion flashes people.
 * - adminlog: Whether to log the explosion/report it to the administration.
 * - ignorecap: Whether to ignore the relevant bombcap. Defaults to TRUE for some mysterious reason.
 * - flame_range: The range at which the explosion should produce hotspots.
 * - silent: Whether to generate/execute sound effects.
 * - smoke: Whether to generate a smoke cloud provided the explosion is powerful enough to warrant it.
 * - explosion_cause: The atom that caused the explosion. Used for logging.
 */


// Explosion SFX defines...
/// The probability that a quaking explosion will make the station creak per unit. Maths!
#define QUAKE_CREAK_PROB 30
/// The probability that an echoing explosion will make the station creak per unit.
#define ECHO_CREAK_PROB 5
/// Time taken for the hull to begin to creak after an explosion, if applicable.
#define CREAK_DELAY (5 SECONDS)
/// Lower limit for far explosion SFX volume.
#define FAR_LOWER 40
/// Upper limit for far explosion SFX volume.
#define FAR_UPPER 60
/// The probability that a distant explosion SFX will be a far explosion sound rather than an echo. (0-100)
#define FAR_SOUND_PROB 75
/// The upper limit on screenshake amplitude for nearby explosions.
#define NEAR_SHAKE_CAP 5
/// The upper limit on screenshake amplifude for distant explosions.
#define FAR_SHAKE_CAP 1.5
/// The duration of the screenshake for nearby explosions.
#define NEAR_SHAKE_DURATION (1.5 SECONDS)
/// The duration of the screenshake for distant explosions.
#define FAR_SHAKE_DURATION (1 SECONDS)
/// The lower limit for the randomly selected hull creaking frequency.
#define FREQ_LOWER 25
/// The upper limit for the randomly selected hull creaking frequency.
#define FREQ_UPPER 40

/**
 * Handles the sfx and screenshake caused by an explosion.
 *
 * Arguments:
 * - [epicenter][/turf]: The location of the explosion.
 * - near_distance: How close to the explosion you need to be to get the full effect of the explosion.
 * - far_distance: How close to the explosion you need to be to hear more than echos.
 * - quake_factor: Main scaling factor for screenshake.
 * - echo_factor: Whether to make the explosion echo off of very distant parts of the station.
 * - creaking: Whether to make the station creak. Autoset if null.
 * - [near_sound][/sound]: The sound that plays if you are close to the explosion.
 * - [far_sound][/sound]: The sound that plays if you are far from the explosion.
 * - [echo_sound][/sound]: The sound that plays as echos for the explosion.
 * - [creaking_sound][/sound]: The sound that plays when the station creaks during the explosion.
 * - [hull_creaking_sound][/sound]: The sound that plays when the station creaks after the explosion.
 */
/datum/controller/subsystem/explosions/proc/shake_the_room(turf/epicenter, near_distance, far_distance, quake_factor, echo_factor, creaking, sound/near_sound = sound(get_sfx(SFX_EXPLOSION)), sound/far_sound = sound('sound/effects/explosionfar.ogg'), sound/echo_sound = sound('sound/effects/explosion_distant.ogg'), sound/creaking_sound = sound(get_sfx(SFX_EXPLOSION_CREAKING)), hull_creaking_sound = sound(get_sfx(SFX_HULL_CREAKING)))
	var/frequency = get_rand_frequency()
	var/blast_z = epicenter.z
	if(isnull(creaking)) // Autoset creaking.
		var/on_station = SSmapping.level_trait(epicenter.z, ZTRAIT_STATION)
		if(on_station && prob((quake_factor * QUAKE_CREAK_PROB) + (echo_factor * ECHO_CREAK_PROB))) // Huge explosions are near guaranteed to make the station creak and whine, smaller ones might.
			creaking = TRUE // prob over 100 always returns true
		else
			creaking = FALSE

	for(var/mob/listener as anything in GLOB.player_list)
		var/turf/listener_turf = get_turf(listener)
		if(!listener_turf || listener_turf.z != blast_z)
			continue

		var/distance = get_dist(epicenter, listener_turf)
		if(epicenter == listener_turf)
			distance = 0
		var/base_shake_amount = sqrt(near_distance / (distance + 1))

		if(distance <= round(near_distance + world.view - 2, 1)) // If you are close enough to see the effects of the explosion first-hand (ignoring walls)
			listener.playsound_local(epicenter, null, 100, TRUE, frequency, sound_to_use = near_sound)
			if(base_shake_amount > 0)
				shake_camera(listener, NEAR_SHAKE_DURATION, clamp(base_shake_amount, 0, NEAR_SHAKE_CAP))

		else if(distance < far_distance) // You can hear a far explosion if you are outside the blast radius. Small explosions shouldn't be heard throughout the station.
			var/far_volume = clamp(far_distance / 2, FAR_LOWER, FAR_UPPER)
			if(creaking)
				listener.playsound_local(epicenter, null, far_volume, TRUE, frequency, sound_to_use = creaking_sound, distance_multiplier = 0)
			else if(prob(FAR_SOUND_PROB)) // Sound variety during meteor storm/tesloose/other bad event
				listener.playsound_local(epicenter, null, far_volume, TRUE, frequency, sound_to_use = far_sound, distance_multiplier = 0)
			else
				listener.playsound_local(epicenter, null, far_volume, TRUE, frequency, sound_to_use = echo_sound, distance_multiplier = 0)

			if(base_shake_amount || quake_factor)
				base_shake_amount = max(base_shake_amount, quake_factor * 3, 0) // Devastating explosions rock the station and ground
				shake_camera(listener, FAR_SHAKE_DURATION, min(base_shake_amount, FAR_SHAKE_CAP))

		else if(!isspaceturf(listener_turf) && echo_factor) // Big enough explosions echo through the hull.
			var/echo_volume
			if(quake_factor)
				echo_volume = 60
				shake_camera(listener, FAR_SHAKE_DURATION, clamp(quake_factor / 4, 0, FAR_SHAKE_CAP))
			else
				echo_volume = 40
			listener.playsound_local(epicenter, null, echo_volume, TRUE, frequency, sound_to_use = echo_sound, distance_multiplier = 0)

		if(creaking) // 5 seconds after the bang, the station begins to creak
			addtimer(CALLBACK(listener, /mob/proc/playsound_local, epicenter, null, rand(FREQ_LOWER, FREQ_UPPER), TRUE, frequency, null, null, FALSE, hull_creaking_sound, 0), CREAK_DELAY)

#undef CREAK_DELAY
#undef QUAKE_CREAK_PROB
#undef ECHO_CREAK_PROB
#undef FAR_UPPER
#undef FAR_LOWER
#undef FAR_SOUND_PROB
#undef NEAR_SHAKE_CAP
#undef FAR_SHAKE_CAP
#undef NEAR_SHAKE_DURATION
#undef FAR_SHAKE_DURATION
#undef FREQ_UPPER
#undef FREQ_LOWER


#define EXPLFX_BOTH 3
#define EXPLFX_SOUND 2
#define EXPLFX_SHAKE 1
#define EXPLFX_NONE 0

// All the vars used on the turf should be on unsimulated turfs too, we just don't care about those generally.
#define SEARCH_DIR(dir) \
	search_direction = dir;\
	search_turf = get_step(current_turf, search_direction);\
	if (isturf(search_turf)) {\
		turf_queue += search_turf;\
		dir_queue += search_direction;\
		power_queue += current_power;\
	}

/datum/controller/subsystem/explosions/proc/iterative_explode(turf/epicenter, power, z_transfer, atom/explosion_cause, admin_log = TRUE)
	set waitfor = FALSE

	if(power <= 0)
		return

	if(try_cancel_explosion(epicenter) & COMSIG_CANCEL_EXPLOSION)
		return

	epicenter = get_turf(epicenter)
	if(!epicenter)
		return

	if(admin_log)
		find_and_log_explosion_source(epicenter, explosion_cause, power)


	if(power > 12)
		SSblackbox.record_feedback("amount", "devastating_booms", 1)

	log_game("iexpl: Beginning discovery phase.")
	var/time = REALTIMEOFDAY
	var/list/act_turfs = list()
	act_turfs[epicenter] = power

	power -= GET_ITERATIVE_EXPLOSION_BLOCK(epicenter)
	for (var/obj/O in epicenter)
		if (O.iterative_explosion_block)
			power -= GET_ITERATIVE_EXPLOSION_BLOCK(O)

	if (power >= iterative_explosions_z_threshold)
		if ((z_transfer & UP))
			var/turf/above = SSmapping.get_turf_above(epicenter)
			if(!isnull(above))
				iterative_explode(above, power * iterative_explosions_z_multiplier, UP)
		if ((z_transfer & DOWN))
			var/turf/below = SSmapping.get_turf_below(epicenter)
			if(!isnull(below))
				iterative_explode(below, power * iterative_explosions_z_multiplier, DOWN)

	// These three lists must always be the same length.
	var/list/turf_queue = list(epicenter, epicenter, epicenter, epicenter)
	var/list/dir_queue = list(NORTH, SOUTH, EAST, WEST)
	var/list/power_queue = list(power, power, power, power)

	var/turf/current_turf
	var/turf/search_turf
	var/origin_direction
	var/search_direction
	var/current_power
	var/index = 1
	while (index <= turf_queue.len)
		current_turf = turf_queue[index]
		origin_direction = dir_queue[index]
		current_power = power_queue[index]
		++index

		if (!istype(current_turf) || current_power <= 0)
			CHECK_TICK
			continue

		if (act_turfs[current_turf] >= current_power && current_turf != epicenter)
			CHECK_TICK
			continue

		act_turfs[current_turf] = current_power
		current_power -= GET_ITERATIVE_EXPLOSION_BLOCK(current_turf)

		// Attempt to shortcut on empty tiles: if a turf only has a LO on it, we don't need to check object resistance. Some turfs might not have LOs, so we need to check it actually has one.
		if (length(current_turf.contents))
			for (var/obj/O as anything in current_turf)
				if (O.iterative_explosion_block)
					power -= GET_ITERATIVE_EXPLOSION_BLOCK(O)

		if (current_power <= 0)
			CHECK_TICK
			continue

		SEARCH_DIR(origin_direction)
		SEARCH_DIR(turn(origin_direction, 90))
		SEARCH_DIR(turn(origin_direction, -90))

		CHECK_TICK

	log_game("iexpl: Discovery completed in [(REALTIMEOFDAY-time)/10] seconds.")
	log_game("iexpl: Beginning SFX phase.")
	time = REALTIMEOFDAY

	var/volume = 10 + (power * 20)

	var/frequency = get_rand_frequency()
	var/close_dist = round(power + world.view - 2, 1)

	var/sound/explosion_sound = sound(get_sfx(SFX_EXPLOSION))

	for (var/mob/M as anything in GLOB.player_list)
		var/reception = EXPLFX_BOTH
		var/turf/T = isturf(M.loc) ? M.loc : get_turf(M)

		if (!T)
			CHECK_TICK
			continue

		if (!SSmapping.are_same_zstack(T.z, epicenter.z))
			CHECK_TICK
			continue

		if (istype(T, /turf/open/space) || istype(T, /turf/open/openspace))
			reception = EXPLFX_NONE

			for (var/turf/neighbor as anything in RANGE_TURFS(1, M))
				if(!(istype(neighbor, /turf/open/space) || istype(neighbor, /turf/open/openspace)))
					reception |= EXPLFX_SHAKE
					break

			if (!reception)
				CHECK_TICK
				continue

		var/dist = get_dist(M, epicenter) || 1
		if ((reception & EXPLFX_SOUND) && M.can_hear())
			if (dist <= close_dist)
				M.playsound_local(epicenter, explosion_sound, min(100, volume), 1, frequency, falloff_exponent = 5)
				//You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.
			else
				volume = M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', volume, 1, frequency, falloff_exponent = 1000)

		if ((reception & EXPLFX_SHAKE) && volume > 0)
			shake_camera(M, min(30, max(2,(power*2) / dist)), min(3.5, ((power/3) / dist)),0.05)
			//Maximum duration is 3 seconds, and max strength is 3.5
			//Becuse values higher than those just get really silly

		CHECK_TICK

	log_game("iexpl: SFX phase completed in [(REALTIMEOFDAY-time)/10] seconds.")
	log_game("iexpl: Beginning application phase.")
	time = REALTIMEOFDAY

	var/turf_tally = 0
	var/movable_tally = 0
	for (var/turf/T as anything in act_turfs)
		if (act_turfs[T] <= 0)
			CHECK_TICK
			continue

		var/severity = 4 - round(max(min( 3, ((act_turfs[T] - T.explosion_block) / (max(3,(power/3)))) ) ,1), 1)
		//sanity			effective power on tile				divided by either 3 or one third the total explosion power
		//															One third because there are three power levels and I
		//															want each one to take up a third of the crater
		var/throw_target = get_edge_target_turf(T, get_dir(epicenter,T))
		var/throw_dist = 9/severity
		if (T.simulated)
			EX_ACT(T, severity)
		if (length(T.contents))
			for (var/atom/movable/AM as anything in T)
				if (AM.simulated)
					EX_ACT(AM, severity)
					if(!QDELETED(AM) && !AM.anchored)
						addtimer(CALLBACK(AM, /atom/movable/.proc/throw_at, throw_target, throw_dist, throw_dist), 0)
				movable_tally++
				CHECK_TICK
		else
			CHECK_TICK

		turf_tally++

	//SEND_GLOBAL_SIGNAL(COMSIG_GLOB_EXPLOSION, epicenter, devastation_range, heavy_impact_range, light_impact_range, took, orig_dev_range, orig_heavy_range, orig_light_range, explosion_cause, explosion_index)
	log_game("iexpl: Application completed in [(REALTIMEOFDAY-time)/10] seconds; processed [turf_tally] turfs and [movable_tally] movables.")


#undef SEARCH_DIR
#undef EXPLFX_BOTH
#undef EXPLFX_SOUND
#undef EXPLFX_SHAKE
#undef EXPLFX_NONE

/datum/controller/subsystem/explosions/proc/find_and_log_explosion_source(turf/epicenter, atom/explosion_cause, power)
	// Now begins a bit of a logic train to find out whodunnit.
	var/who_did_it = "N/A"
	var/who_did_it_game_log = "N/A"

	// Projectiles have special handling. They rely on a firer var and not fingerprints. Check special cases for firer being
	// mecha, mob or an object such as the gun itself. Handle each uniquely.
	if(isprojectile(explosion_cause))
		var/obj/projectile/fired_projectile = explosion_cause
		if(ismecha(fired_projectile.firer))
			var/obj/vehicle/sealed/mecha/firing_mecha = fired_projectile.firer
			var/list/mob/drivers = firing_mecha.return_occupants()
			if(length(drivers))
				who_did_it = "\[Mecha drivers:"
				who_did_it_game_log = "\[Mecha drivers:"
				for(var/mob/driver in drivers)
					who_did_it += " [ADMIN_LOOKUPFLW(driver)]"
					who_did_it_game_log = " [key_name(driver)]"
				who_did_it += "\]"
				who_did_it_game_log += "\]"
		else if(ismob(fired_projectile.firer))
			who_did_it = "\[Projectile firer: [ADMIN_LOOKUPFLW(fired_projectile.firer)]\]"
			who_did_it_game_log = "\[Projectile firer: [key_name(fired_projectile.firer)]\]"
		else
			who_did_it = "\[Projectile firer: [ADMIN_LOOKUPFLW(fired_projectile.firer.fingerprintslast)]\]"
			who_did_it_game_log = "\[Projectile firer: [key_name(fired_projectile.firer.fingerprintslast)]\]"
	// Otherwise if the explosion cause is an atom, try get the fingerprints.
	else if(istype(explosion_cause))
		who_did_it = ADMIN_LOOKUPFLW(explosion_cause.fingerprintslast)
		who_did_it_game_log = key_name(explosion_cause.fingerprintslast)

	message_admins("Explosion with size [power]) in [ADMIN_VERBOSEJMP(epicenter)]. Possible cause: [explosion_cause]. Last fingerprints: [who_did_it].")
	log_game("Explosion with size [power] in [loc_name(epicenter)].  Possible cause: [explosion_cause]. Last fingerprints: [who_did_it_game_log].")

/datum/controller/subsystem/explosions/proc/try_cancel_explosion(atom/origin)
	var/atom/location = isturf(origin) ? origin : origin.loc
	if(SEND_SIGNAL(origin, COMSIG_ATOM_EXPLODE, arguments) & COMSIG_CANCEL_EXPLOSION)
		return COMSIG_CANCEL_EXPLOSION // Signals are incompatible with `arglist(...)` so we can't actually use that for these. Additionally,

	while(location)
		var/next_loc = location.loc
		if(SEND_SIGNAL(location, COMSIG_ATOM_INTERNAL_EXPLOSION, arguments) & COMSIG_CANCEL_EXPLOSION)
			return COMSIG_CANCEL_EXPLOSION
		if(isturf(location))
			break
		location = next_loc

	if(!location)
		return

	var/area/epicenter_area = get_area(location)
	if(SEND_SIGNAL(epicenter_area, COMSIG_AREA_INTERNAL_EXPLOSION, arguments) & COMSIG_CANCEL_EXPLOSION)
		return COMSIG_CANCEL_EXPLOSION
