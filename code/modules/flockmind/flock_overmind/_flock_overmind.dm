/mob/camera/flock/overmind
	name = "flockmind"
	desc = "TODO"
	icon = 'goon/icons/mob/featherzone.dmi'
	icon_state ="flockmind"

	// pass_flags = PASSBLOB
	// faction = list(ROLE_BLOB)
	//hud_type = /datum/hud/blob_overmind

	actions_to_grant = list(
		/datum/action/cooldown/flock/gatecrash,
	)

/mob/camera/flock/overmind/Initialize(mapload)
	. = ..()
	set_real_name(flock_realname(FLOCK_TYPE_OVERMIND))

/mob/camera/flock/overmind
