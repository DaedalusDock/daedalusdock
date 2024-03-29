///Dummy mob reserve slot for manifest
#define DUMMY_HUMAN_SLOT_MANIFEST "dummy_manifest_generation"

GLOBAL_DATUM_INIT(datacore, /datum/datacore, new)

//TODO: someone please get rid of this shit
/datum/datacore
	var/list/datum/data/record/medical/medical = list()
	var/list/datum/data/record/general/general = list()
	var/list/datum/data/record/security/security = list()

	var/list/datum/data/record/medical/medical_by_name = list()
	var/list/datum/data/record/general/general_by_name = list()
	var/list/datum/data/record/security/security_by_name = list()

	///This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/list/locked = list()
	var/list/locked_by_name = list()

	var/securityPrintCount = 0
	var/securityCrimeCounter = 0
	var/medicalPrintCount = 0

	/// Set to TRUE when the initial roundstart manifest is complete
	var/finished_setup = FALSE

/// Inject an existing record datum into the datacore.
/datum/datacore/proc/inject_record(datum/data/record/new_record, record_type)
	if(!istype(new_record))
		CRASH("You fucked it this time!!!")

	if(!new_record.fields["name"])
		CRASH("Cannot inject a record with no name!")

	var/list/inject_to
	var/list/inject_name
	switch(record_type)
		if(DATACORE_RECORDS_GENERAL)
			inject_to = general
			inject_name = general_by_name
		if(DATACORE_RECORDS_SECURITY)
			inject_to = security
			inject_name = security_by_name
		if(DATACORE_RECORDS_MEDICAL)
			inject_to = medical
			inject_name = medical_by_name
		if(DATACORE_RECORDS_LOCKED)
			inject_to = locked
			inject_name = locked_by_name

	inject_to += new_record
	inject_name[new_record.fields["name"]] = new_record

/// Returns a data record or null.
/datum/datacore/proc/get_record_by_name(name, record_type = DATACORE_RECORDS_GENERAL)
	RETURN_TYPE(/datum/data/record)
	var/list/to_search

	switch(record_type)
		if(DATACORE_RECORDS_GENERAL)
			to_search = general_by_name
		if(DATACORE_RECORDS_SECURITY)
			to_search = security_by_name
		if(DATACORE_RECORDS_MEDICAL)
			to_search = medical_by_name
		if(DATACORE_RECORDS_LOCKED)
			to_search = locked_by_name

	return to_search[name]

/// Create the roundstart manifest using the newplayer list.
/datum/datacore/proc/manifest()
	for(var/mob/dead/new_player/N as anything in GLOB.new_player_list)
		if(N.new_character)
			log_manifest(N.ckey,N.new_character.mind,N.new_character)

		if(ishuman(N.new_character))
			manifest_inject(N.new_character, N.client)

		CHECK_TICK

	finished_setup = TRUE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_DATACORE_READY, src)

/datum/datacore/proc/manifest_modify(name, assignment, trim)
	var/datum/data/record/foundrecord = get_record_by_name(name, DATACORE_RECORDS_GENERAL)
	if(foundrecord)
		foundrecord.fields[DATACORE_RANK] = assignment
		foundrecord.fields[DATACORE_TRIM] = trim

/datum/datacore/proc/get_manifest()
	// First we build up the order in which we want the departments to appear in.
	var/list/manifest_out = list()
	for(var/datum/job_department/department as anything in SSjob.joinable_departments)
		manifest_out[department.department_name] = list()
	manifest_out[DEPARTMENT_UNASSIGNED] = list()

	var/list/departments_by_type = SSjob.joinable_departments_by_type
	for(var/datum/data/record/record as anything in GLOB.datacore.general)
		var/name = record.fields[DATACORE_NAME]
		var/rank = record.fields[DATACORE_RANK] // user-visible job
		var/trim = record.fields[DATACORE_TRIM] // internal jobs by trim type
		var/datum/job/job = SSjob.GetJob(trim)
		if(!job || !(job.job_flags & JOB_CREW_MANIFEST) || !LAZYLEN(job.departments_list)) // In case an unlawful custom rank is added.
			var/list/misc_list = manifest_out[DEPARTMENT_UNASSIGNED]
			misc_list[++misc_list.len] = list(
				"name" = name,
				"rank" = rank,
				"trim" = trim,
				)
			continue
		for(var/department_type as anything in job.departments_list)
			var/datum/job_department/department = departments_by_type[department_type]
			if(!department)
				stack_trace("get_manifest() failed to get job department for [department_type] of [job.type]")
				continue
			var/list/entry = list(
				"name" = name,
				"rank" = rank,
				"trim" = trim,
				)
			var/list/department_list = manifest_out[department.department_name]
			if(istype(job, department.department_head))
				department_list.Insert(1, null)
				department_list[1] = entry
			else
				department_list[++department_list.len] = entry

	// Trim the empty categories.
	for (var/department in manifest_out)
		if(!length(manifest_out[department]))
			manifest_out -= department

	return manifest_out

