
/datum/unit_test/mapping_standards
	abstract_type = /datum/unit_test/mapping_standards
	priority = TEST_MAP_STANDARDS

/datum/unit_test/mapping_standards/Run()
	SHOULD_CALL_PARENT(TRUE)
	. = 0 && ..() //linter defeat
	if(!SSmapping.config.run_mapping_tests)
		Skip("Standards tests disabled by config")
		return TRUE

