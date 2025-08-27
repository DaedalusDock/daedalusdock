#define MIRROR_WORLD_COPY_RADIUS 3

/datum/action/cooldown/spell/world_between
	name = "World Between"
	desc = "Step into the Between."
	button_icon_state = "lightning"

	invocation_type = INVOCATION_NONE
	school = SCHOOL_BLOOD
	spell_requirements = SPELL_REQUIRES_HUMAN|SPELL_CASTABLE_WITHOUT_INVOCATION

	var/datum/turf_reservation/reservation
	var/turf/mirror_center
	var/turf/cast_location

	var/reservation_clearing = FALSE
	var/in_mirror_world = FALSE

	/// All mobs (including the owner) inside the mirror world.
	var/list/mob/living/abducted_mobs = list()

	/// How long you can be in the mirror world before you're ripped out.
	var/mirror_world_time_limit = 1 MINUTE
	/// Timer id for ripping you out.
	var/force_return_timer_id

/datum/action/cooldown/spell/world_between/Destroy()
	. = ..()
	QDEL_NULL(reservation) // This needs to happen after the parent call so all mobs are freed before the reservation is wiped.

/datum/action/cooldown/spell/world_between/Grant(mob/granted_to)
	. = ..()
	if(!reservation)
		load_prefab()

/datum/action/cooldown/spell/world_between/Remove(mob/living/remove_from)
	. = ..()
	free_all_mobs()

/datum/action/cooldown/spell/world_between/IsAvailable(feedback)
	. = ..()
	if(!.)
		return FALSE

	return !!reservation && !reservation_clearing

/datum/action/cooldown/spell/world_between/proc/load_prefab()
	set waitfor = FALSE

	var/datum/map_template/template = SSmapping.map_templates["lucid_world.dmm"]
	var/datum/turf_reservation/_reservation = SSmapping.RequestBlockReservation(template.width, template.height)

	template.load(locate(_reservation.bottom_left_coords[1], _reservation.bottom_left_coords[2], _reservation.bottom_left_coords[3]))
	// Allows us to use the reservation == null for checking if the prefab is done loading.
	reservation = _reservation
	mirror_center = locate(
		round((reservation.top_right_coords[1] + reservation.bottom_left_coords[1]) / 2),
		round((reservation.top_right_coords[2] + reservation.bottom_left_coords[2]) / 2),
		reservation.bottom_left_coords[3],
	)

	for(var/turf/T as anything in RANGE_TURFS(MIRROR_WORLD_COPY_RADIUS, mirror_center))
		CHECK_TICK
		setup_turf_signals(T)

	build_all_button_icons(UPDATE_BUTTON_STATUS)

/// Resets the reservation, sleeps.
/datum/action/cooldown/spell/world_between/proc/reset_reservation()
	set waitfor = FALSE
	reservation_clearing = TRUE

	for(var/turf/T as anything in RANGE_TURFS(MIRROR_WORLD_COPY_RADIUS, mirror_center))
		CHECK_TICK
		for(var/atom/movable/AM as anything in T)
			CHECK_TICK
			qdel(AM, TRUE)

	reservation_clearing = FALSE
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/cooldown/spell/world_between/cast(atom/cast_on)
	. = ..()

	if(in_mirror_world)
		exit_mirror_world()
	else
		enter_mirror_world()

/datum/action/cooldown/spell/world_between/after_cast(atom/cast_on)
	. = ..()
	if(in_mirror_world)
		StartCooldown(10 SECONDS)

