// Security equipment, security records, gulag item storage, secbots
#define ACCESS_SECURITY 1
/// Armory, gulag teleporter, execution chamber
#define ACCESS_ARMORY 3
///Detective's office, forensics lockers, security+medical records
#define ACCESS_FORENSICS 4
/// Medical general access
#define ACCESS_MEDICAL 5
/// Engineering area, power monitor, power flow control console
#define ACCESS_ENGINEERING 10
///APCs, EngiVend/YouTool, engineering equipment lockers
#define ACCESS_ENGINE_EQUIP 11
#define ACCESS_MAINT_TUNNELS 12
#define ACCESS_EXTERNAL_AIRLOCKS 13
#define ACCESS_CHANGE_IDS 15
#define ACCESS_AI_UPLOAD 16
#define ACCESS_TELEPORTER 17
#define ACCESS_EVA 18
/// Bridge, EVA storage windoors, gateway shutters, AI integrity restorer, comms console
#define ACCESS_FACTION_LEADER 19
#define ACCESS_CAPTAIN 20
#define ACCESS_ALL_PERSONAL_LOCKERS 21
#define ACCESS_CHAPEL_OFFICE 22
/// Faction access for Management
#define ACCESS_MANAGEMENT 23
#define ACCESS_ATMOSPHERICS 24
#define ACCESS_BAR 25
#define ACCESS_JANITOR 26
#define ACCESS_KITCHEN 28
#define ACCESS_ROBOTICS 29
#define ACCESS_CARGO 31
///Allows access to chemistry factory areas on compatible maps
#define ACCESS_HYDROPONICS 35
#define ACCESS_LIBRARY 37
#define ACCESS_LAWYER 38
#define ACCESS_CMO 40
#define ACCESS_QM 41
#define ACCESS_COURT 42
#define ACCESS_THEATRE 46
#define ACCESS_VAULT 53
#define ACCESS_CE 56
#define ACCESS_DELEGATE 57
#define ACCESS_HOS 58
/// Request console announcements
#define ACCESS_RC_ANNOUNCE 59
/// Used for events which require at least two people to confirm them
#define ACCESS_KEYCARD_AUTH 60
/// Has access to the satellite and secure tech storage.
#define ACCESS_SECURE_ENGINEERING 61
#define ACCESS_GATEWAY 62
/// For releasing minerals from the ORM
#define ACCESS_MINERAL_STOREROOM 64
/// Weapon authorization for secbots
#define ACCESS_WEAPONS 66
/// NTnet diagnostics/monitoring software
#define ACCESS_NETWORK 67
/// Pharmacy access (Chemistry room in Medbay)
#define ACCESS_PHARMACY 69 ///Nice.
/// Room and launching.
#define ACCESS_AUX_BASE 72
/// Service access, for service hallway and service consoles
#define ACCESS_SERVICE 73

	//BEGIN CENTCOM ACCESS
	/*Should leave plenty of room if we need to add more access levels.
	Mostly for admin fun times.*/
/// General facilities. CentCom ferry.
#define ACCESS_CENT_GENERAL 101
/// Thunderdome.
#define ACCESS_CENT_THUNDER 102
/// Special Ops. Captain's display case, Marauder and Seraph mechs.
#define ACCESS_CENT_SPECOPS 103
/// Medical/Research
#define ACCESS_CENT_MEDICAL 104
/// Living quarters.
#define ACCESS_CENT_LIVING 105
/// Generic storage areas.
#define ACCESS_CENT_STORAGE 106
/// Teleporter.
#define ACCESS_CENT_TELEPORTER 107
/// Captain's office/ID comp/AI.
#define ACCESS_CENT_CAPTAIN 109
/// The non-existent CentCom Bar
#define ACCESS_CENT_BAR 110

	//The Syndicate
/// General Syndicate Access. Includes Syndicate mechs and ruins.
#define ACCESS_SYNDICATE 150
/// Nuke Op Leader Access
#define ACCESS_SYNDICATE_LEADER 151

	//Away Missions or Ruins
	/*For generic away-mission/ruin access. Why would normal crew have access to a long-abandoned derelict
	or a 2000 year-old temple? */
