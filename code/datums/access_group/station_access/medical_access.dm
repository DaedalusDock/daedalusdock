/datum/access_group/station/medical
	name = "Ward"

/datum/access_group/station/medical/New()
	for(var/path in subtypesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/// Medical areas
/datum/access_group/station/medical/areas
	name = "Ward (Areas)"
	access = list(
		ACCESS_MEDICAL,
		ACCESS_CMO,
		ACCESS_PHARMACY,
	)

/// Medical non-areas
/datum/access_group/station/medical/other
	name = "Ward (Other)"
	access = list(
		ACCESS_MECH_MEDICAL,
		ACCESS_RC_ANNOUNCE,
	)
