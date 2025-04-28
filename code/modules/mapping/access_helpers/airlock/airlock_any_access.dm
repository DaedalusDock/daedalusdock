// -------------------- Req Any (Only requires ONE of the given accesses to open)
// -------------------- Command access helpers
/obj/effect/mapping_helpers/airlock/access/any/command
	icon_state = "access_helper_com"

/obj/effect/mapping_helpers/airlock/access/any/command/general
	granted_any_access = list(ACCESS_MANAGEMENT)

/obj/effect/mapping_helpers/airlock/access/any/command/ai_upload
	granted_any_access = list(ACCESS_AI_UPLOAD)

/obj/effect/mapping_helpers/airlock/access/any/command/teleporter
	granted_any_access = list(ACCESS_TELEPORTER)

/obj/effect/mapping_helpers/airlock/access/any/command/eva
	granted_any_access = list(ACCESS_EVA)

/obj/effect/mapping_helpers/airlock/access/any/command/hop
	granted_any_access = list(ACCESS_DELEGATE)

/obj/effect/mapping_helpers/airlock/access/any/command/captain
	granted_any_access = list(ACCESS_CAPTAIN)

// -------------------- Engineering access helpers
/obj/effect/mapping_helpers/airlock/access/any/engineering
	icon_state = "access_helper_eng"

/obj/effect/mapping_helpers/airlock/access/any/engineering/general
	granted_any_access = list(ACCESS_ENGINEERING)

/obj/effect/mapping_helpers/airlock/access/any/engineering/engine_equipment
	granted_any_access = list(ACCESS_ENGINE_EQUIP)

/obj/effect/mapping_helpers/airlock/access/any/engineering/aux_base
	granted_any_access = list(ACCESS_AUX_BASE)

/obj/effect/mapping_helpers/airlock/access/any/engineering/maintenance
	granted_any_access = list(ACCESS_MAINT_TUNNELS)

/obj/effect/mapping_helpers/airlock/access/any/engineering/external
	granted_any_access = list(ACCESS_EXTERNAL_AIRLOCKS)

/obj/effect/mapping_helpers/airlock/access/any/engineering/secure
	granted_any_access = list(ACCESS_SECURE_ENGINEERING)

/obj/effect/mapping_helpers/airlock/access/any/engineering/atmos
	granted_any_access = list(ACCESS_ATMOSPHERICS)

/obj/effect/mapping_helpers/airlock/access/any/engineering/ce
	granted_any_access = list(ACCESS_CE)

// -------------------- Medical access helpers
/obj/effect/mapping_helpers/airlock/access/any/medical
	icon_state = "access_helper_med"

/obj/effect/mapping_helpers/airlock/access/any/medical/general
	granted_any_access = list(ACCESS_MEDICAL)

/obj/effect/mapping_helpers/airlock/access/any/medical/chemistry
	granted_any_access = list(ACCESS_PHARMACY)

/obj/effect/mapping_helpers/airlock/access/any/medical/cmo
	granted_any_access = list(ACCESS_CMO)

/obj/effect/mapping_helpers/airlock/access/any/medical/pharmacy
	granted_any_access = list(ACCESS_PHARMACY)

// -------------------- Science access helpers
/obj/effect/mapping_helpers/airlock/access/any/science
	icon_state = "access_helper_sci"

/obj/effect/mapping_helpers/airlock/access/any/science/general
	granted_any_access = list(ACCESS_RND)

/obj/effect/mapping_helpers/airlock/access/any/science/research
	granted_any_access = list(ACCESS_RESEARCH)

/obj/effect/mapping_helpers/airlock/access/any/science/ordnance
	granted_any_access = list(ACCESS_ORDNANCE)

/obj/effect/mapping_helpers/airlock/access/any/science/ordnance_storage
	granted_any_access = list(ACCESS_ORDNANCE_STORAGE)

/obj/effect/mapping_helpers/airlock/access/any/science/genetics
	granted_any_access = list(ACCESS_GENETICS)

/obj/effect/mapping_helpers/airlock/access/any/science/robotics
	granted_any_access = list(ACCESS_ROBOTICS)

/obj/effect/mapping_helpers/airlock/access/any/science/xenobio
	granted_any_access = list(ACCESS_XENOBIOLOGY)

/obj/effect/mapping_helpers/airlock/access/any/science/rd
	granted_any_access = list(ACCESS_RD)

// -------------------- Security access helpers
/obj/effect/mapping_helpers/airlock/access/any/security
	icon_state = "access_helper_sec"

/obj/effect/mapping_helpers/airlock/access/any/security/general
	granted_any_access = list(ACCESS_SECURITY)

/obj/effect/mapping_helpers/airlock/access/any/security/armory
	granted_any_access = list(ACCESS_ARMORY)

/obj/effect/mapping_helpers/airlock/access/any/security/detective
	granted_any_access = list(ACCESS_FORENSICS)

/obj/effect/mapping_helpers/airlock/access/any/security/court
	granted_any_access = list(ACCESS_COURT)

/obj/effect/mapping_helpers/airlock/access/any/security/hos
	granted_any_access = list(ACCESS_HOS)

// -------------------- Service access helpers
/obj/effect/mapping_helpers/airlock/access/any/service
	icon_state = "access_helper_serv"

/obj/effect/mapping_helpers/airlock/access/any/service/general
	granted_any_access = list(ACCESS_SERVICE)

/obj/effect/mapping_helpers/airlock/access/any/service/general_and_maint
	granted_any_access = list(ACCESS_SERVICE, ACCESS_MAINT_TUNNELS)

