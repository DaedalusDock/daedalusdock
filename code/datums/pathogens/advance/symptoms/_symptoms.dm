// Symptoms are the effects that engineered advanced pathogens do.

/datum/symptom
	var/name = ""
	var/desc = "If you see this something went very wrong." //Basic symptom description
	///Descriptions of threshold effects
	var/threshold_descs = list()
	///How the symptom affects the pathogen's stealth stat, positive values make it less noticeable
	var/stealth = 0
	///How the symptom affects the pathogen's resistance stat, positive values make it harder to cure
	var/resistance = 0
	///How the symptom affects the pathogen's stage speed stat, positive values cause faster stage progression
	var/stage_speed = 0
	///How the symptom affects the pathogen's transmissibility
	var/transmittable = 0
	///The type level of the symptom. Higher is harder to generate.
	var/level = 0
	///The severity level of the symptom. Higher is more dangerous.
	var/severity = 0
	/// A stringified version of the type.
	VAR_FINAL/id = ""
	///Base chance of sending warning messages, so it can be modified
	var/base_message_chance = 10
	///If the early warnings are suppressed or not
	var/suppress_warning = FALSE
	///Ticks between each activation
	var/next_activation = 0
	var/symptom_delay_min = 1
	var/symptom_delay_max = 1
	///Can be used to multiply virus effects
	var/power = 1
	///A neutered symptom has no effect, and only affects statistics.
	var/neutered = FALSE
	var/list/thresholds
	///If this symptom can appear from /datum/pathogen/advance/GenerateSymptoms()
	var/naturally_occuring = TRUE

/datum/symptom/New()
	id = "[type]"

/// Update vars based on the pathogen properties.
/datum/symptom/proc/sync_properties(list/properties)
	return

///Called when processing of the advance pathogen that holds this symptom infects a host and upon each Refresh() of that advance pathogen.
/datum/symptom/proc/on_start_processing(datum/pathogen/advance/A)
	SHOULD_CALL_PARENT(TRUE)
	if(neutered)
		return FALSE
	return TRUE

/// Called when the pathogen has stopped processing, including due to deletion.
/datum/symptom/proc/on_stop_processing(datum/pathogen/advance/A)
	SHOULD_CALL_PARENT(TRUE)
	if(neutered)
		return FALSE
	return TRUE

/// Called when the symptom is added to a pathogen.
/datum/symptom/proc/on_add_to_pathogen(datum/pathogen/advance/A)
	SHOULD_CALL_PARENT(TRUE)

/// Called when the symptom is removed from a pathogen or neutered.
/datum/symptom/proc/on_remove_from_pathogen(datum/pathogen/advance/A)
	SHOULD_CALL_PARENT(TRUE)
	if(A.has_started)
		on_stop_processing(A)

/// The process handler. Returns TRUE if the pathogen could process this tick. Reschedules the next activation on success.
/datum/symptom/proc/on_process(datum/pathogen/advance/A)
	if(neutered)
		return FALSE

	if(world.time < next_activation)
		return FALSE
	else
		update_next_activation()
		return TRUE

/// Hook for handling stage changes.
/datum/symptom/proc/on_stage_change(datum/pathogen/advance/A)
	if(neutered)
		return FALSE
	return TRUE

/// Set the next activation time.
/datum/symptom/proc/update_next_activation()
	next_activation = world.time + rand(symptom_delay_min SECONDS, symptom_delay_max SECONDS)

/// Returns a new instance of the symptom.
/datum/symptom/proc/Copy()
	var/datum/symptom/new_symp = new type
	new_symp.name = name
	new_symp.neutered = neutered
	return new_symp

/datum/symptom/proc/generate_threshold_desc()
	return
