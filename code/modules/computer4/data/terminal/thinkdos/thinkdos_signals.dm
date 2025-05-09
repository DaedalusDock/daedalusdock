
/// Handles the log file being moved.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/log_file_gone(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(command_log, list(COMSIG_COMPUTER4_FILE_RENAMED, COMSIG_COMPUTER4_FILE_ADDED, COMSIG_PARENT_QDELETING))
	command_log = null

/// Called when the user folder is renamed, deleted, or moved.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/user_folder_gone(datum/source)
	SIGNAL_HANDLER

	set_current_user(null)
	UnregisterSignal(source, list(COMSIG_COMPUTER4_FILE_RENAMED, COMSIG_COMPUTER4_FILE_ADDED, COMSIG_COMPUTER4_FILE_REMOVED))

/// Called when the user file is renamed, deleted, or moved.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/user_file_gone(datum/source)
	SIGNAL_HANDLER

	clear_screen(TRUE)
	set_current_user(null)

	UnregisterSignal(source, list(COMSIG_COMPUTER4_FILE_RENAMED, COMSIG_COMPUTER4_FILE_ADDED, COMSIG_COMPUTER4_FILE_REMOVED))
