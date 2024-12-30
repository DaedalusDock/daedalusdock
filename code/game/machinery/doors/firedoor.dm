#define CONSTRUCTION_PANEL_OPEN 1 //Maintenance panel is open, still functioning
#define CONSTRUCTION_NO_CIRCUIT 2 //Circuit board removed, can safely weld apart
#define DEFAULT_STEP_TIME 20 /// default time for each step
#define DETECT_COOLDOWN_STEP_TIME 5 SECONDS ///Wait time before we can detect an issue again, after a recent clear.

/obj/machinery/door/firedoor
	name = "firelock"
	desc = "Apply crowbar."
	icon = 'icons/obj/doors/doorfire.dmi'
	icon_state = "door_open"
	opacity = FALSE
	density = FALSE
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	heat_proof = TRUE
	glass = FALSE
	sub_door = TRUE
	explosion_block = 1
	dont_close_on_dense_objects = FALSE
	layer = BELOW_OPEN_DOOR_LAYER
	closingLayer = CLOSED_FIREDOOR_LAYER
	assemblytype = /obj/structure/firelock_frame
	armor = list(BLUNT = 10, PUNCTURE = 30, SLASH = 90, LASER = 20, ENERGY = 20, BOMB = 30, BIO = 100, FIRE = 95, ACID = 70)
	interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_REQUIRES_SILICON | INTERACT_MACHINE_OPEN
	door_align_type = /obj/machinery/door/firedoor

	align_to_windows = TRUE
	///Trick to get the glowing overlay visible from a distance
	luminosity = 1
	///X offset for the overlay lights, so that they line up with the thin border firelocks
	var/light_xoffset = 0
	///Y offset for the overlay lights, so that they line up with the thin border firelocks
	var/light_yoffset = 0

	var/boltslocked = TRUE
	///The firedoor's area loc
	var/area/my_area
	///Every area a firedoor is listening to.
	var/list/joined_areas = list()
	///Type of alarm when active. See code/defines/firealarm.dm for the list. This var being null means there is no alarm.
	var/alert_type = FIRE_CLEAR

	knock_sound = 'sound/effects/glassknock.ogg'
	var/bash_sound = 'sound/effects/glassbash.ogg'


/obj/machinery/door/firedoor/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_FIRE_ALERT, PROC_REF(handle_alert))
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/door/firedoor/LateInitialize()
	. = ..()
	set_area(get_area(src))

/obj/machinery/door/firedoor/Destroy()
	set_area(null)
	return ..()

/**
 * Sets the offset for the warning lights.
 *
 * Used for special firelocks with light overlays that don't line up to their sprite.
 */
/obj/machinery/door/firedoor/proc/adjust_lights_starting_offset()
	return

/obj/machinery/door/firedoor/examine(mob/user)
	. = ..()
	if(!density)
		. += span_notice("It is open, but could be <b>pried</b> closed.")

	else if(!welded)
		. += span_notice("It is closed, but could be <b>pried</b> open.")
		. += span_notice("Hold the firelock temporarily open by prying it with <i>left-click</i> and standing next to it.")
		. += span_notice("Prying by <i>right-clicking</i> the firelock will open it permanently.")
		. += span_notice("Deconstruction would require it to be <b>welded</b> shut.")

	else if(boltslocked)
		. += span_notice("It is <i>welded</i> shut. The floor bolts have been locked by <b>screws</b>.")
	else
		. += span_notice("The bolt locks have been <i>unscrewed</i>, but the bolts themselves are still <b>wrenched</b> to the floor.")

