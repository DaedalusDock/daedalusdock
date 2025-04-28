/datum/access_group/station/cargo
	name = "Cargo Bay"

/datum/access_group/station/cargo/New()
	for(var/path in subtypesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/datum/access_group/station/cargo/areas
	name = "Cargo Bay (Areas)"
	access = list(
		ACCESS_CARGO,
		ACCESS_QM,
	)

/datum/access_group/station/cargo/other
	name = "Cargo Bay (Other)"
	access = list(
		ACCESS_MECH_MINING,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_RC_ANNOUNCE,
	)
