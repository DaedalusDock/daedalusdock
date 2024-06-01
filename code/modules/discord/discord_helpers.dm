/**
 * Given a ckey, look up the discord user id attached to the user, if any
 *
 * This gets the most recent entry from the discord_link table that is associated with the given ckey
 *
 * Arguments:
 * * lookup_ckey A string representing the ckey to search on
 */
/client/proc/discord_lookup_id(lookup_ckey)
	var/datum/discord_link_record/link = find_discord_link_by_ckey(lookup_ckey)
	if(link)
		return link.discord_id

/**
 * Given a discord id as a string, look up the ckey attached to that account, if any
 *
 * This gets the most recent entry from the discord_link table that is associated with this discord id snowflake
 *
 * Arguments:
 * * lookup_id The discord id as a string
 *
 * Returns: ckey as string
 */
/client/proc/discord_lookup_ckey(lookup_id)
	var/datum/discord_link_record/link  = find_discord_link_by_discord_id(lookup_id)
	if(link)
		return link.ckey

/**
 * Given a ckey as a string, look up the OTP token attached to that ckey, else generated new one
 *
 * Arguments:
 * * ckey The ckey as a string
 *
 * Returns: OTP token as string
 */
/client/proc/discord_get_or_generate_one_time_token_for_ckey(ckey)
	// Is there an existing valid one time token
	var/datum/discord_link_record/link = find_discord_link_by_ckey(ckey, timebound = TRUE)
	if(link)
		return link.one_time_token

	// Otherwise we make one
	return discord_generate_one_time_token(ckey)

/**
 * Checks if the the given ckey has a valid discord link
 * Returns: TRUE if valid, FALSE if invalid or missing
 */
/client/proc/discord_is_link_valid()
	var/datum/discord_link_record/link = find_discord_link_by_ckey(ckey, timebound = FALSE) //We need their persistent link.
	if(link)
		return link.valid
	return FALSE
