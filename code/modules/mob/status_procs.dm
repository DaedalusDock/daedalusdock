//Here are the procs used to modify status effects of a mob.

/**
* Set drowsyness of a mob to passed value
*/
/mob/proc/set_drowsyness(amount)
	. = drowsyness
	drowsyness = max(amount, 0)

	if(!!. != !!drowsyness)
		if(drowsyness)
			add_movespeed_modifier(/datum/movespeed_modifier/status_effect/drowsy)
		else
			remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/drowsy)
/**
 * Adds passed value to the drowsyness of a mob
 */
/mob/proc/adjust_drowsyness(amount, up_to = INFINITY)
	if(amount + drowsyness > up_to)
		amount = max(up_to - drowsyness, 0)
	set_drowsyness(max(drowsyness + amount, 0))

///Blind a mobs eyes by amount
/mob/proc/blind_eyes(amount)
	adjust_blindness(amount)

/**
 * Adjust a mobs blindness by an amount
 *
 * Will apply the blind alerts if needed
 */
/mob/proc/adjust_blindness(amount)
	var/old_eye_blind = eye_blind
	eye_blind = max(0, eye_blind + amount)
	if(!old_eye_blind || !eye_blind && !HAS_TRAIT(src, TRAIT_BLIND))
		update_blindness()
/**
 * Force set the blindness of a mob to some level
 */
/mob/proc/set_blindness(amount)
	var/old_eye_blind = eye_blind
	eye_blind = max(amount, 0)
	if(!old_eye_blind || !eye_blind && !HAS_TRAIT(src, TRAIT_BLIND))
		update_blindness()


/// proc that adds and removes blindness overlays when necessary
/mob/proc/update_blindness()
	switch(stat)
		if(CONSCIOUS)
			if(HAS_TRAIT(src, TRAIT_BLIND) || eye_blind)
				throw_alert(ALERT_BLIND, /atom/movable/screen/alert/blind)
				do_set_blindness(BLIND_PHYSICAL)
			else
				do_set_blindness(BLIND_NOT_BLIND)
		if(UNCONSCIOUS)
			do_set_blindness(BLIND_SLEEPING)
		if(DEAD)
			do_set_blindness(BLIND_NOT_BLIND)

///Proc that handles adding and removing the blindness overlays.
/mob/proc/do_set_blindness(blindness_level)
	switch(blindness_level)
		if(BLIND_SLEEPING)
			overlay_fullscreen("completely_blind", /atom/movable/screen/fullscreen/blind/blinder)
			// You are blind why should you be able to make out details like color, only shapes near you
			add_client_colour(/datum/client_colour/monochrome/blind)
		if(BLIND_PHYSICAL)
			clear_fullscreen("completely_blind")
			overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
			// You are blind why should you be able to make out details like color, only shapes near you
			add_client_colour(/datum/client_colour/monochrome/blind)
		else
			clear_alert(ALERT_BLIND)
			clear_fullscreen("completely_blind")
			clear_fullscreen("blind")
			remove_client_colour(/datum/client_colour/monochrome/blind)


/**
 * Make the mobs vision blurry
 */
/mob/proc/blur_eyes(amount)
	if(amount>0)
		eye_blurry = max(amount, eye_blurry)
	update_eye_blur()

/**
 * Adjust the current blurriness of the mobs vision by amount
 */
/mob/proc/adjust_blurriness(amount)
	eye_blurry = max(eye_blurry+amount, 0)
	update_eye_blur()

///Set the mobs blurriness of vision to an amount
/mob/proc/set_blurriness(amount)
	eye_blurry = max(amount, 0)
	update_eye_blur()

///Apply the blurry overlays to a mobs clients screen
/mob/proc/update_eye_blur()
	var/atom/movable/plane_master_controller/game_plane_master_controller = hud_used?.plane_master_controllers[PLANE_MASTERS_GAME]
	if(eye_blurry || HAS_TRAIT(src, TRAIT_BLURRY_VISION))
		if(game_plane_master_controller)
			game_plane_master_controller.add_filter("eye_blur", 1, gauss_blur_filter(clamp(eye_blurry * 0.1, 0.6, 3)))
		overlay_fullscreen("dither", /atom/movable/screen/fullscreen/dither)
	else
		if(game_plane_master_controller)
			game_plane_master_controller.remove_filter("eye_blur")
		clear_fullscreen("dither")

///Adjust the disgust level of a mob
/mob/proc/adjust_disgust(amount)
	return

///Set the disgust level of a mob
/mob/proc/set_disgust(amount)
	return

///Adjust the body temperature of a mob, with min/max settings
/mob/proc/adjust_bodytemperature(amount,min_temp=0,max_temp=INFINITY)
	if(bodytemperature >= min_temp && bodytemperature <= max_temp)
		bodytemperature = clamp(bodytemperature + amount,min_temp,max_temp)