/obj/machinery/door/firedoor/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(!isliving(user))
		return .

	var/mob/living/living_user = user

	if (isnull(held_item))
		if(density)
			if(isalienadult(living_user) || issilicon(living_user))
				context[SCREENTIP_CONTEXT_LMB] = "Open"
				return CONTEXTUAL_SCREENTIP_SET
			if(!living_user.combat_mode)
				if(ishuman(living_user))
					context[SCREENTIP_CONTEXT_LMB] = "Knock"
					return CONTEXTUAL_SCREENTIP_SET
			else
				if(ismonkey(living_user))
					context[SCREENTIP_CONTEXT_LMB] = "Attack"
					return CONTEXTUAL_SCREENTIP_SET
				if(ishuman(living_user))
					context[SCREENTIP_CONTEXT_LMB] = "Bash"
					return CONTEXTUAL_SCREENTIP_SET
		else if(issilicon(living_user))
			context[SCREENTIP_CONTEXT_LMB] = "Close"
			return CONTEXTUAL_SCREENTIP_SET
		return .

	if(!Adjacent(src, living_user))
		return .

	switch (held_item.tool_behaviour)
		if (TOOL_CROWBAR)
			if (!density)
				context[SCREENTIP_CONTEXT_LMB] = "Close"
			else if (!welded)
				context[SCREENTIP_CONTEXT_LMB] = "Hold open"
				context[SCREENTIP_CONTEXT_RMB] = "Open permanently"
			return CONTEXTUAL_SCREENTIP_SET
		if (TOOL_WELDER)
			context[SCREENTIP_CONTEXT_LMB] = welded ? "Unweld shut" : "Weld shut"
			return CONTEXTUAL_SCREENTIP_SET
		if (TOOL_WRENCH)
			if (welded && !boltslocked)
				context[SCREENTIP_CONTEXT_LMB] = "Unfasten bolts"
				return CONTEXTUAL_SCREENTIP_SET
		if (TOOL_SCREWDRIVER)
			if (welded)
				context[SCREENTIP_CONTEXT_LMB] = "Unlock bolts"
				return CONTEXTUAL_SCREENTIP_SET

	return .

/obj/machinery/door/firedoor/Moved(atom/oldloc, list/old_locs, momentum_change = TRUE)
	. = ..()
	var/new_area = get_area(src)
	if(my_area != new_area)
		set_area(new_area)

/obj/machinery/door/firedoor/proc/set_area(new_area)
	if(my_area)
		LAZYREMOVE(my_area.firedoors, src)
	for(var/area/A in joined_areas)
		LAZYREMOVE(A.firedoors, src)
	joined_areas.Cut()

	if(!new_area)
		return
	my_area = new_area

	if(!my_area)
		return

	for(var/area/area2join in get_adjacent_open_areas(src) | my_area)
		LAZYDISTINCTADD(area2join.firedoors, src)
		joined_areas |= area2join

/obj/machinery/door/firedoor/proc/handle_alert(datum/source, code)
	SIGNAL_HANDLER

	if(!!alert_type == !!code)
		return

	alert_type = code

	if(code == FIRE_CLEAR)
		INVOKE_ASYNC(src, PROC_REF(open))
	else
		INVOKE_ASYNC(src, PROC_REF(close))

/obj/machinery/door/firedoor/emag_act(mob/user, obj/item/card/emag/doorjack/digital_crowbar)
	if(obj_flags & EMAGGED)
		return
	if(!isAI(user)) //Skip doorjack-specific code
		if(!user || digital_crowbar.charges < 1)
			return
		digital_crowbar.use_charge(user)
	obj_flags |= EMAGGED
	INVOKE_ASYNC(src, PROC_REF(open))

/obj/machinery/door/firedoor/BumpedBy(atom/movable/AM)
	if(panel_open || operating)
		return
	if(!density)
		return ..()
	return FALSE

/obj/machinery/door/firedoor/bumpopen(mob/living/user)
	return FALSE //No bumping to open, not even in mechs

/obj/machinery/door/firedoor/power_change()
	. = ..()
	update_icon()

/obj/machinery/door/firedoor/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(operating || !density)
		return
	user.changeNext_move(CLICK_CD_MELEE)

	if(!user.combat_mode || modifiers[RIGHT_CLICK])
		knock_on(user)
		return TRUE
	else
		user.visible_message(span_warning("[user] bashes [src]!"), \
			span_warning("You bash [src]!"))
		playsound(src, bash_sound, 100, TRUE)
		return TRUE

