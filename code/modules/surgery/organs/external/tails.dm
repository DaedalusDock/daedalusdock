///Tail parent, it doesn't do very much.
/obj/item/organ/tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon_state = "severedtail"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_EXTERNAL_TAIL
	layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)
	organ_flags = ORGAN_EDIBLE
	feature_key = "tail"
	render_key = "tail"
	dna_block = DNA_TAIL_BLOCK
	///Does this tail have a wagging sprite, and is it currently wagging?
	var/wag_flags = NONE
	///The original owner of this tail
	var/original_owner //Yay, snowflake code!

/obj/item/organ/tail/Destroy()
	original_owner = null
	return ..()

/obj/item/organ/tail/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
		return FALSE
	return TRUE

/obj/item/organ/tail/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	. = ..()
	if(.)
		RegisterSignal(reciever, COMSIG_ORGAN_WAG_TAIL, PROC_REF(wag))
		original_owner ||= reciever //One and done

		SEND_SIGNAL(reciever, COMSIG_CLEAR_MOOD_EVENT, "tail_lost")
		SEND_SIGNAL(reciever, COMSIG_CLEAR_MOOD_EVENT, "tail_balance_lost")

		if(original_owner == reciever)
			SEND_SIGNAL(reciever, COMSIG_CLEAR_MOOD_EVENT, "wrong_tail_regained")
		else if(type in reciever.dna.species.cosmetic_organs)
			SEND_SIGNAL(reciever, COMSIG_ADD_MOOD_EVENT, "wrong_tail_regained", /datum/mood_event/tail_regained_wrong)

/obj/item/organ/tail/Remove(mob/living/carbon/organ_owner, special, moving)
	if(wag_flags & WAG_WAGGING)
		wag(FALSE)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_ORGAN_WAG_TAIL)

	if(type in organ_owner.dna.species.cosmetic_organs)
		SEND_SIGNAL(organ_owner, COMSIG_ADD_MOOD_EVENT, "tail_lost", /datum/mood_event/tail_lost)
		SEND_SIGNAL(organ_owner, COMSIG_ADD_MOOD_EVENT, "tail_balance_lost", /datum/mood_event/tail_balance_lost)

/obj/item/organ/tail/build_cache_key()
	. = ..()
	if((wag_flags & WAG_WAGGING))
		. += "wagging"
	return .

/obj/item/organ/tail/get_global_feature_list()
	return GLOB.tails_list

/obj/item/organ/tail/proc/wag(mob/user, start = TRUE, stop_after = 0)
	if(!(wag_flags & WAG_ABLE))
		return

	if(start)
		render_key = "wagging[initial(render_key)]"
		wag_flags |= WAG_WAGGING
		if(stop_after)
			addtimer(CALLBACK(src, PROC_REF(wag), FALSE), stop_after, TIMER_STOPPABLE|TIMER_DELETE_ME)
	else
		render_key = initial(render_key)
		wag_flags &= ~WAG_WAGGING
	owner.update_body_parts()

/obj/item/organ/tail/cat
	name = "tail"
	preference = "feature_human_tail"
	feature_key = "tail_cat"
	color_source = ORGAN_COLOR_HAIR
	wag_flags = WAG_ABLE

/obj/item/organ/tail/monkey
	color_source = NONE

/obj/item/organ/tail/lizard
	name = "lizard tail"
	desc = "A severed lizard tail. Somewhere, no doubt, a lizard hater is very pleased with themselves."
	preference = "feature_lizard_tail"
	feature_key = "tail_lizard"
	wag_flags = WAG_ABLE
	dna_block = DNA_LIZARD_TAIL_BLOCK
	///A reference to the paired_spines, since for some fucking reason tail spines are tied to the spines themselves.
	var/obj/item/organ/spines/paired_spines

/obj/item/organ/tail/lizard/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	. = ..()
	if(.)
		paired_spines = ownerlimb.owner.getorganslot(ORGAN_SLOT_EXTERNAL_SPINES)

/obj/item/organ/tail/lizard/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()
	if(paired_spines)
		paired_spines.render_key = initial(paired_spines.render_key) //Clears wagging
		paired_spines.paired_tail = null
		paired_spines = null

/obj/item/organ/tail/lizard/inherit_color(force)
	. = ..()
	if(.)
		paired_spines = ownerlimb.owner.getorganslot(ORGAN_SLOT_EXTERNAL_SPINES) //I hate this so much.
		if(paired_spines)
			paired_spines.paired_tail = src

/obj/item/organ/tail/lizard/wag(mob/user, start = TRUE, stop_after = 0)
	if(!(wag_flags & WAG_ABLE))
		return

	if(start)
		render_key = "wagging[initial(render_key)]"
		wag_flags |= WAG_WAGGING
		if(stop_after)
			addtimer(CALLBACK(src, PROC_REF(wag), FALSE), stop_after, TIMER_STOPPABLE|TIMER_DELETE_ME)
		if(paired_spines)
			paired_spines.render_key = "wagging[initial(paired_spines.render_key)]"
	else
		render_key = initial(render_key)
		wag_flags &= ~WAG_WAGGING
		if(paired_spines)
			paired_spines.render_key = initial(paired_spines.render_key)

	owner.update_body_parts()

/obj/item/organ/tail/lizard/fake
	name = "fabricated lizard tail"
	desc = "A fabricated severed lizard tail. This one's made of synthflesh. Probably not usable for lizard wine."

// Teshari tail
/obj/item/organ/tail/teshari
	name = "Teshari tail"
	zone = BODY_ZONE_CHEST // Don't think about this too much
	layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)

	feature_key = "tail_teshari"
	preference = "tail_teshari"
	render_key = "tail_teshari"

	dna_block = DNA_TESHARI_TAIL_BLOCK

	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_TESHARI_TAIL

/obj/item/organ/tail/teshari/get_global_feature_list()
	return GLOB.teshari_tails_list

/obj/item/organ/tail/teshari/build_overlays(physique, image_dir)
	. = ..()

	for(var/image_layer in layers)
		var/icon2use = sprite_datum.icon
		var/state2use = build_icon_state(physique, image_layer)

		if(icon_exists(icon2use, "[state2use]_secondary"))
			var/mutable_appearance/tail_secondary = mutable_appearance(icon2use, "[state2use]_secondary", layer = -image_layer)
			tail_secondary.color = mutcolors[MUTCOLORS_TESHARI_TAIL_2]
			. += tail_secondary

		if(icon_exists(icon2use, "[state2use]_tertiary"))
			var/mutable_appearance/tail_tertiary = mutable_appearance(icon2use, "[state2use]_tertiary", layer = -image_layer)

			tail_tertiary.color = mutcolors[MUTCOLORS_TESHARI_TAIL_3]
			. += tail_tertiary


// Vox tail
/obj/item/organ/tail/vox
	wag_flags = WAG_ABLE

	feature_key = "tail_vox"
	preference = "tail_vox"
	render_key = "tail_vox"

	dna_block = DNA_VOX_TAIL_BLOCK

	color_source = ORGAN_COLOR_INHERIT

/obj/item/organ/tail/vox/get_global_feature_list()
	return GLOB.tails_list_vox
