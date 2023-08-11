//Datum used to init Auxtools debugging as early as possible
//Datum gets created in master.dm because for whatever reason global code in there gets runs first
//In case we ever figure out how to manipulate global init order please move the datum creation into this file
/datum/debugger

/datum/debugger/New()
		enable_debugger()

//#define DLL_HARDWIRE "<filepath_here>"


/datum/debugger/proc/enable_debugger()
#ifndef DLL_HARDWIRE
	var/dll = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
#else
	var/dll = DLL_HARDWIRE
	#warn AUXTOOLS DEBUG DLL HARDWIRED, DO NOT MERGE
#endif
	if (dll)
		log_world("Loading Debug DLL at: [dll]")
		LIBCALL(dll, "auxtools_init")()
		enable_debugging()
