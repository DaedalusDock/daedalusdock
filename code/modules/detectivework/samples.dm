/obj/item/sample
	name = "forensic sample"
	icon = 'icons/obj/forensics.dmi'
	item_flags = parent_type::item_flags | NOBLUDGEON | NO_EVIDENCE_ON_INTERACTION
	w_class = WEIGHT_CLASS_TINY

	fingerprint_flags_item_interaction = NONE
	fingerprint_flags_interact_with_atom = NONE

	var/list/evidence = list()
	var/label

/obj/item/sample/Initialize(mapload, atom/sampled_object)
	. = ..()
	if(sampled_object)
		copy_evidence(sampled_object)
		name = "[initial(name)] ([sampled_object])"
		label = "[sampled_object], [get_area(sampled_object)]"

/obj/item/sample/examine(mob/user)
	. = ..()
	. += span_notice("It is labelled: <b>[label]</b>.")

/obj/item/sample/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.type != type)
		return NONE

	if(user.canUnequipItem(tool) && merge_evidence(tool, user))
		qdel(tool)
		return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/item/sample/proc/copy_evidence(atom/supplied)
	var/list/fibers = supplied.return_fibers()
	if(length(fibers))
		evidence = fibers.Copy()
		return TRUE

/obj/item/sample/proc/merge_evidence(obj/item/sample/supplied, mob/user)
	if(!length(supplied.evidence))
		return FALSE

	evidence |= supplied.evidence

	name = "[initial(name)] (combined)"
	label = supplied.label + ", " + label
	to_chat(user, span_notice("You transfer the contents of \the [supplied] into \the [src]."))
	return TRUE

/obj/item/sample/fibers
	name = "fiber bag"
	desc = "Used to hold fiber evidence for the detective."
	icon_state = "fiberbag"

/obj/item/sample/print
	name = "fingerprint card"
	desc = "Records a set of fingerprints."
	icon = 'icons/obj/card.dmi'
	icon_state = "fingerprint0"
	inhand_icon_state = "paper"

/obj/item/sample/print/Initialize(mapload, atom/sampled_object)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)

/obj/item/sample/print/update_icon_state()
	if(length(evidence))
		icon_state = "fingerprint1"
	return ..()

/obj/item/sample/print/merge_evidence(obj/item/sample/supplied, mob/user)
	if(!length(supplied.evidence))
		return FALSE

	for(var/print in supplied.evidence)
		if(evidence[print])
			evidence[print] = stringmerge(evidence[print],supplied.evidence[print])
		else
			evidence[print] = supplied.evidence[print]

	name = "[initial(name)] (combined)"
	label = supplied.label + ", " + label
	to_chat(user, span_notice("You overlay \the [src] and \the [supplied], combining the print records."))
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/item/sample/print/attack_self(mob/user, modifiers)
	if(length(evidence))
		return ..()

	if(!ishuman(user))
		return ..()

	var/mob/living/carbon/human/H = user
	if(!H.has_dna())
		to_chat(user, span_warning("You don't have any fingerprints."))
		return

	if((H.check_obscured_slots(TRUE) & ITEM_SLOT_GLOVES) || H.gloves)
		to_chat(user, span_warning("Your hands are covered."))
		return

	to_chat(user, span_notice("You firmly press your fingertips onto the card."))
	var/fullprint = H.get_fingerprints(hand = H.get_active_hand())
	evidence[fullprint] = fullprint
	name = "[initial(name)] ([H.get_face_name()])"
	update_appearance(UPDATE_ICON_STATE)

/obj/item/sample/print/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with))
		return NONE

	if(length(evidence))
		return ITEM_INTERACT_BLOCKING

	if(!(user.zone_selected in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)))
		return ITEM_INTERACT_BLOCKING

	var/mob/living/carbon/human/H = interacting_with
	if((H.check_obscured_slots(TRUE) & ITEM_SLOT_GLOVES) || H.gloves)
		to_chat(user, span_warning("Their hands are covered."))
		return ITEM_INTERACT_BLOCKING

	if(user != H && H.combat_mode && (H.body_position == STANDING_UP))
		user.visible_message(span_warning("[user] tries to take prints from [H], but they move away."))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/bodypart/arm/hand
	hand = H.get_bodypart(user.zone_selected, TRUE)
	if(!hand)
		to_chat(user, span_warning("They don't have a [parse_zone(user.zone_selected)]."))
		return ITEM_INTERACT_BLOCKING

	if(hand.is_stump)
		to_chat(user, span_warning("You don't think that has any fingerprints."))
		return ITEM_INTERACT_BLOCKING

	var/hand_string = user.zone_selected == BODY_ZONE_L_ARM ? "left hand" : "right hand"
	user.visible_message(span_notice("[user] takes a copy of \the [H]'s [hand_string] fingerprints."))

	evidence[hand.fingerprints] = hand.fingerprints
	name = "[initial(name)] ([H.get_face_name()]'s [hand_string])"
	update_appearance(UPDATE_ICON_STATE)
	return ITEM_INTERACT_SUCCESS

/obj/item/sample/print/copy_evidence(atom/supplied)
	var/list/prints = supplied.return_fingerprints()
	if(length(prints))
		evidence = prints.Copy()
		return TRUE

/obj/item/sample_kit
	name = "fiber collection kit"
	desc = "A magnifying glass and tweezers."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "m_glass"
	w_class = WEIGHT_CLASS_SMALL
	item_flags = parent_type::item_flags | NOBLUDGEON

	fingerprint_flags_interact_with_atom = NONE

	var/evidence_type = "fiber"
	var/evidence_path = /obj/item/sample/fibers

/obj/item/sample_kit/proc/can_take_sample(mob/user, atom/supplied)
	return length(supplied.return_fibers())

/obj/item/sample_kit/proc/take_sample(mob/user, atom/supplied)
	var/obj/item/sample/S = new evidence_path(null, supplied)
	if(!user.put_in_hands(S))
		S.forceMove(drop_location())
	to_chat(user, span_notice("You transfer [length(S.evidence)] [length(S.evidence) > 1 ? "[evidence_type]s" : "[evidence_type]"] to \the [S]."))

/obj/item/sample_kit/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(ATOM_HAS_FIRST_CLASS_INTERACTION(interacting_with))
		return NONE

	if(!can_take_sample(user, interacting_with))
		to_chat(user, span_warning("There is no evidence on [interacting_with]."))
		return ITEM_INTERACT_BLOCKING

	take_sample(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/sample_kit/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!can_take_sample(user, interacting_with))
		to_chat(user, span_warning("There is no evidence on [interacting_with]."))
		return ITEM_INTERACT_BLOCKING

	take_sample(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/sample_kit/powder
	name = "fingerprint powder"
	desc = "A jar containing alumiinum powder and a specialized brush."
	icon_state = "dust"
	evidence_type = "fingerprint"
	evidence_path = /obj/item/sample/print

/obj/item/sample_kit/powder/can_take_sample(mob/user, atom/supplied)
	return length(supplied.return_fingerprints())
