/**
* System for drawing organs with overlays. These overlays are drawn directly on the bodypart, attached to a person or not
* Works in tandem with the /datum/sprite_accessory datum to generate sprites
* Unlike normal organs, we're actually inside a persons limbs at all times
*/

/**mob_sprite is optional if you havent set sprite_datums for the object, and is used mostly to generate sprite_datums from a persons DNA
* For _mob_sprite we make a distinction between "Round Snout" and "round". Round Snout is the name of the sprite datum, while "round" would be part of the sprite
* I'm sorry
*/


/obj/item/organ/proc/set_sprite(sprite_name)
	stored_feature_id = sprite_name
	sprite_datum = get_global_feature_list()[sprite_name]
	if(!sprite_datum && stored_feature_id)
		stack_trace("External organ has no valid sprite datum for name [sprite_name]")

///Return a dumb glob list for this specific feature (called from parse_sprite)
/obj/item/organ/proc/get_global_feature_list()
	CRASH("External organ has no feature list, it will render invisible")

///Check whether we can draw the overlays. You generally don't want lizard snouts to draw over an EVA suit
/obj/item/organ/proc/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

///Update our features after something changed our appearance
/obj/item/organ/proc/mutate_feature(features, mob/living/carbon/human/human)
	if(!dna_block || !get_global_feature_list())
		CRASH("External organ has no dna block/feature_list implimented!")

	var/list/feature_list = get_global_feature_list()

	set_sprite(feature_list[deconstruct_block(get_uni_feature_block(features, dna_block), feature_list.len)])

///Give the organ it's color. Force will override the existing one.
/obj/item/organ/proc/inherit_color(force)
	if(draw_color && !force)
		return
	switch(color_source)
		if(ORGAN_COLOR_OVERRIDE)
			draw_color = override_color(ownerlimb.draw_color)

		if(ORGAN_COLOR_INHERIT)
			draw_color = ownerlimb.draw_color

		if(ORGAN_COLOR_HAIR)
			if(!ishuman(ownerlimb.owner))
				return

			var/mob/living/carbon/human/human_owner = ownerlimb.owner
			draw_color = human_owner.hair_color

		if(ORGAN_COLOR_STATIC)
			color = draw_color //Empty if clauses are linted

		if(ORGAN_COLOR_INHERIT_ALL)
			mutcolors = ownerlimb.mutcolors.Copy()
			draw_color = mutcolors["[mutcolor_used]_1"]

	color = draw_color
	return TRUE

///Colorizes the limb it's inserted to, if required.
/obj/item/organ/proc/override_color(rgb_value)
	CRASH("External organ color set to override with no override proc.")

///The horns of a lizard!
/obj/item/organ/horns
	name = "horns"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HORNS
	layers = list(BODY_ADJ_LAYER)

	feature_key = "horns"
	preference = "feature_lizard_horns"

	dna_block = DNA_HORNS_BLOCK

/obj/item/organ/horns/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/horns/get_global_feature_list()
	return GLOB.horns_list

///The frills of a lizard (like weird fin ears)
/obj/item/organ/frills
	name = "frills"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_FRILLS
	layers = list(BODY_ADJ_LAYER)

	feature_key = "frills"
	preference = "feature_lizard_frills"

	dna_block = DNA_FRILLS_BLOCK

/obj/item/organ/frills/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEEARS))
		return TRUE
	return FALSE


/obj/item/organ/frills/get_global_feature_list()
	return GLOB.frills_list

///A moth's antennae
/obj/item/organ/antennae
	name = "antennae"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_ANTENNAE
	layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)
	feature_key = "moth_antennae"
	preference = "feature_moth_antennae"

	dna_block = DNA_MOTH_ANTENNAE_BLOCK

	///Are we burned?
	var/burnt = FALSE
	///Store our old sprite here for if our antennae wings are healed
	var/original_sprite = ""

/obj/item/organ/antennae/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	. = ..()
	if(!.)
		return

	RegisterSignal(reciever, COMSIG_HUMAN_BURNING, PROC_REF(try_burn_antennae))
	RegisterSignal(reciever, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(heal_antennae))

/obj/item/organ/antennae/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()

	UnregisterSignal(organ_owner, list(COMSIG_HUMAN_BURNING, COMSIG_LIVING_POST_FULLY_HEAL))

/obj/item/organ/antennae/get_global_feature_list()
	return GLOB.moth_antennae_list

/obj/item/organ/antennae/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

///check if our antennae can burn off ;_;
/obj/item/organ/antennae/proc/try_burn_antennae(mob/living/carbon/human/human)
	SIGNAL_HANDLER

	if(!burnt && human.bodytemperature >= 800 && human.fire_stacks > 0) //do not go into the extremely hot light. you will not survive
		to_chat(human, span_danger("Your precious antennae burn to a crisp!"))

		burn_antennae()
		human.update_body_parts()

/obj/item/organ/antennae/proc/burn_antennae()
	burnt = TRUE
	original_sprite = sprite_datum.name
	set_sprite("Burnt Off")

///heal our antennae back up!!
/obj/item/organ/antennae/proc/heal_antennae()
	SIGNAL_HANDLER

	if(burnt)
		burnt = FALSE
		set_sprite(original_sprite)

//podperson hair
/obj/item/organ/pod_hair
	name = "leaves"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_POD_HAIR
	layers = list(BODY_FRONT_LAYER, BODY_ADJ_LAYER)

	feature_key = "pod_hair"
	preference = "feature_pod_hair"

	dna_block = DNA_POD_HAIR_BLOCK

	color_source = ORGAN_COLOR_OVERRIDE

