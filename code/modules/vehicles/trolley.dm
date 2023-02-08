#define MAX_CARGO_LIMIT 3

/obj/vehicle/ridden/trolley
	name = "trolley"
	desc = "It's mostly used to move crates around in bulk."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "trolley_0"
	max_integrity = 150
	armor = list(MELEE = 0, BULLET = 0, LASER = 20, ENERGY = 0, BOMB = 10, BIO = 0, FIRE = 20, ACID = 0)
	var/amount_of_cargo = 0

/obj/vehicle/ridden/trolley/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_KEEP_DIRECTION_WHILE_PULLING, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_REJECT_INSERTION, INNATE_TRAIT)
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/trolley)
	var/handlebars = new /image{icon_state = "trolley_handlebars"; layer = MOB_BELOW_PIGGYBACK_LAYER}
	add_overlay(handlebars)

/obj/vehicle/ridden/trolley/atom_destruction(damage_flag)
	for(var/obj/structure/closet/crate/cargo in contents)
		cargo.forceMove(get_turf(src))
	. = ..()

// Needed so that the rider renders underneath the handlebars when riding but renders above it after disembarking.
/obj/vehicle/ridden/trolley/after_add_occupant(mob/M)
	. = ..()
	M.layer = VEHICLE_RIDING_LAYER

/obj/vehicle/ridden/trolley/after_remove_occupant(mob/M)
	. = ..()
	M.layer = MOB_LAYER

/obj/vehicle/ridden/trolley/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(!has_gravity())
		return

	playsound(src, 'sound/effects/roll.ogg', 40, TRUE)
	if(LAZYLEN(occupants))
		var/ran_over_mob = 0
		for(var/mob/living/carbon/victim in loc)
			ran_over_mob += run_over(victim)
		if(ran_over_mob)
			playsound(src, pick('sound/effects/wounds/crack1.ogg', 'sound/effects/wounds/crack2.ogg'), 40)
			animate(src, pixel_y = -4, time = 0.5 SECONDS, easing = SINE_EASING)
			animate(occupants[1], pixel_y = 4, time = 0.5 SECONDS, easing = SINE_EASING)

/obj/vehicle/ridden/trolley/examine(mob/user)
	. = ..()
	if(amount_of_cargo)
		. += "There [amount_of_cargo > 1 ? "are [amount_of_cargo] crates" : "is 1 crate" ] currently loaded on it."
	else if(LAZYLEN(occupants))
		. += "[occupants[1]] is riding it."

/obj/vehicle/ridden/trolley/MouseDrop_T(atom/dropped_atom, mob/living/user)
	if(isliving(dropped_atom))
		var/mob/living/buckling_mob = dropped_atom
		return ..(buckling_mob, user)

	if(istype(dropped_atom, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/new_cargo = dropped_atom

		if(LAZYLEN(occupants))
			to_chat(user, span_warning("You cannot load [new_cargo] whilst someone is riding [src]!"))
			return FALSE
		if(amount_of_cargo >= MAX_CARGO_LIMIT)
			to_chat(user, span_warning("[src] is at max capacity!"))
			return FALSE

		user.visible_message(
			span_notice("[user] begins to load [new_cargo] onto [src]..."),
			span_notice("You begin to load [new_cargo] onto [src]..."))
		if(do_after(user, new_cargo, 2 SECONDS))
			if(LAZYLEN(occupants))
				to_chat(user, span_warning("You cannot load [new_cargo] whilst someone is riding [src]!"))
				return FALSE
			if(amount_of_cargo >= MAX_CARGO_LIMIT)
				to_chat(user, span_warning("[src] is at max capacity!"))
				return FALSE

			to_chat(user, span_notice("You load [new_cargo] onto [src]."))
			load_cargo(new_cargo)
			return TRUE
		else
			to_chat(user, span_warning("You fail to load [new_cargo] onto [src]!"))
			return FALSE
	else
		if(HAS_TRAIT(dropped_atom, TRAIT_NODROP) || isturf(dropped_atom))
			return

		to_chat(user, span_warning("[dropped_atom] won't fit onto [src]!"))


/obj/vehicle/ridden/trolley/proc/load_cargo(obj/structure/closet/crate/cargo)
	cargo.close()
	cargo.forceMove(src)
	amount_of_cargo++
	icon_state = "trolley_[amount_of_cargo]"

/obj/vehicle/ridden/trolley/proc/unload_cargo(mob/living/user)
	if(!amount_of_cargo)
		to_chat(user, span_warning("[src] is empty!"))
		return
	//First In Last Out
	var/obj/structure/closet/crate/cargo = contents[amount_of_cargo]
	var/turf/deposit_turf = get_turf(get_step(src, dir))

	if(!deposit_turf.Enter(cargo))
		to_chat(user, span_warning("There's no space to unload from [src]!"))
		return

	cargo.forceMove(deposit_turf)
	user.visible_message(
		span_notice("[user] unloads [cargo] from [src]."),
		span_notice("You unload [cargo] from [src]."))
	amount_of_cargo--
	icon_state = "trolley_[amount_of_cargo]"

/obj/vehicle/ridden/trolley/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	unload_cargo(user)
	return TRUE

/obj/vehicle/ridden/trolley/is_user_buckle_possible(mob/living/target, mob/user, check_loc)
	if(!..())
		return FALSE
	if(amount_of_cargo)
		to_chat(user, span_warning("You cannot ride [src] whilst it has cargo!"))
		return FALSE

	return TRUE

/obj/vehicle/ridden/trolley/proc/run_over(mob/living/carbon/victim)
	log_combat(occupants[1], victim, "ran over with [src]")
	if(victim.stat == CONSCIOUS && prob(20))
		victim.emote("scream")
	victim.apply_damage(4)
	to_chat(victim, span_danger("You are crushed by [src]!"))
	return 1

#undef MAX_CARGO_LIMIT
