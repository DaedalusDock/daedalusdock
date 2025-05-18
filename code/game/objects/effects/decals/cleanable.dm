/obj/effect/decal/cleanable
	gender = PLURAL
	layer = ABOVE_NORMAL_TURF_LAYER

	var/list/random_icon_states = null
	/// If TRUE, this decal will attempt to merge with other of it's type.
	var/mergeable_decal = TRUE

	var/beauty = 0
	///The type of cleaning required to clean the decal. See __DEFINES/cleaning.dm for the options
	var/clean_type = CLEAN_TYPE_LIGHT_DECAL
	///The reagent this decal holds. Leave blank for none.
	var/datum/reagent/decal_reagent
	///The amount of reagent this decal holds, if decal_reagent is defined
	var/reagent_amount = 0

	///I'm sorry but cleanable/blood code is ass, and so is blood_DNA
	var/blood_color = ""
	///0-100, amount of blood in this decal, used for making footprints and affecting the alpha of bloody footprints
	var/bloodiness = 0

/obj/effect/decal/cleanable/Initialize(mapload, list/datum/pathogen/diseases, list/blood_dna)
	. = ..()
	if (random_icon_states && (icon_state == initial(icon_state)) && length(random_icon_states) > 0)
		icon_state = pick(random_icon_states)

	create_reagents(300)

	if(decal_reagent)
		reagents.add_reagent(decal_reagent, reagent_amount)

	if(blood_dna)
		add_blood_DNA(blood_dna)
		if(!islist(blood_dna) || !length(blood_dna))
			stack_trace("Bad blood DNA sent")
		else
			var/datum/blood/path = blood_dna[blood_dna[1]]
			blood_color = initial(path.color)

	if(mergeable_decal && isturf(loc))
		for(var/obj/effect/decal/cleanable/C in loc)
			if(C != src && C.type == type && !QDELETED(C))
				if (can_merge_into(C))
					merge_into(C)
					return INITIALIZE_HINT_QDEL

	if(LAZYLEN(diseases))
		var/list/datum/pathogen/diseases_to_add = list()
		for(var/datum/pathogen/D in diseases)
			if(D.spread_flags & PATHOGEN_SPREAD_CONTACT_FLUIDS)
				diseases_to_add += D
		if(LAZYLEN(diseases_to_add))
			AddComponent(/datum/component/infective, diseases_to_add)

	AddElement(/datum/element/beauty, beauty)

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/decal/cleanable/Destroy()
	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)
	return ..()

/obj/effect/decal/cleanable/proc/can_merge_into(obj/effect/decal/cleanable/C) // Returns true if we should give up in favor of the pre-existing decal
	if(mergeable_decal)
		return TRUE

/obj/effect/decal/cleanable/attackby(obj/item/W, mob/user, params)
	if((istype(W, /obj/item/reagent_containers/glass) && !istype(W, /obj/item/reagent_containers/glass/rag)) || istype(W, /obj/item/reagent_containers/food/drinks))
		if(src.reagents && W.reagents)
			. = 1 //so the containers don't splash their content on the src while scooping.
			if(!src.reagents.total_volume)
				to_chat(user, span_notice("[src] isn't thick enough to scoop up!"))
				return
			if(W.reagents.total_volume >= W.reagents.maximum_volume)
				to_chat(user, span_notice("[W] is full!"))
				return
			to_chat(user, span_notice("You scoop up [src] into [W]!"))
			reagents.trans_to(W, reagents.total_volume, transfered_by = user)
			if(!reagents.total_volume) //scooped up all of it
				qdel(src)
				return
	if(W.get_temperature()) //todo: make heating a reagent holder proc
		if(istype(W, /obj/item/clothing/mask/cigarette))
			return
		else
			var/hotness = W.get_temperature()
			reagents.expose_temperature(hotness)
			to_chat(user, span_notice("You heat [name] with [W]!"))
	else
		return ..()

/obj/effect/decal/cleanable/fire_act(exposed_temperature, exposed_volume, turf/adjacent)
	if(reagents)
		reagents.expose_temperature(exposed_temperature)
	..()


//Add "bloodiness" of this blood's type, to the human's shoes
//This is on /cleanable because fuck this ancient mess
/obj/effect/decal/cleanable/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(AM == src)
		return
	if(iscarbon(AM) && blood_color && bloodiness >= 40)
		SEND_SIGNAL(AM, COMSIG_STEP_ON_BLOOD, src)
		update_appearance()

/obj/effect/decal/cleanable/wash(clean_types)
	. = ..()
	if (. || (clean_types & clean_type))
		qdel(src)
		return TRUE
	return .

/**
 * Checks if this decal is a valid decal that can be blood crawled in.
 */
/obj/effect/decal/cleanable/proc/can_bloodcrawl_in()
	return length(return_blood_DNA())

/obj/effect/decal/cleanable/proc/merge_into(obj/effect/decal/cleanable/merger)
	if(!merger)
		return
	if(merger.reagents && reagents)
		reagents.trans_to(merger, reagents.total_volume)