/obj/item/organ/pod_hair/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/pod_hair/get_global_feature_list()
	return GLOB.pod_hair_list

/obj/item/organ/pod_hair/override_color(rgb_value)
	var/list/rgb_list = rgb2num(rgb_value)
	return rgb(255 - rgb_list[1], 255 - rgb_list[2], 255 - rgb_list[3])

//skrell
/obj/item/organ/headtails
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HEADTAILS
	layers = list(BODY_FRONT_LAYER | BODY_ADJ_LAYER)
	dna_block = DNA_HEADTAILS_BLOCK

	feature_key = "headtails"
	preference = "feature_headtails"

/obj/item/organ/headtails/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = TRUE
	if(human.head && (human.head.flags_inv & HIDEHAIR))
		return FALSE
	if(human.wear_mask && (human.wear_mask.flags_inv & HIDEHAIR))
		return FALSE

/obj/item/organ/headtails/get_global_feature_list()
	return GLOB.headtails_list

// Teshari head feathers
/obj/item/organ/teshari_feathers
	name = "head feathers"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_FEATHERS
	layers = list(BODY_ADJ_LAYER)

	feature_key = "teshari_feathers"
	preference = "teshari_feathers"

	dna_block = DNA_TESHARI_FEATHERS_BLOCK
	color_source = ORGAN_COLOR_HAIR

/obj/item/organ/teshari_feathers/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.head && (human.head.flags_inv & HIDEHAIR) || human.wear_mask && (human.wear_mask.flags_inv & HIDEHAIR))
		return FALSE
	return TRUE

/obj/item/organ/teshari_feathers/get_global_feature_list()
	return GLOB.teshari_feathers_list

// Teshari ears
/obj/item/organ/teshari_ears
	name = "ear feathers"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_EARS
	layers = list(BODY_ADJ_LAYER)

	feature_key = "teshari_ears"
	preference = "teshari_ears"

	dna_block = DNA_TESHARI_EARS_BLOCK

/obj/item/organ/teshari_ears/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.head && (human.head.flags_inv & HIDEHAIR) || human.wear_mask && (human.wear_mask.flags_inv & HIDEHAIR))
		return FALSE
	return TRUE

/obj/item/organ/teshari_ears/get_global_feature_list()
	return GLOB.teshari_ears_list

/obj/item/organ/teshari_ears/build_overlays(physique, image_dir)
	. = ..()

	var/mutable_appearance/inner_ears = mutable_appearance(sprite_datum.icon, "m_teshari_earsinner_[sprite_datum.icon_state]_ADJ", layer = -BODY_ADJ_LAYER)
	var/mob/living/carbon/human/human_owner = owner
	if(owner)
		inner_ears.color = human_owner.facial_hair_color
		. += inner_ears

/obj/item/organ/teshari_ears/build_cache_key()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		. += H.facial_hair_color

// Teshari body feathers
/obj/item/organ/teshari_body_feathers
	name = "body feathers"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_BODY_FEATHERS
	layers = list(BODY_ADJ_LAYER)

	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	feature_key = "teshari_body_feathers"
	preference = "teshari_body_feathers"

	dna_block = DNA_TESHARI_BODY_FEATHERS_BLOCK
	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_TESHARI_BODY_FEATHERS

/obj/item/organ/teshari_body_feathers/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!human)
		return TRUE
	if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
		return FALSE
	return TRUE

/obj/item/organ/teshari_body_feathers/get_global_feature_list()
	return GLOB.teshari_body_feathers_list

/obj/item/organ/teshari_body_feathers/build_overlays(physique, image_dir)
	. = ..()
	var/static/list/bodypart_color_indexes = list(
		BODY_ZONE_CHEST = MUTCOLORS_TESHARI_BODY_FEATHERS_1,
		BODY_ZONE_HEAD = MUTCOLORS_TESHARI_BODY_FEATHERS_2,
		BODY_ZONE_R_ARM = MUTCOLORS_TESHARI_BODY_FEATHERS_3,
		BODY_ZONE_L_ARM = MUTCOLORS_TESHARI_BODY_FEATHERS_3,
		BODY_ZONE_R_LEG = MUTCOLORS_TESHARI_BODY_FEATHERS_3,
		BODY_ZONE_L_LEG = MUTCOLORS_TESHARI_BODY_FEATHERS_3,
	)
	if(!owner)
		return

	for(var/image_layer in layers)
		var/state2use = build_icon_state(physique, image_layer)

		for(var/obj/item/bodypart/BP as anything in owner.bodyparts - owner.get_bodypart(BODY_ZONE_CHEST))
			var/mutable_appearance/new_overlay = mutable_appearance(sprite_datum.icon, "[state2use]_[BP.body_zone]", layer = -image_layer)
			new_overlay.color = mutcolors[bodypart_color_indexes[BP.body_zone]]
			. += new_overlay

/obj/item/organ/teshari_body_feathers/build_cache_key()
	. = ..()
	if(ishuman(owner))
		. += "[!!owner.get_bodypart(BODY_ZONE_CHEST)]"
		. += "[!!owner.get_bodypart(BODY_ZONE_HEAD)]"
		. += "[!!owner.get_bodypart(BODY_ZONE_L_ARM)]"
		. += "[!!owner.get_bodypart(BODY_ZONE_R_ARM)]"
		. += "[!!owner.get_bodypart(BODY_ZONE_L_LEG)]"
		. += "[!!owner.get_bodypart(BODY_ZONE_R_LEG)]"
	else
		. += "CHEST_ONLY"
