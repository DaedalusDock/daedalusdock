/*
 * "RTOS" Embedded Operating System
 */


/datum/c4_file/terminal_program/operating_system/embedded
	abstract_type = /datum/c4_file/terminal_program/operating_system/embedded

	name = "firmware"


/datum/c4_file/terminal_program/operating_system/embedded/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	//Load our config file