/obj/machinery/door/firedoor/wrench_act(mob/living/user, obj/item/tool)
	tool.leave_evidence(user, src)
	if(operating || !welded)
		return FALSE

	if(boltslocked)
		to_chat(user, span_notice("There are screws locking the bolts in place!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	tool.play_tool_sound(src)
	user.visible_message(span_notice("[user] starts undoing [src]'s bolts..."), \
		span_notice("You start unfastening [src]'s floor bolts..."))
	if(!tool.use_tool(src, user, DEFAULT_STEP_TIME))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
	user.visible_message(span_notice("[user] unfastens [src]'s bolts."), \
		span_notice("You undo [src]'s floor bolts."))
	deconstruct(TRUE)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/firedoor/screwdriver_act(mob/living/user, obj/item/tool)
	if(operating || !welded)
		return FALSE
	user.visible_message(span_notice("[user] [boltslocked ? "unlocks" : "locks"] [src]'s bolts."), \
				span_notice("You [boltslocked ? "unlock" : "lock"] [src]'s floor bolts."))
	tool.play_tool_sound(src)
	boltslocked = !boltslocked
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/firedoor/try_to_activate_door(mob/user, access_bypass = FALSE, obj/item/attackedby)
	return

/obj/machinery/door/firedoor/try_to_weld(obj/item/weldingtool/W, mob/user)
	if(!W.tool_start_check(user, amount=0))
		return
	user.visible_message(span_notice("[user] starts [welded ? "unwelding" : "welding"] [src]."), span_notice("You start welding [src]."))
	if(W.use_tool(src, user, DEFAULT_STEP_TIME, volume=50))
		welded = !welded
		user.visible_message(span_danger("[user] [welded?"welds":"unwelds"] [src]."), span_notice("You [welded ? "weld" : "unweld"] [src]."))
		log_game("[key_name(user)] [welded ? "welded":"unwelded"] firedoor [src] with [W] at [AREACOORD(src)]")
		update_appearance()

/// We check for adjacency when using the primary attack.
/obj/machinery/door/firedoor/try_to_crowbar(obj/item/acting_object, mob/user)
	if(welded || operating)
		return

	if(density)
		user.visible_message(
			span_danger("[user] presses their crowbar into [src] to pry it open!"),
			span_notice("You press your crowbar between the door and begin to pry it open..."),
			span_hear("You hear a metal clang, followed by metallic groans.")
		)
		if(!do_after(user, src, 3 SECONDS, DO_PUBLIC))
			return
		user.visible_message(
			span_danger("[user] forces [src] open with a crowbar!"),
			span_notice("You force open [src]."),
			span_hear("You hear a heavy metallic object sliding.")
		)
		open()
	else
		user.visible_message(
			span_notice("[user] forces [src] shut."),
			span_notice("You force [src] closed."),
			span_hear("You hear a heavy metallic object sliding, followed by a clang.")
		)
		close()

/obj/machinery/door/firedoor/attack_ai(mob/user)
	add_fingerprint(user)
	if(welded || operating || machine_stat & NOPOWER)
		return TRUE
	if(density)
		open()
	else
		close()
	return TRUE

/obj/machinery/door/firedoor/attack_robot(mob/user)
	return attack_ai(user)

/obj/machinery/door/firedoor/attack_alien(mob/user, list/modifiers)
	add_fingerprint(user)
	if(welded)
		to_chat(user, span_warning("[src] refuses to budge!"))
		return
	open()

/obj/machinery/door/firedoor/do_animate(animation)
	switch(animation)
		if("opening")
			z_flick("[base_icon_state]_opening", src)
		if("closing")
			z_flick("[base_icon_state]_closing", src)

/obj/machinery/door/firedoor/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[density ? "closed" : "open"]"

/obj/machinery/door/firedoor/update_overlays()
	. = ..()
	if(welded)
		. += density ? "welded" : "welded_open"
	if(alert_type && powered())
		var/iconstate2use
		switch(alert_type)
			if(FIRE_RAISED_HOT, FIRE_RAISED_GENERIC)
				iconstate2use = "firelock_alarm_type_hot"
			if(FIRE_RAISED_COLD)
				iconstate2use = "firelock_alarm_type_cold"
			if(FIRE_RAISED_PRESSURE)
				iconstate2use = "firelock_alarm_type_pressure"
		var/mutable_appearance/hazards
		hazards = mutable_appearance(icon, iconstate2use, alpha = src.alpha)
		hazards.pixel_x = light_xoffset
		hazards.pixel_y = light_yoffset
		. += hazards

/obj/machinery/door/firedoor/open()
	if(welded)
		return
	. = ..()
	if(.)
		playsound(loc, 'sound/machines/doors/blastdoor_open.ogg', 60, TRUE)

/obj/machinery/door/firedoor/close()
	if(HAS_TRAIT(loc, TRAIT_FIREDOOR_STOP))
		return
	. = ..()
	if(.)
		playsound(loc, 'sound/machines/doors/blastdoor_close.ogg', 60, TRUE)


/obj/machinery/door/firedoor/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/turf/targetloc = get_turf(src)
		if(disassembled || prob(40))
			var/obj/structure/firelock_frame/unbuilt_lock = new assemblytype(targetloc)
			if(disassembled)
				unbuilt_lock.constructionStep = CONSTRUCTION_PANEL_OPEN
			else
				unbuilt_lock.constructionStep = CONSTRUCTION_NO_CIRCUIT
				unbuilt_lock.update_integrity(unbuilt_lock.max_integrity * 0.5)
			unbuilt_lock.update_appearance()
		else
			new /obj/item/electronics/firelock (targetloc)
	qdel(src)

/obj/machinery/door/firedoor/closed
	icon_state = "door_closed"
	density = TRUE
	alert_type = FIRE_RAISED_GENERIC

/obj/machinery/door/firedoor/border_only
	icon = 'icons/obj/doors/edge_Doorfire.dmi'
	can_crush = FALSE
	flags_1 = ON_BORDER_1
	can_atmos_pass = CANPASS_PROC
	auto_dir_align = FALSE

/obj/machinery/door/firedoor/border_only/closed
	icon_state = "door_closed"
	density = TRUE
	alert_type = FIRE_RAISED_GENERIC

/obj/machinery/door/firedoor/border_only/Initialize(mapload)
	. = ..()
	adjust_lights_starting_offset()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit)
	)

	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/door/firedoor/border_only/adjust_lights_starting_offset()
	light_xoffset = 0
	light_yoffset = 0
	switch(dir)
		if(NORTH)
			light_yoffset = 2
		if(SOUTH)
			light_yoffset = -2
		if(EAST)
			light_xoffset = 2
		if(WEST)
			light_xoffset = -2
	update_icon()

