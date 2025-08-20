/datum/action/cooldown/spell/world_between
	name = "World Between"
	desc = "Step into the Between."
	button_icon_state = "lightning"

	invocation_type = INVOCATION_NONE
	school = SCHOOL_BLOOD
	spell_requirements = SPELL_REQUIRES_HUMAN|SPELL_CASTABLE_WITHOUT_INVOCATION

	var/datum/turf_reservation/reservation
	var/turf/center
	var/turf/cast_location

	var/reservation_clearing = FALSE

	var/list/mob/living/abducted_mobs = list()

/datum/action/cooldown/spell/world_between/Destroy()
	QDEL_NULL(reservation)
	return ..()

/datum/action/cooldown/spell/world_between/Grant(mob/granted_to)
	. = ..()
	if(!reservation)
		load_prefab()

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
	center = locate(
		round((reservation.top_right_coords[1] + reservation.bottom_left_coords[1]) / 2),
		round((reservation.top_right_coords[2] + reservation.bottom_left_coords[2]) / 2),
		reservation.bottom_left_coords[3],
	)

	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/cooldown/spell/world_between/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/caster = cast_on
	cast_location = get_turf(caster)

	var/list/prefab_turfs = spiral_range_turfs(2, center)

	var/i = 0
	for(var/turf/T as anything in spiral_range_turfs(2, cast_location))
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

/// Resets the reservation, sleeps.
/datum/action/cooldown/spell/world_between/proc/reset_reservation()
	set waitfor = FALSE
	reservation_clearing = TRUE

	for(var/turf/T as anything in RANGE_TURFS(2, center))
		CHECK_TICK
		T.empty(null)
		CHECK_TICK

	reservation_clearing = FALSE
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/cooldown/spell/world_between/proc/abduct_mob(mob/living/victim)
	abducted_mobs += victim
	victim.forceMoveWithGroup(center, FALSE)
	victim.add_client_colour(/datum/client_colour/flockcrazy/lucid_world)

	RegisterSignal(victim, list(COMSIG_LIVING_NO_LONGER_GRABBING, COMSIG_ATOM_NO_LONGER_GRABBED), PROC_REF(abducted_grab_release))
	RegisterSignal(victim, list(COMSIG_LIVING_DEATH, COMSIG_PARENT_QDELETING), PROC_REF(abducted_mob_death_or_del))

/// Return a mob to the material plane, to the same turf they are on in the mirror plane.
/datum/action/cooldown/spell/world_between/proc/from_whence_thou_came(mob/living/returning)
	if(!(returning in abducted_mobs))
		return

	abducted_mobs -= returning

	if(QDELETED(returning))
		return

	UnregisterSignal(returning, list(
		COMSIG_LIVING_NO_LONGER_GRABBING,
		COMSIG_ATOM_NO_LONGER_GRABBED,
		COMSIG_LIVING_DEATH,
		COMSIG_PARENT_QDELETING
	))

	var/offset_x = center.x - returning.x
	var/offset_y = center.y - returning.y

	var/turf/return_destination = locate(
		cast_location.x + offset_x,
		cast_location.y + offset_y,
		cast_location.z
	)

	returning.forceMove(return_destination)

/datum/action/cooldown/spell/world_between/proc/abducted_grab_release(mob/living/source)
	SIGNAL_HANDLER

	if(source == owner)
		return

	if(!(owner in source.get_all_grab_chain_members()))
		from_whence_thou_came(source)

/datum/action/cooldown/spell/world_between/proc/abducted_mob_death_or_del(mob/living/source)
	SIGNAL_HANDLER

	if(source == owner)
		for(var/mob/living/L as anything in abducted_mobs)
			from_whence_thou_came(L)
		return

	from_whence_thou_came(source)

#warn handle shit entering turfs that isnt the transported mobs so things dont get stuck from realspace

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

/turf/closed/indestructible/lucid_world
	name = /turf/closed/wall/flock::name
	icon = /turf/closed/wall/flock::icon
	icon_state = /turf/closed/wall/flock::icon_state
	base_icon_state = /turf/closed/wall/flock::base_icon_state

/obj/effect/abstract/lucid_world

