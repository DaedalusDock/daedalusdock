/datum/action/cooldown/flock/designate_tile
	name = "Designate Priority Tile"
	desc = "Add or remove a tile to the urgent tiles the flock should claim."
	button_icon_state = "designate_tile"

	click_to_activate = TRUE
	unset_after_click = FALSE
	click_cd_override = 0

/datum/action/cooldown/flock/designate_tile/is_valid_target(atom/cast_on)
	return cast_on.can_flock_convert()

/datum/action/cooldown/flock/designate_tile/Activate(atom/target)
	target = get_turf(target)
	if(isflockturf(target))
		to_chat(owner, span_alert("That tile has already been converted by the flock."))
		return FALSE

	if(!target.can_flock_convert())
		to_chat(owner, span_alert("The flock is unable to convert that."))
		return FALSE

	var/mob/camera/flock/ghost_bird = owner
	if(!ghost_bird.flock.marked_for_deconstruction[target])
		if(ghost_bird.flock.turf_reservations[target])
			to_chat(ghost_bird, span_alert("That tile is already scheduled for conversion."))
			return FALSE

		ghost_bird.flock.marked_for_deconstruction[target] = TRUE
		ghost_bird.flock.add_notice(target, FLOCK_NOTICE_PRIORITY)
		return TRUE

	else
		ghost_bird.flock.marked_for_deconstruction -= target
		ghost_bird.flock.remove_notice(target, FLOCK_NOTICE_PRIORITY)
		return TRUE
