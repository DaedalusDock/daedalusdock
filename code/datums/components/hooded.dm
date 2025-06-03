/datum/component/hooded
	var/datum/action/item_action/toggle_hood/toggle_action
	/// Hood instance
	var/obj/item/clothing/head/hood
	/// Type path of the hood
	var/hood_type

	/// Callback invoked before equipping a hood, returning FALSE aborts.
	var/datum/callback/pre_equip_hood
	/// Callback invoked after create_hood().
	var/datum/callback/on_hood_created
	/// Callback invoked after must_unequip_hood().
	var/datum/callback/on_hood_unequip
	/// Callback invoked after try_unequip_hood().
	var/datum/callback/on_hood_equip


	/// Suffix applied to parent icon_state while the hood is up.
	var/parent_icon_suffix

	/// If TRUE, the hood is qdeleted and spawned when equipped instead of simply unequipped.
	var/delete_unequipped_hood

	var/hood_active = FALSE

/datum/component/hooded/Initialize(_hood_type, _parent_icon_suffix, _delete_unequipped_hood, _pre_equip_hood, _on_hood_created, _on_hood_unequip, _on_hood_equip)
	var/obj/item/clothing/clothing_parent = parent
	toggle_action = new(clothing_parent)
	clothing_parent.add_item_action(toggle_action)

	hood_type = _hood_type
	parent_icon_suffix = _parent_icon_suffix
	delete_unequipped_hood = _delete_unequipped_hood
	pre_equip_hood = _pre_equip_hood
	on_hood_created = _on_hood_created
	on_hood_unequip = _on_hood_unequip
	on_hood_equip = on_hood_unequip

	if(!delete_unequipped_hood)
		create_hood()

	RegisterSignal(clothing_parent, COMSIG_ITEM_UI_ACTION_CLICK, PROC_REF(on_action_click))
	RegisterSignal(clothing_parent, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(parent_unequipped))

/datum/component/hooded/Destroy(force, silent)
	UnregisterSignal(parent, list(COMSIG_ITEM_UI_ACTION_CLICK, COMSIG_ITEM_POST_UNEQUIP))
	QDEL_NULL(hood)

	var/obj/item/clothing/clothing_parent = parent
	clothing_parent.remove_item_action(toggle_action)
	QDEL_NULL(toggle_action)
	return ..()

/// Creates a new hood
/datum/component/hooded/proc/create_hood()
	hood = new hood_type(parent)
	RegisterSignal(hood, COMSIG_PARENT_QDELETING, PROC_REF(hood_gone))
	RegisterSignal(hood, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(hood_unequipped))
	RegisterSignal(hood, COMSIG_ITEM_EQUIPPED, PROC_REF(hood_equipped))

	on_hood_created?.Invoke(hood)

/// Attempt to equip the hood.
/datum/component/hooded/proc/try_equip_hood(obj/item/clothing/clothing_parent, mob/living/wearer)
	if(wearer.get_item_by_slot(clothing_parent.slot_flags) != clothing_parent)
		to_chat(wearer, span_warning("You must be wearing [clothing_parent] to put up the hood."))
		return FALSE

	if(wearer.get_item_by_slot(ITEM_SLOT_HEAD))
		to_chat(wearer, span_warning("You are already wearing something on your head."))
		return FALSE

	if(!hood)
		if(!delete_unequipped_hood)
			return FALSE

		create_hood()

	if(pre_equip_hood && !pre_equip_hood.Invoke(wearer, hood))
		return FALSE

	if(!wearer.equip_to_slot_if_possible(hood, ITEM_SLOT_HEAD, qdel_on_fail = delete_unequipped_hood))
		return FALSE

	if(parent_icon_suffix)
		clothing_parent.icon_state = "[initial(clothing_parent.icon_state)][parent_icon_suffix]"
		wearer.update_clothing(clothing_parent.slot_flags)

	wearer.update_mob_action_buttons()
	hood_active = TRUE
	on_hood_equip?.Invoke(wearer, hood)
	return TRUE

/// Unequip the hood. Currently cannot fail.
/datum/component/hooded/proc/must_unequip_hood(obj/item/clothing/clothing_parent, mob/living/wearer)
	hood_active = FALSE

	if(!QDELETED(hood))
		if(wearer)
			wearer.transferItemToLoc(hood, clothing_parent, TRUE, animate = FALSE)
		else
			hood.forceMove(parent)

	if(parent_icon_suffix)
		clothing_parent.icon_state = initial(clothing_parent.icon_state)
		wearer?.update_clothing(clothing_parent.slot_flags)

	if(!QDELETED(hood) && delete_unequipped_hood)
		QDEL_NULL(hood)

	wearer?.update_mob_action_buttons()
	on_hood_unequip?.Invoke(wearer, hood)
	return TRUE

/// Toggle hood when the UI button is clicked
/datum/component/hooded/proc/on_action_click(obj/item/source, mob/user, datum/action/action)
	SIGNAL_HANDLER
	if (action != toggle_action)
		return NONE

	if(hood_active)
		must_unequip_hood(parent, user)
	else
		try_equip_hood(parent, user)
	return COMPONENT_ACTION_HANDLED

/// Handles hood qdeletion.
/datum/component/hooded/proc/hood_gone(datum/source)
	SIGNAL_HANDLER
	hood = null

/// Handles the hood being unequipped.
/datum/component/hooded/proc/hood_unequipped(datum/source)
	SIGNAL_HANDLER

	if(hood_active)
		must_unequip_hood(parent, null)

/datum/component/hooded/proc/hood_equipped(datum/source, mob/living/wearer, slot)
	SIGNAL_HANDLER
	if(slot & hood.slot_flags)
		return

	spawn(0)
		must_unequip_hood(parent, wearer)

/datum/component/hooded/proc/parent_unequipped(datum/source, mob/living/wearer)
	SIGNAL_HANDLER

	if(hood_active)
		must_unequip_hood(parent, null)
