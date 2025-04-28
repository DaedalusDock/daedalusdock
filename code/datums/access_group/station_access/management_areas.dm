/datum/access_group/station/management
	name = "Management"

/datum/access_group/station/management/New()
	for(var/path in subtypesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/datum/access_group/station/management/areas
	name = "Management (Areas)"
	access = list(
		ACCESS_SECURE_ENGINEERING,
		ACCESS_TELEPORTER,
		ACCESS_AI_UPLOAD,
		ACCESS_DELEGATE,
		ACCESS_VAULT,
	)

/datum/access_group/station/management/other
	name = "Management (Non-area)"
	access = list(
		ACCESS_CHANGE_IDS,
		ACCESS_KEYCARD_AUTH,
		ACCESS_RC_ANNOUNCE,
	)
