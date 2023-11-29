// Base cartridge type. If you get this, someone fucked up somewhere.
/obj/item/reagent_containers/chem_cartridge
	name = "this should only be seen in code chemical dispenser cartridge"
	desc = "This goes in a chemical dispenser."
	desc_controls = "Use a pen to set the label."
	icon_state = "cartridge_large"
	fill_icon_state = "cartridge"
	fill_icon_thresholds = list(20, 40, 60, 80)

	w_class = WEIGHT_CLASS_BULKY

	// Large, but inaccurate. Use a chem dispenser or beaker for accuracy.
	possible_transfer_amounts = list(50,100)
	amount_per_transfer_from_this = 50

	// These are pretty robust devices.
	resistance_flags = UNACIDABLE | FIRE_PROOF | FREEZE_PROOF

	// Can be transferred to/from, but can't be spilled.
	reagent_flags = OPENCONTAINER

	// If non-null, spawns with the specified reagent filling it's volume.
	var/spawn_reagent
	// Spawn temperature. You should only change this if the stored reagent reacts at room temperature (300K).
	var/spawn_temperature = DEFAULT_REAGENT_TEMPERATURE
	// Label to use. If empty or null, no label is set. Can be set/unset by players.
	var/label

// Large cartridge. Holds 500u.
/obj/item/reagent_containers/chem_cartridge/large
	name = "large chemical dispenser cartridge"
	volume = CARTRIDGE_VOLUME_LARGE

// Medium cartridge. Holds 250u.
/obj/item/reagent_containers/chem_cartridge/medium
	name = "medium chemical dispenser cartridge"
	icon_state = "cartridge_medium"
	volume = CARTRIDGE_VOLUME_MEDIUM
	w_class = WEIGHT_CLASS_NORMAL

// Small cartridge. Holds 100u.
/obj/item/reagent_containers/chem_cartridge/small
	name = "small chemical dispenser cartridge"
	icon_state = "cartridge_small"
	volume = CARTRIDGE_VOLUME_SMALL
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/chem_cartridge/New()
	. = ..()
	// Normally this doesn't do anything, but if someone wants to create mapped-in types, this will save them many headaches.
	if(spawn_reagent)
		reagents.add_reagent(spawn_reagent, volume, reagtemp = spawn_temperature)
		var/datum/reagent/R = spawn_reagent
		setLabel(initial(R.name))
	if(length(label))
		setLabel(label)

/obj/item/reagent_containers/chem_cartridge/examine(mob/user)
	. = ..()
	to_chat(user, "It has a capacity of [volume] units.")
	if(reagents.total_volume <= 0)
		to_chat(user, "It is empty.")
	else
		to_chat(user, "It contains [reagents.total_volume] units of liquid.")

/// Sets the label of the cartridge. Care should be taken to sanitize the input before passing it in here.
/obj/item/reagent_containers/chem_cartridge/proc/setLabel(desired_label, mob/user = null)
	if(desired_label)
		if(user)
			to_chat(user, span_notice("You set the label on \the [src] to '[desired_label]'."))

		label = desired_label
		name = "[initial(name)] - '[desired_label]'"
	else
		if(user)
			to_chat(user, span_notice("You clear the label on \the [src]."))
		label = ""
		name = initial(name)

/obj/item/reagent_containers/chem_cartridge/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/pen))
		var/input = tgui_input_text(user, "Input (leave blank to clear):", "Set Label Name")
		if(input != null) // Empty string is a false value.
			setLabel()
		return TRUE

	return ..()

// Copy-pasted from beakers. This should probably be changed to a basetype thing later.
/obj/item/reagent_containers/chem_cartridge/afterattack(obj/target, mob/living/user, proximity)
	. = ..()
	if((!proximity) || !check_allowed_items(target,target_self=1))
		return

	if(target.is_refillable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src] is empty!"))
			return

		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target] is full."))
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("You transfer [trans] unit\s of the solution to [target]."))

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] is empty and can't be refilled!"))
			return

		if(reagents.holder_full())
			to_chat(user, span_warning("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("You fill [src] with [trans] unit\s of the contents of [target]."))

	target.update_appearance()

// Also copy-pasted from beakers.
/obj/item/reagent_containers/chem_cartridge/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	if((!proximity_flag) || !check_allowed_items(target,target_self=1))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!spillable)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] is empty!"))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		if(reagents.holder_full())
			to_chat(user, span_warning("[src] is full."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("You fill [src] with [trans] unit\s of the contents of [target]."))

	target.update_appearance()
	return SECONDARY_ATTACK_CONTINUE_CHAIN
