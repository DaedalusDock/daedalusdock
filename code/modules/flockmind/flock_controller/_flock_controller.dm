/datum/flock
	var/name = "BAD FLOCK"

	/// The master of the flock
	var/mob/camera/flock/overmind/overmind

	/// Cache of images used by notices.
	var/list/notice_images = list()
	/// A k:V list of atoms the Overmind has marked for conversion, where the value is TRUE
	var/list/marked_for_deconstruction = list()
	/// A k:V list of reserved_turf = TRUE.
	var/list/turf_reservations = list()
	/// A k:V list of flock mobs to their reserved turf.
	var/list/turf_reservations_by_flock = list()

	var/list/claimed_floors = list()
	var/list/claimed_walls = list()

	/// The bits
	var/list/bits = list()
	/// The drones
	var/list/drones = list()
	/// The traces
	var/list/traces = list()

	/// A k:v list of mob : details, contains enemy mobs.
	var/list/enemies = list()
	/// A k:V list of mob : TRUE, where mob is mobs that ai will ignore.
	var/list/ignores = list()

	/// A k:V list of client : image, see ping().
	var/list/active_pings = list()

	var/ui_tab = FLOCK_UI_DRONES

	//* STAT TRACKING *//
	var/stat_drones_made = 0
	var/stat_bits_made = 0
	var/stat_deaths = 0
	var/stat_resources_gained = 0
	var/stat_traces_made = 0
	var/stat_tiles_made = 0
	var/stat_structures_made = 0
	var/stat_highest_compute = 0

/datum/flock/New()
	name = flock_realname(FLOCK_TYPE_OVERMIND)
	create_hud_images()

