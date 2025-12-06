/datum/access_group/station/federation
	name = "Federation"

/datum/access_group/station/federation/New()
	for(var/path in subtypesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/datum/access_group/station/federation/areas
	name = "Federation (Areas)"
	access = list(
		ACCESS_SECURE_ENGINEERING,
		ACCESS_TELEPORTER,
		ACCESS_AI_UPLOAD,
		ACCESS_DELEGATE,
		ACCESS_VAULT,
		ACCESS_CAPTAIN,
		ACCESS_FEDERATION,
	)

/datum/access_group/station/federation/other
	name = "Federation (Non-area)"
	access = list(
		ACCESS_CHANGE_IDS,
		ACCESS_KEYCARD_AUTH,
		ACCESS_RC_ANNOUNCE,
	)
