///////////////////////////////
//CABLE STRUCTURE
///////////////////////////////
////////////////////////////////
// Definitions
////////////////////////////////
/obj/structure/cable
	name = "power cable"
	desc = "A flexible, superconducting insulated cable for heavy-duty power transfer."
	icon = 'icons/obj/power_cond/cable.dmi'
	icon_state = "0"
	color = "yellow"
	layer = WIRE_LAYER //Above hidden pipes, GAS_PIPE_HIDDEN_LAYER
	anchored = TRUE
	obj_flags = CAN_BE_HIT

	/// What cable directions does this cable connect to. Uses a 0-255 bitmasking defined in 'globalvars\lists\cables.dm', with translation lists there aswell
	var/linked_dirs = NONE
	/// The powernet the cable is connected to
	var/tmp/datum/powernet/powernet
	/// If TRUE, auto_propogate_cut_cable() is sleeping
	var/tmp/awaiting_rebuild = FALSE

/obj/structure/cable/Initialize(mapload)
	. = ..()

	::cable_list += src //add it to the global cable list
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)
	RegisterSignal(src, COMSIG_RAT_INTERACT, PROC_REF(on_rat_eat))
	if(isturf(loc))
		var/turf/turf_loc = loc
		turf_loc.add_blueprints_preround(src)
	mapping_init()
	update_layer()

/obj/structure/cable/proc/mapping_init()
	linked_dirs = text2num(icon_state)
	merge_new_connections()

/obj/structure/cable/proc/is_knotted()
	var/dir_count = 0
	for(var/dir in GLOB.cable_dirs)
		if(!(linked_dirs & dir))
			continue
		dir_count++
		if(dir_count >= 2)
			return FALSE
	return TRUE

/obj/structure/cable/proc/amount_of_cables_worth()
	if(is_knotted())
		return 1
	return 2

/obj/structure/cable/proc/set_directions(new_directions, merge_connections = TRUE)
	linked_dirs = new_directions
	var/new_dir_count = 0
	for(var/dir in GLOB.cable_dirs)
		if(!(linked_dirs & dir))
			continue
		new_dir_count++
	if(new_dir_count > 2)
		CRASH("Cable has more than 2 directions on [loc.x],[loc.y],[loc.z]")
	if(merge_connections)
		merge_new_connections()
	update_appearance()

/obj/structure/cable/proc/merge_new_connections()
	if(linked_dirs == NONE)
		return
	merge_connected_cables()
	merge_connected_machines()

/obj/structure/cable/proc/on_rat_eat(datum/source, mob/living/simple_animal/hostile/regalrat/king)
	SIGNAL_HANDLER

	if(avail())
		king.apply_damage(10)
		playsound(king, 'sound/effects/sparks2.ogg', 100, TRUE)
	deconstruct()

/obj/structure/cable/Destroy() // called when a cable is deleted
	cut_cable_from_powernet() // update the powernets
	::cable_list -= src //remove it from global cable list

	return ..() // then go ahead and delete the cable

/obj/structure/cable/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(drop_location(), amount_of_cables_worth())
		coil.color = color
	qdel(src)

///////////////////////////////////
// General procedures
///////////////////////////////////

/obj/structure/cable/update_icon_state()
	icon_state = "[linked_dirs]"
	update_layer()
	return ..()

/obj/structure/cable/proc/update_layer()
	if(is_knotted())
		layer = WIRE_KNOT_LAYER
	else
		layer = WIRE_LAYER


/obj/structure/cable/examine(mob/user)
	. = ..()
	if(isobserver(user))
		. += get_power_info()

