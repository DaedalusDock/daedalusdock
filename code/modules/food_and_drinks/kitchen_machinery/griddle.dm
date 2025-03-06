/obj/machinery/griddle
	name = "griddle"
	desc = "Because using pans is for pansies."
	icon = 'icons/obj/machines/kitchenmachines.dmi'
	icon_state = "griddle1_off"
	density = TRUE
	pass_flags_self = PASSMACHINE | PASSTABLE| LETPASSTHROW // It's roughly the height of a table.
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/griddle
	processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = FIRE_PROOF

	///Things that are being griddled right now
	var/list/griddled_objects = list()
	///Looping sound for the grill
	var/datum/looping_sound/grill/grill_loop
	///Whether or not the machine is turned on right now
	var/on = FALSE
	///What variant of griddle is this?
	var/variant = 1
	///How many shit fits on the griddle?
	var/max_items = 8

/obj/machinery/griddle/Initialize(mapload)
	. = ..()
	grill_loop = new(src, FALSE)
	if(isnum(variant))
		variant = rand(1,3)
	RegisterSignal(src, COMSIG_ATOM_EXPOSE_REAGENT, PROC_REF(on_expose_reagent))
	RegisterSignal(src, COMSIG_STORAGE_DUMP_CONTENT, PROC_REF(on_storage_dump))
	RegisterSignal(get_turf(src), COMSIG_ATOM_HITBY, PROC_REF(AddThrownItemToGrill))

/obj/machinery/griddle/Destroy()
	QDEL_NULL(grill_loop)
	return ..()

/obj/machinery/griddle/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(flags_1 & NODECONSTRUCT_1)
		return
	if(default_deconstruction_crowbar(I, ignore_panel = TRUE))
		return
	variant = rand(1,3)

/obj/machinery/griddle/proc/on_expose_reagent(atom/parent_atom, datum/reagent/exposing_reagent, reac_volume)
	SIGNAL_HANDLER

	if(griddled_objects.len >= max_items || !istype(exposing_reagent, /datum/reagent/consumable/pancakebatter) || reac_volume < 5)
		return NONE //make sure you have space... it's actually batter... and a proper amount of it.

	for(var/pancakes in 1 to FLOOR(reac_volume, 5) step 5) //this adds as many pancakes as you possibly could make, with 5u needed per pancake
		var/obj/item/food/pancakes/raw/new_pancake = new(src)
		new_pancake.pixel_x = rand(16,-16)
		new_pancake.pixel_y = rand(16,-16)
		AddToGrill(new_pancake)
		if(griddled_objects.len >= max_items)
			break
	visible_message(span_notice("[exposing_reagent] begins to cook on [src]."))
	return NONE

/obj/machinery/griddle/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	return default_deconstruction_crowbar(I, ignore_panel = TRUE)

/obj/machinery/griddle/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/kitchen/spatula))
		var/obj/item/offhand_item = user.get_inactive_held_item()

		if(istype(offhand_item, /obj/item/storage/bag/tray))
			var/obj/item/storage/bag/tray/collecting_tray = offhand_item
			for(var/obj/grilled_item in griddled_objects)
				collecting_tray.atom_storage.attempt_insert(grilled_item, user, TRUE)

		else if(istype(offhand_item, /obj/item/plate))
			var/obj/item/plate/collecting_plate = offhand_item
			for(var/obj/grilled_item in griddled_objects)
				if(collecting_plate.can_accept_item(grilled_item))
					if(user.transferItemToLoc(grilled_item, src, silent = FALSE))
						to_chat(user, span_notice("You place [grilled_item] on [collecting_plate]."))
						collecting_plate.AddToPlate(grilled_item, user)
						break

		else
			if(griddled_objects.len)
				to_chat(user, span_notice("You don't have a tray or plate to put the food on!"))
		return

	if(griddled_objects.len >= max_items)
		to_chat(user, span_notice("[src] can't fit more items!"))
		return

	if(istype(I, /obj/item/storage/bag/tray))
		var/obj/item/storage/bag/tray/dumping_tray = I
		if(dumping_tray.contents.len)
			dumping_tray.atom_storage.dump_content_at(src, user)
			return

	var/list/modifiers = params2list(params)
	//Center the icon where the user clicked.
	if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
		return

	if(user.transferItemToLoc(I, src, silent = FALSE))
		//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
		I.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(world.icon_size/2), world.icon_size/2)
		I.pixel_y = clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(world.icon_size/2), world.icon_size/2)
		to_chat(user, span_notice("You place [I] on [src]."))
		AddToGrill(I)
	else
		return ..()

