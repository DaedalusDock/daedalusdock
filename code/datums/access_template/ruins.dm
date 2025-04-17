/// Generic away/pffstation trim.
/datum/access_template/away
	access = list(ACCESS_AWAY_GENERAL)

/// Trim for the hotel ruin. Not Hilbert's Hotel.
/datum/access_template/away/hotel
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINT)

/// Trim for the hotel ruin. Not Hilbert's Hotel.
/datum/access_template/away/hotel/security
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINT, ACCESS_AWAY_SEC)

/// Trim for the oldstation ruin/Charlie station
/datum/access_template/away/old/sec
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_SEC)
	assignment = "Charlie Station Security Officer"

/// Trim for the oldstation ruin/Charlie station
/datum/access_template/away/old/sci
	access = list(ACCESS_AWAY_GENERAL)
	assignment = "Charlie Station Scientist"

/// Trim for the oldstation ruin/Charlie station
/datum/access_template/away/old/eng
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINE)
	assignment = "Charlie Station Engineer"

/// Trim for the oldstation ruin/Charlie station
/datum/access_template/away/old/apc
	access = list(ACCESS_ENGINE_EQUIP)

/// Trim for the cat surgeon ruin.
/datum/access_template/away/cat_surgeon
	assignment = "Cat Surgeon"
	trim_state = "trim_medicaldoctor"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINT)

/// Trim for Hilber in Hilbert's Hotel.
/datum/access_template/away/hilbert
	assignment = "Head Researcher"
	trim_state = "trim_researchdirector"
	access = list(ACCESS_AWAY_GENERIC3, ACCESS_RESEARCH)

/// Trim for beach bum lifeguards.
/datum/access_template/lifeguard
	assignment = "Lifeguard"

/// Trim for beach bum bartenders.
/datum/access_template/space_bartender
	assignment = "Space Bartender"
	trim_state = "trim_bartender"
	access = list(ACCESS_BAR)

/// Trim for various Centcom corpses.
/datum/access_template/centcom/corpse/bridge_officer
	assignment = "Bridge Officer"
	access = list(ACCESS_CENT_CAPTAIN)

/// Trim for various Centcom corpses.
/datum/access_template/centcom/corpse/commander
	assignment = "Commander"
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_STORAGE)

/// Trim for various Centcom corpses.
/datum/access_template/centcom/corpse/private_security
	assignment = JOB_CENTCOM_PRIVATE_SECURITY
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_STORAGE, ACCESS_SECURITY, ACCESS_MECH_SECURITY)

/// Trim for various Centcom corpses.
/datum/access_template/centcom/corpse/private_security/tradepost_officer
	assignment = "Tradepost Officer"

/// Trim for various Centcom corpses.
/datum/access_template/centcom/corpse/assault
	assignment = "Nanotrasen Assault Force"
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_STORAGE, ACCESS_SECURITY, ACCESS_MECH_SECURITY)

/// Trim for various various ruins.
/datum/access_template/engioutpost
	assignment = "Senior Station Engineer"
	trim_state = "trim_stationengineer"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINE, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_MAINT_TUNNELS)

/// Trim for various various ruins.
/datum/access_template/job/station_engineer/gunner
	assignment = "Gunner"
	template_access = null

/// Trim for pirates.
/datum/access_template/pirate
	assignment = "Pirate"
	trim_state = "trim_unknown"
	access = list(ACCESS_SYNDICATE)

/// Trim for pirates.
/datum/access_template/pirate/silverscale
	assignment = "Silver Scale Member"

/// Trim for the pirate captain.
/datum/access_template/pirate/captain
	assignment = "Pirate Captain"
	trim_state = "trim_captain"

/// Trim for the pirate captain.
/datum/access_template/pirate/captain/silverscale
	assignment = "Silver Scale VIP"
