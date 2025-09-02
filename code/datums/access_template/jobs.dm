/**
 * This file contains all the trims associated with station jobs.
 * It also contains special prisoner trims and the miner's spare ID trim.
 */

/// ID Trims for station jobs.
/datum/access_template/job
	template_state = "trim_assistant"

	/// The extra access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is FALSE.
	var/list/extra_access = list()
	/// The base access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is TRUE.
	var/list/minimal_access = list()
	/// Static list. Cache of any mapping config job changes.
	var/static/list/job_changes
	/// What config entry relates to this job. Should be a lowercase job name with underscores for spaces, eg "prisoner" "research_director" "head_of_security"
	var/config_job
	/// An ID card with an access in this list can apply this trim to IDs or use it as a job template when adding access to a card. If the list is null, cannot be used as a template. Should be Head of Staff or ID Console accesses or it may do nothing.
	var/list/template_access
	/// The typepath to the job datum from the id_trim. This is converted to one of the job singletons in New().
	var/datum/job/job = /datum/job/unassigned

/datum/access_template/job/New()
	if(ispath(job))
		job = SSjob.GetJobType(job)

	if(isnull(job_changes))
		job_changes = SSmapping.config.job_changes

	if(!length(job_changes) || !config_job)
		refresh_template_access()
		return

	var/list/access_changes = job_changes[config_job]

	if(!length(access_changes))
		refresh_template_access()
		return

	if(islist(access_changes["additional_access"]))
		extra_access |= access_changes["additional_access"]
	if(islist(access_changes["additional_minimal_access"]))
		minimal_access |= access_changes["additional_minimal_access"]

	refresh_template_access()

/**
 * Goes through various non-map config settings and modifies the trim's access based on this.
 *
 * Returns TRUE if the config is loaded, FALSE otherwise.
 */
/datum/access_template/job/proc/refresh_template_access()
	// If there's no config loaded then assume minimal access.
	if(!config)
		access = minimal_access.Copy()
		return FALSE

	// There is a config loaded. Check for the jobs_have_minimal_access flag being set.
	if(CONFIG_GET(flag/jobs_have_minimal_access))
		access = minimal_access.Copy()
	else
		access = minimal_access | extra_access

	// If the config has global maint access set, we always want to add maint access.
	if(CONFIG_GET(flag/everyone_has_maint_access))
		access |= list(ACCESS_MAINT_TUNNELS)

	access |= ACCESS_EVA

	return TRUE

/datum/access_template/job/assistant
	assignment = JOB_ASSISTANT
	template_state = "trim_assistant"
	sechud_icon_state = SECHUD_ASSISTANT
	extra_access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list()
	config_job = "assistant"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/assistant

/datum/access_template/job/assistant/refresh_template_access()
	. = ..()

	if(!.)
		return

	// Config has assistant maint access set.
	if(CONFIG_GET(flag/assistants_have_maint_access))
		access |= list(ACCESS_MAINT_TUNNELS)

/datum/access_template/job/atmospheric_technician
	assignment = JOB_ATMOSPHERIC_TECHNICIAN
	template_state = "trim_atmospherictechnician"
	sechud_icon_state = SECHUD_ATMOSPHERIC_TECHNICIAN
	extra_access = list(ACCESS_ENGINEERING, ACCESS_ENGINE_EQUIP, ACCESS_MINERAL_STOREROOM, ACCESS_SECURE_ENGINEERING)
	minimal_access = list(ACCESS_ATMOSPHERICS, ACCESS_AUX_BASE, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE,
					ACCESS_MINERAL_STOREROOM)
	config_job = "atmospheric_technician"
	template_access = list(ACCESS_CE, ACCESS_CHANGE_IDS)
	job = /datum/job/atmospheric_technician
	datacore_record_key = DATACORE_RECORDS_DAEDALUS

/datum/access_template/job/bartender
	assignment = JOB_BARTENDER
	template_state = "trim_bartender"
	sechud_icon_state = SECHUD_BARTENDER
	extra_access = list(ACCESS_HYDROPONICS, ACCESS_KITCHEN)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE, ACCESS_WEAPONS, ACCESS_SERVICE)
	config_job = "bartender"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/bartender

