/**
* System for drawing organs with overlays. These overlays are drawn directly on the bodypart, attached to a person or not
* Works in tandem with the /datum/sprite_accessory datum to generate sprites
* Unlike normal organs, we're actually inside a persons limbs at all times
*/
/obj/item/organ/external
	name = "external organ"
	desc = "An external organ that is too external."

	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE

	///Sometimes we need multiple layers, for like the back, middle and front of the person
	var/layers
	///Convert the bitflag define into the actual layer define
	var/static/list/all_layers = list(EXTERNAL_FRONT, EXTERNAL_ADJACENT, EXTERNAL_BEHIND)

	///Defines what kind of 'organ' we're looking at. Sprites have names like 'm_mothwings_firemoth'. 'mothwings' would then be feature_key
	var/feature_key = ""
	///Similar to feature key, but overrides it in the case you need more fine control over the iconstate, like with Tails.
	var/render_key = ""
	///Stores the dna.features[feature_key], used for external organs that can be surgically removed or inserted.
	var/stored_feature_id = ""
	/// The savefile_key of the preference this relates to. Used for the preferences UI.
	var/preference

	///Sprite datum we use to draw on the bodypart
	var/datum/sprite_accessory/sprite_datum
	///Key of the icon states of all the sprite_datums for easy caching
	var/cache_key = ""

	///With what DNA block do we mutate in mutate_feature() ? For genetics
	var/dna_block

	///Reference to the limb we're inside of
	var/obj/item/bodypart/ownerlimb

	///The color this organ draws with. Updated by bodypart/inherit_color()
	var/draw_color

	///Where does this organ inherit it's color from?
	var/color_source = ORGAN_COLOR_INHERIT

	///Used by ORGAN_COLOR_INHERIT_ALL, allows full control of the owner's mutcolors
	var/list/mutcolors = list()
	///See above
	var/mutcolor_used

	///Does this organ have any bodytypes to pass to it's ownerlimb?
	var/external_bodytypes = NONE

	//A lazylist of this organ's appearance_modifier datums
	var/list/appearance_mods


/**mob_sprite is optional if you havent set sprite_datums for the object, and is used mostly to generate sprite_datums from a persons DNA
* For _mob_sprite we make a distinction between "Round Snout" and "round". Round Snout is the name of the sprite datum, while "round" would be part of the sprite
* I'm sorry
*/
/obj/item/organ/external/Initialize(mapload, mob_sprite)
	. = ..()
	if(mob_sprite)
		set_sprite(mob_sprite)

	if(!(organ_flags & ORGAN_UNREMOVABLE))
		color = "#[random_color()]" //A temporary random color that gets overwritten on insertion.

/obj/item/organ/external/Destroy()
	if(owner)
		Remove(owner, special=TRUE)
	else if(ownerlimb)
		remove_from_limb()

	return ..()

/obj/item/organ/external/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	var/obj/item/bodypart/limb = reciever.get_bodypart(deprecise_zone(zone))

	if(!limb)
		return FALSE
	. = ..()
	if(!.)
		return

	if(!stored_feature_id) //We only want this set *once*
		stored_feature_id = reciever.dna.features[feature_key]

	reciever.external_organs.Add(src)
	if(slot)
		reciever.external_organs_slot[slot] = src

	ownerlimb = limb
	add_to_limb(ownerlimb)

	if(external_bodytypes)
		limb.synchronize_bodytypes(reciever)

	reciever.update_body_parts()

/obj/item/organ/external/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()
	if(ownerlimb)
		remove_from_limb()

	if(organ_owner)
		if(slot)
			organ_owner.external_organs_slot.Remove(slot)
		organ_owner.external_organs.Remove(src)
		organ_owner.update_body_parts()

///Transfers the organ to the limb, and to the limb's owner, if it has one.
/obj/item/organ/external/transfer_to_limb(obj/item/bodypart/bodypart, mob/living/carbon/bodypart_owner)
	if(owner)
		Remove(owner, moving = TRUE)
	else if(ownerlimb)
		remove_from_limb()

	if(bodypart_owner)
		Insert(bodypart_owner, TRUE)
	else
		add_to_limb(bodypart)

/obj/item/organ/external/add_to_limb(obj/item/bodypart/bodypart)
	ownerlimb = bodypart
	ownerlimb.external_organs |= src
	inherit_color()
	return ..()

/obj/item/organ/external/remove_from_limb()
	ownerlimb.external_organs -= src
	if(ownerlimb.owner && external_bodytypes)
		ownerlimb.synchronize_bodytypes(ownerlimb.owner)
	ownerlimb = null
	return ..()

