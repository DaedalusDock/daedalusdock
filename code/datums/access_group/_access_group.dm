/datum/access_group
	var/name = "UNNAMED GROUP"
	var/list/access = list()

/// Baseline access IDs should have.
/datum/access_group/baseline
	name = "Baseline"
	access = list()

/datum/access_group/baseline/New()
	if(CONFIG_GET(flag/everyone_has_maint_access))
		access |= ACCESS_MAINT_TUNNELS

/datum/access_group/all
	name = "All"

/datum/access_group/all/New()
	for(var/path in subtypesof(/datum/access_group) - type)
		var/datum/access_group/group = new path

		access |= group.access
