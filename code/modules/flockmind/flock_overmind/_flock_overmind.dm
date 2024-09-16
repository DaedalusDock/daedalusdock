/mob/camera/flock/overmind
	name = "Flockmind"
	desc = "TODO"
	icon = 'goon/icons/mob/featherzone.dmi'
	icon_state ="flockmind"

	// pass_flags = PASSBLOB
	// faction = list(ROLE_BLOB)
	//hud_type = /datum/hud/blob_overmind

	actions_to_grant = list(
		/datum/action/cooldown/flock/gatecrash,
		/datum/action/cooldown/flock/designate_tile,
	)

/mob/camera/flock/overmind/Initialize(mapload)
	. = ..()
	flock = GLOB.debug_flock
	set_real_name("Flockmind [flock.name]")

GLOBAL_DATUM_INIT(debug_flock, /datum/flock, new)
