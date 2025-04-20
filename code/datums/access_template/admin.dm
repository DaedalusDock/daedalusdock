/// Trim for admins and debug cards. Has every single access in the game.
/datum/access_template/admin
	assignment = "Jannie"
	template_state = "trim_ert_janitor"

/datum/access_template/admin/New()
	. = ..()
	// Every single access in the game, all on one handy trim.
	access = SSid_access.get_access_for_group(/datum/access_group/all)

/// Trim for highlander cards, used during the highlander adminbus event.
/datum/access_template/highlander
	assignment = "Highlander"
	template_state = "trim_ert_deathcommando"

/datum/access_template/highlander/New()
	. = ..()
	access = SSid_access.get_access_for_group(list(/datum/access_group/centcom, /datum/access_group/station/all))