/obj/machinery/door/firedoor/border_only/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	adjust_lights_starting_offset()

/obj/machinery/door/firedoor/border_only/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!(border_dir == dir)) //Make sure looking at appropriate border
		return TRUE

/obj/machinery/door/firedoor/border_only/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	return !density || (dir != to_dir)

/obj/machinery/door/firedoor/border_only/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	if(leaving.movement_type & PHASING)
		return
	if(leaving == src)
		return // Let's not block ourselves.

	if(direction == dir && density)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/machinery/door/firedoor/border_only/zas_canpass(turf/T)
	if(QDELETED(src))
		return AIR_ALLOWED
	if(get_dir(loc, T) == dir)
		return density ? (AIR_BLOCKED|ZONE_BLOCKED) : ZONE_BLOCKED
	else
		return ZONE_BLOCKED

/obj/machinery/door/firedoor/heavy
	name = "heavy firelock"
	icon = 'icons/obj/doors/Doorfire.dmi'
	glass = FALSE
	explosion_block = 2
	assemblytype = /obj/structure/firelock_frame/heavy
	max_integrity = 550


/obj/item/electronics/firelock
	name = "firelock circuitry"
	desc = "A circuit board used in construction of firelocks."
	icon_state = "mainboard"

/obj/structure/firelock_frame
	name = "firelock frame"
	desc = "A partially completed firelock."
	icon = 'icons/obj/doors/Doorfire.dmi'
	icon_state = "frame1"
	base_icon_state = "frame"
	anchored = FALSE
	density = TRUE
	var/constructionStep = CONSTRUCTION_NO_CIRCUIT
	var/reinforced = 0

/obj/structure/firelock_frame/examine(mob/user)
	. = ..()
	switch(constructionStep)
		if(CONSTRUCTION_PANEL_OPEN)
			. += span_notice("It is <i>unbolted</i> from the floor. The circuit could be removed with a <b>crowbar</b>.")
			if(!reinforced)
				. += span_notice("It could be reinforced with plasteel.")
		if(CONSTRUCTION_NO_CIRCUIT)
			. += span_notice("There are no <i>firelock electronics</i> in the frame. The frame could be <b>welded</b> apart .")

/obj/structure/firelock_frame/update_icon_state()
	icon_state = "[base_icon_state][constructionStep]"
	return ..()