/// Away general facilities.
#define ACCESS_AWAY_GENERAL 200
/// Away maintenance
#define ACCESS_AWAY_MAINT 201
/// Away medical
#define ACCESS_AWAY_MED 202
/// Away security
#define ACCESS_AWAY_SEC 203
/// Away engineering
#define ACCESS_AWAY_ENGINE 204
/// Away science
#define ACCESS_AWAY_SCIENCE 205
/// Away supply
#define ACCESS_AWAY_SUPPLY 206
/// Away command
#define ACCESS_AWAY_COMMAND 207
///Away generic access
#define ACCESS_AWAY_GENERIC1 208
#define ACCESS_AWAY_GENERIC2 209
#define ACCESS_AWAY_GENERIC3 210
#define ACCESS_AWAY_GENERIC4 211

	//Special, for anything that's basically internal
#define ACCESS_BLOODCULT 250

	// Mech Access, allows maintanenace of internal components and altering keycard requirements.
#define ACCESS_MECH_MINING 300
#define ACCESS_MECH_MEDICAL 301
#define ACCESS_MECH_SECURITY 302
#define ACCESS_MECH_SCIENCE 303
#define ACCESS_MECH_ENGINE 304

/// DEPRECATED ACCESSES
#define ACCESS_ORDNANCE 999
#define ACCESS_RESEARCH 999
#define ACCESS_RD 999
#define ACCESS_XENOBIO 999
#define ACCESS_RND 999
#define ACCESS_GENETICS 999
#define ACCESS_ORDNANCE_STORAGE 999
#define ACCESS_XENOBIOLOGY 999

/// A list of access levels that, when added to an ID card, will warn admins.
#define ACCESS_ALERT_ADMINS list(ACCESS_CHANGE_IDS)

/// Logging define for ID card access changes
#define LOG_ID_ACCESS_CHANGE(user, id_card, change_description) \
	log_game("[key_name(user)] [change_description] to an ID card [(id_card.registered_name) ? "belonging to [id_card.registered_name]." : "with no registered name."]"); \
	user.investigate_log("([key_name(user)]) [change_description] to an ID card [(id_card.registered_name) ? "belonging to [id_card.registered_name]." : "with no registered name."]", INVESTIGATE_ACCESSCHANGES); \
	user.log_message("[change_description] to an ID card [(id_card.registered_name) ? "belonging to [id_card.registered_name]." : "with no registered name."]", LOG_GAME); \


/**
 * A list of PDA paths that can be painted as well as the regional heads which should be able to paint them.
 * If a PDA is not in this list, it cannot be painted using the PDA & ID Painter.
 * If a PDA is in this list, it can always be painted with ACCESS_CHANGE_IDS.
 * Used to see pda_region in [/datum/controller/subsystem/id_access/proc/setup_tgui_lists]
 */
/* PARIAH EDIT
Replaced /pda/quartermaster with /pda/heads/quartermaster and moved it closer to other command PDAs
Comment here because it really doesn't like them anywhere else here
*/
#define PDA_PAINTING_REGIONS list( \
	/obj/item/modular_computer/tablet/pda = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/clown = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/mime = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/medical = list(/datum/access_group/station/medical), \
	/obj/item/modular_computer/tablet/pda/viro = list(/datum/access_group/station/medical), \
	/obj/item/modular_computer/tablet/pda/engineering = list(/datum/access_group/station/engineering), \
	/obj/item/modular_computer/tablet/pda/security = list(/datum/access_group/station/security), \
	/obj/item/modular_computer/tablet/pda/detective = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/warden = list(/datum/access_group/station/security), \
	/obj/item/modular_computer/tablet/pda/janitor = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/heads/hop = list(/datum/access_group/station/management), \
	/obj/item/modular_computer/tablet/pda/heads/hos = list(/datum/access_group/station/management), \
	/obj/item/modular_computer/tablet/pda/heads/cmo = list(/datum/access_group/station/management), \
	/obj/item/modular_computer/tablet/pda/heads/ce = list(/datum/access_group/station/management), \
	/obj/item/modular_computer/tablet/pda/heads/rd = list(/datum/access_group/station/management), \
	/obj/item/modular_computer/tablet/pda/captain = list(/datum/access_group/station/management), \
	/obj/item/modular_computer/tablet/pda/cargo = list(/datum/access_group/station/cargo), \
	/obj/item/modular_computer/tablet/pda/shaftminer = list(/datum/access_group/station/cargo), \
	/obj/item/modular_computer/tablet/pda/chaplain = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/lawyer = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/botanist = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/roboticist = list(/datum/access_group/station/medical), \
	/obj/item/modular_computer/tablet/pda/curator = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/cook = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/bar = list(/datum/access_group/station/independent_areas), \
	/obj/item/modular_computer/tablet/pda/atmos = list(/datum/access_group/station/engineering), \
	/obj/item/modular_computer/tablet/pda/chemist = list(/datum/access_group/station/medical), \
)