/obj/machinery/griddle/attack_hand(mob/user, list/modifiers)
	. = ..()
	on = !on
	if(on)
		begin_processing()
	else
		end_processing()
	update_appearance()
	update_grill_audio()

/obj/machinery/griddle/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	if(get_turf(old_loc))
		UnregisterSignal(get_turf(old_loc), COMSIG_ATOM_HITBY)
	if(get_turf(src))
		RegisterSignal(get_turf(src), COMSIG_ATOM_HITBY, PROC_REF(AddThrownItemToGrill))
	. = ..()

/obj/machinery/griddle/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return ..() || (contained in griddled_objects)

/obj/machinery/griddle/proc/AddThrownItemToGrill(datum/source, atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(!isitem(hitting_atom) || griddled_objects.len >= max_items)
		return

	AddToGrill(hitting_atom)
	if(throwingdatum.thrower)
		to_chat(throwingdatum.thrower, span_notice("You throw [hitting_atom] onto [src]."))

/obj/machinery/griddle/proc/AddToGrill(obj/item/item_to_grill)
	add_viscontents(item_to_grill)
	griddled_objects += item_to_grill
	RegisterSignal(item_to_grill, COMSIG_MOVABLE_MOVED, PROC_REF(ItemMoved))
	RegisterSignal(item_to_grill, COMSIG_GRILL_COMPLETED, PROC_REF(GrillCompleted))
	RegisterSignal(item_to_grill, COMSIG_PARENT_QDELETING, PROC_REF(ItemRemovedFromGrill))
	update_grill_audio()
	update_appearance()

/obj/machinery/griddle/proc/ItemRemovedFromGrill(obj/item/I)
	SIGNAL_HANDLER
	griddled_objects -= I
	remove_viscontents(I)
	UnregisterSignal(I, list(COMSIG_GRILL_COMPLETED, COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	update_grill_audio()

/obj/machinery/griddle/proc/ItemMoved(obj/item/I, atom/OldLoc, Dir, Forced)
	SIGNAL_HANDLER
	ItemRemovedFromGrill(I)

/obj/machinery/griddle/proc/GrillCompleted(obj/item/source, atom/grilled_result)
	SIGNAL_HANDLER
	AddToGrill(grilled_result)

/obj/machinery/griddle/proc/update_grill_audio()
	if(on && griddled_objects.len)
		grill_loop.start()
	else
		grill_loop.stop()

/obj/machinery/griddle/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, time = 2 SECONDS)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/griddle/proc/on_storage_dump(datum/source, obj/item/storage_source, mob/user)
	SIGNAL_HANDLER

	for(var/obj/item/to_dump in storage_source)
		if(to_dump.loc != storage_source)
			continue
		if(griddled_objects.len >= max_items)
			break

		if(!storage_source.atom_storage.attempt_remove(to_dump, src, silent = TRUE))
			continue

		to_dump.pixel_x = to_dump.base_pixel_x + rand(-5, 5)
		to_dump.pixel_y = to_dump.base_pixel_y + rand(-5, 5)
		AddToGrill(to_dump)

	to_chat(user, span_notice("You dump out [storage_source] onto [src]."))
	return STORAGE_DUMP_HANDLED

/obj/machinery/griddle/process(delta_time)
	..()
	for(var/i in griddled_objects)
		var/obj/item/griddled_item = i
		if(SEND_SIGNAL(griddled_item, COMSIG_ITEM_GRILLED, src, delta_time) & COMPONENT_HANDLED_GRILLING)
			continue
		griddled_item.fire_act(null, 1000) //Hot hot hot!
		if(prob(10))
			visible_message(span_danger("[griddled_item] doesn't seem to be doing too great on the [src]!"))

		use_power(active_power_usage)

/obj/machinery/griddle/update_icon_state()
	icon_state = "griddle[variant]_[on ? "on" : "off"]"
	return ..()

/obj/machinery/griddle/stand
	name = "griddle stand"
	desc = "A more commercialized version of your traditional griddle. What happened to the good old days where people griddled with passion?"
	variant = "stand"

/obj/machinery/griddle/stand/update_overlays()
	. = ..()
	. += "front_bar"
