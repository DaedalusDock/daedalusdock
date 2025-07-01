/*
 * THIS FILE IS INTENTIONALLY NOT INCLUDED, IT IS MANUALLY INCLUDED BY helper_defines.dm
 */

// -------------------- Command access helpers
MAKE_ABSTRACT(command, "access_helper_com")

MAKE_REAL(command/general, ACCESS_MANAGEMENT)
MAKE_REAL(command/ai_upload, ACCESS_AI_UPLOAD)
MAKE_REAL(command/teleporter, ACCESS_TELEPORTER)
MAKE_REAL(command/eva, ACCESS_EVA)
MAKE_REAL(command/hop, ACCESS_DELEGATE)
MAKE_REAL(command/captain, ACCESS_CAPTAIN)

// -------------------- Engineering access helpers
MAKE_ABSTRACT(engineering, "access_helper_eng")

MAKE_REAL(engineering/general, ACCESS_ENGINEERING)
MAKE_REAL(engineering/engine_equipment, ACCESS_ENGINE_EQUIP)
MAKE_REAL(engineering/aux_base, ACCESS_AUX_BASE)
MAKE_REAL(engineering/maintenance, ACCESS_MAINT_TUNNELS)
MAKE_REAL(engineering/external, ACCESS_EXTERNAL_AIRLOCKS)
MAKE_REAL(engineering/secure, ACCESS_SECURE_ENGINEERING)
MAKE_REAL(engineering/atmos, ACCESS_ATMOSPHERICS)
MAKE_REAL(engineering/ce, ACCESS_CE)

// -------------------- Medical access helpers
MAKE_ABSTRACT(medical, "access_helper_med")

MAKE_REAL(medical/general, ACCESS_MEDICAL)
MAKE_REAL(medical/chemistry, ACCESS_PHARMACY)
MAKE_REAL(medical/cmo, ACCESS_CMO)
MAKE_REAL(medical/pharmacy, ACCESS_PHARMACY)

// -------------------- Science access helpers
MAKE_ABSTRACT(science, "access_helper_sci")

MAKE_REAL(science/general, ACCESS_RND)
MAKE_REAL(science/research, ACCESS_RESEARCH)
MAKE_REAL(science/ordnance, ACCESS_ORDNANCE)
MAKE_REAL(science/ordnance_storage, ACCESS_ORDNANCE_STORAGE)
MAKE_REAL(science/genetics, ACCESS_GENETICS)
MAKE_REAL(science/robotics, ACCESS_ROBOTICS)
MAKE_REAL(science/xenobio, ACCESS_XENOBIOLOGY)
MAKE_REAL(science/rd, ACCESS_RD)

// -------------------- Security access helpers
MAKE_ABSTRACT(security, "access_helper_sec")

MAKE_REAL(security/general, ACCESS_SECURITY)
MAKE_REAL(security/armory, ACCESS_ARMORY)
MAKE_REAL(security/detective, ACCESS_FORENSICS)
MAKE_REAL(security/court, ACCESS_COURT)
MAKE_REAL(security/hos, ACCESS_HOS)

// -------------------- Service access helpers
MAKE_ABSTRACT(service, "access_helper_serv")

MAKE_REAL(service/general, ACCESS_SERVICE)
MAKE_REAL(service/kitchen, ACCESS_KITCHEN)
MAKE_REAL(service/bar, ACCESS_BAR)
MAKE_REAL(service/hydroponics, ACCESS_HYDROPONICS)
MAKE_REAL(service/janitor, ACCESS_JANITOR)
MAKE_REAL(service/chapel_office, ACCESS_CHAPEL_OFFICE)
MAKE_REAL(service/library, ACCESS_LIBRARY)
MAKE_REAL(service/theatre, ACCESS_THEATRE)
MAKE_REAL(service/lawyer, ACCESS_LAWYER)

// -------------------- Supply access helpers
MAKE_ABSTRACT(supply, "access_helper_sup")

MAKE_REAL(supply/general, ACCESS_CARGO)
MAKE_REAL(supply/mineral_storage, ACCESS_MINERAL_STOREROOM)
MAKE_REAL(supply/qm, ACCESS_QM)
MAKE_REAL(supply/vault, ACCESS_VAULT)

// -------------------- Syndicate access helpers
MAKE_ABSTRACT(syndicate, "access_helper_syn")

MAKE_REAL(syndicate/general, ACCESS_SYNDICATE)
MAKE_REAL(syndicate/leader, ACCESS_SYNDICATE_LEADER)

// -------------------- Away access helpers
MAKE_ABSTRACT(away, "access_helper_awy")

MAKE_REAL(away/general, ACCESS_AWAY_GENERAL)
MAKE_REAL(away/command, ACCESS_AWAY_COMMAND)
MAKE_REAL(away/security, ACCESS_AWAY_SEC)
MAKE_REAL(away/engineering, ACCESS_AWAY_ENGINE)
MAKE_REAL(away/medical, ACCESS_AWAY_MED)
MAKE_REAL(away/supply, ACCESS_AWAY_SUPPLY)
MAKE_REAL(away/science, ACCESS_AWAY_SCIENCE)
MAKE_REAL(away/maintenance, ACCESS_AWAY_MAINT)
MAKE_REAL(away/generic1, ACCESS_AWAY_GENERIC1)
MAKE_REAL(away/generic2, ACCESS_AWAY_GENERIC2)
MAKE_REAL(away/generic3, ACCESS_AWAY_GENERIC3)
MAKE_REAL(away/generic4, ACCESS_AWAY_GENERIC4)

// -------------------- Admin access helpers
MAKE_ABSTRACT(admin, "access_helper_adm")

MAKE_REAL(admin/general, ACCESS_CENT_GENERAL)
MAKE_REAL(admin/thunderdome, ACCESS_CENT_THUNDER)
MAKE_REAL(admin/medical, ACCESS_CENT_MEDICAL)
MAKE_REAL(admin/living, ACCESS_CENT_LIVING)
MAKE_REAL(admin/storage, ACCESS_CENT_STORAGE)
MAKE_REAL(admin/teleporter, ACCESS_CENT_TELEPORTER)
MAKE_REAL(admin/captain, ACCESS_CENT_CAPTAIN)
MAKE_REAL(admin/bar, ACCESS_CENT_BAR)
