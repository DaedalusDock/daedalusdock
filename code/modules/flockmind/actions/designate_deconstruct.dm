/datum/action/cooldown/flock/designate_deconstruct
	name = "Mark for Deconstruction"
	desc = "Mark an existing flock structure for deconstruction, refunding some resources."
	button_icon_state = "destroystructure"

	click_to_activate = TRUE
	unset_after_click = FALSE
	click_cd_override = 0

/datum/action/cooldown/flock/designate_deconstruct/Activate(atom/target)
	. = ..()
	var/mob/camera/flock/ghost_bird = owner
	return ghost_bird.flock.toggle_deconstruction_mark(target)
