/datum/access_group/station/engineering
	name = "Engineering"

/datum/access_group/station/engineering/New()
	for(var/path in subtypesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/datum/access_group/station/engineering/areas
	name = "Engineering (Areas)"
	access = list(
		ACCESS_MAINT_TUNNELS,
		ACCESS_ENGINEERING,
		ACCESS_ATMOSPHERICS,
		ACCESS_SECURE_ENGINEERING,
		ACCESS_CE,
	)

/datum/access_group/station/engineering/other
	name = "Engineering (Other)"
	access = list(
		ACCESS_ENGINE_EQUIP,
		ACCESS_MECH_ENGINE,
		ACCESS_RC_ANNOUNCE
	)
