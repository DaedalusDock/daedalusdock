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
		/datum/action/cooldown/flock/designate_enemy,
		/datum/action/cooldown/flock/designate_ignore,
		/datum/action/cooldown/flock/radio_blast,
		/datum/action/cooldown/flock/ping,
	)

/mob/camera/flock/overmind/Initialize(mapload)
	. = ..()
	flock = GLOB.debug_flock
	flock.register_overmind(src)
	set_real_name("Flockmind [flock.name]")

GLOBAL_DATUM_INIT(debug_flock, /datum/flock, new)