/obj/item/organ/external/proc/set_sprite(sprite_name)
	stored_feature_id = sprite_name
	sprite_datum = get_sprite_datum(sprite_name)
	if(!sprite_datum && stored_feature_id)
		stack_trace("NON-EXISTANT SPRITE DATUM IN EXTERNAL ORGAN")
	cache_key = jointext(generate_icon_cache(), "_")

///Because all the preferences have names like "Beautiful Sharp Snout" we need to get the sprite datum with the actual important info
/obj/item/organ/external/proc/get_sprite_datum(sprite)
	var/list/feature_list = get_global_feature_list()
	return feature_list[sprite]

///Return a dumb glob list for this specific feature (called from parse_sprite)
/obj/item/organ/external/proc/get_global_feature_list()
	CRASH("External organ has no feature list, it will render invisible")

///Check whether we can draw the overlays. You generally don't want lizard snouts to draw over an EVA suit
/obj/item/organ/external/proc/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

///Update our features after something changed our appearance
/obj/item/organ/external/proc/mutate_feature(features, mob/living/carbon/human/human)
	if(!dna_block || !get_global_feature_list())
		CRASH("External organ has no dna block/feature_list implimented!")

	var/list/feature_list = get_global_feature_list()

	set_sprite(feature_list[deconstruct_block(get_uni_feature_block(features, dna_block), feature_list.len)])

///Give the organ it's color. Force will override the existing one.
/obj/item/organ/external/proc/inherit_color(force)
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
/obj/item/organ/external/proc/override_color(rgb_value)
	CRASH("External organ color set to override with no override proc.")

///The horns of a lizard!
/obj/item/organ/external/horns
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HORNS
	layers = EXTERNAL_ADJACENT

	feature_key = "horns"
	preference = "feature_lizard_horns"

	dna_block = DNA_HORNS_BLOCK

/obj/item/organ/external/horns/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/external/horns/get_global_feature_list()
	return GLOB.horns_list

///The frills of a lizard (like weird fin ears)
/obj/item/organ/external/frills
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_FRILLS
	layers = EXTERNAL_ADJACENT

	feature_key = "frills"
	preference = "feature_lizard_frills"

	dna_block = DNA_FRILLS_BLOCK

/obj/item/organ/external/frills/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEEARS))
		return TRUE
	return FALSE


/obj/item/organ/external/frills/get_global_feature_list()
	return GLOB.frills_list

///A moth's antennae
/obj/item/organ/external/antennae
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_ANTENNAE
	layers = EXTERNAL_FRONT | EXTERNAL_BEHIND

	feature_key = "moth_antennae"
	preference = "feature_moth_antennae"

	dna_block = DNA_MOTH_ANTENNAE_BLOCK

	///Are we burned?
	var/burnt = FALSE
	///Store our old sprite here for if our antennae wings are healed
	var/original_sprite = ""

/obj/item/organ/external/antennae/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	. = ..()

	RegisterSignal(reciever, COMSIG_HUMAN_BURNING, .proc/try_burn_antennae)
	RegisterSignal(reciever, COMSIG_LIVING_POST_FULLY_HEAL, .proc/heal_antennae)

/obj/item/organ/external/antennae/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()

	UnregisterSignal(organ_owner, list(COMSIG_HUMAN_BURNING, COMSIG_LIVING_POST_FULLY_HEAL))

/obj/item/organ/external/antennae/get_global_feature_list()
	return GLOB.moth_antennae_list

/obj/item/organ/external/antennae/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

///check if our antennae can burn off ;_;
/obj/item/organ/external/antennae/proc/try_burn_antennae(mob/living/carbon/human/human)
	SIGNAL_HANDLER

	if(!burnt && human.bodytemperature >= 800 && human.fire_stacks > 0) //do not go into the extremely hot light. you will not survive
		to_chat(human, span_danger("Your precious antennae burn to a crisp!"))

		burn_antennae()
		human.update_body_parts()

/obj/item/organ/external/antennae/proc/burn_antennae()
	burnt = TRUE
	original_sprite = sprite_datum.name
	set_sprite("Burnt Off")

///heal our antennae back up!!
/obj/item/organ/external/antennae/proc/heal_antennae()
	SIGNAL_HANDLER

	if(burnt)
		burnt = FALSE
		set_sprite(original_sprite)

