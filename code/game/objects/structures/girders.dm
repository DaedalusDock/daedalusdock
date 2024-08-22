#define GIRDER_PASSCHANCE_NORMAL 20
#define GIRDER_PASSCHANCE_UNANCHORED 25
#define GIRDER_PASSCHANCE_REINFORCED 0

/obj/structure/girder
	name = "girder"
	icon_state = "girder"
	desc = "A large structural assembly made out of metal; It requires a layer of iron before it can be considered a wall."
	anchored = TRUE
	density = TRUE
	max_integrity = 200
	rad_insulation = RAD_VERY_LIGHT_INSULATION
	can_atmos_pass = CANPASS_ALWAYS
	var/state = GIRDER_NORMAL
	var/girderpasschance = GIRDER_PASSCHANCE_NORMAL // percentage chance that a projectile passes through the girder.
	var/can_displace = TRUE //If the girder can be moved around by wrenching it
	var/next_beep = 0 //Prevents spamming of the construction sound
	/// What material is this girder reinforced by
	var/reinforced_material
	/// Paint to apply to the wall built. Matters for deconstructed and reconstructed walls
	var/wall_paint
	/// Stripe paint to apply to the wall built. Matters for deconstructed and reconstructed walls
	var/stripe_paint

/obj/structure/girder/Initialize(mapload, reinforced_mat, new_paint, new_stripe_paint, unanchored)
	. = ..()
	wall_paint = new_paint
	stripe_paint = new_stripe_paint
	if(unanchored)
		set_anchored(FALSE)
		girderpasschance = GIRDER_PASSCHANCE_UNANCHORED
	if(reinforced_mat)
		reinforced_material = reinforced_mat
		state = GIRDER_REINF
		update_appearance()

/obj/structure/girder/update_name()
	. = ..()
	if(!anchored)
		name = "displaced girder"
	else if (state == GIRDER_NORMAL)
		name = "girder"
	else
		name = "reinforced girder"

/obj/structure/girder/update_icon_state()
	. = ..()
	if(!anchored)
		icon_state = "displaced"
	else if (state == GIRDER_NORMAL)
		icon_state = "girder"
	else
		icon_state = "reinforced"

/obj/structure/girder/examine(mob/user)
	. = ..()
	switch(state)
		if(GIRDER_REINF)
			. += span_notice("It's reinforcement can be <b>screwed</b> off.")
		if(GIRDER_REINF_STRUTS)
			. += span_notice("The reinforcement struts can be <b>reinforced</b> with a material or <b>cut</b> off.")
		if(GIRDER_NORMAL)
			. += span_notice("The girder can be prepared for reinforcement with <b>rods</b>.")
	if(anchored)
		if(can_displace)
			. += span_notice("The bolts are <b>wrenched</b> in place.")
	else
		. += span_notice("The bolts are <i>loosened</i>, but the <b>screws</b> are holding [src] together.")

