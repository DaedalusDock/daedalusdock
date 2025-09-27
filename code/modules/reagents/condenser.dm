/obj/item/reagent_containers/cup/condenser
	name = "chemical condenser"
	desc = "TODO"

	icon = 'goon/icons/obj/condenser.dmi'
	icon_state = "condenser"
	inhand_icon_state = "beaker"
	worn_icon_state = "beaker"

	fill_icon_file = 'goon/icons/obj/condenser.dmi'
	fill_icon_state = "f-condenser"
	fill_icon_thresholds = list(0, 1, 25, 50, 75, 100)

	volume = 60

	var/tmp/datum/looping_sound/boiling/loop

	/// Cup attached to the assembly
	var/tmp/obj/item/reagent_containers/cup/beaker/output

	/// Holds the vaporized reagent so we can cool it down before passing it onto the output.
	var/tmp/datum/reagents/temp_holder

/obj/item/reagent_containers/cup/condenser/Initialize(mapload, vol)
	. = ..()
	temp_holder = new(volume)
	loop = new(src)
	register_context()
	START_PROCESSING(SSfastprocess, src)

/obj/item/reagent_containers/cup/condenser/Destroy(force)
	STOP_PROCESSING(SSfastprocess, src)
	QDEL_NULL(output)
	QDEL_NULL(temp_holder)
	QDEL_NULL(loop)
	return ..()

/obj/item/reagent_containers/cup/condenser/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(istype(held_item, /obj/item/reagent_containers/cup/beaker))
		context[SCREENTIP_CONTEXT_RMB] = "Attach Beaker"
		. = CONTEXTUAL_SCREENTIP_SET

	else if(isnull(held_item) && output)
		context[SCREENTIP_CONTEXT_LMB] = "Remove Beaker"
		. = CONTEXTUAL_SCREENTIP_SET

/obj/item/reagent_containers/cup/condenser/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/reagent_containers/cup/beaker))
		return ..()

	if(output)
		to_chat(user, span_warning("[src]'s output already has a container."))
		return ITEM_INTERACT_BLOCKING

	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING

	set_output(tool)
	visible_message("[user] attaches [tool] to [src].")
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/cup/condenser/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!output)
		return

	if(!user.pickup_item(output))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	output.do_pickup_animation(user, get_turf(src))
	set_output(null)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/reagent_containers/cup/condenser/update_overlays()
	. = ..()
	if(!output)
		return

	var/mutable_appearance/output_overlay = new(output)
	output_overlay.plane = FLOAT_PLANE
	output_overlay.layer = FLOAT_LAYER
	output_overlay.pixel_x = 11
	output_overlay.pixel_y = output.condenser_offset_y
	. += output_overlay

	. += image(icon, "condenser-pipe")

/obj/item/reagent_containers/cup/condenser/proc/set_output(obj/item/reagent_containers/cup/beaker/new_output)
	if(output)
		UnregisterSignal(output, COMSIG_PARENT_QDELETING)

	output = new_output

	if(!output)
		update_appearance(UPDATE_OVERLAYS)
		return

	RegisterSignal(output, COMSIG_PARENT_QDELETING, PROC_REF(output_deleted))
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/cup/condenser/proc/output_deleted(datum/source)
	SIGNAL_HANDLER
	set_output(null)

/obj/item/reagent_containers/cup/condenser/process(delta_time)
	var/reagents_moved = FALSE
	for(var/datum/reagent/R as anything in reagents.reagent_list)
		if(isnull(R.boiling_point) || reagents.chem_temp < R.boiling_point) // Solids can sublimate, theoretically.
			continue

		reagents_moved = TRUE
		var/transfer_rate = R.boil_off_rate * delta_time

		if(!output || (R.state == GAS))
			reagents.remove_reagent(R.type, transfer_rate)
			continue

		reagents.trans_id_to(temp_holder, R.type, transfer_rate, no_react = TRUE)
		temp_holder.set_temperature(R.dew_point)
		temp_holder.trans_to(output, temp_holder.maximum_volume, no_react = TRUE)

	if(reagents_moved)
		loop.start()
		reagents.handle_reactions()
		output?.reagents.handle_reactions()
	else
		loop.stop()

