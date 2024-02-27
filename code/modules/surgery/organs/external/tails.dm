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

/obj/item/organ/tail/Destroy()
	return ..()

/obj/item/organ/tail/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.obscured_slots & HIDEJUMPSUIT)
		return FALSE
	return TRUE

/obj/item/organ/tail/get_global_feature_list()
	return GLOB.tails_list

/obj/item/organ/tail/cat
	name = "tail"
	preference = "feature_human_tail"
	feature_key = "tail_cat"
	color_source = ORGAN_COLOR_HAIR

/obj/item/organ/tail/monkey
	color_source = NONE

/obj/item/organ/tail/lizard
	name = "lizard tail"
	desc = "A severed lizard tail. Somewhere, no doubt, a lizard hater is very pleased with themselves."
	preference = "feature_lizard_tail"
	feature_key = "tail_lizard"
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
	feature_key = "tail_vox"
	preference = null
	render_key = "tail_vox"

	dna_block = DNA_VOX_TAIL_BLOCK

	color_source = ORGAN_COLOR_INHERIT

/obj/item/organ/tail/vox/get_global_feature_list()
	return GLOB.tails_list_vox