/obj/structure/girder/attackby(obj/item/W, mob/user, params)
	var/platingmodifier = 1
	if(HAS_TRAIT(user, TRAIT_QUICK_BUILD))
		platingmodifier = 0.7
		if(next_beep <= world.time)
			next_beep = world.time + 10
			playsound(src, 'sound/machines/clockcult/integration_cog_install.ogg', 50, TRUE)
	W.leave_evidence(user, src)

	if(istype(W, /obj/item/gun/energy/plasmacutter))
		to_chat(user, span_notice("You start slicing apart the girder..."))
		if(W.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("You slice apart the girder."))
			var/obj/item/stack/sheet/iron/M = new (loc, 2)
			M.add_fingerprint(user)
			qdel(src)

	else if(istype(W, /obj/item/stack))
		if(iswallturf(loc))
			to_chat(user, span_warning("There is already a wall present!"))
			return
		if(!isfloorturf(src.loc))
			to_chat(user, span_warning("A floor must be present to build a false wall!"))
			return
		if (locate(/obj/structure/falsewall) in src.loc.contents)
			to_chat(user, span_warning("There is already a false wall present!"))
			return

		if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/S = W
			if(state != GIRDER_NORMAL)
				return
			if(S.get_amount() < 2)
				to_chat(user, span_warning("You need two rods to place reinforcement struts!"))
				return
			to_chat(user, span_notice("You start placing reinforcement struts..."))
			if(do_after(user, src, 20*platingmodifier, DO_PUBLIC, display = W))
				if(S.get_amount() < 2)
					return
				if(state != GIRDER_NORMAL)
					return
				to_chat(user, span_notice("You place reinforcement struts."))
				S.use(2)
				state = GIRDER_REINF_STRUTS
				update_appearance()

		if(!istype(W, /obj/item/stack/sheet))
			return

		var/obj/item/stack/sheet/S = W
		if(S.get_amount() < 2)
			to_chat(user, span_warning("You need two sheets of [S]!"))
			return
		if(state == GIRDER_REINF_STRUTS)
			//Let's just prevent you from reinforcing with anything that wouldn't already make a wall
			var/datum/material/reinf_mat_ref = GET_MATERIAL_REF(S.material_type)
			var/wall_type = reinf_mat_ref.wall_type
			if(!wall_type)
				to_chat(user, span_warning("You can't figure out how to reinforce a wall with this!"))
				return
			to_chat(user, span_notice("You start reinforcing the girder..."))
			if(do_after(user, src, 20*platingmodifier, DO_PUBLIC, display = W))
				if(state != GIRDER_REINF_STRUTS)
					return
				if(S.get_amount() < 2)
					return
				S.use(2)
				state = GIRDER_REINF
				reinforced_material = S.material_type
				update_appearance()
			return
		else
			var/datum/material/plating_mat_ref = GET_MATERIAL_REF(S.material_type)
			var/wall_type = plating_mat_ref.wall_type
			if(!wall_type)
				to_chat(user, span_warning("You can't figure out how to make a wall out of this!"))
				return
			if(anchored)
				to_chat(user, span_notice("You start adding plating..."))
			else
				to_chat(user, span_notice("You start adding plating, creating a false wall..."))
			if (do_after(user, src, 40*platingmodifier, DO_PUBLIC, display = W))
				if(S.get_amount() < 2)
					return
				S.use(2)
				if(anchored)
					to_chat(user, span_notice("You add the plating."))
				else
					to_chat(user, span_notice("You create the false wall."))
				var/turf/T = get_turf(src)
				if(anchored)
					//Build a normal wall
					T.PlaceOnTop(wall_type)
					var/turf/closed/wall/placed_wall = T
					placed_wall.set_wall_information(S.material_type, reinforced_material, wall_paint, stripe_paint)
					transfer_fingerprints_to(placed_wall)
				else
					//Build a false wall
					var/false_wall_type = plating_mat_ref.false_wall_type
					var/obj/structure/falsewall/false_wall = new false_wall_type(T)
					false_wall.set_wall_information(S.material_type, reinforced_material, wall_paint, stripe_paint)
					transfer_fingerprints_to(false_wall)
				qdel(src)
				return

		log_touch(user)

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5)) //simple pipes, simple bends, and simple manifolds.
			if(!user.transferItemToLoc(P, drop_location()))
				return
			to_chat(user, span_notice("You fit the pipe into \the [src]."))
	else
		return ..()

// Screwdriver behavior for girders
/obj/structure/girder/screwdriver_act(mob/user, obj/item/tool)
	if(..())
		return TRUE

	. = FALSE
	if(state == GIRDER_REINF)
		to_chat(user, span_notice("You start removing the reinforcement..."))
		if(tool.use_tool(src, user, 40, volume=100))
			if(state != GIRDER_REINF)
				return
			to_chat(user, span_notice("You remove the reinforcement."))
			state = GIRDER_REINF_STRUTS
			var/datum/material/reinf_mat_ref = GET_MATERIAL_REF(reinforced_material)
			new reinf_mat_ref.sheet_type(loc, 2)
			reinforced_material = null
			update_appearance()
		return TRUE

	else if(!anchored && state != GIRDER_REINF_STRUTS)
		user.visible_message(span_warning("[user] disassembles the girder."),
			span_notice("You start to disassemble the girder..."),
			span_hear("You hear clanking and banging noises."))
		if(tool.use_tool(src, user, 40, volume=100))
			if(anchored)
				return
			to_chat(user, span_notice("You disassemble the girder."))
			var/obj/item/stack/sheet/iron/M = new (loc, 2)
			M.add_fingerprint(user)
			qdel(src)
		return TRUE

