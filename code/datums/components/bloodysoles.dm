
/**
 * Component for clothing items that can pick up blood from decals and spread it around everywhere when walking, such as shoes or suits with integrated shoes.
 */
/datum/component/bloodysoles
	/// The type of the last grub pool we stepped in, used to decide the type of footprints to make
	var/last_blood_color = null

	/// How much of each grubby type we have on our feet
	var/list/bloody_shoes = list()

	/// The ITEM_SLOT_* slot the item is equipped on, if it is.
	var/equipped_slot

	/// The parent item but casted into atom type for easier use.
	var/atom/parent_atom

	/// Either the mob carrying the item, or the mob itself for the /feet component subtype
	var/mob/living/carbon/wielder

	/// The world.time when we last picked up blood
	var/last_pickup

	var/blood_print = BLOOD_PRINT_HUMAN

/datum/component/bloodysoles/Initialize()
	if(!isclothing(parent))
		return COMPONENT_INCOMPATIBLE

	parent_atom = parent

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_UNEQUIPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_clean))

/**
 * Unregisters from the wielder if necessary
 */
/datum/component/bloodysoles/proc/unregister()
	if(!QDELETED(wielder))
		UnregisterSignal(wielder, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(wielder, COMSIG_STEP_ON_BLOOD)
	wielder = null
	equipped_slot = null

/**
 * Returns true if the parent item is obscured by something else that the wielder is wearing
 */
/datum/component/bloodysoles/proc/is_obscured()
	return wielder.check_obscured_slots(TRUE) & equipped_slot

/**
 * Run to update the icon of the parent
 */
/datum/component/bloodysoles/proc/update_icon()
	var/obj/item/parent_item = parent
	parent_item.update_slot_icon()


/datum/component/bloodysoles/proc/reset_bloody_shoes()
	bloody_shoes = list()
	on_changed_bloody_shoes()

///lowers bloody_shoes[index] by adjust_by
/datum/component/bloodysoles/proc/adjust_bloody_shoes(index, adjust_by)
	bloody_shoes[index] = max(bloody_shoes[index] - adjust_by, 0)
	on_changed_bloody_shoes(index)

/datum/component/bloodysoles/proc/set_bloody_shoes(index, new_value)
	bloody_shoes[index] = new_value
	on_changed_bloody_shoes(index)

///called whenever the value of bloody_soles changes
/datum/component/bloodysoles/proc/on_changed_bloody_shoes(index)
	if(index && index != last_blood_color)
		last_blood_color = index

	if(!wielder)
		return

	if(bloody_shoes[index] <= BLOOD_FOOTPRINTS_MIN * 2)//need twice that amount to make footprints
		UnregisterSignal(wielder, COMSIG_MOVABLE_MOVED)
	else
		RegisterSignal(wielder, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)

/**
 * Run to equally share the blood between us and a decal
 */
/datum/component/bloodysoles/proc/share_blood(obj/effect/decal/cleanable/pool)
	// Share the blood between our boots and the blood pool
	var/total_bloodiness = pool.bloodiness + bloody_shoes[pool.blood_color]

	// We can however be limited by how much blood we can hold
	var/new_our_bloodiness = min(BLOOD_ITEM_MAX, total_bloodiness / 2)

	set_bloody_shoes(pool.blood_color, new_our_bloodiness)
	pool.bloodiness = total_bloodiness - new_our_bloodiness // Give the pool the remaining blood incase we were limited

	if(HAS_TRAIT(parent_atom, TRAIT_LIGHT_STEP)) //the character is agile enough to don't mess their clothing and hands just from one blood splatter at floor
		return TRUE

	if(ishuman(parent_atom))
		var/bloody_slots = ITEM_SLOT_OCLOTHING|ITEM_SLOT_ICLOTHING|ITEM_SLOT_FEET
		var/mob/living/carbon/human/to_bloody = parent_atom
		if(to_bloody.body_position == LYING_DOWN)
			bloody_slots |= ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_GLOVES

		to_bloody.add_blood_DNA_to_items(pool.return_blood_DNA(), bloody_slots)

	else
		parent_atom.add_blood_DNA(pool.return_blood_DNA())

	if(pool.bloodiness <= 0)
		qdel(pool)

	update_icon()

/**
 * Find a blood decal on a turf that matches our last_blood_color
 */
/datum/component/bloodysoles/proc/find_pool_by_blood_state(turf/turfLoc, typeFilter = null, blood_print)
	for(var/obj/effect/decal/cleanable/blood/pool in turfLoc)
		if(pool.blood_color == last_blood_color && pool.blood_print == blood_print && (!typeFilter || istype(pool, typeFilter)))
			return pool

/**
 * Adds the parent type to the footprint's shoe_types var
 */
/datum/component/bloodysoles/proc/add_parent_to_footprint(obj/effect/decal/cleanable/blood/footprints/FP)
	FP.shoe_types |= parent.type

/**
 * Called when the parent item is equipped by someone
 *
 * Used to register our wielder
 */
/datum/component/bloodysoles/proc/on_equip(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(!iscarbon(equipper))
		return
	var/obj/item/parent_item = parent
	if(!(parent_item.slot_flags & slot))
		unregister()
		return

	equipped_slot = slot
	wielder = equipper
	if(bloody_shoes[last_blood_color] > BLOOD_FOOTPRINTS_MIN * 2)
		RegisterSignal(wielder, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(wielder, COMSIG_STEP_ON_BLOOD, PROC_REF(on_step_blood))

/**
 * Called when the parent item has been dropped
 *
 * Used to deregister our wielder
 */
/datum/component/bloodysoles/proc/on_drop(datum/source, mob/dropper)
	SIGNAL_HANDLER

	unregister()

/**
 * Called when the wielder has moved
 *
 * Used to make bloody footprints on the ground
 */
/datum/component/bloodysoles/proc/on_moved(datum/source, OldLoc, Dir, Forced)
	SIGNAL_HANDLER

	if(!bloody_shoes[last_blood_color])
		return
	if(QDELETED(wielder) || is_obscured())
		return
	if(wielder.body_position == LYING_DOWN || !wielder.has_gravity(wielder.loc))
		return

	var/half_our_blood = bloody_shoes[last_blood_color] / 2

	var/blood_print = wielder.get_blood_print()

	// Add footprints in old loc if we have enough cream
	if(half_our_blood >= BLOOD_FOOTPRINTS_MIN)
		var/turf/oldLocTurf = get_turf(OldLoc)
		var/obj/effect/decal/cleanable/blood/footprints/oldLocFP = find_pool_by_blood_state(oldLocTurf, /obj/effect/decal/cleanable/blood/footprints, blood_print)
		if(oldLocFP)
			// Footprints found in the tile we left, add us to it
			add_parent_to_footprint(oldLocFP)
			if (!(oldLocFP.exited_dirs & wielder.dir))
				oldLocFP.exited_dirs |= wielder.dir
				oldLocFP.update_appearance()

		else if(find_pool_by_blood_state(oldLocTurf, blood_print = blood_print))
			// No footprints in the tile we left, but there was some other blood pool there. Add exit footprints on it
			adjust_bloody_shoes(last_blood_color, half_our_blood)
			update_icon()

			oldLocFP = new(oldLocTurf, null, parent_atom.return_blood_DNA(), blood_print)
			if(!QDELETED(oldLocFP)) ///prints merged
				oldLocFP.exited_dirs |= wielder.dir
				add_parent_to_footprint(oldLocFP)
				oldLocFP.bloodiness = half_our_blood
				oldLocFP.update_appearance()

			half_our_blood = bloody_shoes[last_blood_color] / 2

	// If we picked up the blood on this tick in on_step_blood, don't make footprints at the same place
	if(last_pickup && last_pickup == world.time)
		return

	// Create new footprints
	if(half_our_blood >= BLOOD_FOOTPRINTS_MIN)
		adjust_bloody_shoes(last_blood_color, half_our_blood)
		update_icon()

		var/obj/effect/decal/cleanable/blood/footprints/FP = new(get_turf(parent_atom), null, parent_atom.return_blood_DNA(), blood_print)
		if(!QDELETED(FP)) ///prints merged
			FP.blood_color = last_blood_color
			FP.entered_dirs |= wielder.dir
			add_parent_to_footprint(FP)
			FP.bloodiness = half_our_blood
			FP.update_appearance()


/**
 * Called when the wielder steps in a pool of blood
 *
 * Used to make the parent item bloody
 */
/datum/component/bloodysoles/proc/on_step_blood(datum/source, obj/effect/decal/cleanable/pool)
	SIGNAL_HANDLER

	if(QDELETED(wielder) || is_obscured())
		return

	if(istype(pool, /obj/effect/decal/cleanable/blood/footprints) && pool.blood_color == last_blood_color)
		// The pool we stepped in was actually footprints with the same type
		var/obj/effect/decal/cleanable/blood/footprints/pool_FP = pool
		add_parent_to_footprint(pool_FP)
		if((bloody_shoes[last_blood_color] / 2) >= BLOOD_FOOTPRINTS_MIN && !(pool_FP.entered_dirs & wielder.dir))
			// If our feet are bloody enough, add an entered dir
			pool_FP.entered_dirs |= wielder.dir
			pool_FP.update_appearance()

	share_blood(pool)

	last_pickup = world.time

/**
 * Called when the parent item is being washed
 */
/datum/component/bloodysoles/proc/on_clean(datum/source, clean_types)
	SIGNAL_HANDLER

	if(!(clean_types & CLEAN_TYPE_BLOOD) || last_blood_color == null)
		return NONE

	reset_bloody_shoes()
	update_icon()
	return COMPONENT_CLEANED


/**
 * Like its parent but can be applied to carbon mobs instead of clothing items
 */
/datum/component/bloodysoles/feet

/datum/component/bloodysoles/feet/Initialize(blood_print)
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

	parent_atom = parent
	wielder = parent
	if(blood_print)
		src.blood_print = blood_print

	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_clean))
	RegisterSignal(parent, COMSIG_STEP_ON_BLOOD, PROC_REF(on_step_blood))
	RegisterSignal(parent, COMSIG_CARBON_UNEQUIP_SHOECOVER, PROC_REF(unequip_shoecover))
	RegisterSignal(parent, COMSIG_CARBON_EQUIP_SHOECOVER, PROC_REF(equip_shoecover))

/datum/component/bloodysoles/feet/update_icon()
	if(ishuman(wielder))
		var/mob/living/carbon/human/human = wielder
		if(NOBLOODOVERLAY in human.dna.species.species_traits)
			return
		var/obj/item/bodypart/leg = human.get_bodypart(BODY_ZONE_R_LEG) || human.get_bodypart(BODY_ZONE_L_LEG)
		if(!leg?.icon_bloodycover)
			return

		if(length(bloody_shoes) && !is_obscured())
			human.remove_overlay(SHOES_LAYER)
			var/image/blood_overlay = image(leg.icon_bloodycover, "shoeblood")
			blood_overlay.color = last_blood_color
			human.overlays_standing[SHOES_LAYER] = blood_overlay
			human.apply_overlay(SHOES_LAYER)
		else
			human.update_worn_shoes()

/datum/component/bloodysoles/feet/add_parent_to_footprint(obj/effect/decal/cleanable/blood/footprints/FP)
	return

/datum/component/bloodysoles/feet/is_obscured()
	if(wielder.shoes)
		return TRUE
	return wielder.check_obscured_slots(TRUE) & ITEM_SLOT_FEET

/datum/component/bloodysoles/feet/on_moved(datum/source, OldLoc, Dir, Forced)
	if(wielder.num_legs < 2)
		return

	..()

/datum/component/bloodysoles/feet/on_step_blood(datum/source, obj/effect/decal/cleanable/pool)
	if(wielder.num_legs < 2)
		return

	..()

/datum/component/bloodysoles/feet/proc/unequip_shoecover(datum/source)
	SIGNAL_HANDLER

	update_icon()

/datum/component/bloodysoles/feet/proc/equip_shoecover(datum/source)
	SIGNAL_HANDLER

	update_icon()
