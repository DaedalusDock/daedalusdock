/obj/structure/plasticflaps
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps. Definitely can't get past those. No way."
	gender = PLURAL
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "plasticflaps"
	armor = list(BLUNT = 100, PUNCTURE = 80, SLASH = 100, LASER = 80, ENERGY = 100, BOMB = 50, BIO = 100, FIRE = 50, ACID = 50)
	density = FALSE
	anchored = TRUE
	can_atmos_pass = CANPASS_NEVER
	can_astar_pass = CANASTARPASS_ALWAYS_PROC

/obj/structure/plasticflaps/opaque
	opacity = TRUE

/obj/structure/plasticflaps/Initialize(mapload)
	. = ..()
	alpha = 0
	var/obj/effect/overlay/vis/visual = new(icon, icon_state, ABOVE_MOB_LAYER)
	visual.appearance_flags |= RESET_ALPHA
	add_viscontents(visual) //you see mobs under it, but you hit them like they are above it

/obj/structure/plasticflaps/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("[src] are <b>screwed</b> to the floor.")
	else
		. += span_notice("[src] are no longer <i>screwed</i> to the floor, and the flaps can be <b>cut</b> apart.")

/obj/structure/plasticflaps/screwdriver_act(mob/living/user, obj/item/W)
	if(..())
		return TRUE
	add_fingerprint(user)
	var/action = anchored ? "unscrews [src] from" : "screws [src] to"
	var/uraction = anchored ? "unscrew [src] from" : "screw [src] to"
	user.visible_message(span_warning("[user] [action] the floor."), span_notice("You start to [uraction] the floor..."), span_hear("You hear rustling noises."))
	if(!W.use_tool(src, user, 100, volume=100, extra_checks = CALLBACK(src, PROC_REF(check_anchored_state), anchored)))
		return TRUE
	set_anchored(!anchored)
	update_atmos_behaviour()
	//air_update_turf(TRUE)
	to_chat(user, span_notice("You [uraction] the floor."))
	return TRUE

///Update the flaps behaviour to gases, if not anchored will let air pass through
/obj/structure/plasticflaps/proc/update_atmos_behaviour()
	can_atmos_pass = anchored ? CANPASS_ALWAYS : CANPASS_NEVER

/obj/structure/plasticflaps/wirecutter_act(mob/living/user, obj/item/W)
	. = ..()
	if(!anchored)
		user.visible_message(span_warning("[user] cuts apart [src]."), span_notice("You start to cut apart [src]."), span_hear("You hear cutting."))
		if(W.use_tool(src, user, 50, volume=100))
			if(anchored)
				return TRUE
			to_chat(user, span_notice("You cut apart [src]."))
			var/obj/item/stack/sheet/plastic/five/P = new(loc)
			if (!QDELETED(P))
				P.add_fingerprint(user)
			qdel(src)
		return TRUE

/obj/structure/plasticflaps/proc/check_anchored_state(check_anchored)
	if(anchored != check_anchored)
		return FALSE
	return TRUE

/obj/structure/plasticflaps/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(pass_info.is_living)
		if(pass_info.is_bot)
			return TRUE

		if(pass_info.can_ventcrawl && pass_info.mob_size != MOB_SIZE_TINY)
			return FALSE

	if(pass_info.grab_infos)
		for(var/datum/can_pass_info/grab_info in pass_info.grab_infos)
			if(!CanAStarPass(to_dir, grab_info))
				return FALSE
	return TRUE //diseases, stings, etc can pass


/obj/structure/plasticflaps/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(mover.pass_flags & PASSFLAPS) //For anything specifically engineered to cross plastic flaps.
		return TRUE
	if(mover.pass_flags & PASSGLASS)
		return prob(60)

	if(istype(mover, /obj/structure/bed))
		var/obj/structure/bed/bed_mover = mover
		if(bed_mover.density || bed_mover.has_buckled_mobs())//if it's a bed/chair and is dense or someone is buckled, it will not pass
			return FALSE

	else if(istype(mover, /obj/structure/closet/cardboard))
		var/obj/structure/closet/cardboard/cardboard_mover = mover
		if(cardboard_mover.move_delay)
			return FALSE

	else if(ismecha(mover))
		return FALSE

	else if(isliving(mover)) // You Shall Not Pass!
		var/mob/living/living_mover = mover
		if(istype(living_mover.buckled, /mob/living/simple_animal/bot/mulebot)) // mulebot passenger gets a free pass.
			return TRUE

		if(living_mover.body_position == STANDING_UP && living_mover.mob_size != MOB_SIZE_TINY && !(HAS_TRAIT(living_mover, TRAIT_VENTCRAWLER_ALWAYS) || HAS_TRAIT(living_mover, TRAIT_VENTCRAWLER_NUDE)))
			return FALSE //If you're not laying down, or a small creature, or a ventcrawler, then no pass.


/obj/structure/plasticflaps/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/plastic/five(loc)
	qdel(src)

/obj/structure/plasticflaps/Initialize(mapload)
	. = ..()
	//air_update_turf(TRUE, TRUE)

/*
/obj/structure/plasticflaps/Destroy()
	var/atom/oldloc = loc
	. = ..()
	if (oldloc)
		oldloc./air_update_turf(TRUE, FALSE)
*/
