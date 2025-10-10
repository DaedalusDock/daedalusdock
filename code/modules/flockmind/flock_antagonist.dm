/datum/antagonist/flock
	name = "Divine Flock"
	name_prefix = "the"
	antagpanel_category = "Flock"

	roundend_category = "The Divine Flock"
	antag_hud_name = null
	ui_name = null
	job_rank = ROLE_FLOCK

/datum/antagonist/flock/admin_add(datum/mind/new_owner, mob/admin)
	. = ..()

/datum/antagonist/flock/overmind
	name = "Divine Flock Overmind"

/datum/antagonist/flock/overmind/admin_add(datum/mind/new_owner, mob/admin)
	if(tgui_alert(admin, "Are you sure you want to turn [new_owner.current] ([new_owner.current.ckey]) into a Flock Overmind?", "Antag Panel", list("Yes", "No")) != "Yes")
		return

	var/delete_mob = tgui_alert(admin, "Delete mob?", "Antag Panel", list("Yes", "No")) == "Yes"
	var/mob/old_mob = new_owner.current

	message_admins("[key_name_admin(admin)] made [key_name_admin(new_owner)] into [get_name()].")
	log_admin("[key_name(admin)] made [key_name(new_owner)] into [get_name()].")

	var/mob/camera/flock/overmind/overmind = new(get_turf(new_owner.current))
	overmind.PossessByPlayer(new_owner.current.ckey)

	if(delete_mob)
		qdel(old_mob)