//podperson hair
/obj/item/organ/external/pod_hair
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_POD_HAIR
	layers = EXTERNAL_FRONT|EXTERNAL_ADJACENT

	feature_key = "pod_hair"
	preference = "feature_pod_hair"

	dna_block = DNA_POD_HAIR_BLOCK

	color_source = ORGAN_COLOR_OVERRIDE

/obj/item/organ/external/pod_hair/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/external/pod_hair/get_global_feature_list()
	return GLOB.pod_hair_list

/obj/item/organ/external/pod_hair/override_color(rgb_value)
	var/list/rgb_list = rgb2num(rgb_value)
	return rgb(255 - rgb_list[1], 255 - rgb_list[2], 255 - rgb_list[3])

//skrell
/obj/item/organ/external/headtails
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HEADTAILS
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT
	dna_block = DNA_HEADTAILS_BLOCK

	feature_key = "headtails"
	preference = "feature_headtails"

/obj/item/organ/external/headtails/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = TRUE
	if(human.head && (human.head.flags_inv & HIDEHAIR))
		return FALSE
	if(human.wear_mask && (human.wear_mask.flags_inv & HIDEHAIR))
		return FALSE

/obj/item/organ/external/headtails/get_global_feature_list()
	return GLOB.headtails_list

// Teshari head feathers
/obj/item/organ/external/teshari_feathers
	name = "Head feathers"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_FEATHERS
	layers = EXTERNAL_ADJACENT

	feature_key = "teshari_feathers"
	preference = "teshari_feathers"

	dna_block = DNA_TESHARI_FEATHERS_BLOCK
	color_source = ORGAN_COLOR_HAIR

/obj/item/organ/external/teshari_feathers/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.head && (human.head.flags_inv & HIDEHAIR) || human.wear_mask && (human.wear_mask.flags_inv & HIDEHAIR))
		return FALSE
	return TRUE

/obj/item/organ/external/teshari_feathers/get_global_feature_list()
	return GLOB.teshari_feathers_list

// Teshari ears
/obj/item/organ/external/teshari_ears
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_EARS
	layers = EXTERNAL_ADJACENT

	feature_key = "teshari_ears"
	preference = "teshari_ears"

	dna_block = DNA_TESHARI_EARS_BLOCK

/obj/item/organ/external/teshari_ears/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.head && (human.head.flags_inv & HIDEHAIR) || human.wear_mask && (human.wear_mask.flags_inv & HIDEHAIR))
		return FALSE
	return TRUE

/obj/item/organ/external/teshari_ears/get_global_feature_list()
	return GLOB.teshari_ears_list

/obj/item/organ/external/teshari_ears/get_overlays(physique, image_dir)
	. = ..()

	if(sprite_datum.icon_state == "none")
		return

	var/mutable_appearance/inner_ears = mutable_appearance(sprite_datum.icon, "m_teshari_earsinner_[sprite_datum.icon_state]_ADJ", layer = -BODY_ADJ_LAYER)
	var/mob/living/carbon/human/human_owner = owner
	if(owner)
		inner_ears.color = human_owner.facial_hair_color
		. += inner_ears

// Teshari body feathers
/obj/item/organ/external/teshari_body_feathers
	name = "Body feathers"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_TESHARI_BODY_FEATHERS
	layers = EXTERNAL_ADJACENT

	feature_key = "teshari_body_feathers"
	preference = "teshari_body_feathers"

	dna_block = DNA_TESHARI_BODY_FEATHERS_BLOCK
	color_source = ORGAN_COLOR_INHERIT_ALL
	mutcolor_used = MUTCOLORS_KEY_TESHARI_BODY_FEATHERS

/obj/item/organ/external/teshari_body_feathers/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
		return FALSE
	return TRUE

/obj/item/organ/external/teshari_body_feathers/get_global_feature_list()
	return GLOB.teshari_body_feathers_list

/obj/item/organ/external/teshari_body_feathers/get_overlays(physique, image_dir)
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

	for(var/image_layer in all_layers)
		if(!(layers & image_layer))
			continue
		var/real_layer = GLOB.bitflag2layer["[image_layer]"]
		var/state2use = build_icon_state(physique, image_layer)

		for(var/obj/item/bodypart/BP as anything in owner.bodyparts - owner.get_bodypart(BODY_ZONE_CHEST))
			var/mutable_appearance/new_overlay = mutable_appearance(sprite_datum.icon, "[state2use]_[BP.body_zone]", layer = -real_layer)
			new_overlay.color = mutcolors[bodypart_color_indexes[BP.body_zone]]
			. += new_overlay
