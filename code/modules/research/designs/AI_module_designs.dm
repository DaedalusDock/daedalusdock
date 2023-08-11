///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////

/datum/design/board/aicore
	name = "AI Design (AI Core)"
	desc = "Allows for the construction of circuit boards used to build new AI cores."
	id = "aicore"
	build_path = /obj/item/circuitboard/aicore
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/law
	build_type = IMPRINTER | AWAY_IMPRINTER
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/law/safeguard_module
	name = "Law Board (Safeguard)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "safeguard_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/supplied/safeguard

/datum/design/law/onehuman_module
	name = "Law Board (OneHuman)"
	desc = "Allows for the construction of a OneHuman AI Module."
	id = "onehuman_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 6000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/zeroth/onehuman

/datum/design/law/protectstation_module
	name = "Law Board (ProtectStation)"
	desc = "Allows for the construction of a ProtectStation AI Module."
	id = "protectstation_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/supplied/protect_station

/datum/design/law/quarantine_module
	name = "Law Board (Quarantine)"
	desc = "Allows for the construction of a Quarantine AI Module."
	id = "quarantine_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/supplied/quarantine

/datum/design/law/oxygen_module
	name = "Law Board (OxygenIsToxicToHumans)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "oxygen_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/supplied/oxygen

/datum/design/law/freeform_module
	name = "Law Board (Freeform)"
	desc = "Allows for the construction of a Freeform AI Module."
	id = "freeform_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 10000, /datum/material/bluespace = 2000)//Custom inputs should be more expensive to get
	build_path = /obj/item/ai_module/supplied/freeform

/datum/design/law/reset_module
	name = "Law Board (Reset)"
	desc = "Allows for the construction of a Reset AI Module."
	id = "reset_module"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000)
	build_path = /obj/item/ai_module/reset

/datum/design/law/purge_module
	name = "Law Board (Purge)"
	desc = "Allows for the construction of a Purge AI Module."
	id = "purge_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/reset/purge

/datum/design/law/remove_module
	name = "Law Board (Law Removal)"
	desc = "Allows for the construction of a Law Removal AI Core Module."
	id = "remove_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/remove

/datum/design/law/freeformcore_module
	name = "AI Core Module (Freeform)"
	desc = "Allows for the construction of a Freeform AI Core Module."
	id = "freeformcore_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 10000, /datum/material/bluespace = 2000)//Ditto
	build_path = /obj/item/ai_module/core/freeformcore

/datum/design/law/asimov
	name = "Core Law Board (Asimov)"
	desc = "Allows for the construction of an Asimov AI Core Module."
	id = "asimov_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/core/full/asimov

/datum/design/law/paladin_module
	name = "Core Law Board (P.A.L.A.D.I.N.)"
	desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
	id = "paladin_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/core/full/paladin

/datum/design/law/tyrant_module
	name = "Core Law Board (T.Y.R.A.N.T.)"
	desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
	id = "tyrant_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/core/full/tyrant

/datum/design/law/overlord_module
	name = "Core Law Board (Overlord)"
	desc = "Allows for the construction of an Overlord AI Module."
	id = "overlord_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/core/full/overlord

/datum/design/law/corporate_module
	name = "Core Law Board (Corporate)"
	desc = "Allows for the construction of a Corporate AI Core Module."
	id = "corporate_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/core/full/corp

/datum/design/law/default_module
	name = "Core Law Board (Default)"
	desc = "Allows for the construction of a Default AI Core Module."
	id = "default_module"
	materials = list(/datum/material/glass = 1000, /datum/material/diamond = 2000, /datum/material/bluespace = 1000)
	build_path = /obj/item/ai_module/core/full/custom
