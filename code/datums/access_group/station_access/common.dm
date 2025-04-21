/// All of the station-related access
/datum/access_group/station/all
	name = "Station (All)"

/datum/access_group/station/all/New()
	for(var/path in subtypesof(/datum/access_group/station) - typesof(type))
		var/datum/access_group/group = new path

		access |= group.access

/// Departmental/general/common area accesses.
/datum/access_group/station/common_areas
	name = "Station Common"
	access = list( \
		ACCESS_MECH_MINING, \
		ACCESS_MECH_MEDICAL, \
		ACCESS_MECH_SECURITY, \
		ACCESS_MECH_SCIENCE, \
		ACCESS_MECH_ENGINE, \
		ACCESS_AUX_BASE, \
		ACCESS_PSYCHOLOGY, \
		ACCESS_PHARMACY, \
		ACCESS_NETWORK, \
		ACCESS_MINERAL_STOREROOM, \
		ACCESS_BRIG_ENTRANCE, \
		ACCESS_XENOBIOLOGY, \
		ACCESS_MINING_STATION, \
		ACCESS_MAILSORTING, \
		ACCESS_MINING, \
		ACCESS_RESEARCH, \
		ACCESS_THEATRE, \
		ACCESS_SURGERY, \
		ACCESS_COURT, \
		ACCESS_VIROLOGY, \
		ACCESS_LAWYER, \
		ACCESS_LIBRARY, \
		ACCESS_HYDROPONICS, \
		ACCESS_CHEMISTRY, \
		ACCESS_CONSTRUCTION, \
		ACCESS_CARGO, \
		ACCESS_ROBOTICS, \
		ACCESS_KITCHEN, \
		ACCESS_CREMATORIUM, \
		ACCESS_JANITOR, \
		ACCESS_BAR, \
		ACCESS_CHAPEL_OFFICE, \
		ACCESS_ENGINE, \
		ACCESS_GENETICS, \
		ACCESS_RND, \
		ACCESS_MORGUE, \
		ACCESS_MEDICAL, \
		ACCESS_FORENSICS, \
		ACCESS_BRIG, \
		ACCESS_SECURITY, \
		ACCESS_ATMOSPHERICS, \
		ACCESS_ORDNANCE_STORAGE, \
		ACCESS_ORDNANCE, \
		ACCESS_SERVICE, \
		ACCESS_MAINT_TUNNELS,
	)

/// Access on the station that is not related to an area's access.
/datum/access_group/station/common_other
	name = "Other"
	access = list(
		ACCESS_ENGINE_EQUIP,
		ACCESS_EXTERNAL_AIRLOCKS,
	)


/// Faction head accesses. Does not include the Superintendant.
/datum/access_group/station/faction_heads
	name = "Faction Heads"
	access = list(
		ACCESS_HOS, \
		ACCESS_CE, \
		ACCESS_CMO, \
		ACCESS_RD, \
	)

/// Areas of the station belonging to independant groups.
/datum/access_group/station/independent_areas
	name = "Independent"
	access = list(
		ACCESS_KITCHEN,
		ACCESS_BAR,
		ACCESS_HYDROPONICS,
		ACCESS_JANITOR,
		ACCESS_CHAPEL_OFFICE,
		ACCESS_CREMATORIUM,
		ACCESS_LIBRARY,
		ACCESS_THEATRE,
		ACCESS_LAWYER,
		ACCESS_SERVICE,
	)
