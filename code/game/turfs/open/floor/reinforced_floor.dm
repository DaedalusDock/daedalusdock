
/turf/open/floor/engine
	name = "reinforced floor"
	desc = "Extremely sturdy."
	icon_state = "engine"
	holodeck_compatible = TRUE
	heat_capacity = INFINITY
	floor_tile = /obj/item/stack/rods
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	rcd_proof = TRUE


/turf/open/floor/engine/examine(mob/user)
	. += ..()
	. += span_notice("The reinforcement rods are <b>wrenched</b> firmly in place.")

/turf/open/floor/engine/airless
	initial_gas = AIRLESS_ATMOS

/turf/open/floor/engine/break_tile()
	return //unbreakable

/turf/open/floor/engine/burn_tile()
	return //unburnable

/turf/open/floor/engine/make_plating(force = FALSE)
	if(force)
		return ..()
	return //unplateable

/turf/open/floor/engine/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/engine/crowbar_act(mob/living/user, obj/item/I)
	return

/turf/open/floor/engine/wrench_act(mob/living/user, obj/item/I)
	..()
	to_chat(user, span_notice("You begin removing rods..."))
	if(I.use_tool(src, user, 30, volume=80))
		if(!istype(src, /turf/open/floor/engine))
			return TRUE
		if(floor_tile)
			new floor_tile(src, 2)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	return TRUE

/turf/open/floor/engine/acid_act(acidpwr, acid_volume)
	acidpwr = min(acidpwr, 50) //we reduce the power so reinf floor never get melted.
	return ..()

/turf/open/floor/engine/ex_act(severity, target)
	if(target == src)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return TRUE
	if(severity < EXPLODE_DEVASTATE && is_shielded())
		return FALSE

	switch(severity)
		if(EXPLODE_DEVASTATE)
			if(prob(80))
				if(!length(baseturfs) || !ispath(baseturfs[baseturfs.len-1], /turf/open/floor))
					TryScrapeToLattice()
				else
					ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
			else if(prob(50))
				ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
			else
				ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		if(EXPLODE_HEAVY)
			if(prob(50))
				ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/engine/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/turf/open/floor/engine/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!isliving(user))
		return
	user.move_grabbed_atoms_towards(src)

//air filled floors; used in atmos pressure chambers

/turf/open/floor/engine/n2o
	name = "\improper N2O floor"
	initial_gas = ATMOSTANK_NITROUSOXIDE

/turf/open/floor/engine/co2
	name = "\improper CO2 floor"
	initial_gas = ATMOSTANK_CO2

/turf/open/floor/engine/plasma
	name = "plasma floor"
	initial_gas = ATMOSTANK_PLASMA

/turf/open/floor/engine/o2
	name = "\improper O2 floor"
	initial_gas = ATMOSTANK_OXYGEN

/turf/open/floor/engine/n2
	name = "\improper N2 floor"
	initial_gas = ATMOSTANK_NITROGEN

/turf/open/floor/engine/h2
	name = "\improper H2 floor"
	initial_gas = ATMOSTANK_HYDROGEN

/turf/open/floor/engine/air
	name = "air floor"
	initial_gas = ATMOSTANK_AIRMIX



/turf/open/floor/engine/cult
	name = "engraved floor"
	desc = "The air smells strange over this sinister flooring."
	icon_state = "cult"
	floor_tile = null
	var/obj/effect/cult_turf/overlay/floor/bloodcult/realappearance


/turf/open/floor/engine/cult/Initialize(mapload)
	. = ..()
	icon_state = "plating" //we're redefining the base icon_state here so that the Conceal/Reveal Presence spell works for cultists
	new /obj/effect/temp_visual/cult/turf/floor(src)
	realappearance = new /obj/effect/cult_turf/overlay/floor/bloodcult(src)
	realappearance.linked = src

/turf/open/floor/engine/cult/Destroy()
	be_removed()
	return ..()

/turf/open/floor/engine/cult/ChangeTurf(path, new_baseturf, flags)
	if(path != type)
		be_removed()
	return ..()

/turf/open/floor/engine/cult/proc/be_removed()
	QDEL_NULL(realappearance)

/turf/open/floor/engine/cult/airless
	initial_gas = AIRLESS_ATMOS

/turf/open/floor/engine/vacuum
	name = "vacuum floor"
	initial_gas = AIRLESS_ATMOS

/turf/open/floor/engine/telecomms
	initial_gas = TCOMMS_ATMOS
	temperature = 80
