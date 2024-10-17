/// Max number of unanchored items that will be moved from a tile when attempting to add a window to a grille.
#define CLEAR_TILE_MOVE_LIMIT 20

/obj/structure/grille
	desc = "A flimsy framework of iron rods."
	name = "grille"
	icon = 'icons/obj/smooth_structures/grille.dmi'
	icon_state = "grille-0"
	base_icon_state = "grille"
	color = "#545454"
	density = TRUE
	anchored = TRUE
	pass_flags_self = PASSGRILLE
	can_atmos_pass = CANPASS_ALWAYS
	flags_1 = CONDUCT_1
	//pressure_resistance = 5*ONE_ATMOSPHERE
	armor = list(BLUNT = 50, PUNCTURE = 70, SLASH = 90, LASER = 70, ENERGY = 100, BOMB = 10, BIO = 100, FIRE = 0, ACID = 0)
	max_integrity = 50
	integrity_failure = 0.4
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_GRILLE
	canSmoothWith = SMOOTH_GROUP_GRILLE
	var/rods_type = /obj/item/stack/rods
	var/rods_amount = 2
	var/rods_broken = TRUE

/obj/structure/grille/Initialize(mapload)
	. = ..()
	become_atmos_sensitive()

/obj/structure/grille/Destroy()
	update_cable_icons_on_turf(get_turf(src))
	lose_atmos_sensitivity()
	return ..()

/obj/structure/grille/update_appearance(updates)
	if(QDELETED(src))
		return
	. = ..()

/obj/structure/grille/update_icon_state()
	. = ..()
	if(broken)
		icon_state = "brokengrille"

/obj/structure/grille/set_smoothed_icon_state(new_junction)
	if(broken)
		return
	return ..()

/obj/structure/grille/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("It's secured in place with <b>screws</b>. The rods look like they could be <b>cut</b> through.")
	if(!anchored)
		. += span_notice("The anchoring screws are <i>unscrewed</i>. The rods look like they could be <b>cut</b> through.")

/obj/structure/grille/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 5)
		if(RCD_WINDOWGRILLE)
			var/cost = 8
			var/delay = 2 SECONDS

			if(the_rcd.window_glass == RCD_WINDOW_REINFORCED)
				delay = 4 SECONDS
				cost = 12

			return rcd_result_with_memory(
				list("mode" = RCD_WINDOWGRILLE, "delay" = delay, "cost" = cost),
				get_turf(src), RCD_MEMORY_WINDOWGRILLE,
			)
	return FALSE

/obj/structure/grille/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct the grille."))
			qdel(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			if(!isturf(loc))
				return FALSE
			var/turf/T = loc

			if(repair_grille())
				to_chat(user, span_notice("You rebuild the broken grille."))

			if(!ispath(the_rcd.window_type, /obj/structure/window))
				CRASH("Invalid window path type in RCD: [the_rcd.window_type]")
			var/obj/structure/window/window_path = the_rcd.window_type
			if(!valid_window_location(T, user.dir, is_fulltile = initial(window_path.fulltile)))
				return FALSE
			to_chat(user, span_notice("You construct the window."))
			var/obj/structure/window/WD = new the_rcd.window_type(T, user.dir)
			WD.set_anchored(TRUE)
			return TRUE
	return FALSE

/obj/structure/grille/BumpedBy(atom/movable/AM)
	if(!ismob(AM))
		return
	var/mob/M = AM
	shock(M, 70, M.get_empty_held_index() ? SHOCK_HANDS : SHOCK_USE_AVG_SIEMENS)

/obj/structure/grille/attack_animal(mob/user, list/modifiers)
	. = ..()
	if(!.)
		return
	if(!shock(user, 70) && !QDELETED(src)) //Last hit still shocks but shouldn't deal damage to the grille
		take_damage(rand(5,10), BRUTE, BLUNT, 1)

/obj/structure/grille/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/grille/hulk_damage()
	return 60

/obj/structure/grille/attack_hulk(mob/living/carbon/human/user)
	if(shock(user, 70))
		return
	. = ..()

/obj/structure/grille/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message(span_warning("[user] hits [src]."), null, null, COMBAT_MESSAGE_RANGE)
	log_combat(user, src, "hit")
	if(!shock(user, 70))
		take_damage(rand(5,10), BRUTE, BLUNT, 1)

/obj/structure/grille/attack_alien(mob/living/user, list/modifiers)
	user.do_attack_animation(src)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_warning("[user] mangles [src]."), null, null, COMBAT_MESSAGE_RANGE)
	if(!shock(user, 70))
		take_damage(20, BRUTE, BLUNT, 1)

