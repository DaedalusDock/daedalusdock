/// Ratio of gas removed from the tank for every turf.
#define FLAMETHROWER_RELEASE_RATIO 0.05

TYPEINFO_DEF(/obj/item/flamethrower)
	default_materials = list(/datum/material/iron=500)

/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	inhand_icon_state = "flamethrower_0"
	lefthand_file = 'icons/mob/inhands/weapons/flamethrower_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flamethrower_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 3
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	trigger_guard = TRIGGER_GUARD_NORMAL
	light_system = OVERLAY_LIGHT
	light_on = FALSE
	var/status = FALSE
	var/lit = FALSE //on or off
	var/obj/item/weldingtool/weldtool = null
	var/obj/item/assembly/igniter/igniter = null
	var/obj/item/tank/internals/plasma/ptank = null
	var/warned_admins = FALSE //for the message_admins() when lit
	//variables for prebuilt flamethrowers
	var/create_full = FALSE
	var/create_with_tank = FALSE
	var/igniter_type = /obj/item/assembly/igniter
	var/acti_sound = 'sound/items/welderactivate.ogg'
	var/deac_sound = 'sound/items/welderdeactivate.ogg'

	/// Prevents fuel duping because im a lazy coder.
	COOLDOWN_DECLARE(use_cooldown)

/obj/item/flamethrower/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, ITEM_SLOT_HANDS)

	if(create_full)
		if(!weldtool)
			weldtool = new /obj/item/weldingtool(src)
		weldtool.status = FALSE

		if(!igniter)
			igniter = new igniter_type(src)

		igniter.secured = FALSE
		status = TRUE

		if(create_with_tank)
			ptank = new /obj/item/tank/internals/plasma/full(src)
		update_appearance()

	RegisterSignal(src, COMSIG_ITEM_RECHARGED, PROC_REF(instant_refill))

/obj/item/flamethrower/Destroy()
	if(weldtool)
		QDEL_NULL(weldtool)
	if(igniter)
		QDEL_NULL(igniter)
	if(ptank)
		QDEL_NULL(ptank)
	return ..()

/obj/item/flamethrower/process()
	if(!lit || !igniter)
		return PROCESS_KILL

	var/turf/location = loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.is_holding(src))
			location = M.loc
	if(isturf(location)) //start a fire if possible
		igniter.flamethrower_process(location)

/obj/item/flamethrower/update_icon_state()
	inhand_icon_state = "flamethrower_[lit]"
	return ..()

/obj/item/flamethrower/update_overlays()
	. = ..()
	if(igniter)
		. += "+igniter[status]"
	if(ptank)
		. += "+ptank"
	if(lit)
		. += "+lit"

/obj/item/flamethrower/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(flag)
		return // too close
	if(ishuman(user))
		if(!can_trigger_gun(user))
			return

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You can't bring yourself to fire \the [src]! You don't want to risk harming anyone..."))
		return

	if(user && user.get_active_held_item() == src) // Make sure our user is still holding us
		if(!lit || !ptank)
			return FALSE

		if(!COOLDOWN_FINISHED(src, use_cooldown))
			to_chat(user, span_danger("[src] is cooling down."))
			return FALSE

		var/turf/target_turf = get_turf(target)
		var/turf/our_turf = get_turf(src)
		if(!our_turf || !target_turf)
			return

		if(!check_flamethrower_fuel(ptank.return_air()?.copy().removeRatio(FLAMETHROWER_RELEASE_RATIO)))
			audible_message(span_danger("[src] sputters."))
			playsound(src, 'sound/weapons/gun/flamethrower/flamethrower_empty.ogg', 50, TRUE, -3)
			return

		playsound(
			src,
			pick('sound/weapons/gun/flamethrower/flamethrower1.ogg','sound/weapons/gun/flamethrower/flamethrower2.ogg','sound/weapons/gun/flamethrower/flamethrower3.ogg' ),
			50,
			TRUE,
			-3,
		)

		COOLDOWN_START(src, use_cooldown, 1 SECOND)

		log_combat(user, target, "flamethrowered", src)
		spew_fire(our_turf, target_turf)

