/datum/unit_test/subsystem_init/Run()
	for(var/i in Master.subsystems)
		var/datum/controller/subsystem/ss = i
		if(!ss.initialized)
			TEST_FAIL("[ss]([ss.type]) is a subsystem was not initialized.")