/datum/access_template/job/botanist
	assignment = JOB_BOTANIST
	template_state = "trim_botanist"
	sechud_icon_state = SECHUD_BOTANIST
	extra_access = list(ACCESS_BAR, ACCESS_KITCHEN)
	minimal_access = list(ACCESS_HYDROPONICS, ACCESS_MINERAL_STOREROOM, ACCESS_SERVICE)
	config_job = "botanist"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/botanist

/datum/access_template/job/captain
	assignment = JOB_CAPTAIN
	intern_alt_name = "Subintendant"
	template_state = "trim_captain"
	sechud_icon_state = SECHUD_CAPTAIN
	config_job = "captain"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CHANGE_IDS)
	job = /datum/job/captain

/// Captain gets all station accesses hardcoded in because it's the Captain.
/datum/access_template/job/captain/New()
	extra_access |= SSid_access.get_access_for_group(/datum/access_group/station/all)
	minimal_access |= SSid_access.get_access_for_group(/datum/access_group/station/all)
	return ..()

/datum/access_template/job/cargo_technician
	assignment = JOB_DECKHAND
	template_state = "trim_cargotechnician"
	sechud_icon_state = SECHUD_CARGO_TECHNICIAN
	extra_access = list(ACCESS_QM)
	minimal_access = list(ACCESS_CARGO, ACCESS_MAINT_TUNNELS, ACCESS_MECH_MINING, ACCESS_MINERAL_STOREROOM)
	config_job = "cargo_technician"
	template_access = list(ACCESS_QM, ACCESS_CHANGE_IDS)
	job = /datum/job/cargo_technician
	datacore_record_key = DATACORE_RECORDS_HERMES

/datum/access_template/job/chaplain
	assignment = JOB_CHAPLAIN
	template_state = "trim_chaplain"
	sechud_icon_state = SECHUD_CHAPLAIN
	minimal_access = list(ACCESS_CHAPEL_OFFICE, ACCESS_THEATRE, ACCESS_SERVICE)
	config_job = "chaplain"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/chaplain

/datum/access_template/job/chemist
	assignment = JOB_CHEMIST
	template_state = "trim_chemist"
	sechud_icon_state = SECHUD_CHEMIST
	minimal_access = list(ACCESS_PHARMACY, ACCESS_MECH_MEDICAL, ACCESS_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)
	config_job = "chemist"
	template_access = list(ACCESS_CMO, ACCESS_CHANGE_IDS)
	job = /datum/job/chemist
	datacore_record_key = DATACORE_RECORDS_AETHER

/datum/access_template/job/chief_engineer
	assignment = JOB_CHIEF_ENGINEER
	intern_alt_name = JOB_CHIEF_ENGINEER + "-in-Training"
	template_state = "trim_chiefengineer"
	sechud_icon_state = SECHUD_CHIEF_ENGINEER
	extra_access = list(ACCESS_TELEPORTER)
	minimal_access = list(ACCESS_ATMOSPHERICS, ACCESS_AUX_BASE, ACCESS_CE, ACCESS_ENGINEERING, ACCESS_ENGINE_EQUIP, ACCESS_EVA,
					ACCESS_EXTERNAL_AIRLOCKS, ACCESS_KEYCARD_AUTH, ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE,
					ACCESS_MINERAL_STOREROOM, ACCESS_RC_ANNOUNCE, ACCESS_SECURE_ENGINEERING)
	config_job = "chief_engineer"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CHANGE_IDS)
	job = /datum/job/chief_engineer
	datacore_record_key = DATACORE_RECORDS_DAEDALUS

/datum/access_template/job/chief_medical_officer
	assignment = JOB_AUGUR
	intern_alt_name = "Registered Augur"
	template_state = "trim_chiefmedicalofficer"
	sechud_icon_state = SECHUD_CHIEF_MEDICAL_OFFICER
	extra_access = list(ACCESS_TELEPORTER)
	minimal_access = list(
		ACCESS_CMO, ACCESS_EVA, ACCESS_KEYCARD_AUTH, ACCESS_MAINT_TUNNELS, ACCESS_MECH_MEDICAL,
		ACCESS_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY, ACCESS_RC_ANNOUNCE,
		ACCESS_ROBOTICS
	)
	config_job = "chief_medical_officer"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CHANGE_IDS)
	job = /datum/job/augur
	datacore_record_key = DATACORE_RECORDS_AETHER

