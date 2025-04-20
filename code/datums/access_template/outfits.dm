/**
 * This file contains all the trims associated with outfits.
 */

/// Trim for the assassin outfit.
/datum/access_template/reaper_assassin
	assignment = "Reaper"
	template_state = "trim_ert_deathcommando"

/datum/access_template/highlander/New()
	. = ..()
	access = SSid_access.get_access_for_group(list(/datum/access_group/station/all))

/// Trim for the mobster outfit.
/datum/access_template/mobster
	assignment = "Mobster"
	template_state = "trim_assistant"

/// Trim for VR outfits.
/datum/access_template/vr
	assignment = "VR Participant"

/datum/access_template/vr/New()
	. = ..()
	access |= SSid_access.get_access_for_group(list(/datum/access_group/station/all))

/// Trim for VR outfits.
/datum/access_template/vr/operative
	assignment = "Syndicate VR Operative"

/datum/access_template/vr/operative/New()
	. = ..()
	access |= list(ACCESS_SYNDICATE, ACCESS_MAINT_TUNNELS)

/// Trim for the Tunnel Clown! outfit. Has all access.
/datum/access_template/tunnel_clown
	assignment = "Tunnel Clown!"
	template_state = "trim_clown"

/datum/access_template/tunnel_clown/New()
	. = ..()
	access |= SSid_access.get_access_for_group(list(/datum/access_group/station/all))

/// Trim for Bounty Hunters NOT hired by centcom. (?)
/datum/access_template/bounty_hunter
	assignment = "Bounty Hunter"