/datum/flock/proc/convert_turf(turf/T)
	if(isnull(T))
		return

	free_turf(T)
	T = flock_convert_turf(T, src)

	if(isnull(T))
		return

	playsound(T, 'sound/items/deconstruct.ogg', 30, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	if(iswallturf(T))
		claimed_walls += T
	else
		claimed_floors += T

	T.AddComponent(/datum/component/flock_interest, src)
	SEND_SIGNAL(T, COMSIG_TURF_CLAIMED_BY_FLOCK, src)

/// Reserves a turf, making AI ignore it for the purposes of targetting.
/datum/flock/proc/reserve_turf(mob/living/simple_animal/flock/user, turf/target)
	if(turf_reservations_by_flock[user])
		return FALSE
	if(turf_reservations[target])
		return FALSE

	turf_reservations_by_flock[user] = target
	turf_reservations[target] = user
	add_notice(target, FLOCK_NOTICE_RESERVED)
	RegisterSignal(target, COMSIG_TURF_CHANGE, PROC_REF(reserved_turf_change))
	return TRUE

/// Free a turf from reservation, allowing AI to target it again. override_turf can be given to lookup the user if there isnt a user in this context.
/datum/flock/proc/free_turf(mob/living/simple_animal/flock/user, turf/override_turf)
	var/turf/to_free
	if(user)
		to_free = turf_reservations_by_flock[user]
	else
		user = turf_reservations[override_turf]
		if(isnull(user))
			return

		to_free = override_turf

	if(isnull(to_free))
		return

	remove_notice(to_free, FLOCK_NOTICE_RESERVED)
	remove_notice(to_free, FLOCK_NOTICE_PRIORITY)
	turf_reservations_by_flock -= user
	turf_reservations -= to_free
	marked_for_deconstruction -= to_free
	UnregisterSignal(to_free, COMSIG_TURF_CHANGE)

/// Returns TRUE if the given turf is not reserved.
/datum/flock/proc/is_turf_free(turf/T)
	return !turf_reservations[T]

/// Returns TRUE if the given mob is an enemy.
/datum/flock/proc/is_mob_enemy(mob/M)
	return enemies[M]

/// Returns TRUE if the given mob is ignored by the flock.
/datum/flock/proc/is_mob_ignored(mob/M)
	return ignores[M]

/datum/flock/proc/add_unit(mob/unit)
	if(isflocktrace(unit))
		traces += unit
		return

	if(isflockdrone(unit))
		drones += unit

	else if(isflockbit(unit))
		bits += unit

	RegisterSignal(unit, list(COMSIG_PARENT_QDELETING, COMSIG_LIVING_DEATH), PROC_REF(on_unit_death))
	unit.AddComponent(/datum/component/flock_interest, src)

/datum/flock/proc/free_unit(mob/unit)
	if(isflockdrone(unit))
		drones -= unit

	else if(isflockbit(unit))
		bits -= unit

	UnregisterSignal(unit, list(COMSIG_PARENT_QDELETING, COMSIG_LIVING_DEATH))
	free_turf(unit)
	qdel(unit.GetComponent(/datum/component/flock_interest))

/// Sets the flock's overmind
/datum/flock/proc/register_overmind(mob/camera/flock_overmind)
	overmind = flock_overmind

/// Updates a mob's enemy status. If they are already an enemy, their entry will be updated with new information.
/datum/flock/proc/update_enemy(atom/movable/enemy)
	if(is_mob_ignored(enemy))
		return FALSE

	for(var/mob/living/L in enemy.buckled_mobs)
		update_enemy(L)

	if(!isliving(enemy))
		return FALSE
	if(!enemies[enemy])
		RegisterSignal(enemy, COMSIG_PARENT_QDELETING, PROC_REF(on_enemy_gone))
		add_notice(enemy, FLOCK_NOTICE_ENEMY)
	enemies[enemy] = get_area_name(enemy)
	return TRUE

/datum/flock/proc/remove_enemy(atom/movable/enemy, skip_buckled)
	if(!skip_buckled)
		for(var/mob/living/L in enemy.buckled_mobs)
			remove_enemy(L)

	if(!isliving(enemy))
		return

	enemies -= enemy
	UnregisterSignal(enemy, COMSIG_PARENT_QDELETING)
	remove_notice(enemy, FLOCK_NOTICE_ENEMY)
	return

/datum/flock/proc/add_ignore(atom/movable/ignore)
	for(var/mob/living/L in ignore.buckled_mobs)
		add_ignore(L)

	if(!isliving(ignore))
		return

	if(!enemies[ignore])
		RegisterSignal(ignore, COMSIG_PARENT_QDELETING, PROC_REF(on_ignore_gone))
		add_notice(ignore, FLOCK_NOTICE_IGNORE)
	ignores[ignore] = TRUE

/datum/flock/proc/remove_ignore(atom/movable/ignore, skip_buckled)
	if(!skip_buckled)
		for(var/mob/living/L in ignore.buckled_mobs)
			add_ignore(L)

	if(!isliving(ignore))
		return

	ignores -= ignore
	remove_notice(ignore, FLOCK_NOTICE_IGNORE)
	UnregisterSignal(ignore, COMSIG_PARENT_QDELETING)

/datum/flock/proc/add_notice(atom/target, notice_type)
	var/image/I = image(notice_images[notice_type], loc = target)
	target.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/flock, notice_type, I, null, src)

/datum/flock/proc/remove_notice(atom/target, notice_type)
	target.remove_alt_appearance(notice_type)

/datum/flock/proc/get_priority_turfs(mob/living/simple_animal/flock/bird)
	if(!length(marked_for_deconstruction))
		return null

	return marked_for_deconstruction - turf_reservations

/datum/flock/proc/ping(turf/T, mob/camera/flock/pinger)
	var/message = "System interrupt. Designating new target: [T] in [get_area(T)]."
	flock_talk(pinger, message, src, TRUE, list("italics"))
	for(var/mob/camera/flock/ghost_bird in (traces + overmind))
		if(isnull(ghost_bird.client))
			continue

		ghost_bird.playsound_local(null, 'goon/sounds/flockmind/ping.ogg', 50, TRUE)
		#warn debug removed
		// if(ghost_bird == pinger)
		// 	continue

		var/image/pointer = flock_pointer(ghost_bird, T)
		//T._AddComponent(list(/datum/component/flock_ping, 5 SECONDS))

		animate(pointer, time = 3 SECONDS, alpha = 0)
		add_ping_image(ghost_bird.client, pointer, 3 SECONDS)

