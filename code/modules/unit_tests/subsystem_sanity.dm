/datum/unit_test/subsystem_sanity/Run()
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		if((SS.flags & SS_HIBERNATE) && !length(SS.hibernate_checks))
			TEST_FAIL("[SS.type] is set to hibernate but has no vars to check!")
