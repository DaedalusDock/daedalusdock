/// Trim for admins and debug cards. Has every single access in the game.
/datum/access_template/admin
	assignment = "Jannie"
	trim_state = "trim_ert_janitor"

/datum/access_template/admin/New()
	. = ..()
	// Every single access in the game, all on one handy trim.
	access = SSid_access.get_region_access_list(list(REGION_ALL_GLOBAL))

/// Trim for highlander cards, used during the highlander adminbus event.
/datum/access_template/highlander
	assignment = "Highlander"
	trim_state = "trim_ert_deathcommando"

/datum/access_template/highlander/New()
	. = ..()
	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))