/datum/flock/proc/reserved_turf_change(datum/source)
	SIGNAL_HANDLER
	free_turf(override_turf = source)

/datum/flock/proc/add_ping_image(client/C, image/ping, duration)
	if(isnull(C))
		return

	C.images += ping
	active_pings[C] += list(ping)
	RegisterSignal(C, COMSIG_PARENT_QDELETING, PROC_REF(on_client_gone), override = TRUE)
	addtimer(CALLBACK(src, PROC_REF(cleanup_ping_images), C, ping), 3 SECONDS)

/datum/flock/proc/cleanup_ping_images(client/C, list/images_to_clean)
	if(isnull(C))
		return

	var/list/images = images_to_clean || active_pings[C]
	C.images -= images
	active_pings[C] -= images
	if(!length(active_pings[C]))
		active_pings -= C
		UnregisterSignal(C, COMSIG_PARENT_QDELETING)

/datum/flock/proc/on_client_gone(client/source)
	SIGNAL_HANDLER
	cleanup_ping_images()

/datum/flock/proc/on_unit_death(datum/source)
	SIGNAL_HANDLER
	free_unit(source)

/datum/flock/proc/on_enemy_gone(datum/source)
	SIGNAL_HANDLER
	remove_enemy(source, TRUE)

/datum/flock/proc/on_ignore_gone(datum/source)
	SIGNAL_HANDLER
	remove_ignore(source, TRUE)

/datum/flock/proc/create_hud_images()
	notice_images[FLOCK_NOTICE_RESERVED] = new /image{
		icon = 'goon/icons/mob/featherzone.dmi';
		icon_state = "frontier";
		plane = ABOVE_LIGHTING_PLANE
		appearance_flags = RESET_ALPHA | RESET_COLOR | PIXEL_SCALE;
	}

	notice_images[FLOCK_NOTICE_PRIORITY] = new /image{
		icon = 'goon/icons/mob/featherzone.dmi';
		icon_state = "frontier";
		plane = ABOVE_LIGHTING_PLANE
		appearance_flags = RESET_ALPHA | RESET_COLOR | PIXEL_SCALE;
	}

	notice_images[FLOCK_NOTICE_ENEMY] = new /image{
		icon = 'goon/icons/mob/featherzone.dmi';
		icon_state = "hazard";
		plane = ABOVE_LIGHTING_PLANE
		appearance_flags = RESET_ALPHA | RESET_COLOR | PIXEL_SCALE;
	}

	notice_images[FLOCK_NOTICE_IGNORE] = new /image{
		icon = 'goon/icons/mob/featherzone.dmi';
		icon_state = "ignore";
		plane = ABOVE_LIGHTING_PLANE
		appearance_flags = RESET_ALPHA | RESET_COLOR | PIXEL_SCALE;
	}

	notice_images[FLOCK_NOTICE_FLOCKMIND_CONTROL] = new /image{
		icon = 'goon/icons/mob/featherzone.dmi';
		icon_state = "flockmind_face";
		plane = ABOVE_LIGHTING_PLANE
		appearance_flags = RESET_ALPHA | RESET_COLOR | PIXEL_SCALE;
	}

	notice_images[FLOCK_NOTICE_FLOCKTRACE_CONTROL] = new /image{
		icon = 'goon/icons/mob/featherzone.dmi';
		icon_state = "flocktrace_face";
		plane = ABOVE_LIGHTING_PLANE
		appearance_flags = RESET_ALPHA | RESET_COLOR | PIXEL_SCALE;
	}
