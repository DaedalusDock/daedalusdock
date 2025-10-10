/obj/structure/flock/relay
	icon = 'goon/icons/obj/featherzone-160x160.dmi'
	icon_state = "structure-relay"

	name = "titanic polyhedron"
	desc = "The sight of the towering geodesic sphere fills you with dread. A thousand voices whisper to you."

	pixel_x = -64
	pixel_y = -64

	flock_desc = "Your goal and purpose. Defend it until it can broadcast the Signal."
	flock_id = "Signal Relay Broadcast Amplifier"

	max_integrity = 500
	move_resist = MOVE_FORCE_OVERPOWERING

	resource_cost = 750

	build_time = 3 SECONDS
	allow_flockpass = FALSE

	/// How long it takes until the signal is broadcast and the flock wins :D
	var/tmp/win_time = 360 SECONDS
	var/tmp/flock_won_da_game = FALSE

	/// Radius for turf conversion. Automatically increments during processing.
	var/tmp/conversion_radius = 1

	var/tmp/list/turfs_to_convert = list()

/obj/structure/flock/relay/Initialize(mapload, datum/flock/join_flock)
	. = ..()

	log_game("The Flock ([flock?.name || "NULL"]) has constructed a relay at [AREACOORD(src)].")
	SSshuttle.registerHostileEnvironment(src, FALSE)

	to_chat(
		flock.overmind,
		span_flocksay(span_big("You pool the collective processing power of The Flock to transmit The Signal. If the relay is destroyed, so to will be The Flock!"))
	)

	flock_talk(null, "THE RELAY HAS BEEN CONSTRUCTED! DEFEND IT AT ALL COSTS, BRING FORTH THE FULL BREADTH OF THE DIVINE FLOCK!", flock)

	addtimer(CALLBACK(src, PROC_REF(announce_relay)), 10 SECONDS)

	START_PROCESSING(SSprocessing, src)

/obj/structure/flock/relay/Destroy()
	SSshuttle.clearHostileEnvironment(src)
	STOP_PROCESSING(SSprocessing, src)
	if(flock && !flock_won_da_game)
		flock.game_over(completely_destroy = TRUE)
	turfs_to_convert = null
	return ..()

/obj/structure/flock/relay/do_hurt_animation()
	return

/obj/structure/flock/relay/process(delta_time)
	if(world.time >= (spawn_time + build_time + (win_time * 10)))
		lorimer_burst()
		return TRUE

	var/turf/base = get_turf(src)

	/// Get a chebyshev ring without gigantic list ops.
	if(!length(turfs_to_convert))
		for(var/xo in -conversion_radius to conversion_radius)
			var/turf/potential_turf = locate(base.x + xo, base.y + conversion_radius, base.z)
			if(potential_turf)
				turfs_to_convert += potential_turf

			potential_turf = locate(base.x - xo, base.y - conversion_radius, base.z)
			if(potential_turf)
				turfs_to_convert += potential_turf

		for(var/yo in -conversion_radius to conversion_radius)
			var/turf/potential_turf = locate(base.x + conversion_radius, base.y + yo, base.z)
			if(potential_turf)
				turfs_to_convert += potential_turf

			potential_turf = locate(base.x - conversion_radius, base.y - yo, base.z)
			if(potential_turf)
				turfs_to_convert += potential_turf

		conversion_radius++

	// Convert 5 turfs per second.
	for(var/i in 1 to min(5, length(turfs_to_convert)))
		var/turf/conversion_target = turfs_to_convert[length(turfs_to_convert)]
		turfs_to_convert.len--
		if(!isflockturf(conversion_target) && !isspaceturf(conversion_target) && !isopenspaceturf(conversion_target))
			flock.convert_turf(conversion_target)

/obj/structure/flock/relay/proc/alert_organics()
	var/list/z_levels = SSmapping.get_zstack(z)
	for(var/mob/M as anything in GLOB.player_list)
		var/turf/mob_turf = get_turf(M)
		if(mob_turf && (mob_turf.z in z_levels) && M.can_hear())
			M.playsound_local(loc, 'goon/sounds/flockmind/Flock_Reactor.ogg', 30, FALSE)
			to_chat(M, span_flocksay("<b>A horrible, otherworldly wave eminates from the <i>[dir2text(get_dir(mob_turf, loc))]</i>."))

/obj/structure/flock/relay/proc/announce_relay()
	var/message = stars("The Signal is coming.", 10)
	priority_announce(
		message,
		null,
		null,
		ANNOUNCER_SPANOMALIES,
		FALSE,
		TRUE,
	)

/// GG
/obj/structure/flock/relay/proc/lorimer_burst()
	flock_won_da_game = TRUE
