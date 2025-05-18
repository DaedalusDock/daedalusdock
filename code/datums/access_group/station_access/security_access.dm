/datum/access_group/station/security
	name = "Security"

/datum/access_group/station/security/New()
	for(var/path in subtypesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/// Security areas
/datum/access_group/station/security/areas
	name = "Security (Areas)"
	access = list(
		ACCESS_SECURITY,
		ACCESS_ARMORY,
		ACCESS_COURT,
		ACCESS_HOS,
	)

/// Security non-areas
/datum/access_group/station/security/other
	name = "Security (Other)"
	access = list(
		ACCESS_MECH_SECURITY,
		ACCESS_WEAPONS,
		// This should probably just be on a physical card in security and not actually grantable.
		ACCESS_ALL_PERSONAL_LOCKERS,
		ACCESS_RC_ANNOUNCE,
	)