/datum/access_template/job/clown
	assignment = JOB_CLOWN
	template_state = "trim_clown"
	sechud_icon_state = SECHUD_CLOWN
	extra_access = list()
	minimal_access = list(ACCESS_THEATRE, ACCESS_SERVICE)
	config_job = "clown"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/clown

/datum/access_template/job/cook
	assignment = JOB_COOK
	template_state = "trim_cook"
	sechud_icon_state = SECHUD_COOK
	extra_access = list(ACCESS_BAR, ACCESS_HYDROPONICS)
	minimal_access = list(ACCESS_KITCHEN, ACCESS_MINERAL_STOREROOM, ACCESS_SERVICE)
	config_job = "cook"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/cook

/datum/access_template/job/cook/chef
	assignment = "Chef"
	sechud_icon_state = SECHUD_CHEF

/datum/access_template/job/curator
	assignment = JOB_ARCHIVIST
	template_state = "trim_curator"
	sechud_icon_state = SECHUD_CURATOR
	extra_access = list()
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_LIBRARY, ACCESS_SERVICE)
	config_job = "curator"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/curator

/datum/access_template/job/detective
	assignment = JOB_DETECTIVE
	template_state = "trim_detective"
	sechud_icon_state = SECHUD_DETECTIVE
	extra_access = list()
	minimal_access = list(
		ACCESS_FORENSICS,
		ACCESS_MAINT_TUNNELS,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_WEAPONS
	)
	config_job = "detective"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/detective

/datum/access_template/job/detective/refresh_template_access()
	. = ..()

	if(!.)
		return

	// Config check for if sec has maint access.
	if(CONFIG_GET(flag/security_has_maint_access))
		access |= list(ACCESS_MAINT_TUNNELS)

/datum/access_template/job/head_of_personnel
	assignment = JOB_HEAD_OF_PERSONNEL
	intern_alt_name = JOB_HEAD_OF_PERSONNEL + "-in-Training"
	template_state = "trim_headofpersonnel"
	sechud_icon_state = SECHUD_HEAD_OF_PERSONNEL
	extra_access = list()
	minimal_access = list(ACCESS_AI_UPLOAD, ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_AUX_BASE, ACCESS_BAR, ACCESS_CHAPEL_OFFICE,
					ACCESS_CHANGE_IDS, ACCESS_COURT, ACCESS_ENGINEERING, ACCESS_EVA,
					ACCESS_DELEGATE, ACCESS_HYDROPONICS, ACCESS_JANITOR, ACCESS_KEYCARD_AUTH, ACCESS_KITCHEN, ACCESS_LAWYER, ACCESS_LIBRARY,
					ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE, ACCESS_MECH_MEDICAL, ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY, ACCESS_MEDICAL,
					ACCESS_RC_ANNOUNCE, ACCESS_RESEARCH, ACCESS_TELEPORTER,
					ACCESS_THEATRE, ACCESS_VAULT, ACCESS_WEAPONS, ACCESS_FACTION_LEADER, ACCESS_MANAGEMENT)
	config_job = "head_of_personnel"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CHANGE_IDS)
	job = /datum/job/head_of_personnel

/datum/access_template/job/head_of_security
	assignment = JOB_SECURITY_MARSHAL
	intern_alt_name = JOB_SECURITY_MARSHAL + "-in-Training"
	template_state = "trim_headofsecurity"
	sechud_icon_state = SECHUD_HEAD_OF_SECURITY
	extra_access = list(ACCESS_TELEPORTER)
	minimal_access = list(ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_ARMORY, ACCESS_AUX_BASE, ACCESS_COURT,
					ACCESS_ENGINEERING, ACCESS_EVA, ACCESS_FORENSICS, ACCESS_HOS, ACCESS_KEYCARD_AUTH,
					ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MEDICAL, ACCESS_RC_ANNOUNCE,
					ACCESS_RESEARCH, ACCESS_SECURITY, ACCESS_WEAPONS, ACCESS_FACTION_LEADER, ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MANAGEMENT)
	config_job = "head_of_security"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CHANGE_IDS)
	job = /datum/job/head_of_security
	datacore_record_key = DATACORE_RECORDS_MARS