/obj/structure/cable/proc/handlecable(obj/item/W, mob/user, params)
	var/turf/T = get_turf(src)
	if(T.underfloor_accessibility < UNDERFLOOR_INTERACTABLE)
		return
	if(W.tool_behaviour == TOOL_WIRECUTTER)
		if (shock(user, 50))
			return
		user.visible_message(span_notice("[user] cuts the cable."), span_notice("You cut the cable."))
		investigate_log("was cut by [key_name(usr)] in [AREACOORD(src)]", INVESTIGATE_WIRES)
		deconstruct()
		return

	else if(W.tool_behaviour == TOOL_MULTITOOL)
		to_chat(user, get_power_info())
		shock(user, 5, 0.2)
	else if (istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = W
		coil.place_turf(loc, user, NONE, TRUE, src)


	W.leave_evidence(user, src)


/obj/structure/cable/proc/get_power_info()
	if(powernet?.avail > 0)
		return span_danger("Total power: [display_power(powernet.avail)]\nLoad: [display_power(powernet.load)]\nExcess power: [display_power(surplus())]")
	else
		return span_danger("The cable is not powered.")


// Items usable on a cable :
//   - Wirecutters : cut it duh !
//   - Multitool : get the power currently passing through the cable
//
/obj/structure/cable/attackby(obj/item/W, mob/user, params)
	handlecable(W, user, params)


// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, siemens_coeff = 1)
	if(!prob(prb))
		return FALSE
	if(electrocute_mob(user, powernet, src, siemens_coeff))
		do_sparks(5, TRUE, src)
		return TRUE
	else
		return FALSE

/obj/structure/cable/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		deconstruct()

////////////////////////////////////////////
// Power related
///////////////////////////////////////////

// All power generation handled in add_avail()
// Machines should use add_load(), surplus(), avail()
// Non-machines should use add_delayedload(), delayed_surplus(), newavail()

/// Adds power to the power net next tick.
/obj/structure/cable/proc/add_avail(amount)
	if(powernet)
		powernet.newavail += amount

/// Adds load to the power net this tick.
/obj/structure/cable/proc/add_load(amount)
	if(powernet)
		powernet.load += amount

/// How much extra power is in the power net this tick
/obj/structure/cable/proc/surplus()
	if(powernet)
		return clamp(powernet.avail-powernet.load, 0, powernet.avail)
	else
		return 0

/// How much power is available this tick.
/obj/structure/cable/proc/avail(amount)
	if(powernet)
		return amount ? powernet.avail >= amount : powernet.avail
	else
		return 0

/// Add delayed load to the power net. This should be used outside of machine/process()
/obj/structure/cable/proc/add_delayedload(amount)
	if(powernet)
		powernet.delayedload += amount

/// How much surpless is in the network next tick.
/obj/structure/cable/proc/delayed_surplus()
	if(powernet)
		return clamp(powernet.newavail - powernet.delayedload, 0, powernet.newavail)
	else
		return 0

/// How much power the network will contain next tick.
/obj/structure/cable/proc/newavail()
	if(powernet)
		return powernet.newavail
	else
		return 0

/////////////////////////////////////////////////
// Cable laying helpers
////////////////////////////////////////////////

/obj/structure/cable/proc/merge_connected_cables()
	for(var/obj/structure/cable/C as anything in get_cable_connections())
		if(!C)
			continue

		if(src == C)
			continue

		if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
			var/datum/powernet/newPN = new()
			newPN.add_cable(C)

		if(powernet) //if we already have a powernet, then merge the two powernets
			merge_powernets(powernet, C.powernet)
		else
			C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the source turf
/obj/structure/cable/proc/merge_connected_machines()
	var/list/to_connect = list()

	if(!powernet) //if we somehow have no powernet, make one (should not happen for cables)
		var/datum/powernet/newPN = new()
		newPN.add_cable(src)

	//first let's add turf cables to our powernet
	//then we'll connect machines on turf where a cable is present
	for(var/atom/movable/AM as anything in get_machine_connections())
		if(istype(AM, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/N = AM
			if(!N.terminal)
				continue // APC are connected through their terminal

			if(N.terminal.powernet == powernet) //already connected
				continue

			to_connect += N.terminal //we'll connect the machines after all cables are merged

		else if(istype(AM, /obj/machinery/power)) //other power machines
			var/obj/machinery/power/M = AM

			if(M.powernet == powernet)
				continue

			to_connect += M //we'll connect the machines after all cables are merged

	//now that cables are done, let's connect found machines
	for(var/obj/machinery/power/PM in to_connect)
		if(!PM.connect_to_network())
			PM.disconnect_from_network() //if we somehow can't connect the machine to the new powernet, remove it from the old nonetheless

//////////////////////////////////////////////
// Powernets handling helpers
//////////////////////////////////////////////

/obj/structure/cable/proc/get_cable_connections(powernetless_only = FALSE)
	. = list()
	var/static/list/diagonal_masking_pair = list(NORTH|SOUTH, EAST|WEST)
	var/turf/T
	for(var/cable_dir in GLOB.cable_dirs)
		if(!(linked_dirs & cable_dir))
			continue
		var/inverse_cable_dir = GLOB.cable_dirs_to_inverse["[cable_dir]"]
		var/real_dir = GLOB.cable_dirs_to_real_dirs["[cable_dir]"]
		// Is it diagonal? Yes? Detour into this special shitty hack.
		// This is 1:1 copied from baycode, With comments.
		// Am I being passive aggressive? I think this qualifies as more than that.
		if(ISDIAGONALDIR(real_dir))
			for(var/component_pair in diagonal_masking_pair)
				T = get_step(src, real_dir & component_pair)
				if(T)
					// Determine the direction value we need to see.
					// (real_dir XOR component_pair) will functionally flip the relevant component's parity.
					// Eg. SOUTHWEST (2,8) XOR (1,2) = NORTHWEST (1,8)
					// And then we pass this perfectly unusable value into the Obfuscatomat.
					var/diag_req_dir = GLOB.real_dirs_to_cable_dirs["[real_dir ^ component_pair]"]
					for(var/obj/structure/cable/diag_cable in T)
						if(diag_cable.linked_dirs & diag_req_dir)
							. += diag_cable

		var/turf/step_turf = get_step(src, real_dir)
		for(var/obj/structure/cable/cable_structure in step_turf)
			// if cable structure doesn't have a direction inverse to our cable direction, ignore it
			if(!(cable_structure.linked_dirs & inverse_cable_dir))
				continue
			if(powernetless_only && cable_structure.powernet)
				continue
			. += cable_structure
	// Connect to other knotted cables if we are knotted
	if(is_knotted())
		for(var/obj/structure/cable/cable_structure in get_turf(src))
			if(cable_structure == src)
				continue
			if(!cable_structure.is_knotted())
				continue
			. += cable_structure


/obj/structure/cable/proc/get_machine_connections(powernetless_only = FALSE)
	. = list()
	if(!is_knotted())
		return
	for(var/obj/machinery/power/P in get_turf(src))
		if(powernetless_only && P.powernet)
			continue
		if(P.anchored)
			. += P

/obj/structure/cable/proc/rotate_clockwise_amount(amount)
	if(amount <= 0)
		return
	var/current_links = linked_dirs
	for(var/i in 1 to amount)
		var/list/current_dirs = list()
		for(var/cable_dir in GLOB.cable_dirs)
			if(!(current_links & cable_dir))
				continue
			current_dirs += cable_dir

		var/new_links = NONE
		for(var/cable_dir in current_dirs)
			new_links |= GLOB.cable_dir_rotate_clockwise["[cable_dir]"]
		current_links = new_links

	set_directions(current_links, FALSE)

/obj/structure/cable/proc/auto_propagate_cut_cable()
	set waitfor = FALSE
	if(awaiting_rebuild)
		return

	awaiting_rebuild = TRUE
	var/slept = FALSE
	while(!QDELETED(src) && SSexplosions.is_exploding())
		slept = TRUE
		sleep(world.tick_lag)

	if(QDELETED(src))
		return

	awaiting_rebuild = FALSE

	//NOTE: If packets are acting weird during very high SSpackets load (if you somehow manage to overload it to the point that you're losing packets from powernet rebuilds...), start looking here.
	var/datum/powernet/newPN = new()// creates a new powernet...
	if(slept)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(propagate_network), src, newPN), 0)
	else
		propagate_network(src, newPN)

//Makes a new network for the cable and propgates it. If we already have one, just die
/obj/structure/cable/proc/propagate_if_no_network()
	if(powernet)
		return
	var/datum/powernet/newPN = new()
	propagate_network(src, newPN)

// cut the cable's powernet at this cable and updates the powergrid
/obj/structure/cable/proc/cut_cable_from_powernet(remove = TRUE)
	if(!powernet)
		return

	var/turf/T1 = loc
	if(!T1)
		return

	//clear the powernet of any machines on tile first
	for(var/obj/machinery/power/P in T1)
		P.disconnect_from_network()

	var/list/P_list = get_cable_connections()

	// remove the cut cable from its turf and powernet, so that it doesn't get count in propagate_network worklist
	if(remove)
		moveToNullspace()
	powernet.remove_cable(src) //remove the cut cable from its powernet

	var/first = TRUE
	for(var/obj/structure/cable/cable in P_list)
		if(first)
			first = FALSE
			continue
		//so we don't rebuild the network X times when singulo/explosion destroys a line of X cables
		cable.auto_propagate_cut_cable()
		//addtimer(CALLBACK(O, PROC_REF(auto_propagate_cut_cable), O), 0)

///////////////////////////////////////////////
// Cable variants for mapping
///////////////////////////////////////////////

/obj/structure/cable/red
	color = COLOR_RED

/obj/structure/cable/yellow
	color = COLOR_YELLOW

/obj/structure/cable/blue
	color = COLOR_STRONG_BLUE

/obj/structure/cable/green
	color = COLOR_DARK_LIME

/obj/structure/cable/pink
	color = COLOR_LIGHT_PINK

/obj/structure/cable/orange
	color = COLOR_MOSTLY_PURE_ORANGE

/obj/structure/cable/cyan
	color = COLOR_CYAN

/obj/structure/cable/white
	color = COLOR_WHITE

///////////////////////////////////////////////
// The cable coil object, used for laying cable
///////////////////////////////////////////////

////////////////////////////////
// Definitions
////////////////////////////////

#define CABLE_RESTRAINTS_COST 15

/obj/item/stack/cable_coil
	name = "cable coil"
	custom_price = PAYCHECK_ASSISTANT * 0.8
	multiple_gender = NEUTER //That's a cable coil sounds better than that's some cable coils
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	inhand_icon_state = "coil"
	base_icon_state = "coil"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	max_amount = MAXCOIL
	amount = MAXCOIL
	merge_type = /obj/item/stack/cable_coil // This is here to let its children merge between themselves
	color = "yellow"
	desc = "A coil of insulated power cable."
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL

	throw_range = 5

	stamina_damage = 5
	stamina_cost = 5
	stamina_critical_chance = 10

	mats_per_unit = list(/datum/material/iron=10, /datum/material/glass=5)
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("whips", "lashes", "disciplines", "flogs")
	attack_verb_simple = list("whip", "lash", "discipline", "flog")
	singular_name = "cable piece"
	full_w_class = WEIGHT_CLASS_SMALL
	grind_results = list(/datum/reagent/copper = 2) //2 copper per cable in the coil
	usesound = 'sound/items/deconstruct.ogg'
	cost = 1
	source = /datum/robot_energy_storage/wire

	/// Handles the click foo.
	var/datum/cable_click_manager/click_manager
	/// Previous position stored for purposes of cable laying
	var/turf/previous_position = null
	/// Whether we are in a cable laying mode
	var/cable_layer_mode = FALSE
	/// Reference to the mob laying the cables
	var/mob/living/mob_layer = null

/obj/item/stack/cable_coil/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = base_pixel_x + rand(-2, 2)
	pixel_y = base_pixel_y + rand(-2, 2)
	update_appearance()

/obj/item/stack/cable_coil/Destroy(force)
	QDEL_NULL(click_manager)
	set_cable_layer_mode(FALSE)
	return ..()

/obj/item/stack/cable_coil/examine(mob/user)
	. = ..()
	. += "<b>Right Click</b> on the floor to enable Advanced Placement."
	. += "<b>Ctrl+Click</b> to change the layer you are placing on."

/obj/item/stack/cable_coil/update_name()
	. = ..()
	name = "cable [(amount < 3) ? "piece" : "coil"]"

/obj/item/stack/cable_coil/update_desc()
	. = ..()
	desc = "A [(amount < 3) ? "piece" : "coil"] of insulated power cable."

/obj/item/stack/cable_coil/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][amount < 3 ? amount : ""]"


