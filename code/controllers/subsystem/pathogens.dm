SUBSYSTEM_DEF(pathogens)
	name = "Pathogens"
	flags = SS_NO_FIRE

	/// A list of every symptom type.
	var/list/symptom_types

	/// A copy of every pathogen type by ID.
	var/list/archive_pathogens = list()

	/// A list of every pathogen instance currently inhabiting a mob.
	var/list/active_pathogens = list()

/datum/controller/subsystem/pathogens/PreInit()
	symptom_types = subtypesof(/datum/symptom)

/datum/controller/subsystem/pathogens/Initialize(timeofday)
	var/list/all_common_pathogens = subtypesof(/datum/pathogen) - typesof(/datum/pathogen/advance)
	for(var/common_pathogen_type in all_common_pathogens)
		var/datum/pathogen/prototype = new common_pathogen_type()
		archive_pathogens[prototype.get_id()] = prototype
	return ..()

/datum/controller/subsystem/pathogens/stat_entry(msg)
	msg = "# Diseases:[length(active_pathogens)]"
	return ..()

/datum/controller/subsystem/pathogens/proc/get_disease_name(id)
	var/datum/pathogen/advance/A = archive_pathogens[id]
	if(A.name)
		return A.name
	else
		return "Unknown"
