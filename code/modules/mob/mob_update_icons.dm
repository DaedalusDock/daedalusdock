//Most of these are defined at this level to reduce on checks elsewhere in the code.
//Having them here also makes for a nice reference list of the various overlay-updating procs available

///Redraws the entire mob. For carbons, this is rather expensive, please use the individual update_X procs.
/mob/proc/regenerate_icons() //TODO: phase this out completely if possible
	return

///Updates every item slot passed into it.
/mob/proc/update_clothing(slot_flags)
	return

/mob/proc/update_icons()
	return

///Updates the handcuff overlay & HUD element.
/mob/proc/update_worn_handcuffs()
	return

///Updates the legcuff overlay & HUD element.
/mob/proc/update_worn_legcuffs()
	return

///Updates the back overlay & HUD element.
/mob/proc/update_worn_back()
	return

///Updates the held items overlay(s) & HUD element.
/mob/proc/update_held_items()
	return

///Updates the mask overlay & HUD element.
/mob/proc/update_worn_mask()
	return

///Updates the neck overlay & HUD element.
/mob/proc/update_worn_neck()
	return

///Updates the oversuit overlay & HUD element.
/mob/proc/update_worn_oversuit()
	return

///Updates the undersuit/uniform overlay & HUD element.
/mob/proc/update_worn_undersuit()
	return

///Updates the belt overlay & HUD element.
/mob/proc/update_worn_belt()
	return

///Updates the on-head overlay & HUD element.
/mob/proc/update_worn_head()
	return

///Updates every part of a carbon's body. Including parts, mutant parts, lips, underwear, and socks.
/mob/proc/update_body()
	return

/mob/proc/update_hair()
	return

///Updates the glasses overlay & HUD element.
/mob/proc/update_worn_glasses()
	return

///Updates the id overlay & HUD element.
/mob/proc/update_worn_id()
	return

///Updates the shoes overlay & HUD element.
/mob/proc/update_worn_shoes()
	return

///Updates the glasses overlay & HUD element.
/mob/proc/update_worn_gloves()
	return

///Updates the handcuff overlay & HUD element.
/mob/proc/update_suit_storage()
	return

///Updates the handcuff overlay & HUD element.
/mob/proc/update_pockets()
	return

///Updates the handcuff overlay & HUD element.
/mob/proc/update_worn_ears()
	return

/mob/get_offsets()
	. += ..()

	for(var/offset_key in LAZYACCESS(offsets, PIXEL_X_OFFSET))
		.[PIXEL_X_OFFSET] += offsets[PIXEL_X_OFFSET][offset_key]
	for(var/offset_key in LAZYACCESS(offsets, PIXEL_Y_OFFSET))
		.[PIXEL_Y_OFFSET] += offsets[PIXEL_Y_OFFSET][offset_key]

/**
 * Adds an offset to the mob's pixel position.
 *
 * * source: The source of the offset, a string
 * * x_add: pixel_x offset
 * * y_add: pixel_y offset
 * * animate: If TRUE, the mob will animate to the new position. If FALSE, it will instantly move.
 */
/mob/proc/add_offsets(source, x_add, y_add, animate = TRUE)
	LAZYINITLIST(offsets)
	if(isnum(x_add))
		LAZYSET(offsets[PIXEL_X_OFFSET], source, x_add)
	if(isnum(y_add))
		LAZYSET(offsets[PIXEL_Y_OFFSET], source, y_add)
	update_offsets(animate)

/**
 * Goes through all pixel adjustments and removes any tied to the passed source.
 *
 * * source: The source of the offset to remove
 * * animate: If TRUE, the mob will animate to the position with any offsets removed. If FALSE, it will instantly move.
 */
/mob/proc/remove_offsets(source, animate = TRUE)
	for(var/offset in offsets)
		LAZYREMOVE(offsets[offset], source)
		ASSOC_UNSETEMPTY(offsets, offset)

	UNSETEMPTY(offsets)
	update_offsets(animate)

/**
 * Checks if we are offset by the passed source for the passed pixel.
 *
 * * source: The source of the offset
 * If not supplied, it will report the total offset of the passed pixel.
 * * pixel: Optional, The pixel to check.
 * If not supplied, just reports if it's offset by the source at all (returning the first offset found).
 *
 * Returns the offset if we are, 0 otherwise.
 */
/mob/proc/has_offset(source, pixel)
	if(isnull(source) && isnull(pixel))
		stack_trace("has_offset() requires at least one argument.")
		return 0

	if(isnull(source))
		if(!length(offsets?[pixel]))
			return 0

		var/total_found_offset = 0
		for(var/found_offset in offsets[pixel])
			total_found_offset += has_offset(found_offset, pixel)
		return total_found_offset

	if(isnull(pixel))
		for(var/found_pixel in offsets)
			var/found_offset = has_offset(source, found_pixel)
			if(found_offset)
				return found_offset

		return 0

	return offsets?[pixel]?[source] || 0

/mob/set_base_pixel_x(new_value)
	. = ..()
	update_offsets(FALSE)

/mob/set_base_pixel_y(new_value)
	. = ..()
	update_offsets(FALSE)