/obj/structure/grille/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!. && istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/grille/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!density)
		return TRUE

	if(pass_info.pass_flags & PASSGRILLE)
		return TRUE
	return FALSE

/obj/structure/grille/wirecutter_act(mob/living/user, obj/item/tool)
	add_fingerprint(user)
	if(shock(user, 100))
		return
	tool.play_tool_sound(src, 100)
	deconstruct()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/grille/screwdriver_act(mob/living/user, obj/item/tool)
	if(!isturf(loc) || !anchored)
		return FALSE
	add_fingerprint(user)
	if(shock(user, 90))
		return FALSE
	tool.play_tool_sound(src, 100)
	set_anchored(!anchored)
	user.visible_message(span_notice("[user] [anchored ? "fastens" : "unfastens"] [src]."), \
		span_notice("You [anchored ? "fasten [src] to" : "unfasten [src] from"] the floor."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/grille/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	W.leave_evidence(user, src)
	if(istype(W, /obj/item/stack/rods) && broken)
		if(shock(user, 90))
			return
		var/obj/item/stack/rods/R = W
		user.visible_message(span_notice("[user] rebuilds the broken grille."), \
			span_notice("You rebuild the broken grille."))
		repair_grille()
		R.use(1)
		return TRUE

	//Try place window on the grille if the sheet supports it
	else if(istype(W, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/my_sheet = W
		if(my_sheet.try_install_window(user, src.loc, src))
			return TRUE

	else if(istype(W, /obj/item/shard) || !shock(user, 70))
		return ..()

/obj/structure/grille/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'sound/effects/grillehit.ogg', 80, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 80, TRUE)


/obj/structure/grille/deconstruct(disassembled = TRUE)
	if(!loc) //if already qdel'd somehow, we do nothing
		return
	if(!(flags_1&NODECONSTRUCT_1))
		var/obj/R = new rods_type(drop_location(), rods_amount)
		transfer_fingerprints_to(R)
		qdel(src)
	..()

/obj/structure/grille/atom_break()
	. = ..()
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		set_density(FALSE)
		atom_integrity = 20
		broken = TRUE
		rods_amount = 1
		rods_broken = FALSE
		var/obj/R = new rods_type(drop_location(), rods_broken)
		if(!QDELING(R))
			transfer_fingerprints_to(R)
		smoothing_flags = NONE
		update_appearance()

/obj/structure/grille/proc/repair_grille()
	if(broken)
		set_density(TRUE)
		atom_integrity = max_integrity
		broken = FALSE
		rods_amount = 2
		rods_broken = TRUE
		smoothing_flags = SMOOTH_BITMASK
		update_appearance()
		return TRUE
	return FALSE

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user, prb, shock_flags = SHOCK_HANDS)
	if(!anchored || broken) // anchored/broken grilles are never connected
		return FALSE
	if(!prob(prb))
		return FALSE
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src, 1, TRUE, shock_flags = shock_flags))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			return TRUE
		else
			return FALSE
	return FALSE

/obj/structure/grille/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	if(exposed_temperature > T0C + 1500 && !broken)
		take_damage(1, BURN, 0, 0)

/obj/structure/grille/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isobj(AM))
		if(prob(50) && anchored && !broken)
			var/obj/O = AM
			if(O.throwforce != 0)//don't want to let people spam tesla bolts, this way it will break after time
				var/turf/T = get_turf(src)
				var/obj/structure/cable/C = T.get_cable_node()
				if(C)
					playsound(src, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
					tesla_zap(src, 3, C.newavail() * 0.01, ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN | ZAP_LOW_POWER_GEN | ZAP_ALLOW_DUPLICATES) //Zap for 1/100 of the amount of power. At a million watts in the grid, it will be as powerful as a tesla revolver shot.
					C.add_delayedload(C.newavail() * 0.0375) // you can gain up to 3.5 via the 4x upgrades power is halved by the pole so thats 2x then 1X then .5X for 3.5x the 3 bounces shock.
	return ..()

/obj/structure/grille/zap_act(power, zap_flags)
	if(!anchored)
		return ..()

	var/turf/turfloc = loc
	var/obj/structure/cable/C = turfloc.get_cable_node()
	if(!C)
		return ..()

	zap_flags &= ~ZAP_OBJ_DAMAGE
	C.add_avail(power / 7500)
	power = power / 7500
	return ..()

/obj/structure/grille/get_dumping_location()
	return null

/obj/structure/grille/broken // Pre-broken grilles for map placement
	density = FALSE
	broken = TRUE
	rods_amount = 1
	rods_broken = FALSE

/obj/structure/grille/broken/Initialize(mapload)
	. = ..()
	take_damage(max_integrity * 0.6)