// Wirecutter behavior for girders
/obj/structure/girder/wirecutter_act(mob/user, obj/item/tool)
	. = ..()
	if(state == GIRDER_REINF_STRUTS)
		to_chat(user, span_notice("You start removing the reinforcement struts..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("You remove the reinforcement struts."))
			new /obj/item/stack/rods(get_turf(src), 2)
			state = GIRDER_NORMAL
			update_appearance()
		return TRUE

/obj/structure/girder/wrench_act(mob/user, obj/item/tool)
	. = ..()
	if(!anchored)
		if(!isfloorturf(loc))
			to_chat(user, span_warning("A floor must be present to secure the girder!"))

		to_chat(user, span_notice("You start securing the girder..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("You secure the girder."))
			set_anchored(TRUE)
			girderpasschance = GIRDER_PASSCHANCE_NORMAL
			update_appearance()
		return TRUE
	else if(state == GIRDER_NORMAL && can_displace)
		to_chat(user, span_notice("You start unsecuring the girder..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("You unsecure the girder."))
			set_anchored(FALSE)
			girderpasschance = GIRDER_PASSCHANCE_UNANCHORED
			update_appearance()
		return TRUE

/obj/structure/girder/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if((mover.pass_flags & PASSGRILLE) || istype(mover, /obj/projectile))
		return prob(girderpasschance)

/obj/structure/girder/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!density)
		return TRUE

	if(pass_info.pass_flags & PASSGRILLE)
		return TRUE

	return FALSE

/obj/structure/girder/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/remains = pick(/obj/item/stack/rods, /obj/item/stack/sheet/iron)
		new remains(loc)
	qdel(src)

/obj/structure/girder/narsie_act()
	new /obj/structure/girder/cult(loc)
	qdel(src)

/obj/structure/girder/displaced
	name = "displaced girder"
	anchored = FALSE
	girderpasschance = GIRDER_PASSCHANCE_UNANCHORED

/obj/structure/girder/reinforced
	name = "reinforced girder"
	state = GIRDER_REINF
	reinforced_material = /datum/material/iron
	girderpasschance = GIRDER_PASSCHANCE_REINFORCED

/obj/structure/girder/tram
	name = "tram girder"
	state = GIRDER_TRAM

//////////////////////////////////////////// cult girder //////////////////////////////////////////////

/obj/structure/girder/cult
	name = "runed girder"
	desc = "Framework made of a strange and shockingly cold metal. It doesn't seem to have any bolts."
	icon = 'icons/obj/cult/structures.dmi'
	icon_state= "cultgirder"
	can_displace = FALSE

/obj/structure/girder/cult/attackby(obj/item/W, mob/user, params)
	W.leave_evidence(user, src)
	if(istype(W, /obj/item/melee/cultblade/dagger) && IS_CULTIST(user)) //Cultists can demolish cult girders instantly with their tomes
		user.visible_message(span_warning("[user] strikes [src] with [W]!"), span_notice("You demolish [src]."))
		new /obj/item/stack/sheet/runed_metal(drop_location(), 1)
		qdel(src)

	else if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return

		to_chat(user, span_notice("You start slicing apart the girder..."))
		if(W.use_tool(src, user, 40, volume=50))
			to_chat(user, span_notice("You slice apart the girder."))
			var/obj/item/stack/sheet/runed_metal/R = new(drop_location(), 1)
			transfer_fingerprints_to(R)
			qdel(src)

	else if(istype(W, /obj/item/stack/sheet/runed_metal))
		var/obj/item/stack/sheet/runed_metal/R = W
		if(R.get_amount() < 1)
			to_chat(user, span_warning("You need at least one sheet of runed metal to construct a runed wall!"))
			return
		user.visible_message(span_notice("[user] begins laying runed metal on [src]..."), span_notice("You begin constructing a runed wall..."))
		if(do_after(user, src, 50, DO_PUBLIC, display = W))
			if(R.get_amount() < 1)
				return
			user.visible_message(span_notice("[user] plates [src] with runed metal."), span_notice("You construct a runed wall."))
			R.use(1)
			var/turf/T = get_turf(src)
			T.PlaceOnTop(/turf/closed/wall/mineral/cult)
			qdel(src)

	else
		return ..()

/obj/structure/girder/cult/narsie_act()
	return

/obj/structure/girder/cult/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/runed_metal(drop_location(), 1)
	qdel(src)

/obj/structure/girder/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			return rcd_result_with_memory(
				list("mode" = RCD_FLOORWALL, "delay" = 2 SECONDS, "cost" = 8),
				get_turf(src), RCD_MEMORY_WALL,
			)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 13)
	return FALSE

/obj/structure/girder/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	var/turf/T = get_turf(src)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span_notice("You finish a wall."))
			T.PlaceOnTop(/turf/closed/wall)
			qdel(src)
			return TRUE
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct the girder."))
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/girder/bronze
	name = "wall gear"
	desc = "A girder made out of sturdy bronze, made to resemble a gear."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "wall_gear"
	can_displace = FALSE

/obj/structure/girder/bronze/attackby(obj/item/W, mob/living/user, params)
	W.leave_evidence(user, src)
	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount = 0))
			return
		to_chat(user, span_notice("You start slicing apart [src]..."))
		if(W.use_tool(src, user, 40, volume=50))
			to_chat(user, span_notice("You slice apart [src]."))
			var/obj/item/stack/sheet/bronze/B = new(drop_location(), 2)
			transfer_fingerprints_to(B)
			qdel(src)

	else if(istype(W, /obj/item/stack/sheet/bronze))
		var/obj/item/stack/sheet/bronze/B = W
		if(B.get_amount() < 2)
			to_chat(user, span_warning("You need at least two bronze sheets to build a bronze wall!"))
			return
		user.visible_message(span_notice("[user] begins plating [src] with bronze..."), span_notice("You begin constructing a bronze wall..."))
		if(do_after(user, src, 50, DO_PUBLIC, display = W))
			if(B.get_amount() < 2)
				return
			user.visible_message(span_notice("[user] plates [src] with bronze!"), span_notice("You construct a bronze wall."))
			B.use(2)
			var/turf/T = get_turf(src)
			T.PlaceOnTop(/turf/closed/wall/mineral/bronze)
			qdel(src)

	else
		return ..()
