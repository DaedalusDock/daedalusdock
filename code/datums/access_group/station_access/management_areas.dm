/datum/access_group/station/management
	name = "Management"

/datum/access_group/station/management/New()
	for(var/path in subtypesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/datum/access_group/station/management/areas
	name = "Management (Areas)"
	access = list(
		ACCESS_MINISAT,
		ACCESS_TCOMSAT,
		ACCESS_VAULT,
		ACCESS_TECH_STORAGE,
		ACCESS_TELEPORTER,
		ACCESS_ARMORY,
		ACCESS_AI_UPLOAD,
		ACCESS_EVA,
		ACCESS_GATEWAY,
		ACCESS_HOP,
	)

/datum/access_group/station/management/other
	name = "Management (Non-area)"
	access = list(
		ACCESS_ALL_PERSONAL_LOCKERS,
		ACCESS_CHANGE_IDS,
		ACCESS_KEYCARD_AUTH,
		ACCESS_RC_ANNOUNCE,
	)
