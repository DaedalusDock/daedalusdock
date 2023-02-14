/// Is `observed_atom` in a mob's field of view? This takes blindness, nearsightness and FOV into consideration
/mob/living/proc/in_fov(atom/observed_atom, ignore_self = FALSE)
	if(ignore_self && observed_atom == src)
		return TRUE
	if(is_blind())
		return FALSE
	// Handling nearsightnedness
	if(HAS_TRAIT(src, TRAIT_NEARSIGHT))
		//Checking if our dude really is suffering from nearsightness! (very nice nearsightness code)
		if(iscarbon(src))
			var/mob/living/carbon/carbon_me = src
			if(carbon_me.glasses)
				var/obj/item/clothing/glasses/glass = carbon_me.glasses
				if(!glass.vision_correction)
					return FALSE

	return TRUE

/// Plays a visual effect representing a sound cue for people with vision obstructed by FOV or blindness
/proc/play_fov_effect(atom/center, range, icon_state, dir = SOUTH, ignore_self = FALSE, angle = 0, list/override_list)
	var/turf/anchor_point = get_turf(center)
	var/image/fov_image
	for(var/mob/living/living_mob in override_list || get_hearers_in_view(range, center))
		var/client/mob_client = living_mob.client
		if(!mob_client)
			continue
		if(HAS_TRAIT(living_mob, TRAIT_DEAF)) //Deaf people can't hear sounds so no sound indicators
			continue
		if(living_mob.in_fov(center, ignore_self))
			continue
		if(!fov_image) //Make the image once we found one recipient to receive it
			fov_image = image(icon = 'icons/effects/fov_effects.dmi', icon_state = icon_state, loc = anchor_point)
			fov_image.plane = FULLSCREEN_PLANE
			fov_image.layer = FOV_EFFECTS_LAYER
			fov_image.dir = dir
			fov_image.appearance_flags = RESET_COLOR | RESET_TRANSFORM
			if(angle)
				var/matrix/matrix = new
				matrix.Turn(angle)
				fov_image.transform = matrix
			fov_image.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		mob_client.images += fov_image
		addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_image_from_client, fov_image, mob_client), 30)
