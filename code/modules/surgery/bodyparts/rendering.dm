GLOBAL_LIST_INIT(limb_overlays_cache, list())

//we inform the bodypart of the changes that happened to the owner, or give it the informations from a source mob.
//set is_creating to true if you want to change the appearance of the limb outside of mutation changes or forced changes.
/obj/item/bodypart/proc/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	if(HAS_TRAIT(owner, TRAIT_HUSK) && IS_ORGANIC_LIMB(src))
		dmg_overlay_type = "" //no damage overlay shown when husked
		is_husked = TRUE
	else
		dmg_overlay_type = initial(dmg_overlay_type)
		is_husked = FALSE

	if(variable_color)
		draw_color = variable_color
	else if(should_draw_greyscale)
		draw_color = (species_color) || (skin_tone && skintone2hex(skin_tone))
	else
		draw_color = null

	if(!is_creating || !owner)
		return

	// There should technically to be an ishuman(owner) check here, but it is absent because no basetype carbons use bodyparts
	// No, xenos don't actually use bodyparts. Don't ask.
	var/mob/living/carbon/human/human_owner = owner

	var/datum/species/owner_species = human_owner.dna.species
	species_flags_list = human_owner.dna.species.species_traits
	mutcolors = human_owner.dna.mutant_colors.Copy()
	limb_gender = (human_owner.physique == MALE) ? "m" : "f"

	if(owner_species.use_skintones)
		skin_tone = human_owner.skin_tone
	else
		skin_tone = ""

	if(((MUTCOLORS in owner_species.species_traits) || (DYNCOLORS in owner_species.species_traits))) //Ethereal code. Motherfuckers.
		if(owner_species.fixed_mut_color)
			species_color = owner_species.fixed_mut_color
		else
			species_color = mutcolors[mutcolor_used]
	else
		species_color = null

	draw_color = variable_color
	if(should_draw_greyscale) //Should the limb be colored?
		draw_color ||= (species_color) || (skin_tone && skintone2hex(skin_tone))

	recolor_external_organs()
	return TRUE

//to update the bodypart's icon when not attached to a mob
/obj/item/bodypart/proc/update_icon_dropped()
	SHOULD_CALL_PARENT(TRUE)

	cut_overlays()
	dir = SOUTH
	var/key = json_encode(generate_icon_key())
	var/list/standing = GLOB.limb_overlays_cache[key]
	standing ||= get_limb_overlays(TRUE)
	if(!length(standing))
		icon_state = initial(icon_state)//no overlays found, we default back to initial icon.
	pixel_x = px_x
	pixel_y = px_y
	add_overlay(standing)