/obj/item/stack/cable_coil/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDS)
		if(isnull(click_manager))
			click_manager = new(src)

		click_manager.set_user(user)

/obj/item/stack/cable_coil/unequipped()
	. = ..()
	click_manager?.set_user(null)

/obj/item/stack/cable_coil/use(used, transfer, check)
	. = ..()
	update_appearance()

/obj/item/stack/cable_coil/suicide_act(mob/user)
	if(locate(/obj/structure/chair/stool) in get_turf(user))
		user.visible_message(span_suicide("[user] is making a noose with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	else
		user.visible_message(span_suicide("[user] is strangling [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return(OXYLOSS)

/obj/item/stack/cable_coil/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/stack/cable_coil/attack_self(mob/living/user)
	if(!user)
		return
	if(cable_layer_mode)
		turn_off_cable_layer_mode(user)
		return

	var/image/restraints_icon = image(icon = 'icons/obj/restraints.dmi', icon_state = "cuff")
	restraints_icon.maptext = MAPTEXT("<span [amount >= CABLE_RESTRAINTS_COST ? "" : "style='color: red'"]>[CABLE_RESTRAINTS_COST]</span>")

	var/list/radial_menu = list(
	"Cable layer mode" = image(icon = 'icons/obj/tools.dmi', icon_state = "rcl-30"),
	"Multi Z layer cable hub" = image(icon = 'icons/obj/power.dmi', icon_state = "cablerelay-broken-cable"),
	"Cable restraints" = restraints_icon
	)

	var/layer_result = show_radial_menu(user, src, radial_menu, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(layer_result)
		if("Cable layer mode")
			turn_on_cable_layer_mode(user)
			return
		if("Multi Z layer cable hub")
			try_construct_multiz_hub(user)
			return
		if("Cable restraints")
			if (amount < CABLE_RESTRAINTS_COST)
				return
			if(!use(CABLE_RESTRAINTS_COST))
				return
			var/obj/item/restraints/handcuffs/cable/restraints = new
			restraints.color = color
			user.put_in_hands(restraints)
	update_appearance()

/obj/item/stack/cable_coil/unequipped(mob/wearer)
	. = ..()
	set_cable_layer_mode(FALSE, null)

/obj/item/stack/cable_coil/proc/turn_off_cable_layer_mode(mob/user)
	to_chat(user, span_notice("You stop laying cables."))
	set_cable_layer_mode(FALSE, null)

/obj/item/stack/cable_coil/proc/turn_on_cable_layer_mode(mob/user)
	to_chat(user, span_notice("You start laying cables as you move..."))
	set_cable_layer_mode(TRUE, user)

/obj/item/stack/cable_coil/proc/set_cable_layer_mode(new_state, mob/user)
	if(user == null || new_state == FALSE)
		new_state = FALSE
		user = null
	if(new_state == cable_layer_mode)
		return
	if(new_state)
		previous_position = get_turf(user)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(cable_layer_moved))
	else
		previous_position = null
		UnregisterSignal(mob_layer, COMSIG_MOVABLE_MOVED)
	cable_layer_mode = new_state
	mob_layer = user

/obj/item/stack/cable_coil/proc/cable_layer_moved(mob/user)
	SIGNAL_HANDLER
	lay_cable(user)
	previous_position = get_turf(user)

/obj/item/stack/cable_coil/proc/lay_cable(mob/user)
	if(user.incapacitated())
		return
	var/turf/current_position = get_turf(user)
	if(current_position == previous_position)
		return
	var/dir = get_dir(current_position, previous_position)
	var/inverse_dir = get_dir(previous_position, current_position)
	var/cable_dir = GLOB.real_dirs_to_cable_dirs["[dir]"]
	var/inverse_cable_dir = GLOB.real_dirs_to_cable_dirs["[inverse_dir]"]

	// Place on previous position
	cable_laying_place_turf(previous_position, user, inverse_cable_dir)

	// Exit function if cable ran out
	if(QDELETED(src))
		to_chat(user, span_warning("You run out of cable!"))
		return

	//Place on new position
	cable_laying_place_turf(current_position, user, cable_dir)

	// Once again, but mostly to alert the player that it ran out
	if(QDELETED(src))
		to_chat(user, span_warning("You run out of cable!"))
		return

/obj/item/stack/cable_coil/proc/cable_laying_place_turf(turf/T, mob/user, cable_direction = NONE)
	// Don't place over already cabled places that match the same direction (makes it less messy, but unable to connect to existing lines)
	for(var/obj/structure/cable/cable_on_turf in T)
		if(cable_on_turf.linked_dirs & cable_direction)
			return
	place_turf(T, user, cable_direction, TRUE)

/obj/item/stack/cable_coil/proc/try_construct_multiz_hub(mob/user)
	if(!use(1))
		return
	new /obj/structure/cable/multiz(get_turf(user))
	to_chat(user, span_notice("You construct the multi Z layer cable hub."))

///////////////////////////////////
// General procedures
///////////////////////////////////
//you can use wires to heal robotics
/obj/item/stack/cable_coil/attack(mob/living/carbon/human/H, mob/user)
	if(!istype(H))
		return ..()

	var/obj/item/bodypart/affecting = H.get_bodypart(deprecise_zone(user.zone_selected))
	if(affecting && !IS_ORGANIC_LIMB(affecting))
		if(user == H)
			user.visible_message(span_notice("[user] starts to fix some of the wires in [H]'s [affecting.name]."), span_notice("You start fixing some of the wires in [H == user ? "your" : "[H]'s"] [affecting.name]."))
			if(!do_after(user, H, 50))
				return
		if(item_heal_robotic(H, user, 0, 15))
			use(1)
		return
	else
		return ..()


///////////////////////////////////////////////
// Cable laying procedures
//////////////////////////////////////////////

// called when cable_coil is clicked on a turf
/obj/item/stack/cable_coil/proc/place_turf(turf/T, mob/user, cable_direction = NONE, connect_to_knotted = FALSE, obj/structure/cable/target_knot = null)
	if(!isturf(user.loc))
		return

	if(!isturf(T) || T.underfloor_accessibility < UNDERFLOOR_INTERACTABLE || !T.can_have_cabling())
		to_chat(user, span_warning("You can only lay cables on catwalks and plating!"))
		return

	if(get_amount() < 1) // Out of cable
		to_chat(user, span_warning("There is no cable left!"))
		return

	if(get_dist(T,user) > 1) // Too far
		to_chat(user, span_warning("You can't lay cable at a place that far away!"))
		return

	var/desired_cable_position = cable_direction
	if(desired_cable_position == NONE)
		var/target_real_dir
		if(get_turf(user) == T)
			target_real_dir = user.dir
		else
			target_real_dir = get_dir(user.loc, T)
			target_real_dir = turn(target_real_dir, 180)
		var/inverse_cable_dir = GLOB.real_dirs_to_cable_dirs["[target_real_dir]"]
		desired_cable_position = inverse_cable_dir //just to be more verbose

	var/adding_to_knotted = FALSE

	var/obj/structure/cable/C
	// See if there's any knotted cables we can add onto, if that's what we want to do
	if(connect_to_knotted)
		if(target_knot && target_knot.is_knotted())
			C = target_knot
			adding_to_knotted = TRUE
		else
			for(var/obj/structure/cable/cable_on_turf in T)
				if(!cable_on_turf.is_knotted())
					continue
				C = cable_on_turf
				adding_to_knotted = TRUE
				break

	if(!C)
		C = new /obj/structure/cable(T)
		C.color = color

	var/target_directions = C.linked_dirs
	target_directions |= desired_cable_position

	if(adding_to_knotted)
		if(desired_cable_position == C.linked_dirs)
			to_chat(user, span_warning("There's already a cable at that position!"))
			return
		for(var/obj/structure/cable/cable_on_turf in T)
			if(cable_on_turf.is_knotted())
				continue
			if(cable_on_turf.linked_dirs == target_directions)
				to_chat(user, span_warning("There's already a cable at that position!"))
				return
	else
		for(var/obj/structure/cable/cable_on_turf in T)
			if(cable_on_turf.linked_dirs == target_directions)
				to_chat(user, span_warning("There's already a cable at that position!"))
				qdel(C)
				return

	//create a new powernet with the cable, if needed it will be merged later
	var/datum/powernet/PN = new()
	PN.add_cable(C)

	C.set_directions(target_directions)

	use(1)

	if(C.shock(user, 50))
		if(prob(50)) //fail
			C.deconstruct()

	return C

/obj/item/stack/cable_coil/five
	amount = 5

/obj/item/stack/cable_coil/ten
	amount = 10

/obj/item/stack/cable_coil/cut
	amount = null
	icon_state = "coil2"
	worn_icon_state = "coil"
	base_icon_state = "coil2"

/obj/item/stack/cable_coil/cut/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	if(!amount)
		amount = rand(1,2)
	. = ..()
	pixel_x = base_pixel_x + rand(-2, 2)
	pixel_y = base_pixel_y + rand(-2, 2)
	update_appearance()

/obj/item/stack/cable_coil/random

/obj/item/stack/cable_coil/random/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	var/list/cable_colors_list = GLOB.cable_colors
	var/random_color = pick(cable_colors_list)
	color = cable_colors_list[random_color]
	. = ..()

/obj/item/stack/cable_coil/red
	color = COLOR_RED

/obj/item/stack/cable_coil/yellow
	color = COLOR_YELLOW

/obj/item/stack/cable_coil/blue
	color = COLOR_STRONG_BLUE

/obj/item/stack/cable_coil/green
	color = COLOR_DARK_LIME

/obj/item/stack/cable_coil/pink
	color = COLOR_LIGHT_PINK

/obj/item/stack/cable_coil/orange
	color = COLOR_MOSTLY_PURE_ORANGE

/obj/item/stack/cable_coil/cyan
	color = COLOR_CYAN

/obj/item/stack/cable_coil/white
	color = COLOR_WHITE

#undef CABLE_RESTRAINTS_COST
