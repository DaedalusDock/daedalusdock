/// Represents a record from the discord link table in a nicer format
/datum/discord_link_record
	var/ckey
	var/discord_id
	var/timestamp
	var/one_time_token
	var/valid

/**
 * Generate a discord link datum from the values
 *
 * Arguments:
 * * ckey Ckey as a string
 * * discord_id Discord id as a string
 * * timestamp as a string
 * * one_time_token as a string
 * * valid as boolean, defaults to FALSE
 */
/datum/discord_link_record/New(ckey, discord_id, timestamp, one_time_token, valid = FALSE)
	src.ckey = ckey
	src.discord_id = discord_id
	src.one_time_token = one_time_token
	src.timestamp = timestamp
	src.valid = valid