/datum/access_template/job/head_of_security/refresh_template_access()
	. = ..()

	if(!.)
		return

	// Config check for if sec has maint access.
	if(CONFIG_GET(flag/security_has_maint_access))
		access |= list(ACCESS_MAINT_TUNNELS)

/datum/access_template/job/janitor
	assignment = JOB_JANITOR
	template_state = "trim_janitor"
	sechud_icon_state = SECHUD_JANITOR
	extra_access = list()
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM, ACCESS_SERVICE)
	config_job = "janitor"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/janitor

/datum/access_template/job/lawyer
	assignment = JOB_LAWYER
	template_state = "trim_lawyer"
	sechud_icon_state = SECHUD_LAWYER
	extra_access = list()
	minimal_access = list(ACCESS_COURT, ACCESS_LAWYER, ACCESS_SERVICE)
	config_job = "lawyer"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/lawyer

/datum/access_template/job/medical_doctor
	assignment = JOB_ACOLYTE
	template_state = "trim_medicaldoctor"
	sechud_icon_state = SECHUD_MEDICAL_DOCTOR
	extra_access = list(ACCESS_ROBOTICS)
	minimal_access = list(ACCESS_MECH_MEDICAL, ACCESS_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)
	config_job = "medical_doctor"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CMO, ACCESS_CHANGE_IDS)
	job = /datum/job/acolyte
	datacore_record_key = DATACORE_RECORDS_AETHER

/datum/access_template/job/mime
	assignment = JOB_CLOWN
	template_state = "trim_mime"
	sechud_icon_state = SECHUD_MIME
	extra_access = list()
	minimal_access = list(ACCESS_THEATRE, ACCESS_SERVICE)
	config_job = "mime"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/clown

/datum/access_template/job/paramedic
	assignment = JOB_PARAMEDIC
	template_state = "trim_paramedic"
	sechud_icon_state = SECHUD_PARAMEDIC
	minimal_access = list(ACCESS_HYDROPONICS, ACCESS_MAINT_TUNNELS, ACCESS_MECH_MEDICAL,
					ACCESS_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH)
	config_job = "paramedic"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CMO, ACCESS_CHANGE_IDS)
	job = /datum/job/paramedic
	datacore_record_key = DATACORE_RECORDS_AETHER

/datum/access_template/job/prisoner
	assignment = JOB_PRISONER
	template_state = "trim_prisoner"
	sechud_icon_state = SECHUD_PRISONER
	config_job = "prisoner"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/prisoner
	datacore_record_key = DATACORE_RECORDS_MARS

/datum/access_template/job/prisoner/one
	template_state = "trim_prisoner_1"
	template_access = null

/datum/access_template/job/prisoner/two
	template_state = "trim_prisoner_2"
	template_access = null

/datum/access_template/job/prisoner/three
	template_state = "trim_prisoner_3"
	template_access = null

/datum/access_template/job/prisoner/four
	template_state = "trim_prisoner_4"
	template_access = null

/datum/access_template/job/prisoner/five
	template_state = "trim_prisoner_5"
	template_access = null

/datum/access_template/job/prisoner/six
	template_state = "trim_prisoner_6"
	template_access = null

/datum/access_template/job/prisoner/seven
	template_state = "trim_prisoner_7"
	template_access = null

/datum/access_template/job/psychologist
	assignment = JOB_PSYCHOLOGIST
	template_state = "trim_psychologist"
	sechud_icon_state = SECHUD_PSYCHOLOGIST
	extra_access = list()
	minimal_access = list(ACCESS_MEDICAL, ACCESS_SERVICE)
	config_job = "psychologist"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CMO, ACCESS_CHANGE_IDS)
	job = /datum/job/psychologist
	datacore_record_key = DATACORE_RECORDS_AETHER

