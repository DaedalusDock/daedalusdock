/mob/camera/flock/overmind
	name = "Flockmind"
	desc = "TODO"
	icon_state ="flockmind"

	// pass_flags = PASSBLOB
	// faction = list(ROLE_BLOB)
	//hud_type = /datum/hud/blob_overmind

	actions_to_grant = list(
		/datum/action/cooldown/flock/gatecrash,
		/datum/action/cooldown/flock/designate_tile,
		/datum/action/cooldown/flock/designate_enemy,
		/datum/action/cooldown/flock/designate_ignore,
		/datum/action/cooldown/flock/radio_blast,
		/datum/action/cooldown/flock/ping,
		/datum/action/cooldown/flock/diffract_drone,
		/datum/action/cooldown/flock/control_drone,
		/datum/action/cooldown/flock/control_panel,
	)

/mob/camera/flock/overmind/Initialize(mapload, join_flock)
	. = ..()
	flock.register_overmind(src)
	set_real_name("Flockmind [flock.name]")

/mob/camera/flock/overmind/Logout()
	. = ..()
	// If we disconnect, free our homeboy
	var/datum/action/cooldown/flock/control_drone/control_drone = locate() in actions
	control_drone?.free_drone()

/mob/camera/flock/overmind/so_very_sad_death()
	var/datum/flock/old_flock = flock
	flock = null
	old_flock?.overmind = null
	old_flock.game_over()
	. = ..()

