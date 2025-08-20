/obj/item/swab
	name = "swab"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "swab"

	item_flags = parent_type::item_flags | NOBLUDGEON | NO_EVIDENCE_ON_INTERACTION

	fingerprint_flags_interact_with_atom = NONE

	var/used = FALSE

	var/sample_name
	var/datum/forensics/swabbed_forensics

/obj/item/swab/Initialize(mapload)
	. = ..()
	swabbed_forensics = new()
	register_item_context()

/obj/item/swab/Destroy(force)
	QDEL_NULL(swabbed_forensics)
	return ..()

/obj/item/swab/add_item_context(obj/item/source, list/context, atom/target, mob/living/user)
	if(used)
		return

	if(!ATOM_HAS_FIRST_CLASS_INTERACTION(target))
		context[SCREENTIP_CONTEXT_LMB] = "Swab"

	context[SCREENTIP_CONTEXT_RMB] = "Swab"

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/swab/update_name(updates)
	name = "[initial(name)] ([sample_name])"
	return ..()

/obj/item/swab/update_icon_state()
	. = ..()
	if(used)
		icon_state = "swab_used"

/obj/item/swab/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(used || ATOM_HAS_FIRST_CLASS_INTERACTION(interacting_with))
		return NONE

	if(ishuman(interacting_with))
		return swab_human(interacting_with, user)

	return swab_atom(interacting_with, user)

/obj/item/swab/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(ishuman(interacting_with))
		return swab_human(interacting_with, user)

	return swab_atom(interacting_with, user)

/obj/item/swab/proc/swab_human(mob/living/carbon/human/target, mob/living/user)
	// Resisting
	if(user != target && (target.combat_mode && target.body_position == STANDING_UP && !target.incapacitated()))
		user.visible_message(span_warning("<b>[user]</b> tries to swab <b>[target]</b>, but they move away."))
		return ITEM_INTERACT_BLOCKING

	// Swab their mouth.
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(!target.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning("They have no head."))
			return ITEM_INTERACT_BLOCKING

		if(!target.has_mouth())
			to_chat(user, span_warning("They have no mouth."))
			return ITEM_INTERACT_BLOCKING

		if(!target.has_dna())
			to_chat(user, span_warning("You feel like this wouldn't be useful."))
			return ITEM_INTERACT_BLOCKING

		user.visible_message(span_notice("<b>[user]</b> attempts to insert [src] into <b>[target]</b>'s mouth."))
		if(!do_after(user, target, 2 SECONDS, DO_PUBLIC|DO_RESTRICT_CLICKING|DO_RESTRICT_USER_DIR_CHANGE, display = src))
			return ITEM_INTERACT_BLOCKING

		swabbed_forensics.add_trace_DNA(target.get_trace_dna())
		set_used(target.get_face_name())
		user.do_item_attack_animation(target, used_item = src)
		return ITEM_INTERACT_SUCCESS

	var/zone = deprecise_zone(user.zone_selected)
	var/obj/item/bodypart/BP = target.get_bodypart(zone)
	if(!BP)
		to_chat(user, span_warning("They don't have \a [zone]"))
		return ITEM_INTERACT_BLOCKING

	if(target.get_item_covering_bodypart(BP))
		to_chat(user, span_warning("[target.p_their(TRUE)] [BP.plaintext_zone] is covered."))
		return ITEM_INTERACT_BLOCKING

	if(!is_valid_target(target))
		to_chat(user, span_warning("[target] has nothing to swab on their body."))
		return ITEM_INTERACT_BLOCKING

/obj/item/swab/proc/swab_atom(atom/target, mob/user)
	if(ishuman(target))
		var/mob/living/carbon/H = target
		target = H.get_item_covering_zone(deprecise_zone(user.zone_selected))
		if(!target)
			return ITEM_INTERACT_BLOCKING

		if(!is_valid_target(target))
			to_chat(user, span_warning("There is no evidence on [H]'s [target]."))
			return ITEM_INTERACT_BLOCKING

	if(!is_valid_target(target))
		to_chat(user, span_warning("There is no evidence on [target]."))
		return ITEM_INTERACT_BLOCKING

	if(istype(target, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = target
		swabbed_forensics.add_blood_DNA(S.dirty_blood_DNA)

	swabbed_forensics.add_trace_DNA(target.return_trace_DNA())
	swabbed_forensics.add_blood_DNA(target.return_blood_DNA())
	swabbed_forensics.add_gunshot_residue_list(target.return_gunshot_residue())

	set_used(target)

	user.do_item_attack_animation(target, used_item = src)
	user.visible_message(span_notice("[user] swabs [target]."))
	return ITEM_INTERACT_SUCCESS

/obj/item/swab/proc/set_used(sample_name)
	used = TRUE
	src.sample_name = "[sample_name]"
	update_appearance()

/obj/item/swab/proc/is_valid_target(atom/target)
	if(length(target.return_blood_DNA()) || length(target.return_trace_DNA()) || length(target.return_gunshot_residue()))
		return TRUE

	if(istype(target, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = target
		if(length(S.dirty_blood_DNA))
			return TRUE
	return FALSE