/obj/item/flamethrower/wrench_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(status)
		return FALSE
	tool.play_tool_sound(src)
	var/turf/T = get_turf(src)
	if(weldtool)
		weldtool.forceMove(T)
		weldtool = null
	if(igniter)
		igniter.forceMove(T)
		igniter = null
	if(ptank)
		ptank.forceMove(T)
		ptank = null
	new /obj/item/stack/rods(T)
	qdel(src)

/obj/item/flamethrower/screwdriver_act(mob/living/user, obj/item/tool)
	if(igniter && !lit)
		tool.play_tool_sound(src)
		status = !status
		to_chat(user, span_notice("[igniter] is now [status ? "secured" : "unsecured"]!"))
		update_appearance()
		return TRUE

/obj/item/flamethrower/attackby(obj/item/W, mob/user, params)
	if(isigniter(W))
		var/obj/item/assembly/igniter/I = W
		if(I.secured)
			return
		if(igniter)
			return
		if(!user.transferItemToLoc(W, src))
			return
		igniter = I
		update_appearance()
		return

	else if(istype(W, /obj/item/tank/internals/plasma))
		if(ptank)
			if(user.transferItemToLoc(W,src))
				ptank.forceMove(get_turf(src))
				ptank = W
				to_chat(user, span_notice("You swap the plasma tank in [src]!"))
			return
		if(!user.transferItemToLoc(W, src))
			return
		ptank = W
		update_appearance()
		return

	else
		return ..()

/obj/item/flamethrower/return_analyzable_air()
	if(ptank)
		return ptank.return_analyzable_air()
	else
		return null

/obj/item/flamethrower/attack_self(mob/user)
	toggle_igniter(user)

/obj/item/flamethrower/AltClick(mob/user)
	if(ptank && isliving(user) && user.canUseTopic(src, USE_CLOSE|USE_NEED_HANDS|USE_DEXTERITY))
		user.put_in_hands(ptank)
		ptank = null
		to_chat(user, span_notice("You remove the plasma tank from [src]!"))
		update_appearance()

/obj/item/flamethrower/examine(mob/user)
	. = ..()
	if(ptank)
		. += span_notice("\The [src] has \a [ptank] attached. Alt-click to remove it.")

/obj/item/flamethrower/proc/toggle_igniter(mob/user)
	if(!ptank)
		to_chat(user, span_notice("Attach a plasma tank first!"))
		return
	if(!status)
		to_chat(user, span_notice("Secure the igniter first!"))
		return
	to_chat(user, span_notice("You [lit ? "extinguish" : "ignite"] [src]!"))
	lit = !lit
	if(lit)
		playsound(loc, acti_sound, 50, TRUE)
		START_PROCESSING(SSobj, src)
		if(!warned_admins)
			message_admins("[ADMIN_LOOKUPFLW(user)] has lit a flamethrower.")
			warned_admins = TRUE
	else
		playsound(loc, deac_sound, 50, TRUE)
		STOP_PROCESSING(SSobj,src)
	set_light_on(lit)
	update_appearance()

/obj/item/flamethrower/CheckParts(list/parts_list)
	..()
	weldtool = locate(/obj/item/weldingtool) in contents
	igniter = locate(/obj/item/assembly/igniter) in contents
	weldtool.status = FALSE
	igniter.secured = FALSE
	status = TRUE
	update_appearance()

/// Ignites every turf in the turf list, with a small gap between each.
/obj/item/flamethrower/proc/spew_fire(turf/starting_turf, turf/target_turf)
	var/list/turf_list = get_cone(
		starting_turf,
		max(get_dist(starting_turf, target_turf), 5),
		1,
		60,
		get_angle(starting_turf, target_turf),
		check_air_passability = TRUE,
	)

	flamethrower_recursive_ignite(turf_list, starting_turf, get_dist(get_turf(src), target_turf), ptank.return_air())