/datum/access_template/job/quartermaster
	assignment = JOB_QUARTERMASTER
	template_state = "trim_quartermaster"
	sechud_icon_state = SECHUD_QUARTERMASTER
	extra_access = list()
	minimal_access = list(ACCESS_CARGO, ACCESS_KEYCARD_AUTH, ACCESS_MAINT_TUNNELS, ACCESS_MECH_MINING,
					ACCESS_MINERAL_STOREROOM, ACCESS_QM, ACCESS_RC_ANNOUNCE, ACCESS_VAULT)
	config_job = "quartermaster"
	template_access = list(ACCESS_CAPTAIN, ACCESS_DELEGATE, ACCESS_CHANGE_IDS)
	job = /datum/job/quartermaster
	datacore_record_key = DATACORE_RECORDS_HERMES

/// Sec officers have departmental variants. They each have their own trims with bonus departmental accesses.
/datum/access_template/job/security_officer
	assignment = JOB_SECURITY_OFFICER
	template_state = "trim_securityofficer"
	sechud_icon_state = SECHUD_SECURITY_OFFICER
	extra_access = list(ACCESS_FORENSICS, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_COURT, ACCESS_SECURITY, ACCESS_MECH_SECURITY,
					ACCESS_MINERAL_STOREROOM, ACCESS_WEAPONS)
	/// List of bonus departmental accesses that departmental sec officers get.
	var/department_access = list()
	config_job = "security_officer"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/security_officer
	datacore_record_key = DATACORE_RECORDS_MARS

/datum/access_template/job/security_officer/refresh_template_access()
	. = ..()

	if(!.)
		return

	// Config check for if sec has maint access.
	if(CONFIG_GET(flag/security_has_maint_access))
		access |= list(ACCESS_MAINT_TUNNELS)

	access |= department_access

/datum/access_template/job/shaft_miner
	assignment = JOB_PROSPECTOR
	template_state = "trim_shaftminer"
	sechud_icon_state = SECHUD_SHAFT_MINER
	extra_access = list(ACCESS_MAINT_TUNNELS, ACCESS_QM)
	minimal_access = list(ACCESS_CARGO, ACCESS_AUX_BASE, ACCESS_MECH_MINING, ACCESS_MINERAL_STOREROOM)
	config_job = "shaft_miner"
	template_access = list(ACCESS_QM, ACCESS_CHANGE_IDS)
	job = /datum/job/shaft_miner
	datacore_record_key = DATACORE_RECORDS_HERMES

/// ID card obtained from the mining Disney dollar points vending machine.
/datum/access_template/job/shaft_miner/spare
	extra_access = list()
	minimal_access = list(ACCESS_MECH_MINING, ACCESS_MINERAL_STOREROOM)
	template_access = null

/datum/access_template/job/station_engineer
	assignment = JOB_STATION_ENGINEER
	template_state = "trim_stationengineer"
	sechud_icon_state = SECHUD_STATION_ENGINEER
	extra_access = list(ACCESS_ATMOSPHERICS)
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_ENGINEERING, ACCESS_ENGINE_EQUIP, ACCESS_EXTERNAL_AIRLOCKS,
					ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE, ACCESS_MINERAL_STOREROOM, ACCESS_SECURE_ENGINEERING)
	config_job = "station_engineer"
	template_access = list(ACCESS_CE, ACCESS_CHANGE_IDS)
	job = /datum/job/station_engineer
	datacore_record_key = DATACORE_RECORDS_DAEDALUS

/datum/access_template/job/virologist
	assignment = JOB_VIROLOGIST
	template_state = "trim_virologist"
	sechud_icon_state = SECHUD_VIROLOGIST
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	config_job = "virologist"
	template_access = list(ACCESS_CMO, ACCESS_CHANGE_IDS)
	job = /datum/job/virologist
	datacore_record_key = DATACORE_RECORDS_AETHER

/datum/access_template/job/warden
	assignment = JOB_WARDEN
	template_state = "trim_warden"
	sechud_icon_state = SECHUD_WARDEN
	extra_access = list(ACCESS_FORENSICS, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_ARMORY, ACCESS_COURT, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM,
					ACCESS_SECURITY, ACCESS_WEAPONS) // See /datum/job/warden/get_access()
	config_job = "warden"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/warden
	datacore_record_key = DATACORE_RECORDS_MARS

/datum/access_template/job/warden/refresh_template_access()
	. = ..()

	if(!.)
		return

	// Config check for if sec has maint access.
	if(CONFIG_GET(flag/security_has_maint_access))
		access |= list(ACCESS_MAINT_TUNNELS)
