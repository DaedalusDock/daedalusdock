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
		ACCESS_MORGUE,
		ACCESS_CHEMISTRY,
		ACCESS_VIROLOGY,
		ACCESS_SURGERY,
		ACCESS_ROBOTICS,
		ACCESS_CMO,
		ACCESS_PHARMACY,
		ACCESS_PSYCHOLOGY,
	)

/// Medical non-areas
/datum/access_group/station/medical/other
	name = "Ward (Other)"
	access = list(
		ACCESS_MECH_MEDICAL,
	)
