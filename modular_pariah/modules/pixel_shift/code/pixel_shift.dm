/mob
	///Whether the mob is pixel shifted or not
	var/shifting //If we are in the shifting setting.

/datum/keybinding/mob/pixel_shift
	hotkey_keys = list("J")
	name = "pixel_shift"
	full_name = "Pixel Shift"
	description = "Shift your characters offset."
	category = CATEGORY_MOVEMENT
	keybind_signal = COMSIG_KB_MOB_PIXELSHIFT

/datum/keybinding/mob/pixel_shift/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.shifting = TRUE
	return TRUE

/datum/keybinding/mob/pixel_shift/up(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.shifting = FALSE
	return TRUE

/mob/proc/unpixel_shift()
	return

/mob/living/unpixel_shift()
	remove_offsets(TRAIT_PIXEL_SHIFTED)
	REMOVE_TRAIT(src, TRAIT_PIXEL_SHIFTED, INNATE_TRAIT)

/mob/proc/pixel_shift(direction)
	return

/mob/living/pixel_shift(direction)
	if(stat > CONSCIOUS || notransform || incapacitated())
		return FALSE

	var/existing_y_offset = has_offset(TRAIT_PIXEL_SHIFTED, PIXEL_Y_OFFSET) || 0
	var/existing_x_offset = has_offset(TRAIT_PIXEL_SHIFTED, PIXEL_X_OFFSET) || 0

	if(direction & NORTH)
		if(existing_y_offset < 16)
			add_offsets(TRAIT_PIXEL_SHIFTED, y_add = clamp(existing_y_offset + 1, -16, 16))
			ADD_TRAIT(src, TRAIT_PIXEL_SHIFTED, INNATE_TRAIT)

	if(direction & EAST)
		if(existing_x_offset < 16)
			add_offsets(TRAIT_PIXEL_SHIFTED, x_add = clamp(existing_x_offset + 1, -16, 16))
			ADD_TRAIT(src, TRAIT_PIXEL_SHIFTED, INNATE_TRAIT)

	if(direction & SOUTH)
		if(existing_y_offset > -16)
			add_offsets(TRAIT_PIXEL_SHIFTED, y_add = clamp(existing_y_offset - 1, -16, 16))
			ADD_TRAIT(src, TRAIT_PIXEL_SHIFTED, INNATE_TRAIT)

	if(direction & WEST)
		if(existing_x_offset < 16)
			add_offsets(TRAIT_PIXEL_SHIFTED, x_add = clamp(existing_x_offset - 1, -16, 16))
			ADD_TRAIT(src, TRAIT_PIXEL_SHIFTED, INNATE_TRAIT)