///Generates a list of mutable appearances for the limb to be used as overlays
/obj/item/bodypart/proc/get_limb_overlays(dropped)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	pixel_x = 0
	pixel_y = 0
	icon_state = "" //to erase the default sprite, we're building the visual aspects of the bodypart through overlays alone.


	. = list()

	var/image_dir = dropped ? SOUTH : null

	var/chosen_icon = ""
	var/chosen_icon_state = ""
	var/chosen_aux_state = ""

	//HUSK SHIIIIT
	if(is_husked)
		chosen_icon = icon_husk
		chosen_icon_state = "[husk_type]_husk_[body_zone]"
		icon_exists(chosen_icon, chosen_icon_state, scream = TRUE) //Prints a stack trace on the first failure of a given iconstate.
		. += mutable_appearance(chosen_icon, chosen_icon_state)
		if(aux_zone) //Hand shit
			. += image(chosen_icon, "[husk_type]_husk_[aux_zone]", -aux_layer, image_dir)
		return
	//END HUSK SHIIIIT

	////This is the MEAT of limb icon code
	chosen_icon = icon_greyscale
	if(!should_draw_greyscale || !icon_greyscale)
		chosen_icon = icon_static

	if(is_dimorphic) //Does this type of limb have sexual dimorphism?
		chosen_icon_state = "[limb_id]_[body_zone]_[limb_gender]"
	else
		chosen_icon_state = "[limb_id]_[body_zone]"

	chosen_aux_state = "[limb_id]_[aux_zone]"

	//The icon's information has been settled. Time to create it's icon for manipulation.
	icon_exists(chosen_icon, chosen_icon_state, TRUE) //Prints a stack trace on the first failure of a given iconstate.

	var/icon/new_icon = icon(chosen_icon, chosen_icon_state)
	current_icon = new_icon
	if(draw_color && (body_zone != BODY_ZONE_L_LEG && body_zone != BODY_ZONE_R_LEG))
		current_icon.Blend(draw_color, ICON_MULTIPLY)
	if(aux_layer)
		var/icon/new_aux_icon = icon(chosen_icon, chosen_aux_state)
		current_aux_icon = new_aux_icon
		if(draw_color && (body_zone != BODY_ZONE_L_LEG && body_zone != BODY_ZONE_R_LEG))
			current_aux_icon.Blend(draw_color, ICON_MULTIPLY)

	if((body_zone != BODY_ZONE_L_LEG && body_zone != BODY_ZONE_R_LEG))
		for(var/datum/appearance_modifier/mod as anything in appearance_mods)
			mod.BlendOnto(current_icon)
			if(mod.affects_hands && aux_zone)
				mod.BlendOnto(current_aux_icon)

	//Icon is greebled. Add overlays.

	var/mutable_appearance/limb_appearance = mutable_appearance(current_icon, chosen_icon_state, -BODYPARTS_LAYER, direction = image_dir)
	var/mutable_appearance/aux_appearance
	. += limb_appearance
	if(aux_layer)
		aux_appearance = mutable_appearance(current_aux_icon, chosen_aux_state, -aux_layer, direction = image_dir)
		. += aux_appearance


	//Ok so legs are a bit goofy in regards to layering, and we will need two images instead of one to fix that.
	if((body_zone == BODY_ZONE_R_LEG) || (body_zone == BODY_ZONE_L_LEG))

		for(var/mutable_appearance/old_appearance as anything in .)
			//remove the old, unmasked image
			. -= old_appearance
			//add two masked images based on the old one
			. += generate_masked_leg(old_appearance, image_dir)


	if(dropped)
		if(dmg_overlay_type)
			if(brutestate)
				. += image('icons/mob/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_[brutestate]0", -DAMAGE_LAYER, image_dir)
			if(burnstate)
				. += image('icons/mob/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_0[burnstate]", -DAMAGE_LAYER, image_dir)



	//EMISSIVE CODE START
	if(!is_husked)
		if(blocks_emissive)
			var/mutable_appearance/limb_em_block = emissive_blocker(chosen_icon, chosen_icon_state, -BODY_LAYER, alpha = limb_appearance.alpha)
			limb_em_block.dir = image_dir
			. += limb_em_block

			if(aux_zone)
				var/mutable_appearance/aux_em_block = emissive_blocker(chosen_icon, chosen_aux_state, -BODY_LAYER, alpha = aux_appearance.alpha)
				aux_em_block.dir = image_dir
				. += aux_em_block
	//EMISSIVE CODE END

	if(!is_husked)
		//Draw external organs like horns and frills
		for(var/obj/item/organ/external/external_organ in external_organs)
			if(!dropped && !external_organ.can_draw_on_bodypart(owner))
				continue
			//Some externals have multiple layers for background, foreground and between
			. += external_organ.get_overlays(limb_gender, image_dir)

	return .

/////////////////////////
// Limb Icon Cache 2.0 //
/////////////////////////
/**
 * Called from update_body_parts() these procs handle the limb icon cache.
 * the limb icon cache adds an icon_render_key to a human mob, it represents:
 * - Gender, if applicable
 * - The ID of the limb
 * - Draw color, if applicable
 * These procs only store limbs as to increase the number of matching icon_render_keys
 * This cache exists because drawing 6/7 icons for humans constantly is quite a waste
 * See RemieRichards on irc.rizon.net #coderbus (RIP remie :sob:)
**/
/obj/item/bodypart/proc/generate_icon_key()
	RETURN_TYPE(/list)
	. = list()
	if(is_dimorphic)
		. += "[limb_gender]-"
	. += "[limb_id]"
	. += "-[body_zone]"
	if(should_draw_greyscale && draw_color)
		. += "-[draw_color]"

	for(var/obj/item/organ/external/external_organ as anything in external_organs)
		if(owner && !external_organ.can_draw_on_bodypart(owner))
			continue
		. += "-[jointext(external_organ.generate_icon_cache(), "-")]"

	for(var/datum/appearance_modifier/mod as anything in appearance_mods)
		. += mod.key

	return .

///Generates a cache key specifically for husks
/obj/item/bodypart/proc/generate_husk_key()
	RETURN_TYPE(/list)
	. = list()
	. += "[husk_type]"
	. += "-husk"
	. += "-[body_zone]"
	return .

/obj/item/bodypart/head/generate_icon_key()
	. = ..()
	. += "-[facial_hairstyle]"
	. += "-[facial_hair_color]"
	if(facial_hair_gradient_style)
		. += "-[facial_hair_gradient_style]"
		if(hair_gradient_color)
			. += "-[facial_hair_gradient_color]"
	if(facial_hair_hidden)
		. += "-FACIAL_HAIR_HIDDEN"
	if(show_debrained)
		. += "-SHOW_DEBRAINED"
		return .

	. += "-[hair_style]"
	. += "-[fixed_hair_color || override_hair_color || hair_color]"
	if(hair_gradient_style)
		. += "-[hair_gradient_style]"
		if(hair_gradient_color)
			. += "-[hair_gradient_color]"
	if(hair_hidden)
		. += "-HAIR_HIDDEN"

	return .

GLOBAL_LIST_EMPTY(masked_leg_icons_cache)

/**
 * This proc serves as a way to ensure that legs layer properly on a mob.
 * To do this, two separate images are created - A low layer one, and a normal layer one.
 * Each of the image will appropriately crop out dirs that are not used on that given layer.
 *
 * Arguments:
 * * limb_overlay - The limb image being masked, not necessarily the original limb image as it could be an overlay on top of it
 * * image_dir - Direction of the masked images.
 *
 * Returns the list of masked images, or `null` if the limb_overlay didn't exist
 */
/obj/item/bodypart/proc/generate_masked_leg(mutable_appearance/limb_overlay, image_dir = NONE)
	RETURN_TYPE(/list)
	if(!limb_overlay)
		return
	. = list()

	var/icon_cache_key = json_encode(generate_icon_key())
	var/icon/new_leg_icon
	var/icon/new_leg_icon_lower

	//in case we do not have a cached version of the two cropped icons for this key, we have to create it
	if(!GLOB.masked_leg_icons_cache[icon_cache_key])
		var/icon/leg_crop_mask = (body_zone == BODY_ZONE_R_LEG ? icon('icons/mob/leg_masks.dmi', "right_leg") : icon('icons/mob/leg_masks.dmi', "left_leg"))
		var/icon/leg_crop_mask_lower = (body_zone == BODY_ZONE_R_LEG ? icon('icons/mob/leg_masks.dmi', "right_leg_lower") : icon('icons/mob/leg_masks.dmi', "left_leg_lower"))

		new_leg_icon = icon(limb_overlay.icon, limb_overlay.icon_state)
		new_leg_icon.Blend(leg_crop_mask, ICON_MULTIPLY)
		if(draw_color)
			new_leg_icon.Blend(draw_color, ICON_MULTIPLY)

		new_leg_icon_lower = icon(limb_overlay.icon, limb_overlay.icon_state)
		new_leg_icon_lower.Blend(leg_crop_mask_lower, ICON_MULTIPLY)
		if(draw_color)
			new_leg_icon_lower.Blend(draw_color, ICON_MULTIPLY)

		GLOB.masked_leg_icons_cache[icon_cache_key] = list(new_leg_icon, new_leg_icon_lower)

	new_leg_icon = GLOB.masked_leg_icons_cache[icon_cache_key][1]
	new_leg_icon_lower = GLOB.masked_leg_icons_cache[icon_cache_key][2]

	for(var/datum/appearance_modifier/mod as anything in appearance_mods)
		mod.BlendOnto(new_leg_icon)
		mod.BlendOnto(new_leg_icon_lower)

	//this could break layering in oddjob cases, but i'm sure it will work fine most of the time... right?
	var/mutable_appearance/new_leg_appearance = new(limb_overlay)
	new_leg_appearance.icon = new_leg_icon
	new_leg_appearance.layer = -BODYPARTS_LAYER
	new_leg_appearance.dir = image_dir //for some reason, things do not work properly otherwise
	. += new_leg_appearance
	var/mutable_appearance/new_leg_appearance_lower = new(limb_overlay)
	new_leg_appearance_lower.icon = new_leg_icon_lower
	new_leg_appearance_lower.layer = -BODYPARTS_LOW_LAYER
	new_leg_appearance_lower.dir = image_dir
	. += new_leg_appearance_lower
	return .
