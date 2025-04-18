/datum/access_group/station/engineering
	name = "Engineering"

/datum/access_group/station/engineering/New()
	for(var/path in subtypesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/datum/access_group/station/engineering/areas
	name = "Engineering (Areas)"
	access = list(
		ACCESS_CONSTRUCTION,
		ACCESS_AUX_BASE,
		ACCESS_MAINT_TUNNELS,
		ACCESS_ENGINE,
		ACCESS_TECH_STORAGE,
		ACCESS_ATMOSPHERICS,
		ACCESS_MECH_ENGINE,
		ACCESS_TCOMSAT,
		ACCESS_MINISAT,
		ACCESS_CE,
	)

/datum/access_group/station/engineering/other
	name = "Engineering (Other)"
	access = list(
		ACCESS_ENGINE_EQUIP,
	)
