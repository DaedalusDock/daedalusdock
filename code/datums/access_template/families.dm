/// Trim for the families space police. Has all access.
/datum/access_template/space_police
	template_state = "trim_ert_security"
	assignment = "Space Police"

/datum/access_template/space_police/New()
	. = ..()
	access = SSid_access.get_access_for_group(list(/datum/access_group/station/all))
