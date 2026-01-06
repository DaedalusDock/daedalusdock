/**
 * Players can use this item to put obj/item/implant's in living mobs. Can be renamed with a pen.
 */
TYPEINFO_DEF(/obj/item/implanter)
	default_materials = list(/datum/material/iron=600, /datum/material/glass=200)

/obj/item/implanter
	name = "implanter"
	desc = "A sterile automatic implant injector."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "implanter0"
	inhand_icon_state = "syringe_0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	///The implant in our implanter
	var/obj/item/implant/imp = null
	///Type of implant this will spawn as imp upon being spawned
	var/imp_type = null

/obj/item/implanter/update_icon_state()
	icon_state = "implanter[imp ? 1 : 0]"
	return ..()

/obj/item/implanter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/mob/living/target = interacting_with
	if(!istype(target))
		return NONE

	if(target != user)
		target.visible_message(span_warning("[user] is attempting to implant [target]."))

	var/turf/target_on = get_turf(target)
	if(!(target_on && (target == user || do_after(user, target, 5 SECONDS))))
		return ITEM_INTERACT_BLOCKING

	if(!imp.implant(target, user, deprecise_zone(user.zone_selected)))
		to_chat(user, span_warning("[src] fails to implant [target]."))
		return ITEM_INTERACT_BLOCKING

	if (target == user)
		to_chat(user, span_notice("You implant yourself."))
	else
		target.visible_message(span_notice("[user] implants [target]."), span_notice("[user] implants you."))
	imp = null
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/implanter/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/pen))
		return NONE

	if(!user.is_literate())
		to_chat(user, span_notice("You prod at [src] with [tool]."))
		return ITEM_INTERACT_BLOCKING

	var/new_name = tgui_input_text(user, "What would you like the label to be?", name, max_length = MAX_NAME_LEN)
	if(user.get_active_held_item() != tool)
		return ITEM_INTERACT_BLOCKING
	if(!user.canUseTopic(src, USE_CLOSE))
		return ITEM_INTERACT_BLOCKING

	if(new_name)
		name = "implanter ([new_name])"
	else
		name = "implanter"
	return ITEM_INTERACT_SUCCESS

/obj/item/implanter/Initialize(mapload)
	. = ..()
	if(!imp && imp_type)
		imp = new imp_type(src)
	update_appearance()