/datum/datacore/proc/get_manifest_html(monochrome = FALSE)
	var/list/manifest = get_manifest()
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"#DEF; background-color:white; color:black"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #48C; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: #488;"] }
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #DEF"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th></tr>
	"}
	for(var/department in manifest)
		var/list/entries = manifest[department]
		dat += "<tr><th colspan=3>[department]</th></tr>"
		//JUST
		var/even = FALSE
		for(var/entry in entries)
			var/list/entry_list = entry
			dat += "<tr[even ? " class='alt'" : ""]><td>[entry_list["name"]]</td><td>[entry_list["rank"] == entry_list["trim"] ? entry_list["rank"] : "[entry_list["rank"]] ([entry_list["trim"]])"]</td></tr>"
			even = !even

	dat += "</table>"
	dat = replacetext(dat, "\n", "")
	dat = replacetext(dat, "\t", "")
	return dat

/datum/datacore/proc/manifest_inject(mob/living/carbon/human/H, client/C)
	SHOULD_NOT_SLEEP(TRUE)
	var/static/list/show_directions = list(SOUTH, WEST)
	if(!(H.mind?.assigned_role.job_flags & JOB_CREW_MANIFEST))
		return

	var/assignment = H.mind.assigned_role.title
	//PARIAH EDIT ADDITION
	// The alt job title, if user picked one, or the default
	var/chosen_assignment = C?.prefs.alt_job_titles[assignment] || assignment
	//PARIAH EDIT END

	var/static/record_id_num = 1001
	var/id = num2hex(record_id_num++,6)
	if(!C)
		C = H.client

	var/mutable_appearance/character_appearance = new(H.appearance)

	//General Record
	var/datum/data/record/general/G = new()
	G.fields[DATACORE_ID] = id

	G.fields[DATACORE_NAME] = H.real_name
	G.fields[DATACORE_RANK] = chosen_assignment //PARIAH EDIT
	G.fields[DATACORE_TRIM] = assignment
	G.fields[DATACORE_INITIAL_RANK] = assignment
	G.fields[DATACORE_AGE] = H.age
	G.fields[DATACORE_SPECIES] = H.dna.species.name
	G.fields[DATACORE_FINGERPRINT] = H.get_fingerprints(TRUE)
	G.fields[DATACORE_PHYSICAL_HEALTH] = "Active"
	G.fields[DATACORE_MENTAL_HEALTH] = "Stable"
	G.fields[DATACORE_GENDER] = H.gender
	if(H.gender == "male")
		G.fields[DATACORE_GENDER] = "Male"
	else if(H.gender == "female")
		G.fields[DATACORE_GENDER] = "Female"
	else
		G.fields[DATACORE_GENDER] = "Other"
	G.fields[DATACORE_APPEARANCE] = character_appearance
	general_by_name[G.fields[DATACORE_NAME]] = G
	general += G

	//Medical Record
	var/datum/data/record/medical/M = new()
	M.fields[DATACORE_ID] = id
	M.fields[DATACORE_NAME] = H.real_name
	M.fields[DATACORE_BLOOD_TYPE] = H.dna.blood_type.name
	M.fields[DATACORE_BLOOD_DNA] = H.dna.unique_enzymes
	M.fields["mi_dis"] = H.get_quirk_string(!medical, CAT_QUIRK_MINOR_DISABILITY)
	M.fields["mi_dis_d"] = H.get_quirk_string(medical, CAT_QUIRK_MINOR_DISABILITY)
	M.fields["ma_dis"] = H.get_quirk_string(!medical, CAT_QUIRK_MAJOR_DISABILITY)
	M.fields["ma_dis_d"] = H.get_quirk_string(medical, CAT_QUIRK_MAJOR_DISABILITY)
	M.fields[DATACORE_DISEASES] = "None"
	M.fields[DATACORE_DISEASES_DETAILS] = "No diseases have been diagnosed at the moment."
	M.fields[DATACORE_NOTES] = H.get_quirk_string(!medical, CAT_QUIRK_NOTES)
	M.fields[DATACORE_NOTES_DETAILS] = H.get_quirk_string(medical, CAT_QUIRK_NOTES)
	medical_by_name[M.fields[DATACORE_NAME]] = M
	medical += M

	//Security Record
	var/datum/data/record/security/S = new()
	S.fields[DATACORE_ID] = id
	S.fields[DATACORE_NAME] = H.real_name
	S.fields[DATACORE_CRIMINAL_STATUS] = CRIMINAL_NONE
	S.fields[DATACORE_CITATIONS] = list()
	S.fields[DATACORE_CRIMES] = list()
	S.fields[DATACORE_NOTES] = "No notes."
	security_by_name[S.fields[DATACORE_NAME]] = S
	security += S

	//Locked Record
	var/datum/data/record/locked/L = new()
	L.fields[DATACORE_ID] = id
	L.fields[DATACORE_NAME] = H.real_name
	// L.fields[DATACORE_RANK] = assignment //ORIGINAL
	L.fields[DATACORE_RANK] = chosen_assignment  //PARIAH EDIT
	L.fields[DATACORE_TRIM] = assignment
	G.fields[DATACORE_INITIAL_RANK] = assignment
	L.fields[DATACORE_AGE] = H.age
	L.fields[DATACORE_GENDER] = H.gender
	if(H.gender == "male")
		G.fields[DATACORE_GENDER] = "Male"
	else if(H.gender == "female")
		G.fields[DATACORE_GENDER] = "Female"
	else
		G.fields[DATACORE_GENDER] = "Other"
	L.fields[DATACORE_BLOOD_TYPE] = H.dna.blood_type
	L.fields[DATACORE_BLOOD_DNA] = H.dna.unique_enzymes
	L.fields[DATACORE_DNA_IDENTITY] = H.dna.unique_identity
	L.fields[DATACORE_SPECIES] = H.dna.species.type
	L.fields[DATACORE_DNA_FEATURES] = H.dna.features
	L.fields[DATACORE_APPEARANCE] = character_appearance
	L.fields[DATACORE_MINDREF] = H.mind
	locked += L
	locked_by_name[L.fields[DATACORE_NAME]] = L

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MANIFEST_INJECT, G, M, S, L)
	return

