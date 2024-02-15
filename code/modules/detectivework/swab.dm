/obj/item/swab
	name = "swab"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "swab"

	item_flags = parent_type::item_flags | NOBLUDGEON | NO_EVIDENCE_ON_ATTACK

	var/used = FALSE

	var/sample_type
	var/sample = ""

/obj/item/swab/update_name(updates)
	name = "[initial(name)] ([sample_type])"
	return ..()

/obj/item/swab/update_icon_state()
	. = ..()
	if(used)
		icon_state = "swab_used"

/obj/item/swab/attack(mob/living/M, mob/living/user, params)
	if(!ishuman(M))
		return ..()

	if(used)
		return

	var/mob/living/carbon/human/target = M

	// Resisting
	if(user != target && (target.combat_mode && target.body_position == STANDING_UP && !target.incapacitated()))
		user.visible_message(span_warning("[user] tries to swab [target], but they move away."))
		return

	// Swab their mouth.
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(!target.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning("They have no head."))
			return TRUE
		if(!target.has_mouth())
			to_chat(user, span_warning("They have no mouth."))
			return TRUE
		if(!target.has_dna())
			to_chat(user, span_warning("You feel like this wouldn't be useful."))
			return TRUE

		user.visible_message(span_notice("[user] swabs [target]'s mouth."))
		set_used(SAMPLE_TRACE_DNA, target.get_trace_dna())
		return TRUE

	var/zone = deprecise_zone(user.zone_selected)
	var/obj/item/bodypart/BP = target.get_bodypart(zone)
	if(!BP)
		to_chat(user, span_warning("They don't have \a [zone]"))
		return TRUE

	if(target.get_item_covering_bodypart(BP))
		return

	if(!target.forensics)
		to_chat(user, span_warning("[target] has nothing to swab on their body."))
		return TRUE

	var/list/choices = list()
	if(target.forensics.blood_DNA)
		choices += SAMPLE_BLOOD_DNA
	if(target.forensics.trace_DNA)
		choices += SAMPLE_TRACE_DNA
	if(target.forensics.gunshot_residue)
		choices += SAMPLE_RESIDUE

	var/input = tgui_input_list(user, "What kind of evidence are you looking for?","Evidence Collection", choices)
	if(!input)
		return TRUE
	if(!user.Adjacent(target) || !user.is_holding(src) || user.incapacitated())
		return TRUE

	user.visible_message(span_notice("[user] swabs [target]'s [BP.plaintext_zone]."))
	switch(input)
		if(SAMPLE_BLOOD_DNA)
			set_used(input, target.return_blood_DNA())
		if(SAMPLE_RESIDUE)
			set_used(input, target.return_gunshot_residue())
		if(SAMPLE_TRACE_DNA)
			set_used(input, target.return_trace_DNA())
	return TRUE

/obj/item/swab/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(used)
		to_chat(user, span_warning("This swab has been used."))
		return

	if(ishuman(target))
		var/mob/living/carbon/H = target
		target = H.get_item_covering_zone(deprecise_zone(user.zone_selected))
		if(!target)
			return
		if(!target.forensics)
			to_chat(user, span_warning("There is no evidence on [H]'s [target]."))
			return

	if(!target.forensics)
		to_chat(user, span_warning("There is no evidence on [target]."))
		return

	var/list/choices = list()

	if(length(target.forensics.blood_DNA))
		choices += SAMPLE_BLOOD_DNA
	if(length(target.forensics.trace_DNA))
		choices += SAMPLE_TRACE_DNA
	if(length(target.forensics.gunshot_residue))
		choices += SAMPLE_RESIDUE

	var/input
	if(length(choices) == 1)
		input = choices[1]
	else
		input = tgui_input_list(user, "What kind of evidence are you looking for?","Evidence Collection", choices)

	if(!input)
		return
	if(!user.Adjacent(target) || !user.is_holding(src) || user.incapacitated())
		return

	switch(input)
		if(SAMPLE_BLOOD_DNA)
			set_used(input, target.return_blood_DNA())
		if(SAMPLE_RESIDUE)
			set_used(input, target.return_gunshot_residue())
		if(SAMPLE_TRACE_DNA)
			set_used(input, target.return_trace_DNA())

	user.visible_message(span_notice("[user] swabs [target]."))

/obj/item/swab/proc/set_used(sample_type, sample)
	used = TRUE
	src.sample_type = sample_type
	src.sample = sample
	update_appearance()