/datum/action/cooldown/spell/world_between/proc/enter_mirror_world()
	in_mirror_world = TRUE

	var/mob/living/carbon/human/caster = owner
	cast_location = get_turf(caster)

	playsound(cast_location, 'sound/effects/abilities/lucid_world/enter.ogg', 30, FALSE)

	var/list/prefab_turfs = spiral_range_turfs(MIRROR_WORLD_COPY_RADIUS, mirror_center)

	var/i = 0
	for(var/turf/T as anything in spiral_range_turfs(MIRROR_WORLD_COPY_RADIUS, cast_location))
		i++
		var/turf/between_turf = prefab_turfs[i]
		between_turf.appearance = T.appearance
		between_turf.opacity = FALSE

		var/object_count = 0
		for(var/obj/O in T.contents)
			if(O.alpha == 0 || O.invisibility)
				continue

			var/obj/effect/abstract/lucid_world/mimic_object = new(between_turf)
			mimic_object.appearance = O.appearance
			mimic_object.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			mimic_object.alpha = 200
			mimic_object.opacity = FALSE

			object_count++
			if(object_count > 3)
				break

	abduct_mob(caster)
	for(var/mob/living/L in caster.get_all_grab_chain_members() - caster)
		abduct_mob(L)

	force_return_timer_id = addtimer(CALLBACK(src, PROC_REF(force_exit_from_mirror_world)), mirror_world_time_limit, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/action/cooldown/spell/world_between/proc/exit_mirror_world()
	in_mirror_world = FALSE

	deltimer(force_return_timer_id)
	free_all_mobs()
	reset_reservation()
	playsound(owner, 'sound/effects/abilities/lucid_world/exit.ogg', 30, FALSE)

/// Called when you've been in the mirror world for too long.
/datum/action/cooldown/spell/world_between/proc/force_exit_from_mirror_world()
	exit_mirror_world()
	StartCooldown()

/// Setup turf signals for the mirror world.
/datum/action/cooldown/spell/world_between/proc/setup_turf_signals(turf/T)
	RegisterSignal(T, COMSIG_ATOM_ENTERED, PROC_REF(mirror_world_entered))

/// Cleanup turf signals for the mirror world.
/datum/action/cooldown/spell/world_between/proc/cleanup_turf_signals(turf/T)
	UnregisterSignal(T, list(
		COMSIG_ATOM_ENTERED,
	))

/// Yoink a mob and transport them to the mirror world.
/datum/action/cooldown/spell/world_between/proc/abduct_mob(mob/living/victim)
	abducted_mobs += victim
	victim.forceMoveWithGroup(mirror_center, FALSE)
	victim.add_client_colour(/datum/client_colour/flockcrazy/lucid_world)

	RegisterSignal(victim, list(COMSIG_LIVING_NO_LONGER_GRABBING, COMSIG_ATOM_NO_LONGER_GRABBED), PROC_REF(abducted_grab_release))
	RegisterSignal(victim, COMSIG_LIVING_DEATH, PROC_REF(abducted_mob_death_or_del))
	if(victim != owner)
		RegisterSignal(victim, COMSIG_PARENT_PREQDELETED, PROC_REF(abducted_mob_death_or_del))

	var/sound/static_loop = sound('sound/effects/abilities/lucid_world/static_loop.ogg', repeat = TRUE, channel = CHANNEL_LUCID_STATIC, volume = 8)
	SEND_SOUND(victim, static_loop)

/datum/action/cooldown/spell/world_between/proc/free_all_mobs()
	for(var/mob/living/L as anything in abducted_mobs)
		from_whence_thou_came(L, TRUE, TRUE)

/// Return a mob to the material plane, to the same turf they are on in the mirror world.
/datum/action/cooldown/spell/world_between/proc/from_whence_thou_came(atom/movable/returning, move_grab_chain = FALSE, retain_grabs = FALSE)
	if(isliving(returning))
		if(!(returning in abducted_mobs))
			return

		var/mob/living/returning_mob = returning

		abducted_mobs -= returning_mob
		UnregisterSignal(returning_mob, list(
			COMSIG_LIVING_NO_LONGER_GRABBING,
			COMSIG_ATOM_NO_LONGER_GRABBED,
			COMSIG_LIVING_DEATH,
			COMSIG_PARENT_PREQDELETED
		))

		returning_mob.remove_client_colour(/datum/client_colour/flockcrazy/lucid_world)
		var/sound/null_sound = sound(channel = CHANNEL_LUCID_STATIC)
		SEND_SOUND(returning_mob, null_sound)

	if(QDELETED(returning))
		return

	var/offset_x = returning.x - mirror_center.x
	var/offset_y = returning.y - mirror_center.y

	var/turf/return_destination = locate(
		cast_location.x + offset_x,
		cast_location.y + offset_y,
		cast_location.z
	)

	if(isclosedturf(return_destination))
		var/damage = 30
		var/list/nearby_turfs = RANGE_TURFS(1, return_destination) - return_destination
		while(length(nearby_turfs) && !isopenturf(return_destination))
			return_destination = pick_n_take(nearby_turfs)

		if(!isopenturf(return_destination)) // Fallback if you got stuck in a fucking 3x3 of walls
			damage = 50
			return_destination = cast_location

		to_chat(returning, span_danger("You are ripped back to the pool with soul-shattering force."))
		astype(returning, /mob/living)?.apply_damage(damage, BRUTE, BODY_ZONE_CHEST, spread_damage = TRUE)
		if(ishuman(returning))
			var/mob/living/carbon/human/returning_human = returning
			spawn(-1)
				returning_human.pain_emote(PAIN_AMT_AGONIZING)
			returning_human.Paralyze(8 SECONDS)

	if(retain_grabs)
		returning.forceMoveWithGroup(return_destination)
		if(move_grab_chain)
			for(var/mob/living/L in returning.get_all_grab_chain_members() - returning)
				from_whence_thou_came(L, FALSE, TRUE)

	else
		returning.forceMove(return_destination)

/// Called when source stops grabbing something or they stop being grabbed by someone.
/datum/action/cooldown/spell/world_between/proc/abducted_grab_release(mob/living/source)
	SIGNAL_HANDLER

	if(source == owner)
		return

	if(!(owner in source.get_all_grab_chain_members()))
		from_whence_thou_came(source)

/// Called when source dies or is deleted.
/datum/action/cooldown/spell/world_between/proc/abducted_mob_death_or_del(mob/living/source)
	SIGNAL_HANDLER

	if(source == owner)
		free_all_mobs()
		return

	from_whence_thou_came(source)

/datum/action/cooldown/spell/world_between/on_owner_or_target_delete(datum/ref)
	abducted_mob_death_or_del(ref)
	return ..()

/datum/action/cooldown/spell/world_between/proc/mirror_world_entered(turf/source, atom/movable/arrived, atom/old_loc, list/old_locs)
	SIGNAL_HANDLER

	if(isliving(arrived))
		return

	if(istype(arrived, /obj/effect/abstract/lucid_world))
		return

	from_whence_thou_came(arrived)

/area/lucid_world
	name = "The Between"
	area_flags = NOTELEPORT | HIDDEN_AREA

	area_lighting = AREA_LIGHTING_STATIC

	requires_power = FALSE
	has_gravity = TRUE

/turf/open/indestructible/lucid_world
	name = /turf/open/floor/flock::name
	icon = /turf/open/floor/flock::icon
	icon_state = /turf/open/floor/flock::icon_state
	base_icon_state = /turf/open/floor/flock::base_icon_state

	turf_flags = NOJAUNT

/turf/closed/indestructible/lucid_world
	name = /turf/closed/wall/flock::name
	icon = /turf/closed/wall/flock::icon
	icon_state = /turf/closed/wall/flock::icon_state
	base_icon_state = /turf/closed/wall/flock::base_icon_state

/obj/effect/abstract/lucid_world

#undef MIRROR_WORLD_COPY_RADIUS