/**
 * Supporing proc for getting general records
 * and using them as pAI ui data. This gets
 * medical information - or what I would deem
 * medical information - and sends it as a list.
 *
 * @return - list(general_records_out)
 */
/datum/datacore/proc/get_general_records()
	if(!GLOB.datacore.general)
		return list()
	/// The array of records
	var/list/general_records_out = list()
	for(var/datum/data/record/gen_record as anything in GLOB.datacore.general)
		/// The object containing the crew info
		var/list/crew_record = list()
		crew_record["ref"] = REF(gen_record)
		crew_record["name"] = gen_record.fields[DATACORE_NAME]
		crew_record["physical_health"] = gen_record.fields[DATACORE_PHYSICAL_HEALTH]
		crew_record["mental_health"] = gen_record.fields[DATACORE_MENTAL_HEALTH]
		general_records_out += list(crew_record)
	return general_records_out

/**
 * Supporing proc for getting secrurity records
 * and using them as pAI ui data. Sends it as a
 * list.
 *
 * @return - list(security_records_out)
 */
/datum/datacore/proc/get_security_records()
	if(!GLOB.datacore.security)
		return list()
	/// The array of records
	var/list/security_records_out = list()
	for(var/datum/data/record/sec_record as anything in GLOB.datacore.security)
		/// The object containing the crew info
		var/list/crew_record = list()
		crew_record["ref"] = REF(sec_record)
		crew_record["name"] = sec_record.fields[DATACORE_NAME]
		crew_record["status"] = sec_record.fields[DATACORE_CRIMINAL_STATUS] // wanted status
		crew_record["crimes"] = length(sec_record.fields[DATACORE_CRIMES])
		security_records_out += list(crew_record)
	return security_records_out

/// Creates a new crime entry and hands it back.
/datum/datacore/proc/new_crime_entry(cname = "", cdetails = "", author = "", time = "", fine = 0)
	var/datum/data/crime/c = new /datum/data/crime
	c.crimeName = cname
	c.crimeDetails = cdetails
	c.author = author
	c.time = time
	c.fine = fine
	c.paid = 0
	c.dataId = ++securityCrimeCounter
	return c

#undef DUMMY_HUMAN_SLOT_MANIFEST
