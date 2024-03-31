/* Helpers for Debug Messaging
 *
 * Log Levels conform to standard Unix expectations.
 * All have the same argument set
 *
 * Messages are built as follows
 * $PREFIX: $MESSAGE
 *
 * Messages are passed to chat only when the running server is in debug (is_debug_server), or live debugging has been enabled (GLOB.Debug2)
 * Messages are passed globally on debug servers, otherwise Messages are passed to admins if live debugging is enabled.
 * The single exception is TRACE level messages, which REQUIRE live debugging, this is to decrease general noise.
 *
 *  - level | Log level, controls the message border's color. Traces are only sent to chat when Live Debugging is enabled.
 *   - DBG_TRACE: white | Spammy stuff, raw values of a calculation, etc.
 *   - DBG_INFO: blue (default) | State changes, progress indications, Etc.
 *   - DBG_WARN: orange | An issue has been handled cleanly, or something isn't right, but not enough to cause a problem for players.
 *   - DBG_ERROR: red | Errors. Something has gone wrong and you're probably just about to bail out of the proc. Consider throwing a stack as well.

 *
 *  - prefix | Describes the sending system, Examples: Packets/IRPS, Jobs/AssignCaptain
 *   - default: "DEBUG"
 *
 *  - message | The actual content of the message.
 *   - Required.
 *
 *  - additional | Additional actions to take. Bitfield.
 *   - DBG_LOG_WORLD (default) | call log_world with message.
 *   - DBG_STACK_TRACE | Throw a stack trace.
 *   - DBG_ALWAYS | Send regardless of debug status.
 *
 */

/proc/message_debug(level = DBG_INFO, prefix = "DEBUG", message, additional = DBG_LOG_WORLD)
	// If we're a trace message and debugging is not enabled, return immediately.
	// or we aren't being forced to send regardless.
	if(level == DBG_TRACE && !GLOB.Debug2 && !(additional & DBG_ALWAYS))
		return
	// No message, No Service.
	if(!message)
		CRASH("Debug message without message? Wack.")

	/// Built message with prefix.
	var/built_message = "[prefix]: [message]"

	/// Severity span class to use.
	var/severity_class
	switch(level)
		if(DBG_TRACE)
			severity_class = "debug_trace"
		if(DBG_INFO)
			severity_class = "debug_info"
		if(DBG_WARN)
			severity_class = "debug_warn"
		if(DBG_ERROR)
			severity_class = "debug_error"
		else
			message_debug(DBG_ERROR, "DebugMessage/Severity", "Invalid severity level [level]. Setting to error.", DBG_STACK_TRACE)
			level = DBG_ERROR
			severity_class = "debug_error"

	// Check if we throw a stack trace.
	if(additional & DBG_STACK_TRACE)
		stack_trace("[level]| [built_message]")
	// Log to world.
	if(additional & DBG_LOG_WORLD)
		log_world("[level]| [built_message]")

	//Do we sent this, and to who?
	//Trace requires Debug2 explicitly.
	if((additional & DBG_ALWAYS) || GLOB.Debug2 || (GLOB.is_debug_server && (level != DBG_TRACE)))
		to_chat(
			target = (GLOB.is_debug_server ? world : GLOB.admins),
			type = MESSAGE_TYPE_DEBUG,
			html = "<div class='debug [severity_class]'>[built_message]</div>"
			)
