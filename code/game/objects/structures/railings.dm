TYPEINFO_DEF(/obj/structure/railing)
	default_armor = list(BLUNT = 50, PUNCTURE = 70, SLASH = 90, LASER = 70, ENERGY = 100, BOMB = 10, BIO = 100, FIRE = 0, ACID = 0)

/obj/structure/railing
	name = "railing"
	desc = "Basic railing meant to protect idiots like you from falling."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "railing"
	flags_1 = ON_BORDER_1
	density = TRUE
	anchored = TRUE
	pass_flags_self = LETPASSTHROW|PASSSTRUCTURE
	/// armor more or less consistent with grille. max_integrity about one time and a half that of a grille.
	max_integrity = 75

	var/climbable = TRUE
	///Initial direction of the railing.
	var/ini_dir

/obj/structure/railing/corner //aesthetic corner sharp edges hurt oof ouch
	icon_state = "railing_corner"
	density = FALSE
	climbable = FALSE

/obj/structure/railing/Initialize(mapload)
	. = ..()
	ini_dir = dir
	if(climbable)
		AddElement(/datum/element/climbable)

	if(density && flags_1 & ON_BORDER_1) // blocks normal movement from and to the direction it's facing.
		var/static/list/loc_connections = list(
			COMSIG_ATOM_EXIT = PROC_REF(on_exit),
		)
		AddElement(/datum/element/connect_loc, loc_connections)

	AddComponent(/datum/component/simple_rotation, ROTATION_NEEDS_ROOM)

/obj/structure/railing/attackby(obj/item/I, mob/living/user, params)
	..()
	I.leave_evidence(user, src)

	if(I.tool_behaviour == TOOL_WELDER && !user.combat_mode)
		if(atom_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, span_notice("You begin repairing [src]..."))
			if(I.use_tool(src, user, 40, volume=50))
				atom_integrity = max_integrity
				to_chat(user, span_notice("You repair [src]."))
		else
			to_chat(user, span_warning("[src] is already in good condition!"))
		return

/obj/structure/railing/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/structure/railing/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(!anchored)
		to_chat(user, span_warning("You cut apart the railing."))
		I.play_tool_sound(src, 100)
		deconstruct()
		return TRUE

/obj/structure/railing/deconstruct(disassembled)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/obj/item/stack/rods/rod = new /obj/item/stack/rods(drop_location(), 6)
		transfer_fingerprints_to(rod)
	return ..()

///Implements behaviour that makes it possible to unanchor the railing.
/obj/structure/railing/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(flags_1&NODECONSTRUCT_1)
		return
	to_chat(user, span_notice("You begin to [anchored ? "unfasten the railing from":"fasten the railing to"] the floor..."))
	if(I.use_tool(src, user, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_anchored), anchored)))
		set_anchored(!anchored)
		to_chat(user, span_notice("You [anchored ? "fasten the railing to":"unfasten the railing from"] the floor."))
	return TRUE

/obj/structure/railing/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(border_dir & dir)
		return . || mover.throwing || mover.movement_type & (FLYING | FLOATING)
	return TRUE

/obj/structure/railing/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!(to_dir & dir))
		return TRUE
	return ..()

/obj/structure/railing/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return // Let's not block ourselves.

	if(!(direction & dir))
		return

	if (!density)
		return

	if (leaving.throwing)
		return

	if (leaving.movement_type & (PHASING | FLYING | FLOATING))
		return

	if (leaving.move_force >= MOVE_FORCE_EXTREMELY_STRONG)
		return

	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/railing/proc/check_anchored(checked_anchored)
	if(anchored == checked_anchored)
		return TRUE

/obj/structure/railing/attack_grab(mob/living/user, atom/movable/victim, obj/item/hand_item/grab/grab, list/params)
	var/mob/living/L = grab.get_affecting_mob()
	if(!grab.current_grab.enable_violent_interactions || !isliving(L))
		return ..()

	if(!Adjacent(L))
		grab.move_victim_towards(get_turf(src))
		return ..()

	if(user.combat_mode)
		visible_message(span_danger("<b>[user] slams <b>[L]</b>'s face against \the [src]!</span>"))
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		var/blocked = L.run_armor_check(BODY_ZONE_HEAD, BLUNT)
		if (prob(30 * ((100 - blocked)/100)))
			L.Knockdown(10 SECONDS)
		L.apply_damage(8, BRUTE, BODY_ZONE_HEAD)
	else
		if (get_turf(L) == get_turf(src))
			L.forceMove(get_step(src, src.dir))
		else
			L.forceMove(get_turf(src))
		L.Knockdown(10 SECONDS)
		visible_message(span_danger("<b>[user]</b> throws \the <b>[L]</b> over \the [src].</span>"))
