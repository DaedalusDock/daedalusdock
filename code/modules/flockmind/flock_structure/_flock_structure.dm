/obj/structure/flock
	name = "CALL A CODER AAAAAAAAAA"
	icon = 'goon/icons/mob/featherzone.dmi'
	anchored = TRUE
	density = TRUE

	max_integrity = 50
	armor = list(
		BLUNT = -20,
		PUNCTURE = -20,
		SLASH = -20,
		LASER = 80,
		ENERGY = 80,
		BOMB = 0,
		BIO = 100,
		FIRE = 80,
		ACID = 100,
	)

	var/datum/flock/flock

	var/flock_id
	/// Shown in the flockmind UI
	var/flock_desc

	/// How much juice it takes to construct
	var/resource_cost = 0
	/// How long it takes to build
	var/build_time = 0
	/// Is the tealprint cancellable
	var/cancellable = TRUE

	/// world.time this was created at
	var/spawn_time
	/// How much compute this structure provides to the Flock.
	var/compute_provided = 0

	/// Whether or not the turret is active. The state of the Flock can change this.
	var/active = FALSE
	/// The compute cost while active
	var/active_compute_cost = 0

	/// Allows flockdrones to pass through.
	var/allow_flockpass = TRUE

	COOLDOWN_DECLARE(scream_cd)

/obj/structure/flock/Initialize(mapload, datum/flock/join_flock)
	. = ..()

	spawn_time = world.time

	join_flock ||= get_default_flock()
	if(join_flock)
		join_flock.add_structure(src)
		AddComponent(/datum/component/flock_object, join_flock)

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_crossed),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	if(build_time)
		START_PROCESSING(SSobj, src)

/obj/structure/flock/Destroy()
	STOP_PROCESSING(SSobj, src)
	flock?.free_structure(src)
	return ..()

/obj/structure/flock/get_flock_id()
	return flock_id

/obj/structure/flock/proc/get_flock_data()
	. = list()
	.["ref"] = ref(src)
	.["name"] = flock_id
	.["health"] = get_integrity_percentage()
	.["compute"] = active ? -active_compute_cost : compute_provided
	.["desc"] = flock_desc
	.["area"] = get_area_name(src, TRUE) || "???"

/obj/structure/flock/deconstruct(disassembled)
	visible_message(span_alert("[src] dissolves into nothingness."))

	return ..()

/obj/structure/flock/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(allow_flockpass)
		return isflockdrone(mover)

/obj/structure/flock/try_flock_convert(datum/flock/flock, force)
	return

/obj/structure/flock/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(user.combat_mode)
		user.visible_message(span_danger("<b>[user]</b> punches <b>[src]."))
		user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
		//playsound(src, 'sound/impact_sounds/Crystal_Hit_1.ogg', 50, TRUE, -1)
		bitch_and_moan()
		take_damage(1, BRUTE, BLUNT)
		return TRUE

/obj/structure/flock/attacked_by(obj/item/attacking_item, mob/living/user)
	. = ..()
	if(!.)
		return

	bitch_and_moan()
	// if (. < 5)
	// 	playsound(src, 'sound/impact_sounds/Crystal_Hit_1.ogg', 50, TRUE)
	// else
	// 	playsound(src, 'sound/impact_sounds/Glass_Shards_Hit_1.ogg', 50, TRUE)

/obj/structure/flock/update_integrity(new_value)
	. = ..()
	if(isnull(.))
		return

	if(!flock)
		return

	var/datum/atom_hud/alternate_appearance/basic/flock/notice = get_alt_appearance(FLOCK_NOTICE_HEALTH)
	if(!notice)
		notice = flock.add_notice(src, FLOCK_NOTICE_HEALTH)

	var/image/I = notice.image
	I.icon_state = "hp-[get_integrity_percentage()]"


/obj/structure/flock/process(delta_time)
	if(spawn_time + build_time <= world.time)
		finish_building()
		return

/obj/structure/flock/proc/set_active(new_state)
	if(active == new_state)
		return

	active = new_state
	update_appearance(UPDATE_ICON_STATE)
	if(active)
		flock.remove_compute_influence(compute_provided)
		flock.add_compute_influence(-active_compute_cost)
	else
		flock.remove_compute_influence(-active_compute_cost)
		flock.add_compute_influence(compute_provided)

/// Called when an object finishes construction
/obj/structure/flock/proc/finish_building()
	SHOULD_CALL_PARENT(TRUE)
	STOP_PROCESSING(SSobj, src)

/obj/structure/flock/proc/on_crossed(atom/source, atom/movable/crosser)
	SIGNAL_HANDLER

	if(!allow_flockpass || !isflockdrone(crosser))
		return

	if(!HAS_TRAIT(crosser, TRAIT_FLOCKPHASE))
		animate_flockpass(crosser)

/obj/structure/flock/proc/bitch_and_moan()
	if(!COOLDOWN_FINISHED(src, scream_cd))
		return

	COOLDOWN_START(src, scream_cd, 10 SECONDS)
	flock_talk(src, "WARNING: Under attack", flock)