/// Global so that when the flamethrower stops existing we can keep spitting fire.
/proc/flamethrower_recursive_ignite(list/turfs, starting_turf, range = 1, datum/gas_mixture/released_gas, iteration = 1)
	if(!released_gas?.volume)
		return

	if(iteration > range)
		return

	for(var/turf/T as anything in turfs)
		if(get_dist(starting_turf, T) != iteration)
			continue

		var/datum/gas_mixture/release_iter = released_gas.removeRatio(FLAMETHROWER_RELEASE_RATIO)
		if(!check_flamethrower_fuel(release_iter))
			return

		flamethrower_ignite_turf(T, release_iter)

	iteration++

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(flamethrower_recursive_ignite), turfs, starting_turf, range, released_gas, iteration), 0.1 SECONDS)

/// Attempt to ignite a turf
/proc/flamethrower_ignite_turf(turf/target, datum/gas_mixture/air_transfer)
	if(isclosedturf(target) || isgroundlessturf(target))
		return FALSE

	var/reagent_amount = GASFUEL_AMOUNT_TO_LIQUID(air_transfer.getByFlag(XGM_GAS_FUEL))

	// Find or make the ignitable decal
	var/obj/effect/decal/cleanable/oil/l_fuel = locate() in target
	if(!l_fuel)
		l_fuel = new(target)
		l_fuel.reagents.clear_reagents()

	// Add the reagents to the fuel
	l_fuel.reagents.add_reagent(/datum/reagent/fuel/oil, reagent_amount)

	// Remove the actual fuel, we don't want to dump plasma into the air
	air_transfer.removeByFlag(XGM_GAS_FUEL, INFINITY)
	//Transfer the removed air to the turf
	target.assume_air(air_transfer)
	//Burn it based on transfered gas
	target.hotspot_expose((air_transfer.temperature*2) + 380, 500) // -- More of my "how do I shot fire?" dickery. -- TLE
	return TRUE

/// Returns TRUE if the given gas mixture is enough to ignite a fire.
/proc/check_flamethrower_fuel(datum/gas_mixture/checking_gas)
	if(!checking_gas?.volume)
		return FALSE

	if(checking_gas.getByFlag(XGM_GAS_FUEL) < FIRE_MINIMUM_FUEL_MOL_TO_EXIST)
		return FALSE

	return TRUE

/obj/item/flamethrower/proc/rupture_tank()
	if(!ptank)
		return

	var/list/turf_list = get_cone(get_turf(src), 4, -1, 359, 0, check_air_passability = TRUE)
	flamethrower_recursive_ignite(turf_list, get_turf(src), 5, ptank.return_air())
	qdel(ptank)
	update_appearance()

/obj/item/flamethrower/full
	create_full = TRUE

/obj/item/flamethrower/full/tank
	create_with_tank = TRUE

/obj/item/flamethrower/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0, attack_type = MELEE_ATTACK, block_success = TRUE)
	. = ..()
	if(!.)
		return

	var/obj/projectile/P = hitby
	if(ptank && damage && attack_type == PROJECTILE_ATTACK && P.damage_type != STAMINA && prob(15))
		owner.visible_message(span_danger("\The [attack_text] hits the fuel tank on [owner]'s [name], rupturing it! What a shot!"))
		var/turf/target_turf = get_turf(owner)
		log_game("A projectile ([hitby]) detonated a flamethrower tank held by [key_name(owner)] at [COORD(target_turf)]")
		rupture_tank()
		return 1 //It hit the flamethrower, not them


/obj/item/assembly/igniter/proc/flamethrower_process(turf/open/location)
	location.hotspot_expose(heat,2)

/obj/item/flamethrower/proc/instant_refill()
	SIGNAL_HANDLER
	if(ptank)
		var/datum/gas_mixture/tank_mix = ptank.return_air()
		tank_mix.setGasMoles(GAS_PLASMA,(10*ONE_ATMOSPHERE)*ptank.volume/(R_IDEAL_GAS_EQUATION*T20C))
		ptank = new /obj/item/tank/internals/plasma/full(src)
	update_appearance()

#undef FLAMETHROWER_RELEASE_RATIO
