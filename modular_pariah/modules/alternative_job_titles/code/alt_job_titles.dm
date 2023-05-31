/**
 * This is the file you should use to add alternate titles for each job, just
 * follow the way they're done here, it's easy enough and shouldn't take any
 * time at all to add more or add some for a job that doesn't have any.
 */


/datum/job
	/// The list of alternative job titles people can pick from, null by default.
	var/list/alt_titles = null

// Heads

/datum/job/research_director
	alt_titles = list(JOB_RESEARCH_DIRECTOR, "Lead Researcher")

/datum/job/chief_engineer
	alt_titles = list(JOB_CHIEF_ENGINEER, "Engineering Foreman", "Head of Engineering")

/datum/job/chief_medical_officer
	alt_titles = list(JOB_CHIEF_MEDICAL_OFFICER, "Head of Medical", "Senior Physician")

/datum/job/head_of_personnel
	alt_titles = list(JOB_HEAD_OF_PERSONNEL, "Personnel Manager", "Crew Overseer")

/datum/job/head_of_security
	alt_titles = list(JOB_HEAD_OF_SECURITY, "Security Commander", "Chief of Security")

// Security

/datum/job/security_officer
	alt_titles = list("Security Officer", "Security Guard")

/datum/job/warden
	alt_titles = list("Warden", "Brig Officer", "Security Sergeant")

/datum/job/detective
	alt_titles = list("Detective", "Forensic Technician")

/datum/job/prisoner
	alt_titles = list("Prisoner", "Inmate")

// Medical

/datum/job/doctor
	alt_titles = list("Medical Doctor", "Surgeon", "Nurse", "Physician", "Medical Resident", "Medical Technician")

/datum/job/paramedic
	alt_titles = list("Paramedic", "Emergency Medical Technician")

/datum/job/chemist
	alt_titles = list("Chemist", "Pharmacist", "Pharmacologist")

/datum/job/virologist
	alt_titles = list("Virologist", "Pathologist", "Microbiologist")

/datum/job/psychologist
	alt_titles = list("Psychologist", "Psychiatrist", "Therapist")

// Science

/datum/job/roboticist
	alt_titles = list("Roboticist", "Biomechanical Engineer", "Mechatronic Engineer")

/datum/job/scientist
	alt_titles = list("Scientist", "Circuitry Designer", "Xenobiologist", "Cytologist", "Plasma Researcher", "Anomalist", "Ordnance Technician")

/datum/job/geneticist
	alt_titles = list("Geneticist", "Mutation Researcher")

// Engineering

/datum/job/station_engineer
	alt_titles = list("Station Engineer", "Maintenance Technician", "Electrician", "Engine Technician")

/datum/job/atmospheric_technician
	alt_titles = list("Atmospheric Technician", "Life Support Technician")

// Cargo
/datum/job/quartermaster
	alt_titles = list(JOB_QUARTERMASTER, "Deck Chief")

/datum/job/cargo_technician
	alt_titles = list("Cargo Technician", "Deck Worker", "Mailman")

/datum/job/shaft_miner
	alt_titles = list("Shaft Miner", "Prospector")

// Service

/datum/job/cook
	alt_titles = list("Cook", "Chef", "Culinary Artist")

/datum/job/bartender
	alt_titles = list("Bartender", "Mixologist", "Barkeeper")

/datum/job/botanist
	alt_titles = list("Botanist", "Hydroponicist", "Botanical Researcher")

/datum/job/curator
	alt_titles = list("Curator", "Librarian", "Journalist")

/datum/job/janitor
	alt_titles = list("Janitor", "Custodian", "Sanitation Technician")

/datum/job/chaplain
	alt_titles = list("Chaplain", "Priest", "Preacher", "Reverend", "Oracle", "Pontifex", "Magister", "High Priest", "Imam", "Rabbi", "Monk", "Counselor")

/datum/job/lawyer
	alt_titles = list("Lawyer", "Human Resources Agent", "Defence Attorney", "Public Defender", "Prosecutor")

// Misc

/datum/job/assistant
	alt_titles = list("Assistant", "Civilian", "Businessman", "Trader", "Off-Duty Crew")
