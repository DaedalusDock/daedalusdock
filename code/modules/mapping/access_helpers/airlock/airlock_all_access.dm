// -------------------- Req All (Requires ALL of the given accesses to open)
// -------------------- Command access helpers
/obj/effect/mapping_helpers/airlock/access/all/command
	icon_state = "access_helper_com"

/obj/effect/mapping_helpers/airlock/access/all/command/general
	granted_all_access = list(ACCESS_MANAGEMENT)

/obj/effect/mapping_helpers/airlock/access/all/command/ai_upload
	granted_all_access = list(ACCESS_AI_UPLOAD)

/obj/effect/mapping_helpers/airlock/access/all/command/teleporter
	granted_all_access = list(ACCESS_TELEPORTER)

/obj/effect/mapping_helpers/airlock/access/all/command/eva
	granted_all_access = list(ACCESS_EVA)

/obj/effect/mapping_helpers/airlock/access/all/command/hop
	granted_all_access = list(ACCESS_DELEGATE)

/obj/effect/mapping_helpers/airlock/access/all/command/captain
	granted_all_access = list(ACCESS_CAPTAIN)

// -------------------- Engineering access helpers
/obj/effect/mapping_helpers/airlock/access/all/engineering
	icon_state = "access_helper_eng"

/obj/effect/mapping_helpers/airlock/access/all/engineering/general
	granted_all_access = list(ACCESS_ENGINEERING)

/obj/effect/mapping_helpers/airlock/access/all/engineering/engine_equipment
	granted_all_access = list(ACCESS_ENGINE_EQUIP)

/obj/effect/mapping_helpers/airlock/access/all/engineering/aux_base
	granted_all_access = list(ACCESS_AUX_BASE)

/obj/effect/mapping_helpers/airlock/access/all/engineering/maintenance
	granted_all_access = list(ACCESS_MAINT_TUNNELS)

/obj/effect/mapping_helpers/airlock/access/all/engineering/external
	granted_all_access = list(ACCESS_EXTERNAL_AIRLOCKS)

/obj/effect/mapping_helpers/airlock/access/all/engineering/secure
	granted_all_access = list(ACCESS_SECURE_ENGINEERING)

/obj/effect/mapping_helpers/airlock/access/all/engineering/atmos
	granted_all_access = list(ACCESS_ATMOSPHERICS)


/obj/effect/mapping_helpers/airlock/access/all/engineering/ce
	granted_all_access = list(ACCESS_CE)

// -------------------- Medical access helpers
/obj/effect/mapping_helpers/airlock/access/all/medical
	icon_state = "access_helper_med"

/obj/effect/mapping_helpers/airlock/access/all/medical/general
	granted_all_access = list(ACCESS_MEDICAL)

/obj/effect/mapping_helpers/airlock/access/all/medical/chemistry
	granted_all_access = list(ACCESS_PHARMACY)

/obj/effect/mapping_helpers/airlock/access/all/medical/cmo
	granted_all_access = list(ACCESS_CMO)

/obj/effect/mapping_helpers/airlock/access/all/medical/pharmacy
	granted_all_access = list(ACCESS_PHARMACY)

// -------------------- Science access helpers
/obj/effect/mapping_helpers/airlock/access/all/science
	icon_state = "access_helper_sci"

/obj/effect/mapping_helpers/airlock/access/all/science/general
	granted_all_access = list(ACCESS_RND)

/obj/effect/mapping_helpers/airlock/access/all/science/research
	granted_all_access = list(ACCESS_RESEARCH)

/obj/effect/mapping_helpers/airlock/access/all/science/ordnance
	granted_all_access = list(ACCESS_ORDNANCE)

/obj/effect/mapping_helpers/airlock/access/all/science/ordnance_storage
	granted_all_access = list(ACCESS_ORDNANCE_STORAGE)

/obj/effect/mapping_helpers/airlock/access/all/science/genetics
	granted_all_access = list(ACCESS_GENETICS)

/obj/effect/mapping_helpers/airlock/access/all/science/robotics
	granted_all_access = list(ACCESS_ROBOTICS)

/obj/effect/mapping_helpers/airlock/access/all/science/xenobio
	granted_all_access = list(ACCESS_XENOBIOLOGY)

/obj/effect/mapping_helpers/airlock/access/all/science/rd
	granted_all_access = list(ACCESS_RD)

// -------------------- Security access helpers
/obj/effect/mapping_helpers/airlock/access/all/security
	icon_state = "access_helper_sec"

/obj/effect/mapping_helpers/airlock/access/all/security/general
	granted_all_access = list(ACCESS_SECURITY)

/obj/effect/mapping_helpers/airlock/access/all/security/armory
	granted_all_access = list(ACCESS_ARMORY)

/obj/effect/mapping_helpers/airlock/access/all/security/detective
	granted_all_access = list(ACCESS_FORENSICS)

/obj/effect/mapping_helpers/airlock/access/all/security/court
	granted_all_access = list(ACCESS_COURT)

/obj/effect/mapping_helpers/airlock/access/all/security/hos
	granted_all_access = list(ACCESS_HOS)

// -------------------- Service access helpers
/obj/effect/mapping_helpers/airlock/access/all/service
	icon_state = "access_helper_serv"

/obj/effect/mapping_helpers/airlock/access/all/service/general
	granted_all_access = list(ACCESS_SERVICE)