/obj/structure/firelock_frame/attackby(obj/item/attacking_object, mob/user)
	switch(constructionStep)
		if(CONSTRUCTION_PANEL_OPEN)
			if(attacking_object.tool_behaviour == TOOL_CROWBAR)
				attacking_object.play_tool_sound(src)
				user.visible_message(span_notice("[user] begins removing the circuit board from [src]..."), \
					span_notice("You begin prying out the circuit board from [src]..."))
				if(!attacking_object.use_tool(src, user, DEFAULT_STEP_TIME))
					return
				if(constructionStep != CONSTRUCTION_PANEL_OPEN)
					return
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				user.visible_message(span_notice("[user] removes [src]'s circuit board."), \
					span_notice("You remove the circuit board from [src]."))
				new /obj/item/electronics/firelock(drop_location())
				constructionStep = CONSTRUCTION_NO_CIRCUIT
				update_appearance()
				return
			if(attacking_object.tool_behaviour == TOOL_WRENCH)
				if(locate(/obj/machinery/door/firedoor) in get_turf(src))
					to_chat(user, span_warning("There's already a firelock there."))
					return
				attacking_object.play_tool_sound(src)
				user.visible_message(span_notice("[user] starts bolting down [src]..."), \
					span_notice("You begin bolting [src]..."))
				if(!attacking_object.use_tool(src, user, DEFAULT_STEP_TIME))
					return
				if(locate(/obj/machinery/door/firedoor) in get_turf(src))
					return
				user.visible_message(span_notice("[user] finishes the firelock."), \
					span_notice("You finish the firelock."))
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				if(reinforced)
					new /obj/machinery/door/firedoor/heavy(get_turf(src))
				else
					new /obj/machinery/door/firedoor(get_turf(src))
				qdel(src)
				return
			if(istype(attacking_object, /obj/item/stack/sheet/plasteel))
				var/obj/item/stack/sheet/plasteel/plasteel_sheet = attacking_object
				if(reinforced)
					to_chat(user, span_warning("[src] is already reinforced."))
					return
				if(plasteel_sheet.get_amount() < 2)
					to_chat(user, span_warning("You need more plasteel to reinforce [src]."))
					return
				user.visible_message(span_notice("[user] begins reinforcing [src]..."), \
					span_notice("You begin reinforcing [src]..."))
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				if(do_after(user, src, DEFAULT_STEP_TIME))
					if(constructionStep != CONSTRUCTION_PANEL_OPEN || reinforced || plasteel_sheet.get_amount() < 2 || !plasteel_sheet)
						return
					user.visible_message(span_notice("[user] reinforces [src]."), \
						span_notice("You reinforce [src]."))
					playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
					plasteel_sheet.use(2)
					reinforced = 1
				return
		if(CONSTRUCTION_NO_CIRCUIT)
			if(istype(attacking_object, /obj/item/electronics/firelock))
				user.visible_message(span_notice("[user] starts adding [attacking_object] to [src]..."), \
					span_notice("You begin adding a circuit board to [src]..."))
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				if(!do_after(user, src, DEFAULT_STEP_TIME))
					return
				if(constructionStep != CONSTRUCTION_NO_CIRCUIT)
					return
				qdel(attacking_object)
				user.visible_message(span_notice("[user] adds a circuit to [src]."), \
					span_notice("You insert and secure [attacking_object]."))
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				constructionStep = CONSTRUCTION_PANEL_OPEN
				return
			if(attacking_object.tool_behaviour == TOOL_WELDER)
				if(!attacking_object.tool_start_check(user, amount=1))
					return
				user.visible_message(span_notice("[user] begins cutting apart [src]'s frame..."), \
					span_notice("You begin slicing [src] apart..."))

				if(attacking_object.use_tool(src, user, DEFAULT_STEP_TIME, volume=50, amount=1))
					if(constructionStep != CONSTRUCTION_NO_CIRCUIT)
						return
					user.visible_message(span_notice("[user] cuts apart [src]!"), \
						span_notice("You cut [src] into metal."))
					var/turf/tagetloc = get_turf(src)
					new /obj/item/stack/sheet/iron(tagetloc, 3)
					if(reinforced)
						new /obj/item/stack/sheet/plasteel(tagetloc, 2)
					qdel(src)
				return
			if(istype(attacking_object, /obj/item/electroadaptive_pseudocircuit))
				var/obj/item/electroadaptive_pseudocircuit/raspberrypi = attacking_object
				if(!raspberrypi.adapt_circuit(user, DEFAULT_STEP_TIME * 0.5))
					return
				user.visible_message(span_notice("[user] fabricates a circuit and places it into [src]."), \
				span_notice("You adapt a firelock circuit and slot it into the assembly."))
				constructionStep = CONSTRUCTION_PANEL_OPEN
				update_appearance()
				return
	return ..()

/obj/structure/firelock_frame/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("mode" = RCD_DECONSTRUCT, "delay" = 50, "cost" = 16)
	else if((constructionStep == CONSTRUCTION_NO_CIRCUIT) && (the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return list("mode" = RCD_UPGRADE_SIMPLE_CIRCUITS, "delay" = 20, "cost" = 1)
	return FALSE

/obj/structure/firelock_frame/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_UPGRADE_SIMPLE_CIRCUITS)
			user.visible_message(span_notice("[user] fabricates a circuit and places it into [src]."), \
			span_notice("You adapt a firelock circuit and slot it into the assembly."))
			constructionStep = CONSTRUCTION_PANEL_OPEN
			update_appearance()
			return TRUE
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct [src]."))
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/firelock_frame/heavy
	name = "heavy firelock frame"
	reinforced = TRUE

#undef CONSTRUCTION_PANEL_OPEN
#undef CONSTRUCTION_NO_CIRCUIT
