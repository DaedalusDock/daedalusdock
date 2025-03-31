
/**
 * Generate a timebound token for discord verification
 *
 * This uses the common word list to generate a three word random token, this token can then be fed to a discord bot that has access
 * to the same database, and it can use it to link a ckey to a discord id, with minimal user effort
 *
 * It returns the token to the calling proc, after inserting an entry into the discord_link table of the following form
 *
 * ```
 * (unique_id, ckey, null, the current time, the one time token generated)
 * the null value will be filled out with the discord id by the integrated discord bot when a user verifies
 * ```
 *
 * Notes:
 * * The token is guaranteed to be unique during it's validity period
 * * The validity period is currently set at 4 hours
 * * A token may not be unique outside it's validity window (to reduce conflicts)
 *
 * Arguments:
 * * ckey_for a string representing the ckey this token is for
 *
 * Returns a string representing the one time token
 */
/client/proc/discord_generate_one_time_token(ckey_for)
	var/static/list/token_wordlist = world.file2list("strings/eff_large_wordlist.txt")
	var/not_unique = TRUE
	var/one_time_token = ""
	// While there's a collision in the token, generate a new one (should rarely happen)
	while(not_unique)
		//Column is varchar 100, so we trim just in case someone does us the dirty later
		one_time_token = trim("[pick(token_wordlist)]-[pick(token_wordlist)]-[pick(token_wordlist)]", 100)

		not_unique = find_discord_link_by_token(one_time_token, timebound = TRUE)

	// Insert into the table, null in the discord id, id and timestamp and valid fields so the db fills them out where needed
	var/datum/db_query/query_insert_link_record = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("discord_links")] (
			ckey,
			one_time_token
		) VALUES (
			:ckey,
			:token
		)"},
		list(
			"ckey" = ckey_for,
			"token" = one_time_token
		)
	)

	if(!query_insert_link_record.Execute())
		qdel(query_insert_link_record)
		message_admins("WARNING! FAILED TO ASSIGN A OTP FOR USER [ckey_for], CALL A CODER!")
		stack_trace("WARNING! FAILED TO ASSIGN A OTP FOR USER [ckey_for], CALL A CODER!")
		return "FAILED TO GENERATE ONE-TIME-PASSWORD. PLEASE NOTIFY @francinum"

	//Cleanup
	qdel(query_insert_link_record)
	return one_time_token

/**
 * Find discord link entry by the passed in user token
 *
 * This will look into the discord link table and return the *last* (most recent) entry that matches the given one time token
 *
 * Arguments:
 * * one_time_token the string of words representing the one time token
 * * timebound A boolean flag, that specifies if it should only look for entries within the last 4 hours, false by default
 *
 * Returns a [/datum/discord_link_record]
 */
/client/proc/find_discord_link_by_token(one_time_token, timebound = FALSE)
	var/timeboundsql = ""
	if(timebound)
		timeboundsql = "AND timestamp >= Now() - INTERVAL 4 HOUR"

	var/query = {"
		SELECT
			ckey,
			CAST(discord_id AS CHAR(25)),
			timestamp,
			one_time_token,
			valid
		FROM [format_table_name("discord_links")]
		WHERE
			one_time_token = :one_time_token
			[timeboundsql]
		ORDER BY timestamp DESC
		LIMIT 1
	"}

	var/datum/db_query/query_get_discord_link_record = SSdbcore.NewQuery(
		query,
		list("one_time_token" = one_time_token)
	)

	if(!query_get_discord_link_record.Execute())
		qdel(query_get_discord_link_record)
		return

	if(query_get_discord_link_record.NextRow())
		var/result = query_get_discord_link_record.item
		. = new /datum/discord_link_record(result[1], result[2], result[3], result[4], result[5])

	//Make sure we clean up the query
	qdel(query_get_discord_link_record)

/**
 * Find discord link entry by the passed in user ckey
 *
 * This will look into the discord link table and return the last (most recent) entry that matches the given ckey
 *
 * Arguments:
 * * ckey the users ckey as a string
 * * timebound A boolean flag, that specifies if it should only look for entries within the last 4 hours, false by default
 *
 * Returns a [/datum/discord_link_record]
 */
/client/proc/find_discord_link_by_ckey(ckey, timebound = FALSE)
	if(!SSdbcore.Connect())
		return null // No DB, No data.

	var/timeboundsql = ""
	if(timebound)
		timeboundsql = "AND timestamp >= Now() - INTERVAL 4 HOUR"

	var/query = {"
		SELECT
			ckey,
			CAST(discord_id AS CHAR(25)),
			timestamp,
			one_time_token,
			valid
		FROM [format_table_name("discord_links")]
		WHERE
			ckey = :ckey
			[timeboundsql]
		ORDER BY timestamp DESC
		LIMIT 1
	"}

	var/datum/db_query/query_get_discord_link_record = SSdbcore.NewQuery(
		query,
		list("ckey" = ckey)
	)

	if(!query_get_discord_link_record.Execute())
		qdel(query_get_discord_link_record)
		return

	if(query_get_discord_link_record.NextRow())
		var/result = query_get_discord_link_record.item
		. = new /datum/discord_link_record(result[1], result[2], result[3], result[4], result[5])

	//Make sure we clean up the query
	qdel(query_get_discord_link_record)

/**
 * Find discord link entry by the passed in user discord id
 *
 * This will look into the discord link table and return the last (most recent) entry that matches the given id number
 *
 * Arguments:
 * * discord_id The users discord id (string)
 * * timebound should we search only in the last 4 hours
 *
 * Returns a [/datum/discord_link_record]
 */
/client/proc/find_discord_link_by_discord_id(discord_id, timebound = FALSE)
	var/timeboundsql = ""
	if(timebound)
		timeboundsql = "AND timestamp >= Now() - INTERVAL 4 HOUR"

	var/query = {"
		SELECT
			ckey,
			CAST(discord_id AS CHAR(25)),
			timestamp,
			one_time_token,
			valid
		FROM [format_table_name("discord_links")]
		WHERE
			discord_id = :discord_id
			[timeboundsql]
		ORDER BY timestamp DESC
		LIMIT 1
	"}

	var/datum/db_query/query_get_discord_link_record = SSdbcore.NewQuery(
		query,
		list("discord_id" = discord_id)
	)

	if(!query_get_discord_link_record.Execute())
		qdel(query_get_discord_link_record)
		return

	if(query_get_discord_link_record.NextRow())
		var/result = query_get_discord_link_record.item
		. = new /datum/discord_link_record(result[1], result[2], result[3], result[4], result[5])

	//Make sure we clean up the query
	qdel(query_get_discord_link_record)
