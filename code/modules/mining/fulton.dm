GLOBAL_LIST_EMPTY(total_extraction_beacons)

// This doesnt work anymore and im too lazy to fully remove it
/obj/item/extraction_pack
	name = "fulton extraction pack"
	desc = "A balloon that can be used to extract equipment or personnel to a Fulton Recovery Beacon. Anything not bolted down can be moved. Link the pack to a beacon by using the pack in hand."
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_pack"
	w_class = WEIGHT_CLASS_NORMAL
	var/obj/structure/extraction_point/beacon
	var/list/beacon_networks = list("station")
	var/uses_left = 3
	var/can_use_indoors
	var/safe_for_living_creatures = 1
	var/max_force_fulton = MOVE_FORCE_STRONG

/obj/item/extraction_pack/examine()
	. = ..()
	. += "It has [uses_left] use\s remaining."

/obj/item/extraction_pack/attack_self(mob/user)
	var/list/possible_beacons = list()
	for(var/obj/structure/extraction_point/extraction_point as anything in GLOB.total_extraction_beacons)
		if(extraction_point.beacon_network in beacon_networks)
			possible_beacons += extraction_point
	if(!length(possible_beacons))
		to_chat(user, span_warning("There are no extraction beacons in existence!"))
		return
	else
		var/chosen_beacon = tgui_input_list(user, "Beacon to connect to", "Balloon Extraction Pack", sort_names(possible_beacons))
		if(isnull(chosen_beacon))
			return
		beacon = chosen_beacon
		to_chat(user, span_notice("You link the extraction pack to the beacon system."))

/obj/item/extraction_pack/contractor
	name = "black fulton extraction pack"
	icon_state = "extraction_pack_contractor"
	can_use_indoors = TRUE
	desc = "A modified fulton pack that can be used indoors thanks to Bluespace technology. Favored by Syndicate Contractors."

/obj/item/fulton_core
	name = "extraction beacon signaller"
	desc = "Emits a signal which fulton recovery devices can lock onto. Activate in hand to create a beacon."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "subspace_amplifier"

/obj/item/fulton_core/attack_self(mob/user)
	if(do_after(user, user, 15) && !QDELETED(src))
		new /obj/structure/extraction_point(get_turf(user))
		qdel(src)

/obj/structure/extraction_point
	name = "fulton recovery beacon"
	desc = "A beacon for the fulton recovery system. Activate a pack in your hand to link it to a beacon."
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_point"
	anchored = TRUE
	density = FALSE
	var/beacon_network = "station"

/obj/structure/extraction_point/Initialize(mapload)
	. = ..()
	name += " ([rand(100,999)]) ([get_area_name(src, TRUE)])"
	GLOB.total_extraction_beacons += src

/obj/structure/extraction_point/Destroy()
	GLOB.total_extraction_beacons -= src
	return ..()

/obj/effect/extraction_holder
	name = "extraction holder"
	desc = "you shouldn't see this"
	var/atom/movable/stored_obj

/obj/item/extraction_pack/proc/check_for_living_mobs(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.stat != DEAD)
			return TRUE
	for(var/thing in A.get_all_contents())
		if(isliving(A))
			var/mob/living/L = A
			if(L.stat != DEAD)
				return TRUE
	return FALSE

/obj/effect/extraction_holder/singularity_act()
	return

/obj/effect/extraction_holder/singularity_pull()
	return