/obj/effect/mapping_helpers/airlock/access/any/service/kitchen
	granted_any_access = list(ACCESS_KITCHEN)

/obj/effect/mapping_helpers/airlock/access/any/service/bar
	granted_any_access = list(ACCESS_BAR)

/obj/effect/mapping_helpers/airlock/access/any/service/hydroponics
	granted_any_access = list(ACCESS_HYDROPONICS)

/obj/effect/mapping_helpers/airlock/access/any/service/janitor
	granted_any_access = list(ACCESS_JANITOR)

/obj/effect/mapping_helpers/airlock/access/any/service/chapel_office
	granted_any_access = list(ACCESS_CHAPEL_OFFICE)

/obj/effect/mapping_helpers/airlock/access/any/service/library
	granted_any_access = list(ACCESS_LIBRARY)

/obj/effect/mapping_helpers/airlock/access/any/service/theatre
	granted_any_access = list(ACCESS_THEATRE)

/obj/effect/mapping_helpers/airlock/access/any/service/lawyer
	granted_any_access = list(ACCESS_LAWYER)

// -------------------- Supply access helpers
/obj/effect/mapping_helpers/airlock/access/any/supply
	icon_state = "access_helper_sup"

/obj/effect/mapping_helpers/airlock/access/any/supply/general
	granted_any_access = list(ACCESS_CARGO)

/obj/effect/mapping_helpers/airlock/access/any/supply/mineral_storage
	granted_any_access = list(ACCESS_MINERAL_STOREROOM)

/obj/effect/mapping_helpers/airlock/access/any/supply/qm
	granted_any_access = list(ACCESS_QM)

/obj/effect/mapping_helpers/airlock/access/any/supply/vault
	granted_any_access = list(ACCESS_VAULT)

/obj/effect/mapping_helpers/airlock/access/any/supply/maintenance
	granted_any_access = list(ACCESS_CARGO, ACCESS_MAINT_TUNNELS)

// -------------------- Syndicate access helpers
/obj/effect/mapping_helpers/airlock/access/any/syndicate
	icon_state = "access_helper_syn"

/obj/effect/mapping_helpers/airlock/access/any/syndicate/general
	granted_any_access = list(ACCESS_SYNDICATE)

/obj/effect/mapping_helpers/airlock/access/any/syndicate/leader
	granted_any_access = list(ACCESS_SYNDICATE_LEADER)

// -------------------- Away access helpers
/obj/effect/mapping_helpers/airlock/access/any/away
	icon_state = "access_helper_awy"

/obj/effect/mapping_helpers/airlock/access/any/away/general
	granted_any_access = list(ACCESS_AWAY_GENERAL)

/obj/effect/mapping_helpers/airlock/access/any/away/command
	granted_any_access = list(ACCESS_AWAY_COMMAND)

/obj/effect/mapping_helpers/airlock/access/any/away/security
	granted_any_access = list(ACCESS_AWAY_SEC)

/obj/effect/mapping_helpers/airlock/access/any/away/engineering
	granted_any_access = list(ACCESS_AWAY_ENGINE)

/obj/effect/mapping_helpers/airlock/access/any/away/medical
	granted_any_access = list(ACCESS_AWAY_MED)

/obj/effect/mapping_helpers/airlock/access/any/away/supply
	granted_any_access = list(ACCESS_AWAY_SUPPLY)

/obj/effect/mapping_helpers/airlock/access/any/away/science
	granted_any_access = list(ACCESS_AWAY_SCIENCE)

/obj/effect/mapping_helpers/airlock/access/any/away/maintenance
	granted_any_access = list(ACCESS_AWAY_MAINT)

/obj/effect/mapping_helpers/airlock/access/any/away/generic1
	granted_any_access = list(ACCESS_AWAY_GENERIC1)

/obj/effect/mapping_helpers/airlock/access/any/away/generic2
	granted_any_access = list(ACCESS_AWAY_GENERIC2)

/obj/effect/mapping_helpers/airlock/access/any/away/generic3
	granted_any_access = list(ACCESS_AWAY_GENERIC3)

/obj/effect/mapping_helpers/airlock/access/any/away/generic4
	granted_any_access = list(ACCESS_AWAY_GENERIC4)

// -------------------- Admin access helpers
/obj/effect/mapping_helpers/airlock/access/any/admin
	icon_state = "access_helper_adm"

/obj/effect/mapping_helpers/airlock/access/any/admin/general
	granted_any_access = list(ACCESS_CENT_GENERAL)

/obj/effect/mapping_helpers/airlock/access/any/admin/thunderdome
	granted_any_access = list(ACCESS_CENT_THUNDER)

/obj/effect/mapping_helpers/airlock/access/any/admin/medical
	granted_any_access = list(ACCESS_CENT_MEDICAL)

/obj/effect/mapping_helpers/airlock/access/any/admin/living
	granted_any_access = list(ACCESS_CENT_LIVING)

/obj/effect/mapping_helpers/airlock/access/any/admin/storage
	granted_any_access = list(ACCESS_CENT_STORAGE)

/obj/effect/mapping_helpers/airlock/access/any/admin/teleporter
	granted_any_access = list(ACCESS_CENT_TELEPORTER)

/obj/effect/mapping_helpers/airlock/access/any/admin/captain
	granted_any_access = list(ACCESS_CENT_CAPTAIN)

/obj/effect/mapping_helpers/airlock/access/any/admin/bar
	granted_any_access = list(ACCESS_CENT_CAPTAIN)