/obj/effect/mapping_helpers/airlock/access/all/service/kitchen
	granted_all_access = list(ACCESS_KITCHEN)

/obj/effect/mapping_helpers/airlock/access/all/service/bar
	granted_all_access = list(ACCESS_BAR)

/obj/effect/mapping_helpers/airlock/access/all/service/hydroponics
	granted_all_access = list(ACCESS_HYDROPONICS)

/obj/effect/mapping_helpers/airlock/access/all/service/janitor
	granted_all_access = list(ACCESS_JANITOR)

/obj/effect/mapping_helpers/airlock/access/all/service/chapel_office
	granted_all_access = list(ACCESS_CHAPEL_OFFICE)

/obj/effect/mapping_helpers/airlock/access/all/service/library
	granted_all_access = list(ACCESS_LIBRARY)

/obj/effect/mapping_helpers/airlock/access/all/service/theatre
	granted_all_access = list(ACCESS_THEATRE)

/obj/effect/mapping_helpers/airlock/access/all/service/lawyer
	granted_all_access = list(ACCESS_LAWYER)

// -------------------- Supply access helpers
/obj/effect/mapping_helpers/airlock/access/all/supply
	icon_state = "access_helper_sup"

/obj/effect/mapping_helpers/airlock/access/all/supply/general
	granted_all_access = list(ACCESS_CARGO)

/obj/effect/mapping_helpers/airlock/access/all/supply/mineral_storage
	granted_all_access = list(ACCESS_MINERAL_STOREROOM)

/obj/effect/mapping_helpers/airlock/access/all/supply/qm
	granted_all_access = list(ACCESS_QM)

/obj/effect/mapping_helpers/airlock/access/all/supply/vault
	granted_all_access = list(ACCESS_VAULT)

// -------------------- Syndicate access helpers
/obj/effect/mapping_helpers/airlock/access/all/syndicate
	icon_state = "access_helper_syn"

/obj/effect/mapping_helpers/airlock/access/all/syndicate/general
	granted_all_access = list(ACCESS_SYNDICATE)

/obj/effect/mapping_helpers/airlock/access/all/syndicate/leader
	granted_all_access = list(ACCESS_SYNDICATE_LEADER)

// -------------------- Away access helpers
/obj/effect/mapping_helpers/airlock/access/all/away
	icon_state = "access_helper_awy"

/obj/effect/mapping_helpers/airlock/access/all/away/general
	granted_all_access = list(ACCESS_AWAY_GENERAL)

/obj/effect/mapping_helpers/airlock/access/all/away/command
	granted_all_access = list(ACCESS_AWAY_COMMAND)

/obj/effect/mapping_helpers/airlock/access/all/away/security
	granted_all_access = list(ACCESS_AWAY_SEC)

/obj/effect/mapping_helpers/airlock/access/all/away/engineering
	granted_all_access = list(ACCESS_AWAY_ENGINE)

/obj/effect/mapping_helpers/airlock/access/all/away/medical
	granted_all_access = list(ACCESS_AWAY_MED)

/obj/effect/mapping_helpers/airlock/access/all/away/supply
	granted_all_access = list(ACCESS_AWAY_SUPPLY)

/obj/effect/mapping_helpers/airlock/access/all/away/science
	granted_all_access = list(ACCESS_AWAY_SCIENCE)

/obj/effect/mapping_helpers/airlock/access/all/away/maintenance
	granted_all_access = list(ACCESS_AWAY_MAINT)

/obj/effect/mapping_helpers/airlock/access/all/away/generic1
	granted_all_access = list(ACCESS_AWAY_GENERIC1)

/obj/effect/mapping_helpers/airlock/access/all/away/generic2
	granted_all_access = list(ACCESS_AWAY_GENERIC2)

/obj/effect/mapping_helpers/airlock/access/all/away/generic3
	granted_all_access = list(ACCESS_AWAY_GENERIC3)

/obj/effect/mapping_helpers/airlock/access/all/away/generic4
	granted_all_access = list(ACCESS_AWAY_GENERIC4)

// -------------------- Admin access helpers
/obj/effect/mapping_helpers/airlock/access/all/admin
	icon_state = "access_helper_adm"

/obj/effect/mapping_helpers/airlock/access/all/admin/general
	granted_all_access = list(ACCESS_CENT_GENERAL)

/obj/effect/mapping_helpers/airlock/access/all/admin/thunderdome
	granted_all_access = list(ACCESS_CENT_THUNDER)

/obj/effect/mapping_helpers/airlock/access/all/admin/medical
	granted_all_access = list(ACCESS_CENT_MEDICAL)

/obj/effect/mapping_helpers/airlock/access/all/admin/living
	granted_all_access = list(ACCESS_CENT_LIVING)

/obj/effect/mapping_helpers/airlock/access/all/admin/storage
	granted_all_access = list(ACCESS_CENT_STORAGE)

/obj/effect/mapping_helpers/airlock/access/all/admin/teleporter
	granted_all_access = list(ACCESS_CENT_TELEPORTER)

/obj/effect/mapping_helpers/airlock/access/all/admin/captain
	granted_all_access = list(ACCESS_CENT_CAPTAIN)

/obj/effect/mapping_helpers/airlock/access/all/admin/bar
	granted_all_access = list(ACCESS_CENT_BAR)
